#!/bin/bash

echo "Producing and consuming messages ..."

TOPIC_NAME="test-topic"
APP_NAME="kafka-test-app"
# Get internal listener values needed to update the cluster config with
INTERNAL_LISTENERS=$(juju run kafka/leader get-admin-credentials | grep "bootstrap.servers" | cut -d "=" -f2 | sed -s "s/\:9092/:19092/g") 
# Extract username and password from the data-integrator
CREDS=$(juju run data-integrator/leader get-credentials)
USERNAME=$(echo "$CREDS" | awk '{ if ($1 == "username:") { print $2 } }')
PASSWORD=$(echo "$CREDS" | awk '{ if ($1 == "password:") { print $2 } }')

# Kafka Test App: a test charm that also bundles some python scripts to push data to Kafka
juju deploy ${APP_NAME} -n1 --channel edge

# To produce messages to Kafka, configure the APP_NAME to act as producer, publishing messages to a specific topic
# Relate the APP_NAME with Kafka to start producing messages to Kafka
# This will take care of creating a dedicated user and start a producer process publishing messages to the APP_NAME_kafka-app topic, basically automating what was done before by hands.
juju config ${APP_NAME} topic_name=${TOPIC_NAME}_kafka-app role=producer num_messages=50
# wait for the relation to be torn down
sleep 15
juju relate ${APP_NAME} kafka
# Wait for "Topic TOPIC_NAME_kafka-app enabled with process producer" status message
juju status --watch 1s
# Stop the process and remove the user
juju remove-relation ${APP_NAME} kafka

# Consume the messages
juju config ${APP_NAME} topic_name=${TOPIC_NAME}_kafka-app role=consumer consumer_group_prefix=cg
# Wait for the relation to be torn down
sleep 15
juju relate ${APP_NAME} kafka
# Wait for "Topic TOPIC_NAME_kafka-app enabled with process consumer" status message
juju status --watch 1s
# Stop the process and remove the user
juju remove-relation ${APP_NAME} kafka

# Check the logs for produced and consumed messages
juju exec --application ${APP_NAME} "tail /tmp/*.log"


# These following commands are automated with the data-integrator and relations to the kafka client above

#echo ""
#echo "-----------------------------------------------------"
#echo "The following commands in must be executed manually:"
#echo "-----------------------------------------------------"
#echo ""
#echo "juju ssh ${APP_NAME}/0 /bin/bash"
## Make Python virtual environment libraries visible:
#echo "export PYTHONPATH=\"/var/lib/juju/agents/unit-${APP_NAME}-0/charm/venv:/var/lib/juju/agents/unit-${APP_NAME}-0/charm/lib\""
#echo "INTERNAL_LISTENERS=${INTERNAL_LISTENERS}"
#echo "python3 -m charms.kafka.v0.client -u ${USERNAME} -p ${PASSWORD} -t ${TOPIC_NAME} -s \"\$INTERNAL_LISTENERS\" -n 10 --producer -r 3 --num-partitions 2"
#echo "python3 -m charms.kafka.v0.client -u ${USERNAME} -p ${PASSWORD} -t ${TOPIC_NAME} -s \"\$INTERNAL_LISTENERS\" --consumer -c \"cg\""
