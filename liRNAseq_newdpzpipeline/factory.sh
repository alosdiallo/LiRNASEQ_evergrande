#!/bin/bash
#This is just the /groups/bpf-evergrande/liRNAseq_scripts/lirRNAseq_pipeline.sh  script with the directory change commented out
#cd /groups/bpf-evergrande/data/FC_01648/Unaligned_1_PF_mm1/Data/Project_yael

#R libraries taken from /groups/cbdm_lab/dp133/R_libraries
export R_LIBS="/groups/cbdm_lab/dp133/R_libraries"
export R_LIBS="/groups/immdiv-bioinfo/evergrande/yael/liRNAseq_newdpzpipeline"
#editing by Alos



dataBase=$1
dirCurrent=$2
experiment_directory_$3
size_of_gene_list=$4
echo $dirCurrent
gene_array=("$@")

cd $expdir


bsub -j "geneUmi[1-size_of_gene_list]" -o $dir.geneUmi.log $dirCurrent/create_sub_list.r dataBase; done
