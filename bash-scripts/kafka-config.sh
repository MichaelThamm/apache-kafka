#!/bin/bash

echo "Configuring kafka application ..."

# Get credentials to access a broker
juju run kafka/leader get-admin-credentials
INTERNAL_LISTENERS=$(juju run kafka/leader get-admin-credentials | grep "bootstrap.servers" | cut -d "=" -f2 | sed -s "s/\:9092/:19092/g")
echo "---INTERNAL LISTENERS CONTENTS---"
echo $INTERNAL_LISTENERS
echo "---------------------------------"

juju ssh kafka/leader sudo -i
export CLIENT_PROPERTIES=/var/snap/charmed-kafka/current/etc/kafka/client.properties