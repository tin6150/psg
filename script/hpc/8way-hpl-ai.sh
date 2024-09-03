#!/bin/bash


# intend to run as tin@master
# pdsh -w n0[122-123].savio4 /global/home/users/tin/tin-bb/blpriv/cf_bk/savio4/benchmark_gpu/8way.sh
# pdsh -w n0[122-129].savio4 /global/home/users/tin/tin-bb/blpriv/cf_bk/savio4/benchmark_gpu/8way.sh
# pdsh -w n0[186].savio4 /global/home/users/tin/tin-bb/blpriv/cf_bk/savio4/benchmark_gpu/8way-hpl-ai.sh

# result stored in 
# /global/scratch/users/tin/JUNK/benchmark_gpu


# run some gpu test on 8x A5000 ,   n0122.savio4
# seems to work now, capturing output to file


# from PSG singularity page:
#1# singularity pull --docker-login docker://nvcr.io/nvidia/hpc-benchmarks:21.4-hpl
#1# singularity pull --docker-login hpc-benchmarks:23.5.sif docker://nvcr.io/nvidia/hpc-benchmarks:23.5 # 2023-0814

# the --docker-login will prompt for login, see .ssh/nvcr_io_api... 

cacheDir=/global/scratch/users/tin/cacheDir

export SIMG=$cacheDir/nvidia-benchmark/hpc-benchmarks_21.4-hpl.sif
#export SIMG=$cacheDir/nvidia-benchmark/hpc-benchmarks_23.5-hpl.sif
export DAT=~tin/CF_BK/greta/benchmark_gpu/HPL_4x2_Ns200k.dat

export OutDir=/global/scratch/users/tin/JUNK/benchmark_gpu
export OutFile=$OutDir/$(hostname --fqdn).$(date "+%Y-%m%d-%H%M").TXT


# run in subshell to capture full output to file
(

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




# 8 gpu test for n0122.savio4:
CMD="singularity exec --nv $SIMG \
  mpirun --mca btl smcuda,self -x UCX_TLS=sm,cuda,cuda_copy,cuda_ipc  --bind-to none -np 8 \
  hpl.sh  --xhpl-ai  --cpu-affinity 0-1:2-3:4-5:6-7:16-17:18-19:20-21:22-23 --gpu-affinity 0:1:2:3:4:5:6:7 --cpu-cores-per-rank 2 \
  --dat $DAT"

echo "about to run cmd: $CMD"
echo "==== ================= ======================================================="
$CMD ## 2>&1 > $OutFile

exitcode=$?

echo "==== ================= ======================================================="
echo "==== gpu test done === ======================================================="
echo "==== ================= ======================================================="

nvidia-smi 

uptime
date
echo "benchmard Cmd exitcode: $exitcode"
#exit $exitcode

# run in subshell to capture full output to file
) 2>&1 > $OutFile


exit $exitcode


############################################################

# --cpu-cores-per-rank 2 # 1 doesn't seems to work, may relate to cpu-affinity string...

CMD="singularity exec --nv $SIMG \
  mpirun --mca btl smcuda,self -x UCX_TLS=sm,cuda,cuda_copy,cuda_ipc  --bind-to none -np 8 \
  hpl.sh  --xhpl-ai  --cpu-affinity 0-1:2-3:4-5:6-7:16-17:18-19:20-21:22-23 --gpu-affinity 0:1:2:3:4:5:6:7 --cpu-cores-per-rank 2 \
  --dat $DAT"

echo "about to run cmd: $CMD"


  #hpl.sh  --xhpl-ai  --cpu-affinity "0-1:2-3:4-5:6-7:16-17:18-19:20-21:22-23" --gpu-affinity "0:1:2:3:4:5:6:7" --cpu-cores-per-rank 4 \  # works, power util 20-80W

  #hpl.sh  --xhpl-ai  --cpu-affinity "0-3:4-7:8-11:12-15:16-19:20-23:24-27:28-31" --gpu-affinity "0:1:2:3:4:5:6:7" --cpu-cores-per-rank 4 \   # works, but low power util, around 100W

############################################################

**^ tin n0123.savio4 ~/PSG/script/hpc ^**>  nvidia-smi topo -m
        GPU0    GPU1    GPU2    GPU3    GPU4    GPU5    GPU6    GPU7    mlx5_0  mlx5_1  CPU Affinity    NUMA Affinity
GPU0     X      PXB     PXB     PXB     SYS     SYS     SYS     SYS     NODE    NODE    0-15    0
GPU1    PXB      X      PXB     PXB     SYS     SYS     SYS     SYS     NODE    NODE    0-15    0
GPU2    PXB     PXB      X      PIX     SYS     SYS     SYS     SYS     NODE    NODE    0-15    0
GPU3    PXB     PXB     PIX      X      SYS     SYS     SYS     SYS     NODE    NODE    0-15    0
GPU4    SYS     SYS     SYS     SYS      X      PXB     PXB     PXB     SYS     SYS     16-31   1
GPU5    SYS     SYS     SYS     SYS     PXB      X      PXB     PXB     SYS     SYS     16-31   1
GPU6    SYS     SYS     SYS     SYS     PXB     PXB      X      PIX     SYS     SYS     16-31   1
GPU7    SYS     SYS     SYS     SYS     PXB     PXB     PIX      X      SYS     SYS     16-31   1
mlx5_0  NODE    NODE    NODE    NODE    SYS     SYS     SYS     SYS      X      PIX
mlx5_1  NODE    NODE    NODE    NODE    SYS     SYS     SYS     SYS     PIX      X


