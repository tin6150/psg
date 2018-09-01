
################################################################################
#### this rst is really now a shell script that can be run 
################################################################################

#### over time will put all my github (and bitbucket) repos cloning here
#### for now, run as:
#### cat ~tin/PSG/git.setup.gh.sh | egrep -v "^$|^#"
#### and cut-n-paste output, pausing in places that may ask for password...


# assume script is in the psg/ dir 
#cd ..

# nah, going forward, always setup a new dir :)
### in WSL setup, precreate:

##WslEnv=True
##if [[ x${WslEnv} == xTrue ]]; then
useC_tin=True  # in select WSL/bash env wehre I don't want things multiple time in home of cygwin, moba, etc.
if [[ x${useC_tin} == xTrue ]]; then
	cd /mnt/c/tin
	mkdir tin-gh
	cd ~
	ln -s /mnt/c/tin/tin-gh .	# this cmd need to run in wsl bash prompt  NOT cygwin. (cyz of /mnt/c)
fi
MyGitDir=~/tin-gh	# could be a link (mostly in win/wsl)
[[ -e $MyGitDir ]] || mkdir $MyGitDir
cd $MyGitDir

#exit 666



########################
### config settings ####
########################

## create fn, and eval a param, don't always want to run this...  but it is essentially idempotent...
#git clone https://tin6150@github.com/tin6150/psg

[[ -d $MyGitDir/psg ]] || mkdir $MyGitDir/psg
cd $MyGitDir/psg
## config need to write to some .git...   create a fn for this?

git config --global user.email "tin@newbox.grumpyxmas.com"             # FIXME++ change this to machine specific settings to get better idea of where commits, 
                                                        # merges are done, but don't display well on bitbucket :(
git config --global user.name tin6150
## in bitbucket, need username to match what bitbucket.org has in record for it to prompt for pwd
git config --global credential.helper 'cache --timeout=36000'
git config --global github.user   tin6150
git config --global alias.lol "log --oneline --graph --decorate"                # create alias "git lol"   # logd
git config merge.conflictstyle diff3            # cmd diff tool, make file w/ <<<< |||| >>>>, bearable


#cd ..

########################
#### tin6150 github ####
########################

cd $MyGitDir

git clone https://tin6150@github.com/tin6150/psg
echo "may need password..."

git clone https://tin6150@github.com/tin6150/singularity
### many random programming bits, eg knime, dataTables/panda, jQuery, mpi, etc
git clone https://tin6150@github.com/tin6150/inet-dev-class
### boston housing price ML 
git clone https://tin6150@github.com/tin6150/machine-learning-nanodegree.git

### VMware tools as ansible role fork (so as not get updte unless manually checked)
### actually trying to do subtree merging under CF_BK/Ansible/roles
### git clone https://github.com/tin6150/ansible-role-vmwaretools

### old projects
git clone https://tin6150@github.com/tin6150/db4cpa
git clone https://tin6150@github.com/tin6150/taxonomy_reporter
git clone https://tin6150@github.com/tin6150/pyspark
git clone https://tin6150@github.com/tin6150/taxo-spark

### singularity container dev or not posting to singularity-hub.org 
git clone https://tin6150@github.com/tin6150/singhub      

### contributed to singularityware web doc
git clone https://tin6150@github.com/tin6150/singularityware.github.io

### singularity-hub container definitions
git clone https://tin6150@github.com/tin6150/circos.git
git clone https://tin6150@github.com/tin6150/knime
git clone https://tin6150@github.com/tin6150/dell_idracadm
git clone https://tin6150@github.com/tin6150/biolab-orange/
git clone https://tin6150@github.com/tin6150/perf_tools
git clone https://tin6150@github.com/tin6150/cuda
git clone https://tin6150@github.com/tin6150/boinc-client.git


############################
#### formerly in tin-bb ####
############################

# run from a parent dir eg ~/tin-bb 
# cd ..
git clone https://tin6150@bitbucket.org/tin6150/blpriv
echo "may ask for password..."
git clone https://tin6150@bitbucket.org/tin6150/spark
git clone https://tin6150@bitbucket.org/tin6150/predpriv.git


###########################
#### tin@lbl bitbucket ####
###########################

# run from a parent dir eg ~/tin-bbb 
# cd ..
git clone https://sn5050@bitbucket.org/sn5050/ansible-dev


#  cuda is dup, can be ignored



############################################################
#### create sym links that I have in most places now
############################################################


# don't use tab below or cut-n-paste may engage tab completion.
#GIT_DIR=$(pwd)
#### previos approach created symlink in home dir
#### useful, but would need more.
#-- block below should take care of this.
#--GIT_DIR=$MyGitDir
#--cd ~
#--ln -s ${GIT_DIR}/blpriv/bofhbot            ~/BOFHbot
#--ln -s ${GIT_DIR}/psg                       ~/PSG
#--cd $GIT_DIR	# ie cd back



####WSL/bash env need additional link from ghDir (or multiple homes)
# don't use tab below or cut-n-paste may engage tab completion.
#### for WSL/bash, want link in C_tin
if [[ x${useC_tin} == xTrue ]]; then
	GIT_DIR="./tin-gh"
	cd ~/C_tin
else
	GIT_DIR=$MyGitDir
	cd ~
fi

ln -s ${GIT_DIR}/blpriv/cf_bk              ./CF_BK
ln -s ${GIT_DIR}/blpriv/note               ./NOTE
ln -s ${GIT_DIR}/blpriv/hpcs_toolkit       ./HPCS_toolkit
ln -s ${GIT_DIR}/blpriv/bofhbot            ./BOFHbot
ln -s ${GIT_DIR}/psg                       ./PSG
ln -s ${GIT_DIR}/psg                       ~/PSG		## historically created links with absolute PATH at ~
cd $GIT_DIR	# ie cd back

