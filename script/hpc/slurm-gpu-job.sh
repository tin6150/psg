#!/bin/bash  -l

# -l in bash is SOMETIME important for login shell and getting the TF job to start

#### this script run GPU jobs using 4 or 8 GPU at a time.
#### it runs a TF CNN benchmark, but run on large batches (instead of epoch?)
#### mostly to stress test/power load test a machine
#### (it is a adaptation from  ~wfeinstein/test-gpu/test.sh)
#### submit-slurm-allIdle-brc.sh can invoke this script
####
#### can also just invoke this script directly from the shell to test a specific node


#SBATCH				--job-name=SnGpuTest    # -J CLI arg will overwrite this
#					CPU time (in seconds 1199 == 00:19:59 HH:MM:ss) :
#	#SBATCH			--time=1199
#SBATCH				--time=08:19:59
#					Wall clock limit in HH:MM:ss
#	#SBATCH			--time=00:10:00
#
#   oh don't remember all the diff b/w -n -N --nodes=...   rtfm 
#   --nodes=2 --ntasks=8 --cpus-per-task=2 would span 2 nodes and give 4 tasks per node # https://research-it.berkeley.edu/services/high-performance-computing/running-your-jobs
#?? #SBATCH			-N 1		# wei had this, but shouldnt matter cuz cli use --ntasks=8
#	#SBATCH			--ntasks=2
#	#SBATCH			--nodes=4
#	#SBATCH			--ntasks=2           # -n, help scheduler determine total tasks and how many nodes are needed
#	#SBATCH			--cpus-per-task 1    # will be 1 except when running threaded code. 

#	#SBATCH			--qos=cf_normal
#	#SBATCH  		--qos=lr_lowprio
#	#SBATCH  		--qos=lr_normal # cf_normal
#SBATCH				--qos=savio_normal 
#SBATCH				--account=scs        # -A

#   #SBATCH			--partition=savio2
#	#SBATCH			--partition=cf1

#### gpu gres request
#SBATCH        		--partition=savio4_gpu
#SBATCH         	--gres=gpu:8				# this works for savio4_gpu when it was homegeneous A5000
#	#SBATCH         	--gres=gpu:A5000:8
#	#SBATCH      	--partition=savio2_gpu
#   #SBATCH         --gres=gpu:2

## #SBATCH --constrain=savio2_1080ti   # feature in slurm.conf


#	#SBATCH			--mail-type=all
#	#SBATCH			--mail-type=END,FAIL
#   #SBATCH			--mail-type=FAIL
#SBATCH  			--mail-type=NONE
#SBATCH				--mail-user=tin@berkeley.edu
#	#SBATCH			--mail-user=tin@lbl.gov
#	#SBATCH			-o  slurm_testnode_%N_%j.txt
#	#SBATCH			-o  junkable_slurm_out_cf1.txt
#SBATCH				-o  sn_%N_%j.out
#SBATCH				-e  sn_%N_%j.err

# %j is for jobid (eg 128)
# %J is for jobid.stepid (eg 128.0)
# %N is short node name
# %n is node number relative to current job, 0 for first node.  task spanning multiple node will get multiple file created
# -J is --job-name for CLI arg


################################################################################
##### print some header info into the log
################################################################################

LOGDIR=/global/scratch/users/tin/JUNK/
MAQ=$(hostname)
TAG=$(hostname).$(date +%m%d.%H%M)
OUTFILE=$LOGDIR/slurm-gpu-job.$TAG.out.rst

hostname 

# consider: run whole thing in subshell to capture output to a file 


echo ----hostname-----------------------------------
echo -n "hostname: " 
hostname 
echo ----date-----------------------------------
date
echo ----os-release----------------------------------
cat /etc/os-release

echo ----lscpu-----------------------------------
lscpu
echo ----nvidia-smi-----------------------------------
nvidia-smi


echo "==== ================= ======================================================="
echo "==== gpu test next === =======================================================" 
echo "==== ================= ======================================================="
#  gpu test from wei

