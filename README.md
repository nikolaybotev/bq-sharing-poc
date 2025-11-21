# BigQuery Cross-Organization Data Sharing PoC

This repository contains Terraform configurations for a proof-of-concept demonstrating secure BigQuery data sharing between two different GCP organizations using Analytics Hub, VPC Service Controls, and Organization Policies.

## Objectives

- **Demonstrate end-to-end functionality**: Provide a fully functional, production-ready implementation of secure BigQuery cross-organization data sharing using Analytics Hub, implemented as Terraform infrastructure-as-code
- **Document subscriber requirements**: Identify and document the **minimum set of information** required from a subscriber organization (Customer ID, Project Number, and Principal) to enable secure dataset sharing
- **Establish least-privilege VPC Service Controls**: Define the **minimum required** VPC Service Control perimeter ingress and egress rules for successful cross-organization sharing while maintaining **maximum data exfiltration protection** and enforcing least-privilege network access
- **Establish least-privilege IAM Organization Policy**: Define the Organization Policy configuration (`iam.allowedPolicyMemberDomains`) that protects against data exfiltration by restricting IAM grants to external principals, enforcing least-privilege access at the organizational level
- **Compare architectural variants**: Validate and document both the two-project (publisher/exchange separation) and single-project architectural approaches to help teams choose the appropriate pattern for their use case

## Overview

This PoC consists of two separate Terraform projects that work together to establish a secure data sharing connection:

1. **Publisher** (`publisher/`): The data provider organization that creates and shares a BigQuery dataset
2. **Subscriber** (`subscriber/`): The data consumer organization that subscribes to the shared dataset

The architecture uses **VPC Service Controls** and **Organization Policies** to enforce security boundaries and control access across organizational boundaries, simulating a real-world cross-organization sharing scenario.

## Architecture

### Publisher Side
- **Publisher Project**: Contains the source BigQuery dataset to be shared
- **Exchange Project**: Hosts the Analytics Hub data exchange and listing
- **VPC Service Controls**: Service perimeters protecting BigQuery and Analytics Hub APIs
- **Organization Policies**: Allow IAM policy members from external subscriber organizations

Note: there is also a single-project variant of the publisher where the Data Exchange is in the same
project as the BigQuery dataset. See the section at the end of the document for details.

### Subscriber Side
- **Subscriber Project**: Contains the subscription and linked dataset
- **Subscription**: Connects to the publisher's listing to access shared data

## Security Controls

### VPC Service Controls
VPC Service Controls are used to restrict and control access to Google Cloud services:

- **Service Perimeters**: Protect BigQuery and Analytics Hub APIs in both publisher and exchange projects
- **Access Levels**: Define IP-based access restrictions (optional)
- **Ingress Policies**: Control who can access resources from outside the perimeter (e.g., subscriber accessing exchange)
- **Egress Policies**: Control what resources can be accessed from within the perimeter (e.g., exchange creating linked datasets in subscriber project)

### Organization Policies
Organization Policies are used to allow cross-organization IAM bindings:

- **`iam.allowedPolicyMemberDomains`**: Allows the publisher to grant IAM roles to users from the subscriber's organization by specifying the subscriber's customer ID

## Data Sharing Process

### Step 1: Subscriber Shares Information with Publisher
The subscriber organization provides the following information to the publisher:

- **Subscriber Customer ID**: The GCP customer ID of the subscriber organization (e.g., `C00n20csy`)
- **Subscriber Project Number**: The project number where the subscription will be created (e.g., `618045648662`)
- **Subscriber Principal**: The IAM principal (user or service account) that will subscribe to the listing (e.g., `user:johndoe@subscriber.com`)

### Step 2: Publisher Creates and Shares Listing
The publisher organization uses the subscriber information to:

1. Create an Organization Policy allowing IAM bindings to the subscriber's customer ID
2. Create a data exchange in the exchange project
3. Create a listing that references the shared BigQuery dataset
4. Grant the subscriber principal the `roles/analyticshub.subscriber` role on the listing
5. Configure VPC Service Controls ingress/egress policies to allow the subscriber to access the exchange and for the exchange to create resources in the subscriber project

### Step 3: Subscriber Creates Subscription
The subscriber organization uses the publisher's information to:

1. Create a subscription to the publisher's listing
2. The subscription automatically creates a linked dataset in the subscriber project, providing access to the shared data

