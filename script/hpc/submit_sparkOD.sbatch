#!/bin/bash

# sbatch submit_sparkOD.sbatch 
# to submit a slurm job that launch spark on demand.
# ref: https://sites.google.com/a/lbl.gov/high-performance-computing-services-group/getting-started/faq


#SBATCH --job-name=spark-test
#SBATCH --partition=lr5
#SBATCH --qos=lr_debug
#SBATCH --account=scs
#SBATCH --nodes=4
#SBATCH --time=00:10:00

source /global/home/groups/allhands/bin/spark_helper.sh

# Start Spark On Demand
spark-start

# Example 1
spark-submit --master $SPARK_URL $SPARK_DIR/examples/src/main/python/pi.py

# Example 2
spark-submit --master $SPARK_URL $SPARK_DIR/examples/src/main/python/wordcount.py /foo/bar

# Stop Spark On Demand
spark-stop