#echo "---which module; define -F ------------------------------------"
#which module
#define -F | grep module
#[[ -f /etc/profile.d/modules.sh ]] && source /etc/profile.d/modules.sh
#which module
#define -F | grep module

echo "---module list before purge ------------------------------------"
module list    2>&1
module purge   2>&1
module load ml/tensorflow/1.12.0-py36 2>&1 
echo "---module list after purge ------------------------------------"
module list    2>&1



PRECISION=fp32 
MODEL=inception3
BATCH_SIZE=32 # --num_batches param, this  should take about 8 hours

#NUM_BATCHES=250 # 1080ti n0299.sav2 ML@B, ~3 min to run
NUM_BATCHES=2500 # 1080ti n0299.sav2 ML@B, ~14 min to run
#kNUM_BATCHES=2500 # quick sanity test, still took 61m on 8x A5000 n0120.sav4
#NUM_BATCHES=25000 # n0120 error out ~41min : InternalError (see above for traceback): Blas GEMM launch failed : a.shape=(32, 2048), b.shape=(32, 1001), m=2048, n=1001, k=32
#NUM_BATCHES=250000 # for V100 or colefax, need to change.  # real    951m51.584s # user    6718m43.128s # sys     525m50.911s
#NUM_BATCHES=2500001 # for V100 or colefax, need to change.
#NUM_GPU=4							
#NUM_GPU=2							
#NUM_GPU=7 #8
NUM_GPU=8
#NUM_GPU=4

echo "---about to start tf cnn benchmark  --------------------"

##echo time python /global/home/users/tin/benchmarks/scripts/tf_cnn_benchmarks/tf_cnn_benchmarks.py --model ${MODEL} --batch_size ${BATCH_SIZE} --num_batches ${NUM_BATCHES} --num_gpus ${NUM_GPU} --data_name imagene
##time python /global/home/users/tin/benchmarks/scripts/tf_cnn_benchmarks/tf_cnn_benchmarks.py --model ${MODEL} --batch_size ${BATCH_SIZE} --num_batches ${NUM_BATCHES} --num_gpus ${NUM_GPU} --data_name imagene


## see ~wfeinstein/test-gpu/test.sh 

#?? python /global/home/users/wfeinstein/benchmarks/scripts/tf_cnn_benchmarks/tf_cnn_benchmarks.py --model ${MODEL} --batch_size ${BATCH_SIZE} --num_batches ${NUM_BATCHES} --num_gpus ${NUM_GPU} --data_name imagene

##time python /global/home/users/wfeinstein/benchmarks/scripts/tf_cnn_benchmarks/tf_cnn_benchmarks.py --model ${MODEL} --batch_size ${BATCH_SIZE} --num_batches ${NUM_BATCHES} --num_gpus ${NUM_GPU} --data_name imagene

# now using files under my dir
#~echo time python /global/home/users/tin/gpu-benchmarks/scripts/tf_cnn_benchmarks/tf_cnn_benchmarks.py --model ${MODEL} --batch_size ${BATCH_SIZE} --num_batches ${NUM_BATCHES} --num_gpus ${NUM_GPU} --data_name imagenet 
echo time python /global/scratch/usrs/tin/gpu-benchmarks/scripts/tf_cnn_benchmarks/tf_cnn_benchmarks.py --model ${MODEL} --batch_size ${BATCH_SIZE} --num_batches ${NUM_BATCHES} --num_gpus ${NUM_GPU} --data_name imagenet 

