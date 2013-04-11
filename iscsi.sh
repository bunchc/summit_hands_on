#!/bin/bash

# iscsi.sh

# Authors: Cody Bunch (bunchc@gmail.com)

# Source in common env vars
. /vagrant/common.sh

sudo aptitude purge ebtables
sudo apt-get install -y libvirt-bin build-essential linux-headers-`uname -r`

virsh net-destroy default
virsh net-undefine default

apt-get install -y openvswitch-controller openvswitch-datapath-source openvswitch-brcompat openvswitch-switch 