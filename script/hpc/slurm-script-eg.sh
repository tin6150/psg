#!/bin/sh

#SBATCH --time=1
#SBATCH --partition=cf0 --account=test --qos=test
###SBATCH -n 4
#SBATCH -N 1
###SBATCH -o  junkable_slurm_out.txt
##SBATCH -o  junkable_slurm_out2.txt

## see slurm-script-xmas-eg.sh for more info on -o, --mail-type, etc


# submit job as  
#    sbatch   ./slurm-script-eg.sh                                          
#    sbatch   --partition savio1   ./slurm-script-eg.sh                                          
#    sbatch   --partition=savio2 -w n0293.savio2 -N 1 --account=scs --qos=savio_debug ./slurm-script-eg.sh   
#    sbatch   -p savio2  -A scs --qos savio_debug ./slurm-script-eg.sh # works in 2020.0412, this script has all required feature (or not specifying feature not understood by some bloody banking plugin?


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

