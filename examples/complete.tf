provider "aws" {
  region = var.region
}

provider "elasticsearch" {
  url                 = "https://${module.opensearch.fqdn}"
  aws_region          = var.region
  aws_assume_role_arn = module.opensearch_iam_role.iam_role_arn
  healthcheck         = false
}

module "opensearch" {
  source = "./terraform-aws-opensearch"

  create_opensearch = true
  region            = var.region
  name_prefix       = var.name_prefix
  environment       = var.environment
  root_domain_name  = var.root_domain_name
  master_user_arn   = module.opensearch_iam_role.iam_role_arn

  sso_admins_group_id = var.sso_admins_group_id
  sso_entity_id       = var.sso_entity_id
  roles_mappings = {
    readall = {
      description = "Gives readall Opensearch permission"
      backend_roles = [
        "123456-abcd" // <AWS_SSO_READONLY_GROUP_ID>
      ]
    }
    all_access = {
      description = "Gives all_access Opensearch permission"
      backend_roles = [
        "123456-efgh", // <AWS_SSO_ADMINS_GROUP_ID>,
        module.opensearch_iam_role.iam_role_arn
      ]
    }
    opensearch_dashboards_user = {
      description = "Gives opensearch_dashboards_user Opensearch permission"
      backend_roles = [
        "78912-abcd" // <AWS_SSO_DEVELOPERS_GROUP_ID>
      ]
    }
  }
}

module "opensearch_iam_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.10.0"

  trusted_role_arns = [
    "arn:aws:iam::${var.aws_account_id}:root",
  ]
  create_role       = true
  role_name         = "${var.name_prefix}-opensearch-admin"
  role_requires_mfa = false
  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonOpenSearchServiceFullAccess",
  ]
}