#!/bin/bash

#### a series of commands for cut-n-paste
#### to setup a newly installed OS running ubuntu and derivative
#### invoke this script with sudo if not cut-n-pasting.


sudo apt-get install git
sudo apt-get install -y python-pip
sudo pip install ansible
#### zorin's ansible is 2.0.0.2, can't even do "include-tasks under tasks: section :(
#### so pip version of ansible is used instead.

#sudo dpkg --erase alpine-pico  # cuz have visudo bringing up pico!!


#exit 0

#### ~~~~ centos version below
#### may want to add some check to be centos before doing some of them...

sudo groupadd -g 43413 tin
sudo useradd  -g tin -u 43413 -c "tin@lbl.gov" -m -d /home/tin -s /bin/bash tin 

##sudo pwconv
##sudo passwd tin 
## need file redirect, so need to run as root... 
sudo cp -p   /etc/shadow /etc/shadow.backup
sudo sed -i  '/^tin:/d'  /etc/shadow             ## need to remove tin first.
sudo cat /etc/shadow | grep ^root: | sed  's/^root/tin/' | sudo tee -a /etc/shadow
echo "tin 	ALL=(ALL) 	ALL" | sudo tee -a /etc/sudoers



exit 0

# below, if really needed, need to cut-n-paste.  
# maybe can use sudo with heredoc??

sudo su - tin
mkdir tin-gh
tin git clone https://www.github.com/tin6150/psg
cd ~
ln -s tin-gh/psg ~/PSG

# below may have been run from psg dir already...
#cat ~tin/PSG/git.setup.gh.sh | egrep -v "^$|^#"
bash ~tin/PSG/git.setup.gh.sh # when prompt for password, can enter it and continue if not using pipe method above


