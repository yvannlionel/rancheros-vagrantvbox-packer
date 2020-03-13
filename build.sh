#!/usr/bin/env bash
# usage: ./build.sh version , for example: ./build.sh 1.3.0
set -o errexit
set -o nounset

if [ -f "production/RancherOS-common" ]
then
	source "production/RancherOS-common"
else
	source "RancherOS-common"
fi

source "RancherOS-${1}"

packer build \
    -var "vm_version=${vm_version}" \
    -var "iso_md5_checksum=${iso_md5_checksum}" \
    -var "vm_description=RancherOS ${vm_version} ${vm_description}" \
    -var "vagrantcloud_box_name=${vagrantcloud_box_name}" \
    -var "vagrantcloud_token=${vagrantcloud_token}" \
    "packer_rancheros.json"
