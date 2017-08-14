#!/bin/sh

# https://sites.google.com/a/lbl.gov/high-performance-computing-services-group/lbnl-supercluster/xmas


#SBATCH --job-name=test-xmas
#SBATCH --time=5
#SBATCH --partition=xmas
###SBATCH -n 4
###SBATCH --qos=lr_normal
###SBATCH --qos=lr_lowprio
#SBATCH --account=xmas
###SBATCH --ntasks=2
# Wall clock limit:
##SBATCH --time=00:10:00
#SBATCH --mail-type=all
#SBATCH --mail-user=tin@lbl.gov
###SBATCH -N 3
##SBATCH -o  junkable_slurm_out_xmas.txt

## multiple node job will write to the same output file, even when no -o file is specified.  
## maybe if explicit create task array will create the additional per-task-array-job  output file ?

# submit job as  
#    sbatch   ./slurm-script-xmas-eg.sh                                          


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
#echo "date before sleep"
#date
#sleep 180
#echo "date after sleep"
#date

