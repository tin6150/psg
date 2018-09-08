#!/bin/bash

#### a series of commands for (cut-n-paste) or exec script as sudo
#### to setup a newly installed OS running ubuntu and derivative
#### try to minimize, enough to run ansible and let that take over from there.

#### *sigh* homebrew does not allow to be run as sudo brew :(
#### so maybe don't call this script via sudo, and let it invoke sudo where req.


macBootstrap() {
	if [[ -x /usr/local/bin/brew ]]; then
		installBrew=0
	else
		echo "brew cmd not found, install homebrew"
		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	  brew install caskroom/cask/burn added a GUI Burn.app into Applications.
		# brew cask can manage and install mac native apps.  (used by geerlingguy Ansible for DevOps).
    # not sure if this need to be setup manually
    #brew install caskroom/cask/brew-cask 
	fi

	# install packages (that cannot easily mingled wiht other os yum install)
	#$PkgCmd install python
	echo "brew installing python and pip3 for ansible..."
	brew install python
	/usr/local/bin/pip3 install ansible
  # brew cask are for GUI apps.
  # soon would just do brew install (drop cask, at least for install)
  brew install octave  # some/all may go to ansible, but trying not to start can of warm for  mac for now.
  brew cask install vlc
  brew cask install gitup
  # no cask for OneNotes # there is a OneNotes Import thing ,not sure what it is

} # end-macBootstrap fn


rhelBootstrap() {
	sudo yum install git
	sudo yum install -y epel-release
	sudo yum install -y ansible # 2.6.2
	sudo yum install -y libselinux-python  # allow ansible to config iptables
	# if ansible above is enough, may not need next one
	#echo "installing python-pip" 
	sudo yum install -y python-pip
	##pip install ansible
} # end-rhelBootstrap fn

debBootstrap() {
	echo "running bootstrap for debian-based sysrtem"
	#### zorin's (12.4, ubuntu 16.04) comes with 
	#### ansible 2.0.0.2, it can't even do "include-tasks under tasks: section :(
	#### so pip version of ansible is used instead.

	#echo "installing python-pip"
	#PkgCmd install -y python-pip
	sudo apt install -y python-pip
	pip install ansible

	#sudo dpkg --erase alpine-pico  # cuz have visudo bringing up pico!! nope, still there

} # end-debBootstrap fn

hostIsMac=$(uname -a | grep -c Darwin)
hostIsDebian=$( uname -a | grep -c BLA )
hostIsRhel=$( uname -a | egrep el[67].x86_64 ) #  not best, but ok

if [[ $hostIsMac -eq 1 ]]; then
	macBootstrap 
	PkgCmd="brew"
elif  [[ $hostIsRhel -eq 1 ]]; then
	PkgCmd="sudo yum"
	debBootstrap
else
	PkgCmd="sudo apt-get"
	rhelBootstrap

fi



#sudo $PkgCmd install git
#sudo $PkgCmd install -y python-pip
# PkgCmd will include sudo when running on non Darwin system 
echo "installing git"
$PkgCmd install git


#exit 0



#### platform independent
#### but likely not very meaningful in macOS
#### few common cmd b/w centos,ubuntu,macOS
#### but still worthwhile to have them in single file rather than multiple files 
#### to keep track of changes in consistent manner

echo "my very ownn stuff, ie add user, sudo, etc"
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
cd /tmp; cd ~tin

sudo su - tin
sudo -u tin mkdir ~tin/tin-gh
cd ~tin/tin-gh
git clone https://www.github.com/tin6150/psg
cd ~
ln -s tin-gh/psg ~/PSG

# below may have been run from psg dir already...
#cat ~tin/PSG/git.setup.gh.sh | egrep -v "^$|^#"
sudo -u tin ~tin/PSG/git.setup.gh.sh # when prompt for password, can enter it and continue if not using pipe method above


