#!/bin/bash

#### a series of commands for cut-n-paste
#### to setup a newly installed OS

#### centos 6 does not come with ansible
sudo yum -y install epel-release
sudo yum -y install --skip-broken ansible

#### https://dmsimard.com/2016/01/08/selinux-python-virtualenv-chroot-and-ansible-dont-play-nice/
#### Aborting, target uses selinux but python bindings
#### Ansible on localhost need this
sudo yum -y install libselinux-python


#### (before Ansible is setup)

sudo yum -y install git
sudo groupadd -g 43413 tin
sudo useradd  -g tin -u 43413 -c "tin@lbl.gov" -d /home/tin -s /bin/bash tin 

##sudo pwconv
##sudo passwd tin 
## need file redirect, so need to run as root... 
cat /etc/shadow | grep ^root: | sed  's/^root/tin/' >> /etc/shadow

echo "tin 	ALL=(ALL) 	ALL" >> /etc/sudoers

sudo su - tin
cat ~tin/PSG/git.setup.gh.sh | egrep -v "^$|^#"


