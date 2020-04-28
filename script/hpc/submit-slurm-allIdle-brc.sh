#!/bin/bash

# script to submit jobs to all idle nodes
# to load them up to test power util
# tin 2020.0419

# ./submit-slurm-allIdle-brc.sh | tee ./submit-slurm-allIdle-brc.runme.sh
# so that have a record of all the nodes to execute jobs, and clean up afterward as necessary
# though could likely get from squeue.


[[ -d /global/scratch/tin/JUNK/SLURM_OUT/ ]] || mkdir -p /global/scratch/tin/JUNK/SLURM_OUT
chmod 777 /global/scratch/tin/JUNK/
chmod 777 /global/scratch/tin/JUNK/SLURM_OUT

SLEEPTIME=1


#echo "##  **** Idle nodes are ****"
#sinfo --Node --long --format "%N %20P %.10t" | grep savio  | grep idle 


# htc likely have cgroup limiting which cpu they can use
# so a single sbatch will only occupy 1 core and leave the rest idle.  
# other partition seems fine (eg knl)



#PARTITION_LIST=$(sinfo --Node --long --format "%N %20P %.10t" | awk '/savio/ {print $2}' | sort -u  )
#PARTITION_LIST=$(sinfo --Node --long --format "%N %20P %.10t" | egrep -v gpu\|80ti | awk '/savio/ {print $2}' | sort -u  )
PARTITION_LIST=$(sinfo --Node --long --format "%N %20P %.10t" | egrep htc | awk '/savio/ {print $2}' | sort -u  )
for PARTITION in $PARTITION_LIST; do
		echo "##  ---- Processing $PARTITION..."

		# for PARTION="savio" need to append a space for grep not to match savio2	
		NODELIST=$( sinfo --Node --long --format '%N %20P %.10t' | awk "\$2 ~ /^$PARTITION$/ && \$3 ~ /idle/ {print \$1}" )
		for NODE in $NODELIST; do
			echo "sbatch --ntasks=12 -w ${NODE} --partition=$PARTITION --exclusive=user --mail-type=NONE --job-name=${NODE}_allNodeTest -o /global/scratch/tin/JUNK/SLURM_OUT/sn_%N_%j.out ~tin/tin-gh/psg/script/hpc/slurm-allnodes-brc.sh ; sleep $SLEEPTIME"
		done

done

#exit 0  # tmp htc


echo "##  ===================================================================#" 
echo "##  Oversubscribe=Yes  htc  partitions ##"
echo "##  ===================================================================#" 


PARTITION_LIST=$(sinfo --Node --long --format "%N %20P %.10t" | egrep -v gpu\|80ti\|htc | awk '/savio/ {print $2}' | sort -u  )
for PARTITION in $PARTITION_LIST; do
		echo "##  ---- Processing $PARTITION..."

		# for PARTION="savio" need to append a space for grep not to match savio2	
		NODELIST=$( sinfo --Node --long --format '%N %20P %.10t' | awk "\$2 ~ /^$PARTITION$/ && \$3 ~ /idle/ {print \$1}" )
		for NODE in $NODELIST; do
			#echo "##  sbatching partition: $PARTITION for node: $NODE"
			echo "sbatch -w ${NODE} --partition=$PARTITION --exclusive=user --mail-type=NONE --job-name=${NODE}_allNodeTest -o /global/scratch/tin/JUNK/SLURM_OUT/sn_%N_%j.out ~tin/tin-gh/psg/script/hpc/slurm-allnodes-brc.sh ; sleep $SLEEPTIME"
			##echo srun -w ${NODE} --partition=$PARTITION -n 1 --mail-type=NONE --job-name=${NODE}_allNodeTest_srun --time=00:09:59 --account=scs --qos=savio_normal -o /global/scratch/tin/JUNK/SLURM_OUT/sn_%N_%j.out hostname
			# qos may be diff for savio3?  and no trivial way to find out.  this all submit aint easy :/
		done

done


