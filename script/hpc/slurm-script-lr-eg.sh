#!/bin/sh

# https://sites.google.com/a/lbl.gov/high-performance-computing-services-group/lbnl-supercluster/lawrencium


#SBATCH --job-name=test-lr2
###SBATCH --time=5
#SBATCH --partition=lr2
###SBATCH -n 4
###SBATCH --qos=lr_normal
#SBATCH --qos=lr_lowprio
###SBATCH --account=ac_abc
#SBATCH --ntasks=2
# Wall clock limit:
#SBATCH --time=00:10:00
#SBATCH --mail-type=all
#SBATCH --mail-user=tin@lbl.gov
###SBATCH -N 3
#SBATCH -o  junkable_slurm_out_lr2.txt
##SBATCH -o  junkable_slurm_out2.txt

## see slurm-script-xmas-eg.sh for more info on -o, --mail-type, etc


# submit job as  
#    sbatch   ./slurm-script-lr-eg.sh                                          


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
echo ---------------------------------------
echo "date before sleep"
date
sleep 180
echo "date after sleep"
date

