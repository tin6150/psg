#!/bin/bash

# test script for spark on demand
# sbatch submit_sparkOD.sbatch 
# -or-
# sbatch --partition=lr3 --qos=lr_normal -N 3 --reservation=alsacc submit_sparkOD.sbatch 
#
# interactive:
# srun --partition=lr3 --qos=lr_normal -N 1 --reservation=alsacc -t 8:00:00 --pty bash -i    # 8 hrs debugging
# source /global/home/groups/allhands/bin/spark_helper.sh
# spark-start
# spark-submit --master $SPARK_URL $SPARK_DIR/examples/src/main/python/pi.py 
#
# ref: https://sites.google.com/a/lbl.gov/high-performance-computing-services-group/getting-started/faq




#SBATCH --job-name=spark-test
#SBATCH --partition=jbei1
#SBATCH --qos=normal
#SBATCH --account=scs
#SBATCH --nodes=8
#SBATCH --time=00:04:00  # 4 min quick test
#SBATCH --exclusive
#SBATCH --mem-per-core=3G        #
####SBATCH --mem=60G        # memory per node, lr3 has 62G reported by free -h


# slurm.conf
# PartitionName=jbei1         Nodes=n0[000-119].jbei[1]                   Shared=Yes          DefMemPerCPU=3000   LLN=Yes


################################################################################
##### print some info into the slurm output log
################################################################################
###
### info about slurm job
### https://www.glue.umd.edu/hpcc/help/slurmenv.html
### https://slurm.schedmd.com/sbatch.html#lbAH
###
echo "mpirun for xHPL run via slurm"
echo ----slurm-resource-allocated-------------------
echo -n "SLURMD_NODENAME: "
echo    $SLURMD_NODENAME
echo -n "SLURM_JOB_NUM_NODES: "         # Total number of nodes in the job's resource allocation.
echo    $SLURM_JOB_NUM_NODES
echo -n "SLURM_JOB_NODELIST: "
echo    $SLURM_JOB_NODELIST
echo -n "SLURM_TASKS_PER_NODE: "        # eg 64(x2)  , so will be some work before using it for CorePerNode 
echo    $SLURM_TASKS_PER_NODE
echo -n "SLURM_NTASKS_PER_NODE: "       # Number of tasks requested per core. Only set if the --ntasks-per-core option is specified.
echo    $SLURM_NTASKS_PER_NODE
echo -n "SLURM_MEM_PER_NODE: "          # got blank!
echo    $SLURM_MEM_PER_NODE
echo -n "SLURM_MEM_PER_CPU: "          
echo    $SLURM_MEM_PER_CPU
echo -n "SLURM_CPUS_ON_NODE: "          # 64 for n0000.cf1 knl
echo    $SLURM_CPUS_ON_NODE
echo -n "SLURM_JOB_PARTITION:"
echo    $SLURM_JOB_PARTITION
echo -n "SLURM_JOB_QOS:"
echo    $SLURM_JOB_QOS
echo ""
echo ""

echo "cgroup stuff"
grep -r [0-9] /cgroup/cpuset/slurm
grep  [0-9] /cgroup/memory/slurm/*




source /global/home/groups/allhands/bin/spark_helper.sh

echo Start Spark On Demand
spark-start
EXITCODE=$?
echo "spark-start completed, exitcode is $EXITCODE"
module list
which start-master.sh
which start-slaves.sh
echo "======================================================"

echo  SPARK ENV vars:
# spark-env.sh
echo -n  SPARK_EXECUTOR_MEMORY
echo     $SPARK_EXECUTOR_MEMORY
echo -n  SPARK_WORKER_CORES
echo    $SPARK_WORKER_CORES
echo -n SPARK_WORKER_MEMORY
echo    $SPARK_WORKER_MEMORY
echo "======================================================"


echo  Example 1
echo about to run : spark-submit --master $SPARK_URL $SPARK_DIR/examples/src/main/python/pi.py
spark-submit --master $SPARK_URL $SPARK_DIR/examples/src/main/python/pi.py
echo "======================================================"

echo Example 2
echo  about to run :  spark-submit --master $SPARK_URL $SPARK_DIR/examples/src/main/python/wordcount.py /etc/shells 
spark-submit --master $SPARK_URL $SPARK_DIR/examples/src/main/python/wordcount.py /etc/shells
echo "======================================================"

echo "sleeping to aid debugging"
date
sleep $(( 30 ))
#sleep $(( 60*45 ))
echo "end of debugging sleep in submit script.  proceeding to spark-stop"
date



echo  Stop Spark On Demand
spark-stop


#### ports
#### http://n0093.lr3:8080/   spark scheduler/manager/master
#### manager: 8080, 8081,
#### SparkUI 4040, 4041 
#### 7070
#### modules 1) vim/7.4          2) emacs/25.1       3) git/2.11.1       4) java/1.8.0_121   5) spark/2.1.0

#### fix conclusion
#### /global/software/sl-7.x86_64/modules/java/1.8.0_121/spark/2.1.0/sbin has bunch of scripts
#### start-slaves 
####       slaves.sh         # srun (orig use ssh)   # this is likely broken in current env...
####              slave.sh  
####       
#### /global/software/sl-7.x86_64/modules/java/1.8.0_121/spark/2.1.0/sbin/slaves.sh /global/software/sl-7.x86_64/modules/java/1.8.0_121/spark/2.1.0/sbin/start-slave.sh spark://n0070.lr3:7077
#### start-slave.sh calls 
#### + srun -N1 -n1 -w n0095.lr3 /global/software/sl-7.x86_64/modules/java/1.8.0_121/spark/2.1.0/sbin/start-slave.sh spark://n0093.lr3:7077
#### the daemonized java process return the shell prompt, srun exits.
####

#### final fix solution
#### add sleep to start-slave.sh, so that srun will keep the session open.  sleep for long time, like 4 days.
#### the job script has a separate process from spark-submit and will stop daemon services once the job finish
#### thus the worker threads by srun will get signal to close itself down when all is done.
#### Worked in my test.  hopefully work for other users and spark jobs as well.
#### Tin 2018.0520 
