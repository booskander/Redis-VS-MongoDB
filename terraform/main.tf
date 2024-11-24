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
  name = "mongo_data"
}

resource "docker_container" "mongo_container" {
  image = docker_image.mongo_image.name
  name  = "local-mongo"
  networks_advanced {
    name = docker_network.mongo_network.name
  }
  ports {
    internal = 27017
    external = 30287
  }
  env = [
    "MONGO_INITDB_ROOT_USERNAME=admin",
    "MONGO_INITDB_ROOT_PASSWORD=password"
  ]
  volumes {
    volume_name    = docker_volume.mongo_volume.name
    container_path = "/data/db"
  }
}

resource "docker_image" "mongo_image" {
  name = "mongo:latest"
}

output "mongo_container_id" {
  value = docker_container.mongo_container.id
}

output "mongo_address" {
  value = "localhost:${docker_container.mongo_container.ports[0].external}"
}
