#!/bin/bash

### install bunch of apps that is needed on the mac 
### script would hopefully allow getting new machine up and ready
### but may need to update version number of each app :(


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
