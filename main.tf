data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "access_policy" {
  statement {
    actions   = ["es:*"]
    resources = ["arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${local.opensearch_domain_name}/*"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}

data "aws_route53_zone" "env" {
  name = var.route_53_zone_name
}

locals {
  opensearch_domain_name = "${var.name_prefix}-${var.environment}"
}

resource "aws_iam_service_linked_role" "opensearch" {
  count = var.create_opensearch ? 1 : 0

  aws_service_name = "opensearchservice.amazonaws.com"
}

resource "aws_opensearch_domain" "this" {
  count = var.create_opensearch ? 1 : 0

  domain_name     = local.opensearch_domain_name
  engine_version  = var.opensearch_engine_version
  access_policies = data.aws_iam_policy_document.access_policy.json

  cluster_config {
    instance_type  = var.opensearch_instance_type
    instance_count = var.opensearch_instance_count
  }
  advanced_security_options {
    enabled                        = var.enable_advanced_security_options
    internal_user_database_enabled = var.enable_internal_user_database
    master_user_options {
      master_user_arn = var.master_user_arn == null ? data.aws_caller_identity.current.arn : var.master_user_arn
    }
  }
  domain_endpoint_options {
    enforce_https       = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"

    custom_endpoint_enabled         = true
    custom_endpoint                 = "${var.opensearch_subdomain}.${data.aws_route53_zone.env.name}"
    custom_endpoint_certificate_arn = module.acm.acm_certificate_arn
  }

  node_to_node_encryption {
    enabled = true
  }
  encrypt_at_rest {
    enabled = true
  }

  ebs_options {
    ebs_enabled = true
    volume_size = var.opensearch_volume_size
  }
  depends_on = [aws_iam_service_linked_role.opensearch]
}

resource "aws_route53_record" "opensearch" {
  count = var.create_opensearch ? 1 : 0

  zone_id = data.aws_route53_zone.env.id
  name    = var.opensearch_subdomain
  type    = "CNAME"
  ttl     = "60"

  records = [aws_opensearch_domain.this[0].endpoint]
}

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.1.0"

  create_certificate  = var.create_opensearch
  domain_name         = "${var.opensearch_subdomain}.${data.aws_route53_zone.env.name}"
  zone_id             = data.aws_route53_zone.env.id
  wait_for_validation = true
}

#######
# SAML
#######

data "http" "saml_metadata" {
  count = var.create_opensearch && var.enable_saml ? 1 : 0

  url = "https://portal.sso.${var.region}.amazonaws.com/saml/metadata/${var.sso_entity_id}"
}

resource "aws_opensearch_domain_saml_options" "this" {
  count = var.create_opensearch && var.enable_saml ? 1 : 0

  domain_name = aws_opensearch_domain.this[0].domain_name
  saml_options {
    enabled             = true
    roles_key           = "Role"
    master_backend_role = var.sso_admins_group_id
    idp {
      entity_id        = "https://portal.sso.${var.region}.amazonaws.com/saml/assertion/${var.sso_entity_id}"
      metadata_content = sensitive(data.http.saml_metadata[0].response_body)
    }
  }
}

##################
# OpenSearch roles
##################

resource "time_sleep" "wait_300_seconds" {
  count = var.create_opensearch ? 1 : 0

  depends_on = [aws_route53_record.opensearch]

  create_duration = "300s"
}

resource "elasticsearch_opensearch_roles_mapping" "this" {
  for_each = var.roles_mappings

  role_name     = each.key
  description   = try(each.value.description, "")
  backend_roles = try(each.value.backend_roles, [])
  hosts         = try(each.value.hosts, [])
  users         = try(each.value.users, [])

  depends_on = [time_sleep.wait_300_seconds]
}