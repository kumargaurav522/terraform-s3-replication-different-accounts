# S3 Replication with Terraform
Setting up replication of source and destination buckets are owned by different AWS accounts.

## Cross-Account replication
The `cross-account` example needs two different profiles, pointing at different accounts, each with a high level of privilege to use IAM and S3. To begin with , copy the `terraform.tfvars.template` to `terraform.tfvars` and provide the relevant information.

Subsequent to that, do:

```
terraform init
terraform apply
```

At the end of this, the two buckets should be reported to you:

```
Outputs:
destination_bucket = arn:aws:s3:::test-tf1-des
source_bucket = arn:aws:s3:::test-tf1-sou
```
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_aws.dest"></a> [aws.dest](#provider\_aws.dest) | n/a |
| <a name="provider_aws.source"></a> [aws.source](#provider\_aws.source) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.replication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy_attachment.replication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_role.replication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_s3_bucket.destination](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.log_bucket_source](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.source](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_object.sample](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object) | resource |
| [aws_s3_bucket_policy.destination](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dest_account"></a> [dest\_account](#input\_dest\_account) | ID of the destination account | `any` | n/a | yes |
| <a name="input_dest_profile"></a> [dest\_profile](#input\_dest\_profile) | name of the destination profile being used | `any` | n/a | yes |
| <a name="input_dest_region"></a> [dest\_region](#input\_dest\_region) | n/a | `string` | `"ap-south-1"` | no |
| <a name="input_source_account"></a> [source\_account](#input\_source\_account) | ID of the source account | `any` | n/a | yes |
| <a name="input_source_profile"></a> [source\_profile](#input\_source\_profile) | name of the source profile being used | `any` | n/a | yes |
| <a name="input_source_region"></a> [source\_region](#input\_source\_region) | n/a | `string` | `"us-east-1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_destination_bucket"></a> [destination\_bucket](#output\_destination\_bucket) | n/a |
| <a name="output_source_bucket"></a> [source\_bucket](#output\_source\_bucket) | n/a |




