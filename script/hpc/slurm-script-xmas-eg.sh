#!/bin/sh

# https://sites.google.com/a/lbl.gov/high-performance-computing-services-group/lbnl-supercluster/xmas

# to test every node of xmas, run on login node as:
# cd /global/scratch/tin/tmp/xmas
# for T in $(seq -w 0000 0019); do
#         sbatch  --partition=xmas --account=xmas  -w n_${T}.xmas0 --job-name=N${T} /global/home/users/tin/sn-gh/psg/script/hpc/slurm-script-xmas-eg.sh
# done



#SBATCH --job-name=test-xmas
#SBATCH --time=65
#SBATCH --partition=xmas
###SBATCH -n 4
###SBATCH --qos=lr_normal
###SBATCH --qos=lr_lowprio
#SBATCH --account=xmas
###SBATCH --ntasks=2
# Wall clock limit:
##SBATCH --time=00:10:00
#SBATCH --mail-type=END,FAIL
##SBATCH --mail-type=all
#SBATCH --mail-user=tin@lbl.gov
###SBATCH -N 3
##SBATCH -o  junkable_slurm_out_xmas.txt

## multiple node job will write to the same output file, if -o file is specified.  
## if no -o specified, create output file with JOB ID Number as part of file name in CWD

# submit job as  
#    sbatch   ./slurm-script-xmas-eg.sh                                          


hostname
##exit 0		##

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
sleep 60
echo "date after sleep"
date

