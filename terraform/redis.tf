resource "docker_network" "redis_network" {
  name = "redis-network"
  lifecycle {
    ignore_changes = [name]
  }
}

resource "docker_volume" "redis_volume" {
  count = var.redis_replicas_count
  name  = "redis_data_${count.index + 1}"
}

resource "docker_image" "redis_image" {
  name = "redis:latest"
}

resource "docker_container" "redis_container" {
  count = var.redis_replicas_count
  image = docker_image.redis_image.name
  name  = "redis-node-${count.index + 1}"
  networks_advanced {
    name = docker_network.redis_network.name
  }
  ports {
    internal = 6379
    external = 6379 + count.index
  }
  volumes {
    volume_name    = docker_volume.redis_volume[count.index].name
    container_path = "/data"
  }
  env = [
    "REDIS_PASSWORD=password", # Add any necessary env vars like passwords
  ]
  command = ["redis-server", "--requirepass", "password", "--save", "900", "1", "--loglevel", "warning"]

}
