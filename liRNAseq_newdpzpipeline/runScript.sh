#!/bin/bash
#This is just the /groups/bpf-evergrande/liRNAseq_scripts/lirRNAseq_pipeline.sh  script with the directory change commented out
#cd /groups/bpf-evergrande/data/FC_01648/Unaligned_1_PF_mm1/Data/Project_yael

#R libraries taken from /groups/cbdm_lab/dp133/R_libraries
export R_LIBS="/groups/cbdm_lab/dp133/R_libraries"
#editing by Alos


expdir=$1
time=$2
genome=$3
tran=$4
umi=$5
bc=$6
bedFile=$7
dirCurrent=$8

cd $expdir


for dir in S*; do echo $dir ; bsub -q mcore  -n 2 -W $time -R "rusage[mem=24000]" -o $dir.liRNAseq.log $dirCurrent/liRNAseq_pipeline_2.sh $dir $dir $genome $tran $umi $bc $dirCurrent $expdir $bedFile; done
#for dir in S* ; do echo $dir ; bsub -q mcore  -n 2 -W 36:00 -R "rusage[mem=24000]" -o $dir.liRNAseq.log /home/yj88/immdiv_bio/evergrande/yael/liRNAseq_newdpzpipeline/liRNAseq_pipeline_2_mouse.sh $dir $dir; done
