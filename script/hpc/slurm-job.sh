#!/bin/sh

## #SBATCH --constrain=lr3_normal # these not in brc, so get error
###SBATCH --constrain=savio2_c28 # other features could be savio2_1080ti, savio2_m128, savio3_m384, savio3_m96, 4rtx, 8rtx  (which should have been 4gtx), savio3_2080ti should just become savio3_gpu?  
## #SBATCH --job-name=test  
## #SBATCH --partition=savio

#SBATCH --partition=savio4_gpu 
#SBATCH --qos=savio_normal
#SBATCH --account=scs
#SBATCH --nodes=1
#SBATCH --mem-per-cpu=2G 
#SBATCH --time=00:59:59
####SBATCH --time=02:30:00  hh:mm:ss

# submit as 
# sbatch --partition=savio2 -N 1 --account=scs --qos=savio_debug ./slurm-job.sh
# sbatch --reservation=checkJob  ./slurm-job.sh
hostname
date
uptime
df -hT
sleep 3600
