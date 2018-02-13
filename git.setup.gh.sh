
################################################################################
#### this rst is really now a shell script that can be run 
################################################################################

#### over time will put all my github (and bitbucket) repos cloning here


# assume script is in the psg/ dir 

cd ..


########################
### config settings ####
########################

## create fn, and eval a param, don't always want to run this...  but it is essentially idempotent...
#git clone https://tin6150@github.com/tin6150/psg

cd psg
## config need to write to some .git...   create a fn for this?

# git config --global user.email "tin@newbox"             # change this to machine specific settings to get better idea of where commits, 
                                                        # merges are done, but don't display well on bitbucket :(
git config --global user.name tin6150
## in bitbucket, need username to match what bitbucket.org has in record for it to prompt for pwd
git config --global credential.helper 'cache --timeout=36000'
git config --global github.user   tin6150
git config --global alias.lol "log --oneline --graph --decorate"                # create alias "git lol"   # logd
git config merge.conflictstyle diff3            # cmd diff tool, make file w/ <<<< |||| >>>>, bearable


cd ..

########################
#### tin6150 github ####
########################

git clone https://tin6150@github.com/tin6150/singularity
### many random programming bits, eg knime, dataTables/panda, jQuery, mpi, etc
git clone https://tin6150@github.com/tin6150/inet-dev-class
### boston housing price ML 
git clone https://tin6150@github.com/tin6150/machine-learning-nanodegree.git

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
git clone https://tin6150@bitbucket.org/tin6150/spark

###########################
#### tin@lbl bitbucket ####
###########################

# run from a parent dir eg ~/tin-bbb 
# cd ..
git clone https://sn5050@bitbucket.org/sn5050/ansible-dev


# cuda is dup, can be ignored
