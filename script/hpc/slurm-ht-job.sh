#!/bin/sh
#SBATCH --job-name=ht-test
#SBATCH --partition=savio2_knl
#SBATCH --qos=normal
#SBATCH --account=scs
#SBATCH --ntasks=8          # slurm will create a job with these many cores
###SBATCH --nodes=3		# detected as 3 slots... avoid use
#SBATCH --mem-per-cpu=2G 
#SBATCH --time=02:30:00

ht_helper.sh -t ht_taskfile -n1 -s10 -Lv
# -n1  = number of processors per task
# -s10 = number of seconds before next check by ht_helper mini fifo scheduler.
# -L   = log task stdout/stderr to individual files
# -v   = verbose mode