echo "##  ===================================================================#" 
echo "##  Oversubscribe=Yes  gpu  partitions ##"
echo "##  ===================================================================#" 




# slurm.conf Oversubscribe=Yes : savio3_2080ti savio3_gpu avio2_1080ti savio2_gpu savio2_htc
PARTITION_LIST=$(sinfo --Node --long --format "%N %20P %.10t" | egrep gpu\|80ti | awk '/savio/ {print $2}' | sort -u  )
for PARTITION in $PARTITION_LIST; do
		echo "##  ---- Processing $PARTITION..."
		NODELIST=$( sinfo --Node --long --format '%N %20P %.10t' | awk "\$2 ~ /^$PARTITION$/ && \$3 ~ /idle/ {print \$1}" )
		for NODE in $NODELIST; do
			#echo "##  sbatching partition: $PARTITION for node: $NODE"
			#echo sbatch -w ${NODE} --partition=$PARTITION --exclusive=user --ntasks=2 --gres=gpu:1 --mail-type=NONE --job-name=${NODE}_allNodeTest -o /global/scratch/tin/JUNK/SLURM_OUT/sn_%N_%j.out -e /global/scratch/tin/JUNK/SLURM_OUT/sn_%N_%j.err  ~tin/tin-gh/psg/script/hpc/slurm-gpu-job.sh  
			#echo "sbatch -w ${NODE} --partition=$PARTITION --time=05:30:59 --exclusive=user --ntasks=8 --gres=gpu:4 --mail-type=NONE --job-name=${NODE}_allNodeTest -o /global/scratch/tin/JUNK/SLURM_OUT/sn_%N_%j.out -e /global/scratch/tin/JUNK/SLURM_OUT/sn_%N_%j.err   ~wfeinstein/test-gpu/test.sh ; sleep $SLEEPTIME"
			#vv echo "sbatch -w ${NODE} --partition=$PARTITION --time=05:30:59 --exclusive=user --ntasks=8 --gres=gpu:4 --mail-type=NONE --job-name=${NODE}_allNodeTest -o /global/scratch/tin/JUNK/SLURM_OUT/sn_%N_%j.out -e /global/scratch/tin/JUNK/SLURM_OUT/sn_%N_%j.err   ~tin/tin-gh/psg/script/hpc/wei-tf-cnn-benchmark.sh"
			echo "sbatch -w ${NODE} --partition=$PARTITION --time=01:18:50 --exclusive=user --ntasks=8 --gres=gpu:4 --mail-type=NONE --job-name=${NODE}_allNodeTest -o /global/scratch/tin/JUNK/SLURM_OUT/sn_%N_%j.out -e /global/scratch/tin/JUNK/SLURM_OUT/sn_%N_%j.err  ~tin/tin-gh/psg/script/hpc/slurm-gpu-job.sh"  
			##echo srun --time=00:19:55 --account=scs --qos=savio_normal -w ${NODE} --partition=$PARTITION --exclusive=user --ntasks=2 --gres=gpu:1 --mail-type=NONE --job-name=${NODE}_allNodeTest   --pty bash   
			##echo srun -w ${NODE} --partition=$PARTITION -n 1 --mail-type=NONE --job-name=${NODE}_allNodeTest_srun --time=00:09:59 --account=scs --qos=savio_normal -o /global/scratch/tin/JUNK/SLURM_OUT/sn_%N_%j.out hostname
			#--echo sbatch -w ${NODE} --partition=$PARTITION --exclusive=user --ntasks=2 --gres=gpu:1 --mail-type=NONE --job-name=${NODE}_allNodeTest -o /global/scratch/tin/JUNK/SLURM_OUT/sn_%N_%j.out ~tin/tin-gh/psg/script/hpc/slurm-allnodes-brc.sh # stress cpu part on gpu node, does not get to run.
			#echo sleep  $SLEEPTIME
		done

done

echo "##  job script used is /global/scratch/tin/tin-gh/psg/script/hpc/slurm-allnodes-brc.sh "
echo "##  output is in /global/scratch/tin/JUNK/ "


