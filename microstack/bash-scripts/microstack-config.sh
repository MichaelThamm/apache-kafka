#!/bin/bash

VM_NAME="microstack"
CLOUD_INSTANCE_NAME="openstack"

echo "Configuring microstack ..."

# Install openstack
multipass exec ${VM_NAME} -- sudo snap install openstack

# Prepare a machine
multipass exec ${VM_NAME} -- bash -c "sudo -i -u ubuntu sunbeam prepare-node-script | bash -x && newgrp snap_daemon < /dev/null"

# Bootstrap OpenStack
multipass exec ${VM_NAME} -- sunbeam cluster bootstrap --accept-defaults

# Configure OpenStack
multipass exec ${VM_NAME} -- sunbeam configure --accept-defaults --openrc demo-openrc

# Launch a cloud instance
multipass exec ${VM_NAME} -- sunbeam launch ubuntu -n ${CLOUD_INSTANCE_NAME}
