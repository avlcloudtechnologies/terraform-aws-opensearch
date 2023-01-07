variable "region" {
  description = "Region"
  type        = string
}

variable "name_prefix" {
  description = "Prefix to be used with resources"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "create_opensearch" {
  description = "create_opensearch"
  type        = bool
  default     = false
}

variable "route_53_zone_name" {
  description = "route_53_zone_name"
  type        = string
}

variable "opensearch_subdomain" {
  description = "opensearch_subdomain"
  type        = string
  default     = "opensearch"
}

variable "opensearch_engine_version" {
  description = "opensearch_engine_version"
  type        = string
  default     = "OpenSearch_1.2"
}

variable "opensearch_instance_type" {
  description = "opensearch_instance_type"
  type        = string
  default     = "t3.small.search"
}

variable "opensearch_instance_count" {
  description = "opensearch_instance_count"
  type        = string
  default     = "1"
}

variable "opensearch_volume_size" {
  description = "opensearch_volume_size"
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
  description = "enable_saml"
  type        = bool
  default     = true
}

variable "sso_entity_id" {
  description = "sso_entity_id"
  type        = string
  default     = null
}

variable "sso_admins_group_id" {
  description = "sso_admins_group_id"
  type        = string
  default     = null
}

# OpenSearch roles

variable "roles_mappings" {
  description = "roles_mappings"
  type = map(object({
    description   = optional(string)
    backend_roles = list(string)
  }))
  default = {}
}