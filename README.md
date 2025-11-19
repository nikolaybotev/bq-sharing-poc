# Terraform Configuration for BigQuery Sharing with VPC Service Controls

This Terraform configuration sets up a complete BigQuery data sharing infrastructure with VPC Service Controls protection.

## Architecture

The configuration creates:

1. **Three GCP Projects**:
   - `bq-publisher`: Contains the source BigQuery dataset
   - `bq-exchange`: Hosts the BigQuery Sharing data exchange and listing
   - `bq-subscriber`: Subscribes to the shared dataset

2. **VPC Service Controls**:
   - Access level with IP CIDR restrictions
   - Service perimeters protecting bq-publisher and bq-exchange projects
   - Ingress and egress policies allowing secure data sharing

3. **BigQuery Sharing Resources**:
   - Dataset in bq-publisher project
   - Data exchange in bq-exchange project
   - Listing referencing the publisher dataset
   - Subscription in bq-subscriber project
   - IAM policies for access control

## Prerequisites

1. **GCP Organization**: You must have an organization ID
2. **Billing Account**: A billing account ID to associate with projects
3. **Permissions**: The service account or user running Terraform needs:
   - `roles/resourcemanager.projectCreator` at organization level
   - `roles/billing.projectManager` at billing account level
   - `roles/accesscontextmanager.policyAdmin` at organization level
   - `roles/bigquery.admin` on projects
   - `roles/analyticshub.admin` on projects
   - `roles/serviceusage.serviceUsageAdmin` on projects

4. **APIs**: The following APIs must be enabled (Terraform will enable them):
   - BigQuery API
   - Analytics Hub API
   - Access Context Manager API
   - Service Usage API

## Setup

1. **Copy the example variables file**:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```
   
   **Note**: The `.gitignore` file is configured to exclude `terraform.tfvars` to prevent committing sensitive data.

2. **Edit `terraform.tfvars`** with your values:
   - `organization_id`: Your GCP Organization ID
   - `project_prefix`: Prefix for project IDs (e.g., "mycompany")
   - `billing_account_id`: Your billing account ID
   - `allowed_ip_cidr_blocks`: List of allowed IP CIDR blocks
   - `primary_contact`: Contact email for data exchange

3. **Initialize Terraform**:
   ```bash
   terraform init
   ```

4. **Review the plan**:
   ```bash
   terraform plan
   ```

5. **Apply the configuration**:
   ```bash
   terraform apply
   ```

## Variables

### Required Variables

- `organization_id`: GCP Organization ID
- `project_prefix`: Prefix for all project IDs
- `billing_account_id`: Billing account ID
- `primary_contact`: Primary contact email

### Optional Variables

- `allowed_ip_cidr_blocks`: List of IP CIDR blocks (default: empty, allows all)
- `region`: GCP region (default: "us-central1")
- `location`: BigQuery location (default: "us")
- `dataset_id`: Dataset ID (default: "shared_dataset")
- `exchange_id`: Data exchange ID (default: "data-exchange")
- `listing_id`: Listing ID (default: "data-listing")
- `subscription_id`: Subscription ID (default: "data-subscription")

See `variables.tf` for complete variable documentation.

## Outputs

After applying, Terraform will output:

- Project IDs and numbers for all three projects
- BigQuery dataset information
- Data exchange and listing details
- Subscription information
- VPC Service Controls resource names

## VPC Service Controls Configuration

### Access Level
- Created with IP CIDR restrictions from `allowed_ip_cidr_blocks`
- Referenced by all three service perimeters

### Service Perimeters
- **bq-publisher-perimeter**: Protects BigQuery and Analytics Hub APIs in publisher project
- **bq-exchange-perimeter**: Protects BigQuery and Analytics Hub APIs in exchange project
- **bq-subscriber-perimeter**: References the access level for subscriber project

### Ingress Policies
- **Publisher**: Allows queries from bq-subscriber project
- **Exchange**: Allows subscription operations from bq-subscriber project

### Egress Policies
- **Publisher**: Allows access to bq-subscriber for data sharing
- **Exchange**: Allows access to both bq-subscriber and bq-publisher

## Important Notes

1. **Project Creation**: Projects are created in the specified organization. Ensure you have proper permissions.

2. **VPC Service Controls**: Service perimeters can take several minutes to propagate. Be patient during initial setup.

3. **IAM Permissions**: The configuration grants the bq-subscriber project's service account permission to subscribe to listings. Additional IAM bindings may be needed for specific use cases.

4. **Billing**: All projects are associated with the specified billing account. Monitor costs.

5. **API Enablement**: APIs are enabled automatically, but this can take a few minutes.

6. **Dependencies**: Resources are created with proper dependencies, but some operations (like VPC Service Controls propagation) may require waiting.

## Troubleshooting

### VPC Service Controls Issues

If you encounter issues with VPC Service Controls:

1. **Check API enablement**: Ensure Access Context Manager API is enabled
2. **Verify permissions**: Ensure you have `roles/accesscontextmanager.policyAdmin`
3. **Wait for propagation**: Service perimeters can take 5-10 minutes to fully propagate
4. **Check access level**: Verify the access level allows your IP addresses

### BigQuery Sharing Issues

1. **API enablement**: Ensure Analytics Hub API is enabled in all projects
2. **IAM permissions**: Verify the subscriber has proper IAM roles
3. **Dataset location**: Ensure dataset location matches exchange location
4. **Service account**: The subscriber project's Analytics Hub service account needs permissions

### Common Errors

- **"Permission denied"**: Check IAM roles and organization-level permissions
- **"API not enabled"**: Wait a few minutes after project creation for APIs to enable
- **"Service perimeter not ready"**: Wait for VPC Service Controls to propagate

## Cleanup

To destroy all resources:

```bash
terraform destroy
```

**Warning**: This will delete all created projects and resources. Ensure you have backups if needed.

## Additional Resources

- [BigQuery Sharing Documentation](https://cloud.google.com/bigquery/docs/share-access-views)
- [VPC Service Controls Documentation](https://cloud.google.com/vpc-service-controls/docs)
- [Terraform Google Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs)

