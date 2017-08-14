#!/bin/sh

# https://sites.google.com/a/lbl.gov/high-performance-computing-services-group/lbnl-supercluster/xmas

# submit a single job as  
#    sbatch   ./slurm-script-xmas-eg.sh                                          

# to test every node of xmas, run on login node as:
# cd /global/scratch/tin/tmp/xmas
# for T in $(seq -w 0000 0019); do
#         #sbatch  --partition=xmas --account=xmas  -w n${T}.xmas0 --job-name=N_${T} /global/home/users/tin/sn-gh/psg/script/hpc/slurm-script-xmas-eg.sh
# done


#SBATCH 	--job-name=xmas_test	# CLI arg will overwrite this, no 
# 		CPU time: 
#SBATCH 	--time=65
# 		Wall clock limit:
# #SBATCH 	--time=00:10:00
#SBATCH 	--partition=xmas
# #SBATCH 	-n 4
# #SBATCH 	--qos=lr_normal
# #SBATCH 	--qos=lr_lowprio
#SBATCH 	--account=xmas
# #SBATCH 	--ntasks=2
# #SBATCH 	--mail-type=all
# #SBATCH 	--mail-type=END,FAIL
#SBATCH 	--mail-type=FAIL
#SBATCH 	--mail-user=tin@lbl.gov
# #SBATCH 	-N 3
#SBATCH 	-o  slurm_out_xmas_%N_job_%j.txt
# #SBATCH 	-o  junkable_slurm_out_xmas.txt

# %j is for jobid (eg 128)
# %J is for jobid.stepid (eg 128.0)
# %N is short node name
# %n is node number relative to current job, 0 for first node.  task spanning multiple node will get multiple file created
# -J is --job-name for CLI arg

## if no -o specified, default to slurm-%j.out or slurm-%A_%s.out for normal and array jobs
## if not using $j expansion, multiple node job will (over)write to the same output file (not auto concat)
## -e for stderr, which if not specified, would be combined into stdout
## https://slurm.schedmd.com/sbatch.html filename pattern : has details of % expansions



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

