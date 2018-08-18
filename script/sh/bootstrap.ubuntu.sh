#!/bin/bash

#### a series of commands for cut-n-paste
#### to setup a newly installed OS running ubuntu and derivative

#### zorin's ansible is 2.0.0.2, can't even do "include-tasks under tasks: section :(

sudo apt-get install git
sudo apt-get install -y python-pip
sudo pip install ansible


exit 0

#### ~~~~ centos version below

sudo groupadd -g 43413 tin
sudo useradd  -g tin -u 43413 -c "tin@lbl.gov" -m -d /home/tin -s /bin/bash tin 

##sudo pwconv
##sudo passwd tin 
## need file redirect, so need to run as root... 
cp -p /etc/shadow /etc/shadow.backup
cat /etc/shadow | grep ^root: | sed  's/^root/tin/' >> /etc/shadow

echo "tin 	ALL=(ALL) 	ALL" >> /etc/sudoers

sudo su - tin
mkdir tin-gh
git clone https://www.github.com/tin6150/psg
cd ~
ln -s tin-gh/psg ~/PSG
cat ~tin/PSG/git.setup.gh.sh | egrep -v "^$|^#"


