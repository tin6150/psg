#!/bin/sh

# submit jobs to cf1 to test max job limit
# sivonxay

STIME=300   # sleep time
JOBS=20  
JOBS_P=5


for N in $(seq 1 $JOBS); do
	srun -J 1sn${N} --partition=cf1 --account=scs --qos=cf_normal --time 00:07:00   sleep ${STIME} &
done

sleep 10

for N in $(seq 1 $JOBS_P); do
	srun -J 2snHP${N} --partition=cf1-hp --account=scs --qos=condo_mp --time 00:07:00   sleep ${STIME} &
done

sleep 10

for N in $(seq 1 24); do
	srun -J 3sn${N}   --partition=cf1 --account=scs --qos=cf_normal --time 00:07:00   sleep ${STIME} &
	srun -J 3snHP${N} --partition=cf1-hp --account=scs --qos=condo_mp --time 00:07:00   sleep ${STIME} &
done



exit 0



# sprio to see priority of pending job
# perceus-00|scs|tin|cf1-hp|1||||||||||||condo_mp|||
# perceus-00|scs|tin|cf1|1||||||||||||cf_debug,cf_normal|||


for N in $(seq 1 $JOBS); do
	##sbatch --partition=cf1 --account=lr_mp --qos=condo_mp --name J$N sleep $STIME  --time 00:10:00 
	#sbatch --partition=cf1 --account=lr_mp --qos=condo_mp  sleep $STIME  --time 00:10:00 
	#sbatch --partition=cf1 --account=scs --qos=condo_mp  $STIME  --time 00:10:00  /tmp/script
	srun -J sn${N} --partition=cf1 --account=scs --qos=cf_normal --time 00:15:00   sleep ${STIME} &
	#sbatch -w n0000.cf1 -n 64 /tmp/script
done


#n0003.scs00

#!/bin/bash                          
# Job name:                          
#SBATCH --job-name=test              
#                                    
# Partition:                         
#SBATCH --partition=cf1              
#                                    
# QoS:                               
#SBATCH --qos=condo_mp               
#                                    
# Account:                           
#SBATCH --account=lr_mp              
#                                    
# Processors:                        
##SBATCH --ntasks=64                 
#SBATCH --nodes=1                    
#                                    
# Wall clock limit:                  
#SBATCH --time=24:00:00              
#                                    
# Mail type:                         
##SBATCH --mail-type=all             
#                                    
# Mail user:                         
##SBATCH --mail-user=kmuriki@lbl.gov 
                                     
sleep 1000                           
                                     
                                     


exit 007

## ~~


# cd /global/scratch/tin/tmp/xmas
# for T in $(seq -w 0000 0019); do
#         sbatch  --partition=xmas --account=xmas  -w n${T}.xmas0 --job-name=N_${T} /global/home/users/tin/sn-gh/psg/script/hpc/slurm-script-xmas-eg.sh
# done


#SBATCH 	--job-name=xmas_test	# CLI arg will overwrite this, no easy way to embed node name or job number her
# 		CPU time: 
#SBATCH 	--time=65
# 		Wall clock limit:
# #SBATCH 	--time=00:10:00
#SBATCH 	--partition=xmas
# #SBATCH 	-n 4
# #SBATCH 	--qos=lr_normal
# #SBATCH 	--qos=lr_lowprio
#SBATCH 	--account=xmas
# #SBATCH 	--ntasks=2
# #SBATCH 	--mail-type=all
# #SBATCH 	--mail-type=END,FAIL
#SBATCH 	--mail-type=FAIL
#SBATCH 	--mail-user=tin@lbl.gov
# #SBATCH 	-N 3
#SBATCH 	-o  slurm_out_xmas_%N_job_%j.txt
# #SBATCH 	-o  junkable_slurm_out_xmas.txt

# %j is for jobid (eg 128)
# %J is for jobid.stepid (eg 128.0)
# %N is short node name
# %n is node number relative to current job, 0 for first node.  task spanning multiple node will get multiple file created
# -J is --job-name for CLI arg

## if no -o specified, default to slurm-%j.out or slurm-%A_%s.out for normal and array jobs
## if not using $j expansion, multiple node job will (over)write to the same output file (not auto concat)
## -e for stderr, which if not specified, would be combined into stdout
## https://slurm.schedmd.com/sbatch.html filename pattern : has details of % expansions



hostname
##exit 0		##

uptime
date
pwd
echo ---------------------------------------
cat /etc/os-release
echo ---------------------------------------
df -hl
echo ---------------------------------------
cat /proc/mounts
echo ---------------------------------------
echo "date before sleep"
date
sleep 60
echo "date after sleep"
date

