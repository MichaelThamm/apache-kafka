#!/bin/bash

echo "Managing kafka admin and user accounts ..."

# Rotate admin credentials
read -p "Please choose a new, strong kafka admin password: " new_pswd
juju run kafka/leader set-password username=admin password=new_pswd

# Rotate user credentials using the data-integrator by removing and then re-relating the data-integrator with the kafka charm
juju run data-integrator/leader get-credentials
juju remove-relation kafka data-integrator
# wait for the relation to be torn down 
sleep 5
juju relate kafka data-integrator
juju run data-integrator/leader get-credentials

# Removing a user is done by removing relations
juju remove-relation kafka data-integrator
juju status --watch 1s