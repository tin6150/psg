#!/bin/sh
#SBATCH --job-name=test
#SBATCH --partition=lr6
#SBATCH --qos=lr_normal
#SBATCH --account=scs
#SBATCH --nodes=2
#SBATCH --mem-per-cpu=2G 
#SBATCH --time=02:30:00
sleep 3600
