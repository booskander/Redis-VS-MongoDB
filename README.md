# Prerequisities, install docker and terraform fam, we in 2024...

# 1. Navigate to terraform directory

run:

```
terraform init
terraform plan
terraform apply
```

# 2. At this point, inside your docker desktop app you should have something like

<img width="1185" alt="image" src="https://github.com/user-attachments/assets/7641b3df-195f-464a-97a7-6092a939ed01">

### you can also simply run

`docker ps`

### and get

<img width="1384" alt="image" src="https://github.com/user-attachments/assets/5995928b-23e3-4df4-baed-9e3db6364ed9">

# 3. (Optional) Change the number of replicas use this command

```
terraform apply -var="mongo_replicas_count=<desired-count>"
terraform apply -var="redis_replicas_count=<desired-count>
```

# 4. Testing mongoDB connectivity

```
mongosh --host localhost --port <desired-port>
```

### you should now see a mongoDB shell like this:

<img width="1469" alt="image" src="https://github.com/user-attachments/assets/7bcf9d32-06e8-4016-8637-c0dd8f04ed1d">

# 5. Testing Redis connectivity

`redis-cli -h localhost -p <desired-port>`

### you should now see a redis shell like this:

<img width="754" alt="image" src="https://github.com/user-attachments/assets/f6ce94fe-81aa-4fd8-8178-81fb9f094588">

# 6. Verify that the replication set works as expected by runningg
```
mongosh --host localhost --port <desired-port>
rs.status()
```
**and you should get the following output...**

<img width="953" alt="image" src="https://github.com/user-attachments/assets/4f3702e3-6470-41ad-a667-3d18ed077821">


# For reference:

https://www.mongodb.com/resources/products/compatibilities/deploying-a-mongodb-cluster-with-docker
