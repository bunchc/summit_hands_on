#!/bin/bash

# iscsi.sh

# Authors: Cody Bunch (bunchc@gmail.com)

# Source in common env vars
. /vagrant/common.sh

# Install some deps
sudo apt-get install -y linux-headers-`uname -r` build-essential python-mysqldb xfsprogs

# Install Cinder Things
sudo apt-get install -y cinder-api cinder-scheduler cinder-volume iscsitarget open-iscsi iscsitarget-dkms

# Enable!
sudo sed -i 's/false/true/g' /etc/default/iscsitarget

# Restart services
sudo service iscsitarget start
sudo service open-iscsi start

# Configure Cinder
# /etc/cinder/api-paste.ini
sudo sed -i 's/127.0.0.1/172.16.172.200/g' /etc/cinder/api-paste.ini
sudo sed -i 's/%SERVICE_TENANT_NAME%/service/g' /etc/cinder/api-paste.ini
sudo sed -i 's/%SERVICE_USER%/cinder/g' /etc/cinder/api-paste.ini
sudo sed -i 's/%SERVICE_PASSWORD%/cinder/g' /etc/cinder/api-paste.ini


# /etc/cinder/cinder.conf
cat > /etc/cinder/cinder.conf <<EOF
[DEFAULT]
rootwrap_config=/etc/cinder/rootwrap.conf
sql_connection = mysql://cinder:openstack@${CONTROLLER_HOST}/cinder
api_paste_config = /etc/cinder/api-paste.ini
iscsi_helper=ietadm
volume_name_template = volume-%s
volume_group = cinder-volumes
verbose = True
auth_strategy = keystone
#osapi_volume_listen_port=5900
rabbit_host = ${CONTROLLER_HOST}
EOF

# Sync DB
cinder-manage db sync

# Setup loopback FS for iscsi
dd if=/dev/zero of=cinder-volumes bs=1 count=0 seek=5G
losetup /dev/loop2 cinder-volumes
mkfs.xfs -i size=1024 /dev/loop2
pvcreate /dev/loop2
vgcreate cinder-volumes /dev/loop2

# Restart services
cd /etc/init.d/; for i in $( ls cinder-* ); do sudo service $i restart; done
