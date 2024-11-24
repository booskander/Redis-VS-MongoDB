# WARNING !!!! 
# No security has been implemented, it is only to test the deployment native metrics
# DO NOT deploy this configuration on production servers

terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}
provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_network" "mongo_network" {
  name = "mongo-network"
}

resource "docker_volume" "mongo_volume" {
  count = var.replicas_count
  name  = "mongo_data_${count.index + 1}"
}

resource "docker_container" "mongo_container" {
  image = docker_image.mongo_image.name
  count = var.replicas_count
  name  = "local-mongo-${count.index + 1}" # setting unique names
  networks_advanced {
    name = docker_network.mongo_network.name
  }
  ports {
    internal = 27017
    external = 30287 + count.index # checking that ports are unique also
  }
  env = [
    "MONGO_INITDB_ROOT_USERNAME=admin",
    "MONGO_INITDB_ROOT_PASSWORD=password"
  ]
  volumes {
    volume_name    = docker_volume.mongo_volume[count.index].name
    container_path = "/data/db"
  }
}

resource "docker_image" "mongo_image" {
  name = "mongo:latest"
}

output "mongo_container_ids" {
  value = [for container in docker_container.mongo_container : container.id]
}

output "mongo_addresses" {
  value = [for container in docker_container.mongo_container : "localhost:${container.ports[0].external}"]
}
