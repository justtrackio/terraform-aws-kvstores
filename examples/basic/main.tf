module "example" {
  source = "../.."

  namespace            = "ns"
  environment          = "env"
  stage                = "st"
  name                 = "app"
  attributes           = ["foo"]
  attributes_as_suffix = true
  label_orders = {
    redis = ["stage", "name", "attributes"]
  }

  kvstores = {
    basic = {}
  }
  redis_ecs_cluster_arn                    = "arn:aws:ecs:eu-central-1:123456789012:cluster/my-cluster"
  redis_service_discovery_dns_namespace_id = "ns-123456789abcdefg"
}
