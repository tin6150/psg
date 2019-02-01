#!/bin/sh
#SBATCH --job-name=test
#SBATCH --partition=cf1
#SBATCH --qos=cf_normal
#SBATCH --account=scs
#SBATCH --nodes=8
#SBATCH --mem-per-cpu=2G 
#SBATCH --time=90:00

# for brc savio3, can submit as:
# sbatch --partition=savio3 --account=co_laika --qos=laika_savio3_normal slurm-job-cf1.sh

hostname
date
uptime
sleep 3600
