#!/bin/sh

#SBATCH --time=1
#SBATCH --partition=cf0 --account=test --qos=test
###SBATCH -n 4
#SBATCH -N 3
###SBATCH -o  junkable_slurm_out.txt
##SBATCH -o  junkable_slurm_out2.txt

## see slurm-script-xmas-eg.sh for more info on -o, --mail-type, etc


# submit job as  
#    sbatch   ./slurm-script-eg.sh                                          


hostname
uptime
date
pwd
echo ---------------------------------------
cat /etc/os-release
echo ---------------------------------------
df -hl
echo ---------------------------------------
cat /proc/mounts
sleep 180

