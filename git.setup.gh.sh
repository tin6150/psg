
################################################################################
#### mkdir-cd ~/tin-gh, pre-run:
#### git clone https://tin6150@github.com/tin6150/psg
#### bash psg/git.setup.gh.sh
################################################################################

# 2023... windows, wsl... see precreate_ntfs_scheme() ... prefer to put tin-git-Doc in windows ntfs 



#### old method, not liked anymore, cuz prompt for password get gabled from paste
##XX cat ~tin/PSG/git.setup.gh.sh | egrep -v "^$|^#"
##XX and cut-n-paste output, pausing in places that may ask for password...


# check, now automatically detect, for wsl env:
useC_tin=0  # unlikely compatible with the presetup_ntfs_scheme() of 2023!
useC_tin=$(uname -a  | grep -c Microsoft)  # this should be 1 in wsl ubuntu bash

##WslEnv=True
##if [[ x${WslEnv} == xTrue ]]; then
#useC_tin=1  # in select WSL/bash env wehre I don't want things multiple time in home of cygwin, moba, etc.
if [[ ${useC_tin} -eq 1 ]]; then
	echo "useC_tin is true, in WSL"
	cd /mnt/c/tin
	[[ -e tin-gh ]] || mkdir tin-gh
	cd ~
	[[ -e tin-gh ]] || ln -s /mnt/c/tin/tin-gh .	# this cmd need to run in wsl bash prompt  NOT cygwin. (cyz of /mnt/c)
	[[ -e C_tin  ]] || ln -s /mnt/c/tin ./C_tin
fi
#MyGitDir=~/tin-gh		# could be a link (mostly in win/wsl)
MyGitDir=~/tin-git	# untested with precreate_ntfs_scheme() of 2023.08
[[ -e $MyGitDir ]] || mkdir $MyGitDir
cd $MyGitDir


echo "current dir, where git clone(s) will take place is: (^C within 30 sec to cancel--or may need to press ENTER...)"
#ls -ld ~/tin-gh
ls -ld ~/tin-git
pwd
pwd -P
#sleep 15
echo "press Enter to continue..."
read WaitForEnter

#exit 666



########################
### config settings ####
########################

## create fn, and eval a param, don't always want to run this...  but it is essentially idempotent...
#git clone https://tin6150@github.com/tin6150/psg

[[ -d $MyGitDir/psg ]] || mkdir $MyGitDir/psg
cd $MyGitDir/psg
## config need to write to some .git...   create a fn for this?

git config --global user.email "sn+newbox@grumpyxmas.com"             # FIXME++ change this to machine specific settings to get better idea of where commits, 
                                                        # merges are done, but don't display well on bitbucket :(
git config --global user.name tin6150
## in bitbucket, need username to match what bitbucket.org has in record for it to prompt for pwd
git config --global credential.helper 'cache --timeout=36000'
git config --global github.user   tin6150
git config --global alias.lol "log --oneline --graph --decorate"                # create alias "git lol"   # logd
git config --global merge.conflictstyle diff3            # cmd diff tool, make file w/ <<<< |||| >>>>, bearable
#git config merge.conflictstyle diff3            # cmd diff tool, make file w/ <<<< |||| >>>>, bearable

git config --global core.autocrlf false          # auto CR/LF conversion, if not disabled, vscode may update file b/w format and create too many git changes.

#cd ..

## these are the "core" repos, 
## ie many have sym links created in home dir for easy navigation
run_git_clone_core() 
{

	########################
	#### tin6150 github ####
	########################

	cd $MyGitDir

	#git clone https://tin6150@github.com/tin6150/psg
	echo "may need password..."
	git clone https://tin6150@github.com/tin6150/bofhbot


	############################
	#### formerly in tin-bb ####
	############################

	#~~ cd ~/tin-gh
	echo "may ask for password... run the following cut-n-paste:"
	echo git clone https://tin6150@bitbucket.org/tin6150/blpriv
	#git clone https://tin6150@bitbucket.org/tin6150/spark
	#git clone https://tin6150@bitbucket.org/tin6150/predpriv.git


}