date > /global/scratch/users/tin/JUNK/test-gpu.start.LOG.$MAQ 
date > /global/scratch/users/tin/JUNK/slurm-gpu-job.$TAG.begin
#~time python /global/home/users/tin/gpu-benchmarks/scripts/tf_cnn_benchmarks/tf_cnn_benchmarks.py --model ${MODEL} --batch_size ${BATCH_SIZE} --num_batches ${NUM_BATCHES} --num_gpus ${NUM_GPU} --data_name imagenet |tee /global/scratch/tin/JUNK/test-gpu.log
#/time python /global/scratch/tin/gpu-benchmarks/scripts/tf_cnn_benchmarks/tf_cnn_benchmarks.py --model ${MODEL} --batch_size ${BATCH_SIZE} --num_batches ${NUM_BATCHES} --num_gpus ${NUM_GPU} --data_name imagenet |tee /global/scratch/tin/JUNK/test-gpu.LOG.$MAQ  # es1 path
#/time python /global/home/users/tin/gpu-benchmarks/scripts/tf_cnn_benchmarks/tf_cnn_benchmarks.py --model ${MODEL} --batch_size ${BATCH_SIZE} --num_batches ${NUM_BATCHES} --num_gpus ${NUM_GPU} --data_name imagenet |tee /global/scratch/tin/JUNK/test-gpu.log
time python /global/home/users/tin/gpu-benchmarks/scripts/tf_cnn_benchmarks/tf_cnn_benchmarks.py --model ${MODEL} --batch_size ${BATCH_SIZE} --num_batches ${NUM_BATCHES} --num_gpus ${NUM_GPU} --data_name imagenet |tee /global/scratch/users/tin/JUNK/slurm-gpu-job.$TAG.log
echo ----date-----------------------------------
date | tee /global/scratch/users/tin/JUNK/test-gpu.end
date >     /global/scratch/users/tin/JUNK/slurm-gpu-job.$TAG.end


( 

echo '----what is shell inside () subshell?----'
echo $0
echo '---$0 inside () subshell is------'
echo $shell

) 2>&1 >> $OUTFILE   # append/capture the whole thing into a file name I prefer, slurm -o is too limitig


exit 0 


#### example submission
#### sbatch                 --partition=savio4_gpu --exclusive=user --ntasks=4  -A scs --time=05:40:59 --mail-type=NONE --job-name=savio4_gpu_Test -o /global/scratch/users/tin/JUNK/SLURM_OUT/sn_%N_%j.out /global/home/users/tin/tin-gh/psg/script/hpc/slurm-gpu-job.sh
#### sbatch                 --partition=savio4_gpu --exclusive=user --ntasks=16 --gres=gpu:A5000:8 -A scs --time=05:40:59 --mail-type=NONE --job-name=savio4_gpu_Test -o /global/scratch/users/tin/JUNK/SLURM_OUT/sn_%N_%j.out /global/home/users/tin/tin-gh/psg/script/hpc/slurm-gpu-job.sh
#### sbatch -w n0141.savio4 --partition=savio4_gpu --exclusive=user --ntasks=8 -A scs --time=05:40:59 --mail-type=NONE --job-name=savio4_gpu_Test -o /global/scratch/users/tin/JUNK/SLURM_OUT/sn_%N_%j.out /global/home/users/tin/tin-gh/psg/script/hpc/slurm-gpu-job.sh
####
#### old path/script >>
#### sbatch -w n0144.savio3 --partition=savio3_2080ti --exclusive=user --ntasks=8 --gres=gpu:4 --time=05:40:59 --mail-type=NONE --job-name=n0144.savio3_allNodeTest -o /global/scratch/tin/JUNK/SLURM_OUT/sn_%N_%j.out /global/home/users/tin/tin-gh/psg/script/hpc/slurm-allnodes-brc.sh

#### sbatch -w n0145.savio3 --partition=savio3_2080ti --exclusive=user --ntasks=8 --gres=gpu:8 --time=9-00:58:59 --mail-type=NONE --job-name=145savSlurmGpuTest -o /global/scratch/tin/JUNK/SLURM_OUT/sn_%N_%j.out /global/home/users/tin/tin-gh/psg/script/hpc/slurm-gpu-job.sh
### or just invoke this script locally on a drained node!
### ./slurm-gpu-job.sh | tee slurm-gpu-job.n0145-sav3.2021.0303.out
