#!/bin/sh
#SBATCH --job-name=test
#SBATCH --partition=lr3
#SBATCH --constrain=lr3_normal # these are features in slurm conf
#SBATCH --qos=lr_normal
#SBATCH --account=scs
#SBATCH --nodes=2
#SBATCH --mem-per-cpu=2G 
#SBATCH --time=02:30:00

hostname
date
uptime
sleep 3600
