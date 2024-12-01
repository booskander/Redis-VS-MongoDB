#!/bin/bash


# Loop through workloads
for letter in a b c
do
  for i in {0..9}
  do
    echo "workload$letter try $i" >> ./res/load_5.csv
    echo "workload$letter try $i" >> ./res/run_5.csv

    docker run -d --rm \
      --name redis-master \
      --network redis-network \
      -p 6379:6379 \
      redis:7 --appendonly yes

    sleep 5

    docker run -d --rm \
      --name redis-slave1 \
      --network redis-network \
      -p 6380:6379 \
      redis:7 --appendonly yes --replicaof redis-master 6379

    docker run -d --rm \
      --name redis-slave2 \
      --network redis-network \
      -p 6381:6379 \
      redis:7 --appendonly yes --replicaof redis-master 6379
    docker run -d --rm \
      --name redis-slave3 \
      --network redis-network \
      -p 6383:6379 \
      redis:7 --appendonly yes --replicaof redis-master 6379

    docker run -d --rm \
      --name redis-slave4 \
      --network redis-network \
      -p 6384:6379 \
      redis:7 --appendonly yes --replicaof redis-master 6379

    sleep 5

    cd ycsb-0.17.0

    ./bin/ycsb load redis -s -P workloads/workload$letter \
      -p redis.host="127.0.0.1" \
      -p redis.port=6379 \
      -p operationcount=1000 -threads 10 \
      -p exportfile=ycsb_load_results.csv

    ./bin/ycsb run redis -s -P workloads/workload$letter \
        -p redis.host="127.0.0.1" \
      -p redis.port=6379 \
      -p operationcount=1000 -threads 10 \
      -p exportfile=ycsb_run_results.csv

    cd ..

    # Remove Redis containers
    docker rm --force redis-master redis-slave1 redis-slave2 redis-slave3 redis-slave4
    echo "y" | docker volume prune


    sleep 5

    cat "./ycsb-0.17.0/ycsb_load_results.csv" >> "./res/load_5.csv"
    cat "./ycsb-0.17.0/ycsb_run_results.csv" >> "./res/run_5.csv"

  done
done
