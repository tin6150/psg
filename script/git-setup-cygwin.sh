
Cdrv=/cygdrive/c

OneDriveDir=${Cdrv}/Users/tin61/OneDrive

cd $OneDriveDir



GHdir=${Cdrv}/tin-gh
BBdir=${Cdrv}/tin-bb

[[ -d $GHdir ]] || mkdir $GHdir 
[[ -d $BBdir ]] || mkdir $BBdir 

git config --global user.email "tin6150@gmail.com"
git config --global user.name tin6150
## in bitbucket, need username to match what bitbucket.org has in record for it to prompt for pwd
git config --global credential.helper 'cache --timeout=3600'
git config --global github.user   tin6150

git config merge.conflictstyle diff3		# cmd diff tool, make file w/ <<<< |||| >>>>, bearable



cd $GHdir
git clone https://tin6150@github.com/tin6150/psg.git

git clone https://tin6150@github.com/tin6150/singularity
git clone https://tin6150@github.com/tin6150/inet-dev-class

git clone https://tin6150@github.com/tin6150/db4cpa
git clone https://tin6150@github.com/tin6150/taxonomy_reporter
git clone https://tin6150@github.com/tin6150/pyspark
git clone https://tin6150@github.com/tin6150/taxo-spark
git clone https://tin6150@github.com/tin6150/singhub
git clone https://tin6150@github.com/tin6150/circos.git


cd $BBdir
git clone https://tin6150@bitbucket.org/tin6150/blpriv.git


cd $OneDriveDir
