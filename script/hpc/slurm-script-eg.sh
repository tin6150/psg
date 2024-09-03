#!/bin/sh

#SBATCH --time=0:15:0  # max job time in hr:min:sec
#SBATCH --partition=savio2 --account=fc_graham --qos=savio_normal
###SBATCH -n 4
#SBATCH -N 1
###SBATCH -o  junkable_slurm_out.txt
##SBATCH -o  junkable_slurm_out2.txt

## see slurm-script-xmas-eg.sh for more info on -o, --mail-type, etc


# submit job as  
#    sbatch   ./slurm-script-eg.sh                                          
#    sbatch   --partition savio2   ./slurm-script-eg.sh                                          
#    sbatch   --partition=savio2 -w n0293.savio2 -N 1 --account=scs --qos=savio_debug ./slurm-script-eg.sh   
#    sbatch   -p savio2  -A scs --qos savio_debug ./slurm-script-eg.sh # works in 2020.0412, this script has all required feature (or not specifying feature not understood by some bloody banking plugin?
#    sbatch   -p cf0     -A test --qos test       ./slurm-script-eg.sh 


hostname
uptime
date
id
pwd

echo ---------------------------------------
module list
echo ---------------------------------------

echo ---------------------------------------
#cat /etc/os-release
echo ---------------------------------------
#df -hlT
echo ---------------------------------------
#cat /proc/mounts
sleep 180

