#!/bin/sh

## #SBATCH --constrain=lr3_normal # these are features in slurm conf  ## slurm bank don't support these on 2020.0312 :(
## #SBATCH --job-name=test  

#SBATCH --partition=lr3
#SBATCH --qos=lr_normal
#SBATCH --account=scs
#SBATCH --nodes=2
#SBATCH --mem-per-cpu=2G 
#SBATCH --time=02:30:00

# submit as 
# sbatch --partition=savio2 -N 1 --account=scs --qos=savio_debug ./slurm-job.sh
hostname
date
uptime
sleep 3600
