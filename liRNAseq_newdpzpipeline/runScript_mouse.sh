#!/bin/bash
#This is just the /groups/bpf-evergrande/liRNAseq_scripts/lirRNAseq_pipeline.sh  script with the directory change commented out
#cd /groups/bpf-evergrande/data/FC_01648/Unaligned_1_PF_mm1/Data/Project_yael

#R libraries taken from /groups/cbdm_lab/dp133/R_libraries
#export R_LIBS="/groups/bpf-evergrande/tools/cbdm_R_libraries/R_libraries"
for dir in S* ; do echo $dir ; bsub -q mcore  -n 2 -W 36:00 -R "rusage[mem=24000]" -o $dir.liRNAseq.log /home/yj88/immdiv_bio/evergrande/yael/liRNAseq_newdpzpipeline/liRNAseq_pipeline_2_mouse.sh $dir $dir; done
