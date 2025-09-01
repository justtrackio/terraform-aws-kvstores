module "kvstore_label" {
  source  = "justtrackio/label/null"
  version = "0.26.0" # requires Terraform >= 0.13.0

  for_each = var.kvstores

  enabled             = module.this.enabled
  namespace           = module.this.namespace
  tenant              = module.this.tenant
  environment         = module.this.environment
  stage               = module.this.stage
  name                = module.this.name
  delimiter           = module.this.delimiter
  tags                = module.this.tags
  additional_tag_map  = module.this.additional_tag_map
  label_order         = var.label_order
  regex_replace_chars = module.this.regex_replace_chars
  id_length_limit     = module.this.id_length_limit
  label_key_case      = var.label_key_case
  label_value_case    = var.label_value_case
  descriptor_formats  = var.descriptor_formats
  labels_as_tags      = var.labels_as_tags
  attributes          = var.attributes_as_suffix ? concat([each.key], module.this.attributes) : concat(module.this.attributes, [each.key])
}

module "kvstore" {
  source  = "justtrackio/kvstore/aws"
  version = "2.5.0"

  for_each = var.kvstores

  context          = module.kvstore_label[each.key].context
  label_value_case = var.label_value_case

  name = var.name

  ddb_autoscale_read_schedule  = each.value.ddb.autoscaler.enabled ? each.value.ddb.autoscaler.read_schedule : []
  ddb_autoscale_write_schedule = each.value.ddb.autoscaler.enabled ? each.value.ddb.autoscaler.write_schedule : []
  ddb_billing_mode             = each.value.ddb.billing_mode
  label_orders                 = var.label_orders

  redis_cpu_size                           = each.value.redis.cpu_size
  redis_deployment_maximum_percent         = each.value.redis.deployment.maximum_percent
  redis_deployment_minimum_healthy_percent = each.value.redis.deployment.minimum_healthy_percent
  redis_desired_count                      = each.value.redis.deployment.desired_count
  redis_ecs_cluster_arn                    = var.redis_ecs_cluster_arn
  redis_image_repository                   = each.value.redis.deployment.image.repository
  redis_image_tag                          = each.value.redis.deployment.image.tag
  redis_launch_type                        = var.redis_launch_type
  redis_memory_size                        = each.value.redis.memory_size
  redis_network_mode                       = var.redis_network_mode
  redis_propagate_tags                     = var.redis_propagate_tags
  redis_service_discovery_dns_namespace_id = var.redis_service_discovery_dns_namespace_id
  redis_service_discovery_name             = each.value.redis.service_discovery_name
  redis_service_memory_size                = each.value.redis.service_memory_size
  redis_service_placement_constraints      = each.value.redis.service_placement_constraints
  redis_vpc_id                             = var.redis_vpc_id
  redis_enabled                            = each.value.redis.enabled

  tags = module.this.tags
}
