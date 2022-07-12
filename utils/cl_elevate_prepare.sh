#!/bin/bash

yum install -y http://repo.almalinux.org/elevate/elevate-release-latest-el7.noarch.rpm
yum install -y leapp-upgrade leapp-data-almalinux

git clone -b hostinger --single-branch https://github.com/prilr/leapp-repository.git /root/leapp-repository

yes | mv -f /root/leapp-repository/repos/system_upgrade/common/libraries/config/version.py /etc/leapp/repos.d/system_upgrade/common/libraries/config/version.py
yes | mv -f /root/leapp-repository/repos/system_upgrade/common/actors/ipuworkflowconfig/libraries/ipuworkflowconfig.py /etc/leapp/repos.d/system_upgrade/common/actors/ipuworkflowconfig/libraries/ipuworkflowconfig.py
yes | mv -f /root/leapp-repository/repos/system_upgrade/common/actors/redhatsignedrpmscanner/actor.py /etc/leapp/repos.d/system_upgrade/common/actors/redhatsignedrpmscanner/actor.py
yes | mv -f /root/leapp-repository/repos/system_upgrade/common/models/targetsystemtype.py /etc/leapp/repos.d/system_upgrade/common/models/targetsystemtype.py
yes | mv -f /root/leapp-repository/repos/system_upgrade/common/actors/scancustomrepofile/actor.py /etc/leapp/repos.d/system_upgrade/common/actors/scancustomrepofile/actor.py
yes | mv -f /root/leapp-repository/repos/system_upgrade/common/actors/scancustomrepofile/libraries/scancustomrepofile.py /etc/leapp/repos.d/system_upgrade/common/actors/scancustomrepofile/libraries/scancustomrepofile.py
yes | mv -f /root/leapp-repository/repos/system_upgrade/common/actors/setuptargetrepos/actor.py /etc/leapp/repos.d/system_upgrade/common/actors/setuptargetrepos/actor.py

yes | cp -R /etc/leapp/repos.d/system_upgrade/common/files/prod-certs/8.4 /etc/leapp/repos.d/system_upgrade/common/files/prod-certs/8.6
yes | cp -R /root/leapp-repository/repos/system_upgrade/cloudlinux /etc/leapp/repos.d/system_upgrade/cloudlinux

git clone -b hostinger --single-branch https://github.com/prilr/leapp-data.git /root/leapp-data
rsync -a /root/leapp-data/files/cloudlinux/ /etc/leapp/files/

rmmod floppy pata_acpi btrfs
echo PermitRootLogin yes | tee -a /etc/ssh/sshd_config
leapp answer --add --section remove_pam_pkcs11_module_check.confirm=True
leapp answer --add --section select_target_system_type.select=beta

echo -e "\nYou now can run \"leapp upgrade\"!\n"