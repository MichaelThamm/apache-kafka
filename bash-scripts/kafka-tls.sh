#!/bin/bash

# Enabling TLS within an HA DB and between an HA DB to client/server applications using Charmed Kafka has the domain-specific knowledge encoded within it.
# TLS is enabled via relations; i.e. by relating Charmed Kafka to the Self-signed Certificates Charm via the tls-certificates charm relations.
# This centralises TLS certificate management in a consistent manner and handles providing, requesting, and renewing TLS certificates.
# It supports different providers, like the self-signed certificates but also other services, e.g. Let’s Encrypt.

TOPIC_NAME="test-topic"
APP_NAME="kafka-test-app"

# Distribute self-signed certificates to all charms (Kafka, Zookeeper and client applications) signed using a root self-signed CA, trusted by all applications.
juju deploy self-signed-certificates --config ca-common-name="Tutorial CA"

juju status --watch 1s

# Enable TLS on zookeeper and kafka
juju relate zookeeper self-signed-certificates
juju relate kafka:certificates self-signed-certificates

# Checḱ for default encrypted port 9093
telnet


# Client apps need reconfiguration to connect to port 9093 and trust the self-signed CA provided by the self-signed-certificates charm.
juju remove-relation ${APP_NAME} kafka

# Enable encryption on the APP_NAME by relating with the self-signed-certificates charm
juju relate ${APP_NAME} self-signed-certificates

# Set up the APP_NAME to produce messages (note there is no difference with the unencrypted workflow)
juju config ${APP_NAME} topic_name=${TOPIC_NAME}_encrypted role=producer num_messages=50
juju relate ${APP_NAME} kafka
juju exec --application ${APP_NAME} "tail /tmp/*.log"

# Remove the external TLS and return to the locally generate one by removing application relations:
juju remove-relation kafka self-signed-certificates
juju remove-relation zookeeper self-signed-certificates