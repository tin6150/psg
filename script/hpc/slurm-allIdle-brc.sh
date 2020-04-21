#!/bin/bash

# script to submit jobs to all idle nodes
# to load them up to test power util
# tin 2020.0419


[[ -d /global/scratch/tin/JUNK/SLURM_OUT/ ]] || mkdir /global/scratch/tin/JUNK/SLURM_OUT


#echo "**** Idle nodes are ****"
#sinfo --Node --long --format "%N %20P %.10t" | grep savio  | grep idle 


# htc and other non exclusive node?  
# well, mix node would not be idle
# job oversubcribe/exclusive does not overwrite system's option :(
# some fine tuning maybe necessary...

PARTITION_LIST=$(sinfo --Node --long --format "%N %20P %.10t" | awk '/savio/ {print $2}' | sort -u  )
#PARTITION_LIST=$(sinfo --Node --long --format "%N %20P %.10t" | egrep -v gpu\|80ti\|htc | awk '/savio/ {print $2}' | sort -u  )

# may not be able to handle gpu yet cuz of gres thing...
# actually worked for n0005. savio3_gpu
# but not for savio2_1080ti cuz of generic gres spec

# sight, savio2 n0300 complains too
# sbatch: error: Batch job submission failed: Requested node configuration is not available


for PARTITION in $PARTITION_LIST; do
		echo "---- Processing $PARTITION..."


	  # for PARTION="savio" need to append a space for grep not to match savio2	
		# hmm... "savio2 " would match twice for "savio2_1080ti" as well or n0172.savio2_bigmem ++FIXME
		NODELIST=$( sinfo --Node --long --format '%N %20P %.10t' | grep "$PARTITION " | awk '/idle/ {print $1}'  )
		for NODE in $NODELIST; do
			#echo "sbatching partition: $PARTITION for node: $NODE"
			#++echo sbatch -w ${NODE} --partition=$PARTITION -n 1 --mail-type=NONE --job-name=${NODE}_allNodeTest -o /global/scratch/tin/JUNK/SLURM_OUT/sn_%N_%j.out ~tin/tin-gh/psg/script/hpc/slurm-allnodes-lr5.sh
			echo srun -w ${NODE} --partition=$PARTITION -n 1 --mail-type=NONE --job-name=${NODE}_allNodeTest_srun --time=00:09:59 --account=scs --qos=savio_normal -o /global/scratch/tin/JUNK/SLURM_OUT/sn_%N_%j.out hostname
			# qos may be diff for savio3?  and no trivial way to find out.  this all submit aint easy :/
		done

done

echo "## job script used is /global/scratch/tin/tin-gh/psg/script/hpc/slurm-allnodes-lr5.sh "
echo "## output is in /global/scratch/tin/JUNK/ "



# vim: noexpandtab paste
