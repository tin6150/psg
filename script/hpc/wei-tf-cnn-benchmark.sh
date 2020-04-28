#!/bin/bash -l
#SBATCH -N 1
#SBATCH -t 00:28:58
#SBATCH -A scs
#SBATCH -p savio3_2080ti
#SBATCH -J gpu-test

module purge
module load ml/tensorflow/1.12.0-py36

PRECISION=fp32 
MODEL=inception3
BATCH_SIZE=32
NUM_BATCHES=250000
NUM_GPU=4

# this work, even when script placed under my dir
# time python /global/home/users/wfeinstein/benchmarks/scripts/tf_cnn_benchmarks/tf_cnn_benchmarks.py --model ${MODEL} --batch_size ${BATCH_SIZE} --num_batches ${NUM_BATCHES} --num_gpus ${NUM_GPU} --data_name imagenet |tee ~/test-gpu/log

# now using files under my dir
time python /global/home/users/tin/gpu-benchmarks/scripts/tf_cnn_benchmarks/tf_cnn_benchmarks.py --model ${MODEL} --batch_size ${BATCH_SIZE} --num_batches ${NUM_BATCHES} --num_gpus ${NUM_GPU} --data_name imagenet |tee /global/scratch/tin/JUNK/test-gpu-log

