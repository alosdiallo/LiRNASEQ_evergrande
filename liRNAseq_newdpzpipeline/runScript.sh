#!/bin/bash
#This is just the /groups/bpf-evergrande/liRNAseq_scripts/lirRNAseq_pipeline.sh  script with the directory change commented out
#cd /groups/bpf-evergrande/data/FC_01648/Unaligned_1_PF_mm1/Data/Project_yael

#R libraries taken from /groups/cbdm_lab/dp133/R_libraries
#export R_LIBS="/groups/bpf-evergrande/tools/cbdm_R_libraries/R_libraries"
dir=$1
time=$2
tran=$3
umi=$4
bc=$5
for dir in S* ; do echo $dir ; bsub -q mcore  -n 2 -W $time:00 -R "rusage[mem=24000]" -o $dir.liRNAseq.log liRNAseq_pipeline_2.sh $dir $dir $tran $umi $bc; done
