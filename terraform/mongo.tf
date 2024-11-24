# resource "null_resource" "mongo_replicaset_init" {
#   depends_on = [docker_container.mongo_container]

#   provisioner "local-exec" {
#     command = <<EOT
#       for i in {1..10}; do
#         docker exec mongo-node-1 mongo --eval 'rs.initiate()' && break || sleep 5;
#       done
#           docker exec mongo-node-1 mongosh --eval "rs.initiate({
#         _id: \"myReplicaSet\",
#         members: [
#           ${join(",", [for i in range(var.mongo_replicas_count) : "{_id: $i, host: \"mongo-node-${i + 1}\"}"])}
#         ]
#       })"
#     EOT
#   }
# }

# resource "null_resource" "mongo_replicaset_custom_init" {
#   depends_on = [null_resource.mongo_replicaset_init]

#   provisioner "local-exec" {
#     command = <<EOT
#       docker exec mongo-node-1 mongosh --eval "rs.initiate({
#         _id: \"myReplicaSet\",
#         members: [
#           ${join(",", [for i in range(var.mongo_replicas_count) : "{_id: $i, host: \"mongo-node-${i + 1}\"}"])}
#         ]
#       })"
#     EOT
#   }
# }


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
  name  = "mongo-node-${count.index + 1}"

  networks_advanced {
    name = docker_network.mongo_network.name
  }
  ports {
    internal = 27017
    external = 27017 + count.index
  }

  env = [
    # "MONGO_INITDB_ROOT_USERNAME=admin",
    # "MONGO_INITDB_ROOT_PASSWORD=password",
    "MONGO_REPLICA_SET_NAME=mongo-replica-set"
  ]

  command = [
    "mongod",
    "--replSet", "mongo-replica-set",
    "--bind_ip_all",
  ]
  volumes {
    volume_name    = docker_volume.mongo_volume[count.index].name
    container_path = "/data/db"
  }
}


resource "docker_image" "mongo_image" {
  # nearly died to find the right docker image that still supports this bs 
  name = "mongo:5"
}



resource "null_resource" "mongo_replicaset_custom_init" {
  depends_on = [docker_container.mongo_container]
  provisioner "local-exec" {
    command = "./script.sh ${var.mongo_replicas_count}"
  }
}
