#!/bin/bash

BASEDIR="$HOME/tin-gh"

#cd $BASEDIR

RepoList="psg inet-dev-class singhub"

for Repo in $RepoList; do
	cd $BASEDIR/$Repo
	git pull
done



#git clone https://tin6150@github.com/tin6150/singularityware.github.io
#git clone https://tin6150@github.com/tin6150/dell_idracadm
#git clone https://tin6150@github.com/tin6150/singularity
#git clone https://tin6150@github.com/tin6150/circos.git
#git clone https://tin6150@github.com/tin6150/biolab-orange/
