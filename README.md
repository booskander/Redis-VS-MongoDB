# 1. Navigate to terraform directory (you can also modify the docker compose if u want)

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
mongosh --host localhost --port <desired-port> -u admin -p password
```
### you should now see a mongoDB shell like this:
<img width="1469" alt="image" src="https://github.com/user-attachments/assets/7bcf9d32-06e8-4016-8637-c0dd8f04ed1d">


