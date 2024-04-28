#!/bin/bash

# Perform post-installation tasks
lxd init --auto
lxc network set lxdbr0 ipv6.address none

# Bootstrap a Juju controller named overlord to LXD
juju bootstrap localhost overlord
lxc list

# Models host applications such as Charmed Kafka
juju add-model demo

juju deploy zookeeper -n 5
juju deploy kafka -n 3
juju relate kafka zookeeper
juju status --watch 1s