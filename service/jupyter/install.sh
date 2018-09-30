#!/bin/sh

#########################################
##           CREATE FOLDERS            ##
#########################################
# Create files and directories folders
mkdir -p \
	/mnt/data \
	/home/docker

#########################################
##          SET PERMISSIONS            ##
#########################################
# create a "docker" user
useradd -U -d /home/docker docker

# Set the permissions
chown -R docker:docker \
	/mnt/data \
	/home/docker

# Ensure the docker user can export to container ENV
chmod -R 757 /container/environment \

