#!/bin/bash

echo "Configuring the kafka application ..."

TOPIC_NAME="test-topic"


# Get credentials to access a broker
juju run kafka/leader get-admin-credentials

# Get internal listener values needed to update the cluster config with
INTERNAL_LISTENERS=$(juju run kafka/leader get-admin-credentials | grep "bootstrap.servers" | cut -d "=" -f2 | sed -s "s/\:9092/:19092/g")

echo ""
echo "-----------------------------------------------------"
echo "The following commands in must be executed manually:"
echo "-----------------------------------------------------"
echo ""
echo "multipass shell microstack"
echo "juju ssh kafka/leader sudo -i"
echo "CLIENT_PROPERTIES=/var/snap/charmed-kafka/current/etc/kafka/client.properties"
echo "INTERNAL_LISTENERS=${INTERNAL_LISTENERS}"
echo ""
echo "Replace the bootstrap.servers value in the client.properties with:"
echo "nano /var/snap/charmed-kafka/current/etc/kafka/client.properties"
echo "bootstrap.servers=${INTERNAL_LISTENERS}"
echo ""
# Create a topic
echo "charmed-kafka.topics --create --topic ${TOPIC_NAME} --bootstrap-server \$INTERNAL_LISTENERS --command-config \$CLIENT_PROPERTIES"
echo ""
# List the topic
echo "charmed-kafka.topics --list --bootstrap-server \$INTERNAL_LISTENERS --command-config \$CLIENT_PROPERTIES"
echo ""
# Delete the topic
echo "charmed-kafka.topics --delete --topic ${TOPIC_NAME} --bootstrap-server \$INTERNAL_LISTENERS --command-config \$CLIENT_PROPERTIES"
echo ""

# Define a function to prompt the user and read the response
prompt_user() {
    read -p "Have you made the config changes in the kafka node and are ready to continue (y/n)? " answer
}

# Call the function to prompt the user for the first time
prompt_user
# Loop until a valid response is provided
while true; do
    # Check the user's response
    if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
        break
    elif [[ "$answer" == "n" || "$answer" == "N" ]]; then
        echo "Execution stopped, exiting shell ..."
        sleep 3
        exit 0
    else
        echo "Invalid input. Please enter 'y' or 'n'."
        prompt_user
    fi
done