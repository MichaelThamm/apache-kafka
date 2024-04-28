# MicroStack

# Tutorials
* [install-microstack](https://microstack.run)
* [charmed-kafka](https://canonical.com/data/docs/kafka/iaas/t-overview)
* [zero-to-hero-kafka-connect](https://github.com/confluentinc/demo-scene/blob/master/kafka-connect-zero-to-hero/demo_zero-to-hero-with-kafka-connect.adoc)
* [debezium-kafka-connect](https://debezium.io/documentation/reference/stable/architecture.html)

## Bash Scripts
* To run Kafka in single-broker mode, execute:
  * ```. bash-scripts/run.sh```

## Remove microstack (clean environment)
```multipass stop microstack && multipass delete microstack && multipass purge && multipass list```

## Install microstack

### Install multipass
```sudo snap install multipass```
* This command installs Multipass, which is a tool to manage virtual machines (VMs) on your system.

### Get a fresh VM with Ubuntu 22.04 LTS
```multipass launch 22.04 --name microstack --cloud-init cloud-init.yaml --cpus 4 --memory 17G --disk 50G && multipass shell microstack```
* I launched with ```22.04``` because sunbeam was not available for noble (default) at the time of writing this.
* This command creates a new VM named "microstack" with specific CPU, memory, and disk specifications. It then opens a shell in that VM. Since this command creates a VM, any changes or tests you perform will be isolated within this VM.

### Install MicroStack
```sudo snap install openstack```
* This command installs MicroStack, which is a lightweight version of OpenStack designed for development and testing purposes. It installs OpenStack services in your VM.

### Prepare a machine
```sunbeam prepare-node-script | bash -x && newgrp snap_daemon```
* This command prepares the VM for hosting OpenStack services. It might install necessary dependencies and configure some settings within the VM. The newgrp snap_daemon command might change your group membership.
* Result:
  * ```
    ++ lsb_release -sc
    + '[' jammy '!=' jammy ']'
    ++ whoami
    + USER=ubuntu
    ++ id -u
    + '[' 1000 -eq 0 -o ubuntu = root ']'
    + SUDO_ASKPASS=/bin/false
    + sudo -A whoami
    + sudo grep -r ubuntu /etc/sudoers /etc/sudoers.d
    + grep NOPASSWD:ALL
    + dpkg -s openssh-server
    + echo 'fs.inotify.max_user_instances = 1024'
    + sudo tee /etc/sysctl.d/80-sunbeam.conf
    fs.inotify.max_user_instances = 1024
    + sudo sysctl -q -p /etc/sysctl.d/80-sunbeam.conf
    + sudo snap connect openstack:ssh-keys
    + sudo addgroup ubuntu snap_daemon
    Adding user `ubuntu' to group `snap_daemon' ...
    Adding user ubuntu to group snap_daemon
    Done.
    + newgrp snap_daemon
    Generating public/private rsa key pair.
    Your identification has been saved in /home/ubuntu/.ssh/id_rsa
    Your public key has been saved in /home/ubuntu/.ssh/id_rsa.pub
    The key fingerprint is:
    SHA256:gfZ8g4nvtG+UsPUd0V2xH+rbOixZDG7Od5URmh7KDiM ubuntu@microstack
    The key's randomart image is:
    +---[RSA 4096]----+
    |               o=|
    |       .      ..+|
    |      o .     o+.|
    |     . +.+.. +o.o|
    |      . S+=o=o..+|
    |       E.+o*o+...|
    |        +.B +.  .|
    |       o ..* +o. |
    |        oo. oo+. |
    +----[SHA256]-----+
    # 10.58.221.62:22 SSH-2.0-OpenSSH_8.9p1 Ubuntu-3ubuntu0.6
    # 10.58.221.62:22 SSH-2.0-OpenSSH_8.9p1 Ubuntu-3ubuntu0.6
    # 10.58.221.62:22 SSH-2.0-OpenSSH_8.9p1 Ubuntu-3ubuntu0.6
    # 10.58.221.62:22 SSH-2.0-OpenSSH_8.9p1 Ubuntu-3ubuntu0.6
    # 10.58.221.62:22 SSH-2.0-OpenSSH_8.9p1 Ubuntu-3ubuntu0.6
    juju (3.2/stable) 3.2.4 from Canonical✓ installed
    ```

### Bootstrap OpenStack
```sunbeam cluster bootstrap --accept-defaults```
* This command initializes the OpenStack services within the VM. It sets up the necessary components to run OpenStack, such as databases, message queues, and identity services. This process is contained within the VM.
* [fqdn-bug](https://bugs.launchpad.net/snap-openstack/+bug/2030349/comments/6)
* Result:
  * ```Node has been bootstrapped with roles: control, compute```

### Configure OpenStack
```sunbeam configure --accept-defaults --openrc demo-openrc```
* This command configures the OpenStack environment for use. It generates an OpenStack RC file (demo-openrc) that contains environment variables needed to interact with OpenStack services. Again, this process is contained within the VM.

### Launch a cloud instance
```sunbeam launch ubuntu -n test```
* This command launches a new Ubuntu cloud instance within the OpenStack environment. It's a way to test the functionality of OpenStack by creating and managing cloud instances. Any actions performed within this instance will be isolated within the OpenStack environment.
* Result: 
  * ```Launching an OpenStack instance ... 
    Access instance with `ssh -i /home/ubuntu/snap/openstack/324/sunbeam ubuntu@10.20.20.254`
    ```

![juju-status](documentation/juju-status.png)