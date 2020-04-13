#!/bin/sh

## #SBATCH --constrain=lr3_normal # these not in brc, so get error
#SBATCH --constrain=savio2_c28 # other features could be savio2_1080ti, savio2_m128, savio3_m384, savio3_m96, 4rtx, 8rtx  (which should have been 4gtx), savio3_2080ti should just become savio3_gpu?  
## #SBATCH --job-name=test  

#SBATCH --partition=savio2
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
