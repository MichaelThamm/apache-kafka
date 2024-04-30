#!/bin/bash

echo "Configuring the kafka application ..."

# Get credentials to access a broker
juju run kafka/leader get-admin-credentials

# Get internal listener values needed to update the cluster config with
INTERNAL_LISTENERS=$(juju run kafka/leader get-admin-credentials | grep "bootstrap.servers" | cut -d "=" -f2 | sed -s "s/\:9092/:19092/g")

echo ""
echo "-----------------------------------------------------"
echo "The following commands in must be executed manually:"
echo "-----------------------------------------------------"
echo ""
echo "juju ssh kafka/leader sudo -i"
echo "CLIENT_PROPERTIES=/var/snap/charmed-kafka/current/etc/kafka/client.properties"
echo "INTERNAL_LISTENERS=${INTERNAL_LISTENERS}"
echo ""
echo "Replace the bootstrap.servers value in the client.properties with:"
echo "nano /var/snap/charmed-kafka/current/etc/kafka/client.properties"
echo "bootstrap.servers=${INTERNAL_LISTENERS}"
echo ""