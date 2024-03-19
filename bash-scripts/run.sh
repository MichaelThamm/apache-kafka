#!/bin/bash

KAFKA_FOLDER="~/kafka"

cd $KAFKA_FOLDER
. prepare-env.sh
. server.sh
. zookeeper.sh
