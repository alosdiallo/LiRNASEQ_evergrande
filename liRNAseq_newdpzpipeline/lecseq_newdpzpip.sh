#!/bin/bash
# David Zemmour
# Run where the fastq.bz2 files are
# usage: /groups/cbdm_lab/dp133/scripts/umi_scripts/lecseq_newdpzpip.sh  [dir_where_fastq.bz2_files_are - eg TRA002920 - serves also as prefix for prefix_ls_N]

module load seq/fastx/0.0.13
module load seq/tophat/2.0.10
module load seq/bowtie/2.1.0
module load seq/samtools/0.1.19
module load seq/BEDtools/2.23.0
module load stats/R/3.2.1

echo "working directory : " $1

cd $1 # working directory where the fastq.bz2 files are

echo "Merging L1 and L2 for R1..."
#cat *L001_R1.fastq.bz2 *L002_R1.fastq.bz2  > R1.fastq.bz2
echo "Merging L1 and L2 for R2..."
#cat *L001_R2.fastq.bz2 *L002_R2.fastq.bz2  > R2.fastq.bz2

echo "Bunzip R1..."
#bunzip2 -kv R1.fastq.bz2 	#bsub -q short -W 1:00 -J bzR1 bunzip2 -kv R1.fastq.bz2
echo "Bunzip R2..."
##bunzip2 -kv R2.fastq.bz2 	#bsub -q short -W 1:00 -J bzR2 bunzip2 -kv R2.fastq.bz2

echo "Trimming barcode (R2:5-12), UMI (R2:1-4) and R1 (1-30)..."
#mkdir lecseq
cd lecseq
fastx_trimmer -Q 33 -f 5 -l 12 -i ../*R2.fastq -o bc.fastq
fastx_trimmer -Q 33 -f 1 -l 4 -i ../*R2.fastq -o umi.fastq
fastx_trimmer -Q 33 -f 1 -l 30 -i ../*R1.fastq -o R1.fastq

echo "Merging bc, umi and R1 into one file..."
merge_fastq.pl bc.fastq umi.fastq bcumi.fastq
merge_fastq.pl bcumi.fastq R1.fastq bcumiR1.fastq

echo "Filtering..."
fastq_quality_filter -v -Q 33 -q 20 -p 80 -i bcumiR1.fastq -o bcumiR1.filtered.fastq

echo " Moving barcode to header: make sure UMI is on 5th position in the ID..."
add_umi_to_id.pl S bcumiR1.filtered.fastq bcumiR1.filtered.bcumitoid.fq 1 8 9 4

echo "Demultiplexing..."
cat bcumiR1.filtered.bcumitoid.fq | fastx_barcode_splitter.pl --bcfile lecseq_barcodes.tab  --bol --mismatch 2 --prefix ${prefix}_ --suffix ".bcumiR1.fq" &> demultiplex.stat.txt_2m

mkdir trash
mv ${prefix}_unmatched.bcumiR1.fq trash

echo "Trimming out bc and umi files..."
for file in *bcumiR1.fq ; do echo $file ; fastx_trimmer -Q 33 -f 13 -i $file -o ${file%.bcumiR1.fq}.fq ; done

mv *bcumiR1.fq trash

echo "Running MapAndCountUMIs.sh... "
ls ${prefix}_*fq > files.txt
cut -f 1 -d '.' files.txt > libraries.txt
while read line ; do echo $line ; mkdir $line ; mv ${line}.fq $line ; done < libraries.txt
rm files.txt
rm libraries.txt

for dir in ${prefix}_* ; do echo $dir ; bsub -q mcore -n 2 -W 2:00 -o $dir.ls.log MapAndCountUMIs.sh $dir $dir ; done

rm -r trash