# --exclusive=user seems to work, slurm will respect that (so long as there are other free nodes?)   # at least for savio2_htc



exit 0  


############################################################
############################################################
#### Do NOT run below !! 
#### exit above must be preserved 
############################################################
############################################################

: '

error with submission:
sbatch -w n0162.savio1 --partition=savio --ntasks=2 --gres=gpu:1 --exclusive=user --mail-type=NONE --job-name=n0162.savio1_allNodeTest -o /global/scratch/tin/JUNK/SLURM_OUT/sn_%N_%j.out /global/home/users/tin/tin-gh/psg/script/hpc/slurm-allnodes-brc.sh


////

gpu command that  can submit job, but it is not exclusive, and other could land on it, including my very own 2nd job.

sbatch -w n0301.savio2 --partition=savio2_1080ti --exclusive=user --ntasks=2 --gres=gpu:1 --mail-type=NONE --job-name=n0301.savio2_allNodeTest -o /global/scratch/tin/JUNK/SLURM_OUT/sn_%N_%j.out /global/home/users/tin/tin-gh/psg/script/hpc/slurm-allnodes-brc.sh

But exclusive is not heeded, my very own job are oversubscribed 3x when --ntasks=2 and --gres=gpu:1
fiddle with --ntasks=4 didnt help.
change --gres=gpu:4 dont work.  in this case, only gpu:1 work.
(exclusive=user means i can submit more job to it, but other user scheduler will not schedule other user to it
more info https://slurm.schedmd.com/mcs.html )

             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
           5825827    savio2 slurm-jo      tin PD       0:00      1 (QOSMaxWallDurationPerJobLimit)
           5827719     savio n0164.sa      tin PD       0:00      1 (Priority)
           5872924 savio2_ht n0222.sa      tin  R       3:38      1 n0222.savio2
           5872921 savio2_ht n0222.sa      tin  R       4:38      1 n0222.savio2

'

# htc and other non exclusive node?  
# well, mix node would not be idle
# job oversubcribe/exclusive does not overwrite system's option :(
# some fine tuning maybe necessary...


# sigh, savio2 n0300 complains too
# sbatch: error: Batch job submission failed: Requested node configuration is not available

# but work for --partition=savio3_2080ti  n0138.savio3
# also work for n0005.savio3 --partition=savio3_gpu



########


cat > /dev/null << END_HEREDOC


not sure why this savio2 node error out:

sbatch -w n0239.savio2 --partition=savio2 -n 1  --mail-type=NONE --job-name=n0239.savio2_allNodeTest -o /global/scratch/tin/JUNK/SLURM_OUT/sn_%N_%j.out /global/home/users/tin/tin-gh/psg/script/hpc/slurm-allnodes-brc.sh
sbatch: error: Batch job submission failed: Requested node configuration is not available


# gpu gres blues... these didn't work, likely cuz of bug.  Jackie used --gpu=gres:K80:2 
# sbatch -w n0026.savio2 --partition=savio2_gpu --exclusive=user --nodes=1 --ntasks=1 --cpus-per-task=1 --gres=gpu:1 --qos=normal ~tin/tin-gh/psg/script/hpc/slurm-allnodes-lr5.sh
# srun --pty  -w n0301.savio2 --partition=savio2_1080ti --exclusive=user --nodes=1 --ntasks=1 --cpus-per-task=1 --gres=gpu:1 --qos=normal  --time=0:20:00 bash

#  srun --pty  --nodes=1  --partition=savio2_gpu   --gres=gpu:1 --qos=normal  --time=0:20:00 --account=scs bash  
# works when --nodes is >=2  ... bug bug bug!!!

gpu, for now, use this work around, involving --ntasks=2 so that banking and process it correctly
srun --pty --nodes=1 --ntasks=2 --partition=savio2_1080ti --gres=gpu:1 --qos=normal --time=0:05:00 --account=scs bash


END_HEREDOC

# vim: noexpandtab paste
