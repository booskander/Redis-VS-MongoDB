#!/bin/bash

# Check if the required argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <replica_count>"
  exit 1
fi

REPLICA_COUNT=$1
DB_NAME="myDatabase"  # Specify the name of the database to create
COLLECTION_NAME="myCollection"  # Specify the name of the collection to create

# Wait until the MongoDB container is ready
for i in {1..10}; do
  if docker exec mongo-node-1 mongosh --eval 'db.adminCommand("ping")' >/dev/null 2>&1; then
    echo "MongoDB is ready."
    break
  fi
  echo "Waiting for MongoDB to be ready..."
  sleep 5
done

# Check if the replica set is already initiated
INITIATED=$(docker exec mongo-node-1 mongosh --quiet --eval 'rs.status().ok' 2>/dev/null || echo 0)

if [ "$INITIATED" -ne 1 ]; then
  echo "Initializing replica set with $REPLICA_COUNT members..."

  # Dynamically build the replica set configuration
  MEMBERS=""
  for ((i=0; i<REPLICA_COUNT; i++)); do
    HOST="mongo-node-$((i + 1))"
    MEMBERS+="{_id: $i, host: '$HOST'},"
  done
  MEMBERS=${MEMBERS%,} # Remove trailing comma

  # Execute the rs.initiate command with the dynamically built members
  docker exec mongo-node-1 mongosh --eval "rs.initiate({
    _id: 'mongo-replica-set',
    members: [
      $MEMBERS
    ]
  })"
  echo "Replica set initialized with $REPLICA_COUNT members."
else
  echo "Replica set is already initialized."
fi

# Wait until the replica set is ready
for i in {1..10}; do
  if docker exec mongo-node-1 mongosh --eval 'rs.isMaster().ismaster' >/dev/null 2>&1; then
    echo "Replica set is ready for database operations."
    break
  fi
  echo "Waiting for replica set to be ready..."
  sleep 5
done

# Create the database and collection
echo "Creating database '$DB_NAME' and collection '$COLLECTION_NAME'..."

docker exec mongo-node-1 mongosh --eval "
  use ${DB_NAME};
  db.createCollection('${COLLECTION_NAME}');
  print('Database and Collection created successfully.');
"
echo "Database and collection created."
