#!/bin/sh
#SBATCH --job-name=test
#SBATCH --partition=cf1
#SBATCH --qos=cf_normal
#SBATCH --account=scs
#SBATCH --nodes=8
#SBATCH --mem-per-cpu=2G 
#SBATCH --time=90:00

hostname
date
uptime
sleep 3600
