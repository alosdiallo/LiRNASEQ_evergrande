#!/bin/bash
# David Zemmour
# usage: /groups/cbdm_lab/dp133/scripts/allon_scripts/MapAndCountUMIs.sh $path_to_the_folder_containing_fastq_file $prefix

cd $1
prefix=$2

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
tophat -p 4 --library-type fr-firststrand --read-mismatches 5 --read-gap-length 5 --read-edit-dist 5 --no-coverage-search --segment-length 15 --transcriptome-index /groups/bpf-evergrande/genomes/NOD_custom_mm10/known_mm10 -o ./thoutfs /groups/bpf-evergrande/genomes/NOD_custom_mm10/genome $prefix.fq
#tophat2 -p 2 --library-type fr-firststrand --read-mismatches 5 --read-gap-length 5 --read-edit-dist 5 --no-coverage-search --segment-length 15 --transcriptome-index /groups/cbdm_lab/dp133/genomes/hg19/transcriptome -o ./thoutfs /groups/cbdm_lab/dp133/genomes/hg19/genome $prefix.R1
#tophat -p 4 --library-type fr-firststrand --read-mismatches 5 --read-gap-length 5 --read-edit-dist 5 --no-coverage-search --segment-length 15 --transcriptome-index /groups/cbdm_lab/dp133/NOD_custom_mm10/known_mm10 -o ./thoutfs /groups/cbdm_lab/dp133/NOD_custom_mm10/genome reads_95_89.fq

cd thoutfs

echo "Removing multiple alignments"
samtools view -b -F 256 accepted_hits.bam > accepted_hits.uniqalign.bam

#Make bed file with exons
#cut -f 1,4,5  known_mm10_exons.gff > 1
#cut -f 9 known_mm10_exons.gff | cut -d ' ' -f 2 | cut -d '"' -f 2 > 2
#cut -f 6,7 known_mm10_exons.gff > 3
#paste 1 2 3 > known_mm10_exons.bed
# for human i used ../../genomes/hg19/biomart_hg19_genes.gff #andrew

echo "Annotating bam file with gene name..."
tagBam -s -i accepted_hits.uniqalign.bam -files /home/yj88/immdiv_bio/evergrande/yael/liRNAseq_newdpzpipeline/known_mm10_exons.bed -names > accepted_hits.uniqalign.genenames.bam
#samtools view test.bam | grep YB | wc -l
mv accepted_hits.uniqalign.genenames.bam $prefix.uniqalign.genenames.bam

echo "Sorting and indexing bam file"
samtools sort $prefix.uniqalign.genenames.bam $prefix.uniqalign.genenames.sorted
samtools index $prefix.uniqalign.genenames.sorted.bam

echo "UMI correction: writing correcting bam file and count file..."
Rscript /home/yj88/immdiv_bio/evergrande/yael/liRNAseq_newdpzpipeline/CorrectAndCountUMIsEditDist.R exons $prefix.uniqalign.genenames.sorted.bam

echo "Stats..."
echo $prefix > names.txt
#grep 'Input' *align* | cut -d ':' -f 1 | cut -d '.' -f 1 > names.txt
grep 'Input' *align* | cut -d ':' -f 3 > reads.txt
grep 'Mapped' *align* | cut -d ':' -f 3 | cut -d '(' -f 1 > mapped.txt
grep 'of these' *align* | cut -d ':' -f 3 | cut -d '(' -f 1 > multialigned.txt
samtools view *umicorrected.bam | wc -l > umis.txt
echo 'SAMPLE READS MAPPED MULTIALIGN UMIS' > $prefix.mapping_rates.txt
paste names.txt reads.txt mapped.txt multialigned.txt umis.txt >> $prefix.mapping_rates.txt
rm names.txt reads.txt mapped.txt multialigned.txt umis.txt

echo "Removing files..."
#rm *genenames*
#rm accepted_hits.uniqalign.bam

echo "Copying files..."
cp $prefix* ../../

