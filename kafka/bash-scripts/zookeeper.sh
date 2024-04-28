#!/bin/bash

KAFKA_FOLDER="~/kafka"

cd $KAFKA_FOLDER
bin/zookeeper-server-start.sh config/zookeeper.properties
# KAFKA_CLUSTER_ID="$(bin/kafka-storage.sh random-uuid)"