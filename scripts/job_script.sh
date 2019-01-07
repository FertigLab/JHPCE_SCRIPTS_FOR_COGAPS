#!/bin/bash

# When running standard CoGAPS with the nThreads argument,
# -pe local <N> should be equal to nThreads, otherwise set it to 1
#
# When running GWCoGAPS or scCoGAPS, -pe local <N> should be
# equal to nSets, otherwise set it to 1
#
# Make sure you set your time limit to something reasonable, you can set it
# to a small value and run it once to see what CoGAPS was estimating for the
# total run time of the dataset. Note you must double the estimated runtime
# for GWCoGAPS since it runs in two passes

############################# CHANGE THIS SECTION ##############################

# job name
#$ -N FULL_RETINA

# number of cores for the job
#$ -pe local 24

# maximum memory for the job -- this is per core, divide total by num cores
#$ -l mem_free=2G
#$ -l h_vmem=2G

# max time
#$ -l h_rt=168:0:0
#$ -l s_rt=168:0:0

########################## DO NOT CHANGE THIS SECTION ##########################

# verify that an R script wasa passed
if [ ! -f $1 ]; then
    "internal error: R Script not found"
    exit 1
fi
R_SCRIPT=$1

# verify that an output directory was passed
if [ ! -d $2 ]; then
    "internal error: output directory not found"
    exit 1
fi
OUTPUT_DIR=$2

# verify that R script is an absolute path
if [ ! "${R_SCRIPT:0:1}" == "/" ]; then
    "internal error: relative path passed in script name"
    exit 1
fi

# verify that output directory is an absolute path
if [ ! "${OUTPUT_DIR:0:1}" == "/" ]; then
    "internal error: relative path passed in output directory"
    exit 1
fi

# create output directory for this job within the array
mkdir -p $OUTPUT_DIR/result_$SGE_TASK_ID

# change directories so output gets put in the right place
cd $OUTPUT_DIR/result_$SGE_TASK_ID

# run r script
time Rscript $R_SCRIPT $SGE_TASK_ID

################################################################################
