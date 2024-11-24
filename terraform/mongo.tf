resource "docker_network" "mongo_network" {
  name = "mongo-network"
  lifecycle {
    ignore_changes = [name]
  }
}

resource "docker_volume" "mongo_volume" {
  count = var.mongo_replicas_count
  name  = "mongo_data_${count.index + 1}"
}

resource "docker_container" "mongo_container" {
  image = docker_image.mongo_image.name
  count = var.mongo_replicas_count
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
