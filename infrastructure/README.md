# ObservatoryGrid infrastructure

Terraform configuration for ObservatoryGrid. The AWS provider defaults to the
`ObservatoryGrid-AdminAccess` profile and `us-east-2`, matching the profile's
configured region. Credentials stay in your local AWS configuration.

From the repository root:

```sh
aws sts get-caller-identity --profile ObservatoryGrid-AdminAccess
terraform -chdir=infrastructure init
terraform -chdir=infrastructure fmt -check
terraform -chdir=infrastructure validate
terraform -chdir=infrastructure plan
```

The configuration defines a private, KMS-encrypted, versioned S3 bucket, a CloudFront
 distribution with Origin Access Control, an ACM certificate in `us-east-1`, and
 Route 53 A/AAAA aliases for `observatorygrid.space` and `www.observatorygrid.space`.
 It uses the existing public hosted zone. CloudFront gets read-only access through
 a bucket policy scoped to this distribution, rather than an IAM role.

Review `terraform plan` before running `terraform apply`. Existing DNS records
 managed outside Terraform must be imported before applying; this configuration
 does not silently overwrite them. The hosted zone must be delegated by the domain
 registrar for DNS validation and public routing to work.

After applying, build and upload the Astro site from the repository root:

```sh
npm --prefix site/src run build
aws s3 sync site/src/dist/ "s3://$(terraform -chdir=infrastructure output -raw site_bucket_name)/" --profile ObservatoryGrid-AdminAccess
aws cloudfront create-invalidation --distribution-id "$(terraform -chdir=infrastructure output -raw cloudfront_distribution_id)" --paths '/*' --profile ObservatoryGrid-AdminAccess
```

CloudFront rewrites directory URLs to `index.html` and serves Astro's `404.html`
for missing content. Both domain names serve the same site. Uploading content and
invalidating caches are separate from Terraform. Access logging, WAF, and paid
Shield Advanced are not configured in this initial hosting stack.

Override the defaults with `-var='aws_region=us-east-1'` or a local
`terraform.tfvars` file. Local variable files, state, and saved plans are ignored
by Git; commit `.terraform.lock.hcl` to keep provider versions reproducible.

State uses Terraform's local backend for now. Configure a shared backend before
using this configuration from CI or multiple workstations.

S3 uses a customer-managed KMS key (`alias/observatorygrid-site`) with automatic
rotation and S3 Bucket Keys enabled. The key policy grants only this CloudFront
distribution decrypt access and enables account IAM permissions for administrators
and uploaders. Upload identities need `kms:GenerateDataKey` (and `kms:Decrypt` for
multipart uploads) in addition to S3 permissions. Changing default encryption does
not re-encrypt existing objects; those must be copied or uploaded again.
