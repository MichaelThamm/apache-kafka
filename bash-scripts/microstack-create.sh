#!/bin/bash

VM_NAME="microstack"

echo "Creating microstack ..."

# Multipass is a tool to manage VMs.
sudo snap install multipass

# Create a VM with Ubuntu 22.04 LTS.
multipass launch 22.04 --name microstack --cloud-init ../cloud-init.yaml --cpus 4 --memory 17G --disk 50G

# Check VM status
multipass list