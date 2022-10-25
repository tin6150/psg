#!/bin/bash  -l

# -l in bash is SOMETIME important for login shell and getting the TF job to start

#### this script run GPU jobs using 1 GPU at a time.
#### it run beast 2 from a container (pre-pulled as singularity sif)
#### https://github.com/tin6150/beast2/tree/dock264-beagle

#SBATCH				--job-name=SnBeastTest    # -J CLI arg will overwrite this
#SBATCH				--time=01:19:59
#					Wall clock limit in HH:MM:ss
#
#SBATCH				--ntasks=1
#SBATCH				--qos=savio_normal 
#SBATCH				--account=scs        # -A

#### gpu gres request
#SBATCH        		--partition=savio3_gpu
#SBATCH         	--gres=gpu:TITAN:1		
##	#SBATCH         	--gres=gpu:A40:1		# failed on n0262 cuz CUDA 11.2
##	#SBATCH         	--gres=gpu:T20:1		# savio2_gpu
## https://docs-research-it.berkeley.edu/services/high-performance-computing/user-guide/running-your-jobs/submitting-jobs/
## GTX2080TI, TITAN, V100, and A40.

#SBATCH				--mail-type=FAIL
#SBATCH				--mail-user=tin@berkeley.edu
#SBATCH				-o  sn_%N_%j.out
#SBATCH				-e  sn_%N_%j.err

# %j is for jobid (eg 128)
# %J is for jobid.stepid (eg 128.0)
# %N is short node name
# %n is node number relative to current job, 0 for first node.  task spanning multiple node will get multiple file created
# -J is --job-name for CLI arg


################################################################################
##### print some header info into the log
################################################################################

LOGDIR=/global/scratch/users/tin/JUNK/
MAQ=$(hostname)
TAG=$(hostname).$(date +%m%d.%H%M)
OUTFILE=slurm-job-gpu-beast.$TAG.out.rst


echo ----hostname-----------------------------------
echo -n "hostname: " 
hostname 
echo ----date-----------------------------------
date
echo ----os-release----------------------------------
cat /etc/os-release

echo ----lscpu-----------------------------------
lscpu
echo ----nvidia-smi-----------------------------------
nvidia-smi


echo "---module list before purge ------------------------------------"
module list    2>&1
module purge   2>&1
module load ml/tensorflow/1.12.0-py36 2>&1 
echo "---module list after purge ------------------------------------"
module list    2>&1

echo "==== ================= ======================================================="
echo "==== beast/gpu next == =======================================================" 
echo "==== ================= ======================================================="

export ImgDir=/clusterfs/vector/home/groups/software/sl-7.x86_64/modules/beast/2.6.4/

echo "checking beagle with gpu (currently need CUDA 11.4)"
# To ensure beagle see GPU on the machine, run this test:
singularity exec --nv $ImgDir/beast2.6.4-beagle.sif /usr/bin/java -Dlauncher.wait.for.exit=true -Xms256m -Xmx8g -Duser.language=en -cp /opt/gitrepo/beast/lib/launcher.jar beast.app.beastapp.BeastLauncher -beagle_info


echo "running beast2 with beagle/gpu"
cd /global/scratch/users/tin/gitrepo/beast2/examples
git checkout 2.6.6 
# https://github.com/CompEvol/beast2/tree/2.6.6, different version have diff XML, which has java class embeded in it

# GPU need additional singularity flag, thus need to run as below, which get 28s/Msamples:
singularity exec --nv $ImgDir/beast2.6.4-beagle.sif /usr/bin/java -Dlauncher.wait.for.exit=true -Xms256m -Xmx8g -Duser.language=en -cp /opt/gitrepo/beast/lib/launcher.jar beast.app.beastapp.BeastLauncher -beagle_GPU testHKY.xml



#### example submission
#### sbatch slurm-job-gpu-beast.sh

### or just invoke this script locally on a drained/idle node :)
### ./slurm-job-gpu-beast.sh | tee slurm-job-gpu-beast.out
