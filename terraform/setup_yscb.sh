#!/bin/bash
# git clone http://github.com/brianfrankcooper/YCSB.git
# cd YCSB
# mvn -pl site.ycsb:redis-binding -am clean package

# load the mongoDB

./bin/ycsb load mongodb -s -P workloads/workloada -p recordcount=500000 -threads 16 -p mongodb.url="mongodb://127.0.0.1:27017/" >> ../res/cluster3_load_mongo.csv 

# run the mongoDB

./bin/ycsb load mongodb -s -P workloads/workloada -p recordcount=500000 -threads 16 -p mongodb.url="mongodb://127.0.0.1:27018/" >> ../res/cluster3_run_mongo.csv
 
