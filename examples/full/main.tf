module "example" {
  source = "../.."

  namespace            = "ns"
  environment          = "env"
  stage                = "st"
  name                 = "app"
  attributes           = ["foo"]
  attributes_as_suffix = true
  redis_label_order    = ["stage", "name", "attributes"]
  ddb_label_order      = ["environment", "stage", "name", "attributes"]
  iam_label_order      = ["environment", "stage", "name", "attributes"]

  kvstores = {
    basic = {
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
      table = {
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
        enabled             = true
        memory_size         = "100"
        service_memory_size = 150
        service_placement_constraints = [{
          type       = "memberOf"
          expression = "attribute:spotinst.io/container-instance-lifecycle==spot"
        }]
      }
    }
  }
  redis_ecs_cluster_arn                    = "arn:aws:ecs:eu-central-1:164105964448:cluster/mcoins-sandbox-automation"
  redis_launch_type                        = "EC2"
  redis_network_mode                       = null
  redis_propagate_tags                     = "SERVICE"
  redis_service_discovery_dns_namespace_id = "ns-odw635v7pb4veka3"
  redis_vpc_id                             = null
}
