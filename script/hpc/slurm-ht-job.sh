#!/bin/sh
#SBATCH --job-name=ht-test
#SBATCH --partition=savio2_knl
# #SBATCH --partition=savio2_knl,savio2,savio1   # comma list accepted, but core count stuff may need special handling
#SBATCH --qos=normal
#SBATCH --account=scs
#SBATCH --ntasks=130          # slurm will create a job with these many cores
#SBATCH --mem-per-cpu=2G 
#SBATCH --time=02:30:00

ht_helper.sh -t ht_taskfile -n2 -s10 -Lv
# -n = num of processors per task (--ntasks/-n = num concurrent process)
# -s = num of sec before next check by ht_helper mini fifo scheduler. def=60
# -L = log task stdout/stderr to individual files
# -v = verbose mode


