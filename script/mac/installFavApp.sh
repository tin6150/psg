#!/bin/bash

### install bunch of apps that is needed on the mac 
### script would hopefully allow getting new machine up and ready
### but may need to update version number of each app :(
### or have Ansible provision it??!! 

###
### run as:
### wget https://raw.githubusercontent.com/tin6150/psg/master/script/mac/installFavApp.sh -O installFavApp.sh
### bash ./installFavApp.sh
###


## brew

brew install gtk-vnc
# /usr/local/opt/gtk-vnc/bin/gvncviewer
# may have vncserver there too?


cd ~/Downloads

wget https://releases.hashicorp.com/vagrant/2.0.0/vagrant_2.0.0_x86_64.dmg
sudo hdiutil attach vagrant_2.0.0_x86_64.dmg
sudo installer -package /Volumes/Vagrant/vagrant.pkg -target /
# installed to /opt/vagrant with link in /usr/local
sudo hdiutil detach /Volumes/Vagrant

wget http://download.virtualbox.org/virtualbox/5.1.28/VirtualBox-5.1.28-117968-OSX.dmg
sudo hdiutil attach VirtualBox-5.1.28-117968-OSX.dmg 
sudo installer -package /Volumes/VirtualBox/VirtualBox.pkg -target /
# installed to /Applications/VirtualBox.app
sudo hdiutil detach /Volumes/VirtualBox/


### think had some brew install... forgot to merge somewhere...??
### use system's python, add pip, install ansible
### http://docs.ansible.com/ansible/latest/intro_installation.html#latest-releases-via-pip
### hmm... the git method maybe easier to deal with, esp on mac...?

sudo /usr/bin/easy_install pip		
sudo pip install ansible



###
### not installing apps, but should fix for all macs :)
###

sudo launchctl limit maxfiles unlimited		# fix number of open file handles to unlimited (def is very low)

defaults write com.apple.Terminal FocusFollowsMouse -boolean YES 	# sloppy mouse
