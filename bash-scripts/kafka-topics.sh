#!/bin/bash

TOPIC_NAME="test-topic"

echo ""
echo "-----------------------------------------------------"
echo "The following commands in must be executed manually:"
echo "-----------------------------------------------------"
echo ""
echo "juju ssh kafka/leader sudo -i"
# Create a topic
echo "charmed-kafka.topics --create --topic ${TOPIC_NAME} --bootstrap-server \$INTERNAL_LISTENERS --command-config \$CLIENT_PROPERTIES"
echo ""
# List the topic
echo "charmed-kafka.topics --list --bootstrap-server \$INTERNAL_LISTENERS --command-config \$CLIENT_PROPERTIES"
echo ""
# Delete the topic
echo "charmed-kafka.topics --delete --topic ${TOPIC_NAME} --bootstrap-server \$INTERNAL_LISTENERS --command-config \$CLIENT_PROPERTIES"
echo ""
