#!/bin/bash

TOPIC_NAME="test-topic"

echo "Entering the kafka leader node ..."
echo "Execute the commands in kafka-topics.sh manually ..."

juju ssh kafka/leader sudo -i

# These commands will not be automatically executed and need to be manually entered after entering the ssh 
export INTERNAL_LISTENERS="<contents copied from kafka-config.sh result>"
export CLIENT_PROPERTIES=/var/snap/charmed-kafka/current/etc/kafka/client.properties

# Create a topic
charmed-kafka.topics \
    --create --topic ${TOPIC_NAME} \
    --bootstrap-server $INTERNAL_LISTENERS \
    --command-config $CLIENT_PROPERTIES

# List the topic, using
charmed-kafka.topics \
    --list \
    --bootstrap-server  $INTERNAL_LISTENERS \
    --command-config $CLIENT_PROPERTIES

# Delete the topic, using
charmed-kafka.topics \
    --delete --topic ${TOPIC_NAME} \
    --bootstrap-server  $INTERNAL_LISTENERS \
    --command-config $CLIENT_PROPERTIES