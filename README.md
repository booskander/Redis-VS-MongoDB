# Navigate to terraform directory (you can also modify the docker compose if u want)

run:

```
terraform init
terraform plan 
terraform apply
```
 ## At this point, inside your docker desktop app you should have something like

 <img width="809" alt="image" src="https://github.com/user-attachments/assets/e3d33efa-655d-46ae-a468-bdcc4c6fc356">

you can also simply run

`docker ps`
 
 and get
 
<img width="1301" alt="image" src="https://github.com/user-attachments/assets/7a952764-0d97-4c0b-9250-52ff5c66bede">


# Change the number of replicas use this command

```
terraform apply -var="mongo_replicas_count=<desired-count>"
terraform apply -var="redis_replicas_count=<desired-count>
```

# to visualize the containers running run this command:

`docker ps`

# testing mongoDB connectivity

```

```
