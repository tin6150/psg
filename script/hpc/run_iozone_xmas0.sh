#!/bin/sh 


#SBATCH         --job-name=iozone    # CLI arg will overwrite this
#               CPU time:
#SBATCH         --time=605
#               Wall clock limit:
# #SBATCH       --time=00:10:00
#SBATCH         --partition=xmas
# #SBATCH       -n 4
# #SBATCH       --qos=lr_normal
# #SBATCH       --qos=lr_lowprio
#SBATCH         --account=xmas
# #SBATCH       --ntasks=2
# #SBATCH       --mail-type=all
# #SBATCH       --mail-type=END,FAIL
#SBATCH         --mail-type=FAIL
#SBATCH         --mail-user=tin@lbl.gov
# #SBATCH       -N 3
#SBATCH         -o  slurm_iozone_%N_%j.txt
# #SBATCH       -o  junkable_slurm_out_xmas.txt

# %j is for jobid (eg 128)
# %J is for jobid.stepid (eg 128.0)
# %N is short node name
# %n is node number relative to current job, 0 for first node.  task spanning multiple node will get multiple file created
# -J is --job-name for CLI arg


HNAME=$(hostname)

BASEDIR=/clusterfs/xmas/perf_test_tin/iozone3/

DIR=$BASEDIR/scratch_$HNAME
[[ -d $DIR ]] || mkdir $DIR

cd $DIR

THREAD=1
# time now avail in slurm... it is not a binary... some shell thing??
#time -p ../iozone -i 0 -c -e -w -r 1024k -s  16g -t $THREAD -+n -b $DIR/result.xls

../iozone -i 0 -c -e    -r 1024k -s 512m -t $THREAD -+n -b $DIR/result.xls	# 1x 512m file takes about 10s

# -w preserve test data, useful for read/rewrite test?...


## example run 1: (from lrc-sl7):

## #sbatch  --partition=xmas --account=xmas  -w n0001.xmas0 /global/home/users/tin/sn-gh/psg/script/hpc/run_iozone_xmas0.sh

## example run 2:
#for T in $(seq -w 0010 0014); do
#        sbatch  --partition=xmas --account=xmas  -w n${T}.xmas0 /global/home/users/tin/sn-gh/psg/script/hpc/run_iozone_xmas0.sh
#done

# there is also ioperf?  io-perf?


