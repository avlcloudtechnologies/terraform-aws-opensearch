variable "region" {
  description = "Region name"
  type        = string
}

variable "name_prefix" {
  description = "Prefix to be used with resources"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "create_opensearch" {
  description = "Whether to create OpenSearch cluster"
  type        = bool
  default     = false
}

variable "route_53_zone_name" {
  description = "Route53 DNS zone"
  type        = string
}

variable "opensearch_subdomain" {
  description = "Route53 OpenSearch subdomain"
  type        = string
  default     = "opensearch"
}

variable "opensearch_engine_version" {
  description = "Either Elasticsearch_X.Y or OpenSearch_X.Y to specify the engine version for the Amazon OpenSearch Service domain"
  type        = string
  default     = "OpenSearch_1.2"
}

variable "opensearch_instance_type" {
  description = "Instance type of data nodes in the cluster"
  type        = string
  default     = "t3.small.search"
}

variable "opensearch_instance_count" {
  description = "Number of instances in the cluster"
  type        = string
  default     = "1"
}

variable "opensearch_volume_size" {
  description = "Size of EBS volumes attached to data nodes (in GiB)"
  type        = number
  default     = 40
}

variable "enable_advanced_security_options" {
  description = "Whether advanced security is enabled"
  type        = bool
  default     = true
}

variable "enable_internal_user_database" {
  description = "Whether the internal user database is enabled"
  type        = bool
  default     = false
}

variable "master_user_arn" {
  description = "User or role arn which is provisioning opensearch. This role is used to configure opensearch TF provider."
  type        = string
  default     = null
}

# SAML

variable "enable_saml" {
  description = "Whether OpenSearch SAML options are enabled"
  type        = bool
  default     = true
}

variable "sso_entity_id" {
  description = "AWS SSO entity ID"
  type        = string
  default     = null
}

variable "sso_admins_group_id" {
  description = "AWS SSO admins group"
  type        = string
  default     = null
}

# OpenSearch roles

variable "roles_mappings" {
  description = "OpenSearch roles mappings"
  type = map(object({
    description   = optional(string)
    backend_roles = list(string)
  }))
  default = {}
}