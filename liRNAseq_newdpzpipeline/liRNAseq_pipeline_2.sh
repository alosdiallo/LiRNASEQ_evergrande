#!/bin/bash
# Run where the fastq.bz2 files are
# usage: /groups/cbdm_lab/dp133/scripts/liRNAseq_pipeline_2.sh [dir_where_fastq.bz2_files_are] [prefix]

module load seq/fastx/0.0.13
module load seq/tophat/2.0.10
module load seq/bowtie/2.1.0
module load seq/samtools/0.1.19
#module load seq/htseq/0.6.1
module load seq/BEDtools/2.23.0
module load stats/R/3.2.1
dir_home=$1
echo "Working directory : " $dir_home

cd $dir_home # working directory where the fastq.bz2 files are
prefix=$2
genome=$3
tran=$4
umi=$5
bc=$6
dirCode=$7
expdir=$8
bedFile=$9
rDA_path=${10}

echo "GOLD"
echo $rDA_path
echo "GOLD"

bcStart=$umi+1

mkdir $expdir/$prefix.result 
result_directory=$expdir/$prefix.result


echo "Merging L1 and L2 for R1..."
cat *L00*_R1.fastq.bz2 > R1.fastq.bz2
echo "Merging L1 and L2 for R2..."
cat *L00*_R2.fastq.bz2 > R2.fastq.bz2

echo "Bunzipping R1..."
#gzip -dfv R1.fastq.gz
bunzip2 -kv R1.fastq.bz2
echo "Bunzip R2..."
#gzip -dfv R2.fastq.gz
bunzip2 -kv R2.fastq.bz2

echo "Trimming barcode R2:5-12, UMI R2:1-4 and R1:1-30..."
mkdir lecseq
cd lecseq
fastx_trimmer -Q 33 -f $bcStart -l $bc -i ../*R2.fastq -o bc.fastq
fastx_trimmer -Q 33 -f 1 -l $umi -i ../*R2.fastq -o umi.fastq
fastx_trimmer -Q 33 -f 1 -l 30 -i ../*R1.fastq -o R1.fastq

echo "Merging bc, umi and R1 into one file..."
$dirCode/merge_fastq.pl bc.fastq umi.fastq bcumi.fastq
$dirCode/merge_fastq.pl bcumi.fastq R1.fastq bcumiR1.fastq

#rm bc.fastq umi.fastq R1.fastq R2.fastq bcumi.fastq

echo "Filtering..."
fastq_quality_filter -v -Q 33 -q 20 -p 80 -i bcumiR1.fastq -o bcumiR1.filtered.fastq

#rm bcumiR1.fastq

echo " Moving barcode to header: make sure UMI is on 5th position in the ID..."
$dirCode/add_umi_to_id.pl S bcumiR1.filtered.fastq bcumiR1.filtered.bcumitoid.fq 1 8 9 4 #Where are these numbers coming from?

echo "Trimming out bc and umi files..."
fastx_trimmer -Q 33 -f 13 -i bcumiR1.filtered.bcumitoid.fq -o $prefix.fq #What does this do?

echo "Map and correct for UMIs..."
$dirCode/MapAndCountUMIs.sh $prefix $prefix $genome $tran $expdir $dirCode $bedFile $result_directory $rDA_path
