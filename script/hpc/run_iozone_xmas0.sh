#!/bin/sh 

HNAME=$(hostname)

BASEDIR=/clusterfs/xmas/perf_test_tin/iozone3/

DIR=$BASEDIR/scratch_$HNAME
[[ -d $DIR ]] || mkdir $DIR

cd $DIR

THREAD=1
../iozone -i 0 -c -e -w -r 1024k -s 16g -t $THREAD -+n -b $DIR/result.xls


## example run 1: (from lrc-sl7):

## #sbatch  --partition=xmas --account=xmas  -w n0001.xmas0 /global/home/users/tin/sn-gh/psg/script/hpc/run_iozone_xmas0.sh

## example run 2:
#for T in $(seq -w 0010 0014); do
#        sbatch  --partition=xmas --account=xmas  -w n${T}.xmas0 /global/home/users/tin/sn-gh/psg/script/hpc/run_iozone_xmas0.sh
#done

# there is also ioperf?  io-perf?


