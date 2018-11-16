#!/bin/sh
#SBATCH --job-name=test
#SBATCH --partition=lr_manycore
#SBATCH --constrain=lr_1080ti     # other options: lr_k20 lr_k80 (soon: lr_v100)
#SBATCH --qos=lr_lowprio
#SBATCH --account=scs
#SBATCH --nodes=1
#SBATCH --mem-per-cpu=4G 
#SBATCH --time=90:00

hostname
nvidia-smi
sleep 300
