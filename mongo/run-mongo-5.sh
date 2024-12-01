#!/bin/bash

for letter in a b c
do
for i in {0..9}
do
echo "workload$letter try $i" >> ./res/load_5.csv
echo "workload$letter try $i" >> ./res/run_5.csv
docker run -d --rm -p 27017:27017 \
--name mongo1 \
--network mongo-network \
mongo:5 mongod \
--replSet myReplicaSet \
--bind_ip localhost,mongo1

docker run -d --rm -p 27018:27017 \
--name mongo2 \
--network mongo-network \
mongo:5 mongod \
--replSet myReplicaSet \
--bind_ip localhost,mongo2

docker run -d --rm -p 27019:27017 \
--name mongo3 \
--network mongo-network \
mongo:5 mongod \
--replSet myReplicaSet \
--bind_ip localhost,mongo3

docker run -d --rm -p 27020:27017 \
--name mongo4 \
--network mongo-network \
mongo:5 mongod \
--replSet myReplicaSet \
--bind_ip localhost,mongo4

docker run -d --rm -p 27021:27017 \
--name mongo5 \
--network mongo-network \
mongo:5 mongod \
--replSet myReplicaSet \
--bind_ip localhost,mongo5


sleep 5

docker exec -it mongo1 mongosh --eval "rs.initiate({
 _id: \"myReplicaSet\",
 members: [
   {_id: 0, host: \"mongo1\"},
   {_id: 1, host: \"mongo2\"},
   {_id: 2, host: \"mongo3\"},
    {_id: 3, host: \"mongo4\"},
   {_id: 4, host: \"mongo5\"}
 ]
})"

cd ycsb-0.17.0

./bin/ycsb load mongodb -s -P workloads/workload$letter \
-p mongodb.url="mongodb://localhost:27017/testdb" \
-p operationcount=1000 -threads 10 \
-p exportfile=ycsb_load_results.csv

./bin/ycsb run mongodb -s -P workloads/workloada$letter \
-p mongodb.url="mongodb://localhost:27017/testdb" \
-p operationcount=1000 -threads 10 \
-p exportfile=ycsb_run_results.csv

cd ..

docker rm --force mongo1 
docker rm --force mongo2
docker rm --force mongo3
docker rm --force mongo4
docker rm --force mongo5

echo "y" | docker volume prune

sleep 5

cat "./ycsb-0.17.0/ycsb_load_results.csv" >> "./res/load_5.csv"
cat "./ycsb-0.17.0/ycsb_run_results.csv" >> "./res/run_5.csv"

done
done