## Quick Start

### Prerequisites

- Two GCP organizations (or simulate with different projects/accounts)
- Terraform >= 1.0
- `gcloud` CLI installed and configured
- Appropriate permissions in both organizations (see individual project READMEs for details)

### Step 1: Set Up Publisher Credentials

Create application default credentials for the publisher organization:

```bash
gcloud auth application-default login && \
cp ~/.config/gcloud/application_default_credentials.json ./publisher/credentials.json && \
export GOOGLE_APPLICATION_CREDENTIALS="$(pwd)/publisher/credentials.json"
```

### Step 2: Deploy Publisher Infrastructure

```bash
cd publisher
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your publisher organization details
terraform init
terraform plan
terraform apply
```

After deployment, note the outputs:
- `bq_exchange_project_id`
- `data_exchange_id`
- `listing_id`

### Step 3: Set Up Subscriber Credentials

Switch to subscriber credentials (using a different GCP account/organization):

```bash
gcloud auth application-default login && \
cp ~/.config/gcloud/application_default_credentials.json ./subscriber/credentials.json && \
export GOOGLE_APPLICATION_CREDENTIALS="$(pwd)/subscriber/credentials.json"
```

### Step 4: Deploy Subscriber Infrastructure

```bash
cd subscriber
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with:
# - Your subscriber organization details
# - The exchange_project_id, data_exchange_id, and listing_id from publisher outputs
terraform init
terraform plan
terraform apply
```

### Step 5: Verify the Connection

After both deployments complete, verify the subscription was created successfully:

```bash
# Using subscriber credentials
gcloud bigquery analytics-hub subscriptions list \
  --project=<subscriber-project-id> \
  --location=us-central1
```

## Important Notes

- **Cross-Organization Setup**: For a true cross-organization scenario, deploy publisher and subscriber in different GCP organizations using different GCP accounts/credentials
- **Credential Management**: Use separate application default credentials files for publisher and subscriber to simulate different organizations
- **VPC Service Controls Propagation**: Service perimeters can take 5-10 minutes to fully propagate after creation
- **Organization Policies**: The publisher must configure the `iam.allowedPolicyMemberDomains` policy to allow IAM bindings to the subscriber's customer ID
- **Billing**: Ensure both organizations have billing enabled for their respective projects

## Cleanup

To destroy all resources:

```bash
# Destroy subscriber first
cd subscriber
terraform destroy

# Then destroy publisher
cd ../publisher
terraform destroy
```

## Additional Resources

- [BigQuery Sharing (Analytics Hub) Documentation](https://cloud.google.com/bigquery/docs/analytics-hub-introduction)
- [VPC Service Controls for Analytics Hub](https://docs.cloud.google.com/bigquery/docs/analytics-hub-vpc-sc-rules)
- [Organization Policies Documentation](https://cloud.google.com/resource-manager/docs/organization-policy/overview)

## Single-Project Publisher Variant

The `publisher-single-project/` directory contains an alternative publisher configuration that consolidates the publisher and exchange projects into a single project. This variant simplifies the architecture by:

- **Merging Projects**: The BigQuery dataset and Analytics Hub data exchange/listings are both created in the same `bq-publisher` project
- **Unified Service Perimeter**: A single VPC Service Controls service perimeter protects both BigQuery and Analytics Hub APIs with combined ingress/egress policies
- **Simplified Management**: Fewer projects to manage while maintaining the same security controls

### Usage

To use the single-project publisher variant, follow the same Quick Start steps but use the `publisher-single-project/` directory instead of `publisher/`:

```bash
cd publisher-single-project
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your publisher organization details
terraform init
terraform plan
terraform apply
```

After deployment, note the outputs:
- `bq_publisher_project_id` (use this as the `exchange_project_id` in subscriber configuration)
- `data_exchange_id`
- `listing_id`

**Note**: If you're importing existing resources (e.g., Access Policy or Access Level that were created by the two-project publisher), you may need to import them first:

```bash
# Import existing Access Policy (if it already exists)
terraform import google_access_context_manager_access_policy.policy <policy_id>

# Import existing Access Level (if it already exists)
terraform import google_access_context_manager_access_level.allowed_ips accessPolicies/<policy_id>/accessLevels/allowed_ips
```

The subscriber configuration remains the same, but use `bq_publisher_project_id` as the `exchange_project_id` value.
