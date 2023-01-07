# terraform-aws-opensearch
This module handles creation of AWS Opensearch and SAML auth

## Usage

```hcl
provider "aws" {
  region = var.region
}

provider "elasticsearch" {
  url         = "https://${module.opensearch.fqdn}"
  aws_region  = var.aws_region
  healthcheck = false
}

module "opensearch" {
  source =  "./terraform-aws-opensearch"

  create_opensearch   = var.create_opensearch
  region              = var.region
  name_prefix         = var.name_prefix
  environment         = var.environment
  root_domain_name    = var.root_domain_name

  enable_saml         = false
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |
| <a name="requirement_elasticsearch"></a> [elasticsearch](#requirement\_elasticsearch) | ~> 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.0 |
| <a name="provider_elasticsearch"></a> [elasticsearch](#provider\_elasticsearch) | ~> 2.0 |
| <a name="provider_http"></a> [http](#provider\_http) | n/a |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_acm"></a> [acm](#module\_acm) | terraform-aws-modules/acm/aws | ~> 4.1.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_service_linked_role.opensearch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_service_linked_role) | resource |
| [aws_opensearch_domain.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearch_domain) | resource |
| [aws_opensearch_domain_saml_options.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearch_domain_saml_options) | resource |
| [aws_route53_record.opensearch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [elasticsearch_opensearch_roles_mapping.this](https://registry.terraform.io/providers/phillbaker/elasticsearch/latest/docs/resources/opensearch_roles_mapping) | resource |
| [time_sleep.wait_300_seconds](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.access_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_route53_zone.env](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [http_http.saml_metadata](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_opensearch"></a> [create\_opensearch](#input\_create\_opensearch) | Whether to create OpenSearch cluster | `bool` | `false` | no |
| <a name="input_enable_advanced_security_options"></a> [enable\_advanced\_security\_options](#input\_enable\_advanced\_security\_options) | Whether advanced security is enabled | `bool` | `true` | no |
| <a name="input_enable_internal_user_database"></a> [enable\_internal\_user\_database](#input\_enable\_internal\_user\_database) | Whether the internal user database is enabled | `bool` | `false` | no |
| <a name="input_enable_saml"></a> [enable\_saml](#input\_enable\_saml) | Whether OpenSearch SAML options are enabled | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name | `string` | n/a | yes |
| <a name="input_master_user_arn"></a> [master\_user\_arn](#input\_master\_user\_arn) | User or role arn which is provisioning opensearch. This role is used to configure opensearch TF provider. | `string` | `null` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Prefix to be used with resources | `string` | n/a | yes |
| <a name="input_opensearch_engine_version"></a> [opensearch\_engine\_version](#input\_opensearch\_engine\_version) | Either Elasticsearch\_X.Y or OpenSearch\_X.Y to specify the engine version for the Amazon OpenSearch Service domain | `string` | `"OpenSearch_1.2"` | no |
| <a name="input_opensearch_instance_count"></a> [opensearch\_instance\_count](#input\_opensearch\_instance\_count) | Number of instances in the cluster | `string` | `"1"` | no |
| <a name="input_opensearch_instance_type"></a> [opensearch\_instance\_type](#input\_opensearch\_instance\_type) | Instance type of data nodes in the cluster | `string` | `"t3.small.search"` | no |
| <a name="input_opensearch_subdomain"></a> [opensearch\_subdomain](#input\_opensearch\_subdomain) | Route53 OpenSearch subdomain | `string` | `"opensearch"` | no |
| <a name="input_opensearch_volume_size"></a> [opensearch\_volume\_size](#input\_opensearch\_volume\_size) | Size of EBS volumes attached to data nodes (in GiB) | `number` | `40` | no |
| <a name="input_region"></a> [region](#input\_region) | Region name | `string` | n/a | yes |
| <a name="input_roles_mappings"></a> [roles\_mappings](#input\_roles\_mappings) | OpenSearch roles mappings | <pre>map(object({<br>    description   = optional(string)<br>    backend_roles = list(string)<br>  }))</pre> | `{}` | no |
| <a name="input_route_53_zone_name"></a> [route\_53\_zone\_name](#input\_route\_53\_zone\_name) | Route53 DNS zone | `string` | n/a | yes |
| <a name="input_sso_admins_group_id"></a> [sso\_admins\_group\_id](#input\_sso\_admins\_group\_id) | AWS SSO admins group | `string` | `null` | no |
| <a name="input_sso_entity_id"></a> [sso\_entity\_id](#input\_sso\_entity\_id) | AWS SSO entity ID | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_fqdn"></a> [fqdn](#output\_fqdn) | opensearch\_fqdn |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->