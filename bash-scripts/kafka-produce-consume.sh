#!/bin/bash

echo "Producing and consuming messages ..."

# Kafka Test App: a test charm that also bundles some python scripts to push data to Kafka
juju deploy kafka-test-app -n1 --channel edge

# Get internal listener values needed to update the cluster config with
INTERNAL_LISTENERS=$(juju run kafka/leader get-admin-credentials | grep "bootstrap.servers" | cut -d "=" -f2 | sed -s "s/\:9092/:19092/g") 
# Extract username and password from the data-integrator
CREDS=$(juju run data-integrator/leader get-credentials)
USERNAME=$(echo "$CREDS" | awk '{ if ($1 == "username:") { print $2 } }')
PASSWORD=$(echo "$CREDS" | awk '{ if ($1 == "password:") { print $2 } }')

echo ""
echo "-----------------------------------------------------"
echo "The following commands in must be executed manually:"
echo "-----------------------------------------------------"
echo ""
echo "juju ssh kafka-test-app/0 /bin/bash"
# Make Python virtual environment libraries are visible:
echo 'export PYTHONPATH="/var/lib/juju/agents/unit-kafka-test-app-0/charm/venv:/var/lib/juju/agents/unit-kafka-test-app-0/charm/lib"'
echo "python3 -m charms.kafka.v0.client -u ${USERNAME} -p ${PASSWORD} -t test-topic -s \"${INTERNAL_LISTENERS}\" -n 10 --producer -r 3 --num-partitions 1"