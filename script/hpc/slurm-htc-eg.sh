#!/bin/bash

## (abricate) [scarletbliss@ln000 raw_reads]$ cat vf.sh

#SBATCH --job-name=sn-gnu-par
#SBATCH --account=scs
#SBATCH --partition=savio4_htc
#SBATCH --nodes=24
#####SBATCH --ntasks=16   # dont work in savio2_htc, ntasks somehow limited to the 12 cores on single cpu
#SBATCH --cpus-per-task=24          # env reports SLURM_CPUS_PER_TASK=1
#####SBATCH --partition=savio4_htc
#####SBATCH --nodes=3
#####SBATCH --ntasks=56      # 2x28 in savio4_htc and this works
#####SBATCH --ntasks-per-node=24
######SBATCH --cpus-per-task=128
#https://sulis-hpc.github.io/gettingstarted/batchq/singlenode.html
#SBATCH --cpus-per-task=1
#SBATCH --time=00:04:00

#### https://docs-research-it.berkeley.edu/services/high-performance-computing/user-guide/running-your-jobs/gnu-parallel/

env | grep SLURM 

source ~/.bashrc					# to get conda
module load gnu-parallel
#conda activate abricate

#cd /global/scratch/users/scarletbliss/raw_reads
cd /global/scratch/users/tin/fc_graham/PRISA/Assemblies

basename -s .fasta -a *.fasta | head -60 > task.lst


# set number of jobs based on number of cores available and number of threads per job
export JOBS_PER_NODE=$(( $SLURM_CPUS_ON_NODE / $SLURM_CPUS_PER_TASK ))
echo JOBS_PER_NODE  set to $JOBS_PER_NODE
echo SLURM_JOB_NODELIST Is $SLURM_JOB_NODELIST 
echo $SLURM_JOB_NODELIST |sed s/\,/\\n/g > hostfile

hostname
date
parallel -j  6  -a task.lst  'echo processing {}; ls -latrd {}.fasta;  hostname; uptime; date; sleep 20'
date
parallel -j  6  -a task.lst  'echo processing {}; ls -latrd {}.fasta;  hostname; uptime; date; sleep 120'
date

#parallel -j 24  -a task.lst  'abricate --db ecoli_vf {}.fasta > /global/scratch/users/scarletbliss/vf_reads/vf.{}.txt'
#parallel -j 24  -a task.lst  'echo abricate --db ecoli_vf {}.fasta > /global/scratch/users/scarletbliss/vf_reads/vf.{}.txt'


#cd /global/scratch/users/scarletbliss/vf_reads
#abricate --summary vf.*.txt > summary.tab
#cat vf.*.txt  | grep -v "COVERAGE_MAP" > combined.txt
