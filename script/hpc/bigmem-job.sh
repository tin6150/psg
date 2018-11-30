#!/bin/sh
#SBATCH --job-name=bigmem_test
#SBATCH --partition=lr_bigmem
#SBATCH --qos=lr_normal
#SBATCH --account=scs
#SBATCH --nodes=1
#SBATCH --mem-per-cpu=16G 
#SBATCH --time=90:00

hostname
free -h
sleep 300
