#!/bin/sh
# David Zemmour, Ashley Sun, Alos Diallo
# usage: /groups/cbdm_lab/dp133/scripts/allon_scripts/MapAndCountUMIs.sh [path_to_the_folder_containing_fastq_file] [prefix]
prefix=$2
genome=$3
transcriptome=$4
path=$5
dirCode=$6
bedFile=$7
result_directory=$8
rda_directory=$9
RPath="Results"

cd $path/$1
lecseq="lecseq"
lecseqPath=$path/$1/$lecseq
module load seq/fastx/0.0.13
module load seq/tophat/2.0.10
module load seq/bowtie/2.1.0
module load seq/samtools/0.1.19
#module load seq/htseq/0.6.1
module load seq/BEDtools/2.23.0
module load stats/R/3.2.1

echo "Running tophat..."
mkdir thoutfs
#to make the transcriptome reference: tophat -p 2 -G genes.gtf --transcriptome-index=/groups/cbdm_lab/dp133/genomes/hg19/transcriptome /groups/cbdm_lab/dp133/genomes/hg19/genome
#tophat -p 4 --library-type fr-firststrand --read-mismatches 5 --read-gap-length 5 --read-edit-dist 5 --no-coverage-search --segment-length 15 --transcriptome-index /groups/cbdm_lab/dp133/NOD_custom_mm10/known_mm10 -o ./thoutfs /groups/cbdm_lab/dp133/NOD_custom_mm10/genome $prefix.fq
tophat -p 4 --library-type fr-firststrand --read-mismatches 2 --read-gap-length 2 --read-edit-dist 3 --no-coverage-search --segment-length 15 --transcriptome-only --transcriptome-max-hits 1 --prefilter-multihits --transcriptome-index $transcriptome -o ./thoutfs $genome $lecseqPath/$prefix.fq
#tophat2 -p 2 --library-type fr-firststrand --read-mismatches 5 --read-gap-length 5 --read-edit-dist 5 --no-coverage-search --segment-length 15 --transcriptome-index /groups/cbdm_lab/dp133/genomes/hg19/transcriptome -o ./thoutfs /groups/cbdm_lab/dp133/genomes/hg19/genome $prefix.R1

cd thoutfs


echo "Removing multiple alignments and low MAPQ reads"
samtools view -@ 4 -b -q 10 -F 256 accepted_hits.bam > accepted_hits.uniqalign.bam
#and reads with low mapping quality: samtools view -b -q 10 -F 256 accepted_hits.bam > accepted_hits.uniqalign.bam

#Make bed file with exons: do only once
	#cut -f 1,4,5  known_mm10_exons.gff > 1
	#cut -f 9 known_mm10_exons.gff | cut -d ' ' -f 2 | cut -d '"' -f 2 > 2
	#cut -f 6,7 known_mm10_exons.gff > 3
	#paste 1 2 3 > known_mm10_exons.bed

echo "Annotating bam file with gene name..."
tagBam -s -i accepted_hits.uniqalign.bam -files $bedFile -names > accepted_hits.uniqalign.genenames.bam
mv accepted_hits.uniqalign.genenames.bam $prefix.uniqalign.genenames.bam

echo "Sorting and indexing bam file"
samtools sort -@ 4 $prefix.uniqalign.genenames.bam $prefix.uniqalign.genenames.sorted
samtools index $prefix.uniqalign.genenames.sorted.bam

echo "UMI correction: writing correcting bam file and count file..."
#Rscript /groups/cbdm_lab/dp133/scripts/umi_scripts/CorrectAndCountUMIs.R exons $prefix.uniqalign.genenames.sorted.bam
Rscript $dirCode/CorrectAndCountUMIsEditDist.R exons $prefix.uniqalign.genenames.sorted.bam $dirCode $lecseqPath $result_directory $rda_directory

echo "Stats..."
echo $prefix > names.txt
#grep 'Input' *align* | cut -d ':' -f 1 | cut -d '.' -f 1 > names.txt
grep 'Input' *align* | cut -d ':' -f 3 > reads.txt
grep 'Mapped' *align* | cut -d ':' -f 3 | cut -d '(' -f 1 > mapped.txt
#grep 'of these' *align* | cut -d ':' -f 3 | cut -d '(' -f 1 > multialigned.txt
samtools view -@ 4 *umicorrected.bam | wc -l > umis.txt
echo 'SAMPLE READS MAPPED UMIS' > $prefix.mapping_rates.txt
paste names.txt reads.txt mapped.txt umis.txt >> $prefix.mapping_rates.txt
rm names.txt reads.txt mapped.txt umis.txt

echo "Removing files..."
rm *genenames*
rm accepted_hits.uniqalign.bam

echo "Copying files..."
$path
thoutfs="thoutfs"
cp $path/$prefix/$thoutfs/* $result_directory
cp $prefix* ../../
cp $prefix* $result_directory
cp $lecseqPath/* $result_directory
