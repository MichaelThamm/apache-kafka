#!/bin/bash

KAFKA_FOLDER="~/kafka"
sudo apt update && sudo apt upgrade
# Install dependencies
sudo apt install -y openjdk-11-jdk gnome-terminal

cd $KAFKA_FOLDER
bin/zookeeper-server-start.sh config/zookeeper.properties
bin/kafka-server-start.sh config/server.properties

# KAFKA_CLUSTER_ID="$(bin/kafka-storage.sh random-uuid)"