run_git_clone_extended() 
{
	########################
	#### tin6150 github ####
	########################

	cd $MyGitDir

	#git clone https://tin6150@github.com/tin6150/psg
	echo "may need password..."


	#git clone https://tin6150@github.com/tin6150/singularity
	### many random programming bits, eg knime, dataTables/panda, jQuery, mpi, etc
	#git clone https://tin6150@github.com/tin6150/inet-dev-class
	#git clone https://tin6150@github.com/tin6150/smelly.git
	#git clone https://tin6150@github.com/tin6150/adjoin
	#git clone https://tin6150@github.com/tin6150/covid19_care_capacity_map
	#git clone https://tin6150@github.com/tin6150/a51		# private repo, encrypted content.  formerly area51

	### VMware tools as ansible role fork (so as not get updte unless manually checked)
	### actually trying to do subtree merging under CF_BK/Ansible/roles
	### git clone https://github.com/tin6150/ansible-role-vmwaretools

	### old projects
	#git clone https://tin6150@github.com/tin6150/db4cpa
	#git clone https://tin6150@github.com/tin6150/taxonomy_reporter
	#git clone https://tin6150@github.com/tin6150/pyspark
	#git clone https://tin6150@github.com/tin6150/taxo-spark

	### singularity container dev or not posting to singularity-hub.org  (the one script install of singularity is in here)
	#git clone https://tin6150@github.com/tin6150/singhub      

	### contributed to singularityware web doc
	git clone https://tin6150@github.com/tin6150/singularityware.github.io

	### singularity-hub container definitions
	#git clone https://tin6150@github.com/tin6150/circos.git
	#git clone https://tin6150@github.com/tin6150/knime
	git clone https://tin6150@github.com/tin6150/dell_idracadm
	#git clone https://tin6150@github.com/tin6150/biolab-orange/
	git clone https://tin6150@github.com/tin6150/perf_tools
	#git clone https://tin6150@github.com/tin6150/cuda
	#git clone https://tin6150@github.com/tin6150/boinc-client.git
	git clone https://tin6150@github.com/tin6150/cvs.git
	#git clone https://tin6150@github.com/tin6150/PGI-Singularity.git  # fork from Ryan, pgi compiler, netcdf lib

    ###########################################
	#### private github repo ####
    ###########################################
	#git clone https://tin6150@github.com/tin6150/cmaq-old # i created this and had copy of pre git-repo cmaq eg 4.5.1 but stopping development on that for now
	#git clone https://tin6150@github.com/tin6150/CMAQ.git # fork, using 5.2.1  Note it is ALL CAPS  (on bofh used lower case, it worked, but renamed it)

    ###########################################
	### greta, formerly owned by greta-d, i became co-owner now ####
    ###########################################
	#git clone https://github.com/greta-sw/forward-buffer  # need to login as greta-d , or add tin6150 as a member...
	#git clone https://greta-d@github.com/greta-sw/forward-buffer
	#git clone https://greta-d@github.com/greta-sw/signal-decomposition
	#git clone https://greta-d@github.com/greta-sw/data-analysis
	#git clone https://greta-d@github.com/greta-sw/fpga
	#git clone https://greta-d@github.com/greta-sw/slow-control
	#git clone https://greta-d@github.com/greta-sw/sysconfig
	# many repo are being renamed or recrated differently ca 2020-06
	#-git clone https://tin6150@github.com/greta-sw/forward-buffer
	#-git clone https://tin6150@github.com/greta-sw/signal-decomposition
	#-git clone https://tin6150@github.com/greta-sw/data-analysis
	#-git clone https://tin6150@github.com/greta-sw/fpga
	#-git clone https://tin6150@github.com/greta-sw/slow-control
	#git clone https://tin6150@github.com/greta-sw/config

    #############################################
    #### stuff I forked, play/learn with,    ####
	#### but not necessary maintain/publixh  ####
    #############################################

	### boston housing price ML 
	#git clone https://tin6150@github.com/tin6150/machine-learning-nanodegree.git
	### mapbox plugin, trying to get it to work on my map (ZWEDC collab with ETA)
	### also avail as https://tin6150.github.io/mapbox-gl-controls
	#git clone https://github.com/tin6150/mapbox-gl-controls

	### reading csv in javascript, D3js didnt work for me, so hoping this would.  but may need older release to find out what broke the example...
	#git clone https://github.com/tin6150/jquery-csv.git
	
	##############################
	#### tin6150@github gist  ####
	##############################

	#git clone https://gist.github.com/e271e5d3bef6d93ebc6817170ddd2456.git # census2mapbox.rst
	#	git clone https://gist.github.com/tin6150/a9041b900d3803d6d5f012af93704dbf.git # netapp_svm_root_vol_data_protection.txt # axiom




	###########################
	#### tin@lbl bitbucket ####
	###########################

	# run from a parent dir eg ~/tin-bbb 
	# cd ..
	#git clone https://sn5050@bitbucket.org/sn5050/ansible-dev
	#git clone https://sn5050@bitbucket.org/berkeleylab/unified-vnfs.git
	#git clone https://sn5050@bitbucket.org/gimpbully/scg-ansible.git # ro, tmp?
	#git clone https://sn5050@bitbucket.org/berkeleylab/scg-ansible.git # probably rw now under bl

	## biositting tool, collab with ETA Ling Jin, Tyler Huntington
	# 1.1 GB repo , maybe data deleted.  
	#~ git clone https://sn5050@bitbucket.org/olgakavvada/biositing_tool.git 
	# forked , bb interface is significantly diff than github :(
	#+ git clone https://sn5050@bitbucket.org/sn5050/biositing_tool_test.git
	# no GIS_data subdir yet...


	##########################
	#### hpcs-cf git repo ####
	##########################
	# git clone git@hpcs-cf.lbl.gov:/remote/ansible.git 
	#cd ~/tin-gh; ssh-agent bash -c 'ssh-add ~/.ssh/id_rsa ; git clone git@hpcs-cf.lbl.gov:/remote/ansible.git' # this prompt for ssh-key pw then git@hpcs-cf pw :(
	#cd ~/tin-gh; ssh-agent bash -c 'ssh-add ~/.ssh/id_dsa ; git clone git@hpcs-cf.lbl.gov:/remote/ansible.git'
	#cd ~/tin-gh/ansible ; ssh-agent bash -c 'ssh-add ~/.ssh/id_dsa ; git pull' # somehow n0013.ares git 1.7 need this method


	#  cuda is dup, can be ignored

	#################################################################
	#### public repos, not owned by me ####
	#### but these are likely to be reused in other system
	#### and there is really no need to store them in other location
	#### i should be able to tell what's mine and what's not, 
	#### especially with this centralized git clone file
	#################################################################

	#git clone https://github.com/PySlurm/pyslurm.git # python interface for slurm...  not sure if can get sinfo...

	#git clone git://github.com/jonas/tig.git	# https://www.tecmint.com/tig-a-commandline-browser-for-git-repositories/ # in apt-get
	#git clone https://github.com/dlab-berkeley/machine-learning-in-R   # d-lab ML in R
	# git clone https://github.com/mapbox/mapbox-sdk-py.git		   # mapbox uploader, just cuz i need to search for things inside it

	#git clone https://github.com/dlab-berkeley/introduction-to-pandas.git # d-lab Intro to Pandas

	################################################
	#### gitlab instead of github or bitbucket  ####
	################################################

	git clone https://gitlab.com/tin6150/rit-docs.git

	############################
	#### lbl-eta/smelly  ####
	############################
	## just to publish smelly under eta-lbl acc name
	#-[[ -d $MyGitDir/lbl-eta ]] || mkdir $MyGitDir/lbl-eta
	#-cd $MyGitDir/lbl-eta
	#-git clone https://lbl-eta@github.com/lbl-eta/smelly.git

	## actually created an org lbnl-scienceit and placing smelly under it
	#[[ -d $MyGitDir/lbnl-science-it ]] || mkdir $MyGitDir/lbnl-science-it
	#cd $MyGitDir/lbnl-science-it
	#git clone https://tin6150@github.com/lbnl-scienceit/smelly.git
	#git clone ://tin6150@github.com/lbnl-scienceit/smelly.git
	git clone git@github.com:lbnl-science-it/adjoint.git
	git clone git@github.com:lbnl-science-it/smelly.git
	git clone git@github.com:lbnl-science-it/zwedc.git
	
	#[[ -d $MyGitDir/nick ]] || mkdir $MyGitDir/nick
	#cd $MyGitDir/nick
	#git clone https://github.com/nicolaschan/bofhbot.git





} # end-run_git_clone()



