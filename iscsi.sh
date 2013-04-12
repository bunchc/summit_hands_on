#!/bin/bash

# iscsi.sh

# Authors: Cody Bunch (bunchc@gmail.com)

# Source in common env vars
. /vagrant/common.sh

# Install dependencies
sudo apt-get install -y linux-headers-`uname -r` build-essential
sudo apt-get install -y openvswitch-switch