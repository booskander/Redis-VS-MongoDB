#!/bin/bash


for i in {1..10}
do
cd ..
cd ./YCSB
echo "Loading data into MongoDB on port 27017..."
./bin/ycsb load mongodb -s -P workloads/workloadf -p recordcount=1000 -threads 32 -p mongodb.url="mongodb://127.0.0.1:27017" >> /Users/skander/poly/architecture/Redis-VS-MongoDB/terraform/outputLoad.txt

if [ $? -eq 0 ]; then
    echo "Data loaded successfully into MongoDB on port 27017"
else
    echo "Error loading data into MongoDB on port 27017"
    exit 1
fi

echo "Loading data into MongoDB on port 27018..."
./bin/ycsb load mongodb -s -P workloads/workloadf -p recordcount=1000 -threads 32 -p mongodb.url="mongodb://127.0.0.1:27017" >> /Users/skander/poly/architecture/Redis-VS-MongoDB/terraform/outputRun.txt

if [ $? -eq 0 ]; then
    echo "Data loaded successfully into MongoDB on port 27017"
else
    echo "Error loading data into MongoDB on port 27017"
    exit 1
fi
cd ..
cd terraform
echo "yes" | terraform destroy

sleep 5

echo "yes" | terraform init

sleep 5
done
