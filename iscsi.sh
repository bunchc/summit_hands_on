#!/bin/bash

# iscsi.sh

# Authors: Cody Bunch (bunchc@gmail.com)

# Source in common env vars
. /vagrant/common.sh

# Install Cinder Things
sudo apt-get install -y cinder-api cinder-scheduler cinder-volume iscsitarget open-iscsi iscsitarget-dkms

# Enable!
sudo sed -i 's/false/true/g' /etc/default/iscsitarget

# Restart services
sudo service iscsitarget start
sudo service open-iscsi start

# Configure Cinder
# /etc/cinder/api-paste.ini
#[filter:authtoken]
#paste.filter_factory = keystone.middleware.auth_token:filter_factory
#service_protocol = http
#service_host = ${CONTROLLER_HOST}
#service_port = 5000
#auth_host = ${CONTROLLER_HOST}
#auth_port = 35357
#auth_protocol = http
#admin_tenant_name = service
#admin_user = cinder
#admin_password = cinder

# /etc/cinder/cinder.conf
#[DEFAULT]
#rootwrap_config=/etc/cinder/rootwrap.conf
#sql_connection = mysql://cinderUser:cinderPass@10.10.100.51/cinder
#api_paste_config = /etc/cinder/api-paste.ini
#iscsi_helper=ietadm
#volume_name_template = volume-%s
#volume_group = cinder-volumes
#verbose = True
#auth_strategy = keystone
##osapi_volume_listen_port=5900

# Sync DB
cinder-manage db sync

