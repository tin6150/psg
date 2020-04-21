#!/bin/bash

# script to submit jobs to all idle nodes
# to load them up to test power util
# tin 2020.0419


[[ -d /global/scratch/tin/JUNK/SLURM_OUT/ ]] || mkdir -p /global/scratch/tin/JUNK/SLURM_OUT


#echo "##  **** Idle nodes are ****"
#sinfo --Node --long --format "%N %20P %.10t" | grep savio  | grep idle 


#PARTITION_LIST=$(sinfo --Node --long --format "%N %20P %.10t" | awk '/savio/ {print $2}' | sort -u  )
PARTITION_LIST=$(sinfo --Node --long --format "%N %20P %.10t" | egrep -v gpu\|80ti | awk '/savio/ {print $2}' | sort -u  )
for PARTITION in $PARTITION_LIST; do
		echo "##  ---- Processing $PARTITION..."

		# for PARTION="savio" need to append a space for grep not to match savio2	
		NODELIST=$( sinfo --Node --long --format '%N %20P %.10t' | awk "\$2 ~ /^$PARTITION$/ && \$3 ~ /idle/ {print \$1}" )
		for NODE in $NODELIST; do
			#echo "##  sbatching partition: $PARTITION for node: $NODE"
			echo sbatch -w ${NODE} --partition=$PARTITION -n 1 --exclusive=user --mail-type=NONE --job-name=${NODE}_allNodeTest -o /global/scratch/tin/JUNK/SLURM_OUT/sn_%N_%j.out ~tin/tin-gh/psg/script/hpc/slurm-allnodes-lr5.sh
			##echo srun -w ${NODE} --partition=$PARTITION -n 1 --mail-type=NONE --job-name=${NODE}_allNodeTest_srun --time=00:09:59 --account=scs --qos=savio_normal -o /global/scratch/tin/JUNK/SLURM_OUT/sn_%N_%j.out hostname
			# qos may be diff for savio3?  and no trivial way to find out.  this all submit aint easy :/
		done

done



echo "##  Oversubscribe=Yes partitions ##"
echo "##  ===================================================================#" 

# htc and other non exclusive node?  
# well, mix node would not be idle
# job oversubcribe/exclusive does not overwrite system's option :(
# some fine tuning maybe necessary...



# may not be able to handle gpu yet cuz of gres thing...
# actually worked for n0005. savio3_gpu
# but not for savio2_1080ti cuz of generic gres spec

# sigh, savio2 n0300 complains too
# sbatch: error: Batch job submission failed: Requested node configuration is not available

# but work for --partition=savio3_2080ti  n0138.savio3
# also work for n0005.savio3 --partition=savio3_gpu



# slurm.conf Oversubscribe=Yes : savio3_2080ti savio3_gpu avio2_1080ti savio2_gpu savio2_htc
PARTITION_LIST=$(sinfo --Node --long --format "%N %20P %.10t" | egrep gpu\|80ti\|htc | awk '/savio/ {print $2}' | sort -u  )
for PARTITION in $PARTITION_LIST; do
		echo "##  ---- Processing $PARTITION..."
		NODELIST=$( sinfo --Node --long --format '%N %20P %.10t' | awk "\$2 ~ /^$PARTITION$/ && \$3 ~ /idle/ {print \$1}" )
		for NODE in $NODELIST; do
			#echo "##  sbatching partition: $PARTITION for node: $NODE"
			echo sbatch -w ${NODE} --partition=$PARTITION --exclusive=user -n 1 --mail-type=NONE --job-name=${NODE}_allNodeTest -o /global/scratch/tin/JUNK/SLURM_OUT/sn_%N_%j.out ~tin/tin-gh/psg/script/hpc/slurm-allnodes-lr5.sh
			echo srun -w ${NODE} --partition=$PARTITION -n 1 --mail-type=NONE --job-name=${NODE}_allNodeTest_srun --time=00:09:59 --account=scs --qos=savio_normal -o /global/scratch/tin/JUNK/SLURM_OUT/sn_%N_%j.out hostname
			# qos may be diff for savio3?  and no trivial way to find out.  this all submit aint easy :/
		done

done

echo "##  job script used is /global/scratch/tin/tin-gh/psg/script/hpc/slurm-allnodes-lr5.sh "
echo "##  output is in /global/scratch/tin/JUNK/ "


# --exclusive=user seems to work, slurm will respect that (so long as there are other free nodes?)   # at least for savio2_htc



exit 0



cat > /dev/null << END_HEREDOC



not sure why this savio2 node error out:

sbatch -w n0239.savio2 --partition=savio2 -n 1  --mail-type=NONE --job-name=n0239.savio2_allNodeTest -o /global/scratch/tin/JUNK/SLURM_OUT/sn_%N_%j.out /global/home/users/tin/tin-gh/psg/script/hpc/slurm-allnodes-lr5.sh
sbatch: error: Batch job submission failed: Requested node configuration is not available


# gpu gres blues... these didn't work, likely cuz of bug.  Jackie used --gpu=gres:K80:2 
# sbatch -w n0026.savio2 --partition=savio2_gpu --exclusive=user --nodes=1 --ntasks=1 --cpus-per-task=1 --gres=gpu:1 --qos=normal ~tin/tin-gh/psg/script/hpc/slurm-allnodes-lr5.sh
# srun --pty  -w n0301.savio2 --partition=savio2_1080ti --exclusive=user --nodes=1 --ntasks=1 --cpus-per-task=1 --gres=gpu:1 --qos=normal  --time=0:20:00 bash

#  srun --pty  --nodes=1  --partition=savio2_gpu   --gres=gpu:1 --qos=normal  --time=0:20:00 --account=scs bash  
# works when --nodes is >=2  ... bug bug bug!!!


END_HEREDOC

# vim: noexpandtab paste
