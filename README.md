**MongoDB setup**

# create a network for containers to communicate

`docker network create mongo-network`

# navigate to terraform directory (you can also modify the docker compose if u want)

run:

`terraform init`

`terraform plan`

`terraform apply`

# to change the number of replicas use this command

`terraform apply -var="replicas_count=<desired-count>"`

# to visualize the containers running run this command:

`docker ps`
