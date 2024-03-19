#!/bin/bash

KAFKA_FOLDER="~/kafka"

cd $KAFKA_FOLDER
bin/kafka-server-start.sh config/server.properties
# KAFKA_CLUSTER_ID="$(bin/kafka-storage.sh random-uuid)"