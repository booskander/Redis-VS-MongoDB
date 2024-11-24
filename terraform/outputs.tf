output "mongo_container_ids" {
  value = [for container in docker_container.mongo_container : container.id]
}

output "mongo_addresses" {
  value = [for container in docker_container.mongo_container : "localhost:${container.ports[0].external}"]
}

output "redis_container_ids" {
  value = [for container in docker_container.redis_container : container.id]
}

output "redis_addresses" {
  value = [for container in docker_container.redis_container : "localhost:${container.ports[0].external}"]
}
