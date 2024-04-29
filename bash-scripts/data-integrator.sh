#!/bin/bash

TOPIC_NAME="test-topic"

echo "Deploying the data-integrator charm ..."

# Deploy the data-integrator
juju deploy data-integrator --channel stable --config topic-name=${TOPIC_NAME} --config extra-user-roles=producer,consumer

# Allow data to pass between the data-integrator and kafka
juju relate data-integrator kafka

# Wait for completion
juju status --watch 1s

# 
juju run data-integrator/leader get-credentials