#### 2023 want git dir to be shared with windows
precreate_ntfs_scheme()
{
	# untested, reverse eng from T55
	ln -s /mnt/c/Users/tin61/              winHome
	mkdir winHome/Documents/tin-git-Doc
	ln -s winHome/Documents/tin-git-Doc    tin-git-Doc
	cd tin-git-Doc
	
	# run wsl as user, ssh-agent; ssh-add 
	# run wsl as root, hijack ssh-agent session, ssh-add -l
	# run git clone as root, as need to do lock and stuff on the windows ntfs drive that can't be done as user
	#git clone https://github.com/tin6150/guatemala_amr.git
	git clone git@github.com:tin6150/guatemala_amr.git
	git clone git@github.com:tin6150/mission2022.git
}


create_links() 
{
	# not sure if this still works with the precreate_ntfs_scheme of 2023 above 

	############################################################
	############################################################
	#### create sym links that I have in most places now
	############################################################
	############################################################


	# don't use tab below or cut-n-paste may engage tab completion.
	#GIT_DIR=$(pwd)
	#### previos approach created symlink in home dir
	#### useful, but would need more.
	#-- block below should take care of this.
	#--GIT_DIR=$MyGitDir
	#--cd ~
	#--ln -s ${GIT_DIR}/bofhbot            ~/BOFHbot
	#--ln -s ${GIT_DIR}/psg                ~/PSG
	#--cd $GIT_DIR	# ie cd back



	####WSL/bash env need additional link from ghDir (or multiple homes)
	# don't use tab below or cut-n-paste may engage tab completion.
	#### for WSL/bash, want link in C_tin
	#if [[ x${useC_tin} == xTrue ]]; then
	if [[ ${useC_tin} -eq 1 ]]; then
		GIT_DIR="./tin-gh"
		cd ~/C_tin
	else
		# even in wsl, may want this in /home/$USERNAME, extra set of links, should not be too confusing...
		GIT_DIR=$MyGitDir # ie export GIT_DIR="./tin-gh" , which should  still exist in ~, maybe link in wsl
		cd ~
	fi
	# actually, always wants links in ~ ; in wsl, add link to C_tin.
	# thus, above if is obsolete.
	# using for loop below instead.  ## ++ untested at this point

	#
	for LinkBase in ~/C_tin ~; do
		[[ -e $LinkBase ]] || continue # ie, skip the rest if dir/link existance is FALSE 
		cd $LinkBase
		# create links below only if they don't already exist
		[[ -L CF_BK        ]] || ln -s ${GIT_DIR}/blpriv/cf_bk              ./CF_BK
		[[ -L NOTE         ]] || ln -s ${GIT_DIR}/blpriv/note               ./NOTE
		[[ -L HPCS_toolkit ]] || ln -s ${GIT_DIR}/blpriv/hpcs_toolkit       ./HPCS_toolkit
		[[ -L BOFHbot      ]] || ln -s ${GIT_DIR}/bofhbot                   ./BOFHbot
		[[ -L PSG          ]] || ln -s ${GIT_DIR}/psg                       ./PSG
		[[ -L ~/PSG        ]] || ln -s ${GIT_DIR}/psg                       ~/PSG		## historically created links with absolute PATH at ~
		cd $GIT_DIR	# ie cd back
	done

	FECHA=$(  date +%Y%m%d )
	if [[ -f ~/.bashrc ]]; then
		mv ~/.bashrc ~/.bashrc.$FECHA
	fi
	ln -s  ${GIT_DIR}/psg/script/sh/.bashrc       ~/.bashrc
	if [[ -f ~/.bash_profile ]]; then
		mv ~/.bash_profile ~/.bash_profile.$FECHA
	fi
	#ln -s  ~/.bashrc ~/.bash_profile # why did i do this?
	ln -s  ${GIT_DIR}/psg/script/sh/.bash_profile ~/.bash_profile
	if [[ -f ~/.vimrc ]]; then
		mv ~/.vimrc ~/.vimrc.$FECHA
	fi
	ln -s  ${GIT_DIR}/psg/conf/.vimrc ~/.vimrc
	if [[ -f ~/.zshrc ]]; then
		mv ~/.zshrc ~/.zshrc.$FECHA
	fi
	ln -s  ${GIT_DIR}/psg/conf/.zshrc ~/.zshrc

} # end-create_links()


