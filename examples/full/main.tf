module "example" {
  source = "../.."

  namespace            = "ns"
  environment          = "env"
  stage                = "st"
  name                 = "app"
  attributes           = ["foo"]
  attributes_as_suffix = true
  label_orders = {
    ddb   = ["environment", "stage", "name", "attributes"]
    iam   = ["environment", "stage", "name", "attributes"]
    redis = ["stage", "name", "attributes"]
  }

  kvstores = {
    basic = {
      ddb = {
        autoscaler = {
          enabled = true
          read_schedule = [
            {
              schedule     = "cron(0 * * ? * *)"
              min_capacity = 1
              max_capacity = 10
            },
            {
              schedule     = "cron(30 * * ? * *)"
              min_capacity = 10
              max_capacity = 100
            },
          ]
          write_schedule = [
            {
              schedule     = "cron(1* * ? * *)"
              min_capacity = 1
              max_capacity = 10
            },
            {
              schedule     = "cron(31 * * ? * *)"
              min_capacity = 10
              max_capacity = 100
            },
          ]
        }
        billing_mode = "PROVISIONED"
      }
      redis = {
        cpu_size = 100
        deployment = {
          image = {
            repository = "redis"
            tag        = "7"
          }
          desired_count           = 1
          maximum_percent         = 200
          minimum_healthy_percent = 100
        }
        enabled                = true
        memory_size            = "100"
        service_discovery_name = "kvstore_entityName.service.redis"
        service_memory_size    = 150
        service_placement_constraints = [{
          type       = "memberOf"
          expression = "attribute:spotinst.io/container-instance-lifecycle==spot"
        }]
      }
    }
  }
  redis_ecs_cluster_arn                    = "arn:aws:ecs:eu-central-1:123456789012:cluster/my-cluster"
  redis_launch_type                        = "EC2"
  redis_network_mode                       = null
  redis_propagate_tags                     = "SERVICE"
  redis_service_discovery_dns_namespace_id = "ns-12345678abcdefgh"
  redis_vpc_id                             = null
}