macOS_setup()
{

	# refer to https://github.com/geerlingguy/mac-dev-playbook
	# need ansible installed (eg use psg/script/sh/bootstart...sh)

	xcode-select --install
	cd $MyGitDir
	git clone https://github.com/geerlingguy/mac-dev-playbook.git
	cd mac-dev-playbook
	ansible-galaxy install -r requirements.yml
	#### roles/ dir created in . to store galaxy data
	ansible-playbook main.yml -i inventory -K 	# inventory is just localhost

	## analyze, but okay to try on new laptop :):
	## My dotfiles are also installed into the current user's home directory, including the .osx dotfile for configuring many aspects of macOS for better performance and ease of use. You can disable dotfiles management by setting configure_dotfiles: no in your configuration.


}


npm_package_install()
{
	# no npm, maybe should put this in ansible playbook 
	echo "Running sudo npm install --global ..., provide sudo password next..." 
	sudo npm install --global json5
	sudo npm install --global d3-geo-projection # geo2svg test geojson
}


precreate_ntfs_scheme #### 2023 want git dir to be shared with windows

#### sometime links creation breaks and don't need to run clone again.
#### ++ FIXME, enable whatever fn that wants to be run
run_git_clone_core
#+run_git_clone_extended
create_links	# this is link from ~/PSG to tin-gh/psg  CF_BK etc.  not sure if still work with the preset_ntfs_scheme of 2023
#npm_package_install

#macOS_setup ## cmd tried, but fn untested.

#### PS:
#### git clone should be in the right place
#### but sym links for mobaXterm and maybe cygwin may not work yet
#### in wsl/ubuntu/bash should be fine...
#### too messy, too many env.  setup by and or just use C_tin as needed
#### spending too much time on a not so serious problem.


