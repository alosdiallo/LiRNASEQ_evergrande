# Counts UMI and genes
# usage Rscript /groups/cbdm_lab/dp133/scripts/umi_scripts/CorrectAndCountUMIs.R [feature to count in: choice of: exons, genes, genes_5kb] [sorted bam file name]
# requires a sorted and indexed bam file
#install.packages("data.table",dependencies=TRUE)
Sys.getenv('R_LIBS_USER')
suppressWarnings(suppressMessages(library(GenomicAlignments)))
suppressWarnings(suppressMessages(library(Rsamtools)))
suppressWarnings(suppressMessages(library(dplyr)))
suppressWarnings(suppressMessages(library(data.table)))
suppressWarnings(suppressMessages(library(gdata)))

#library(TxDb.Mmusculus.UCSC.mm10.knownGene)
#mm10 = TxDb.Mmusculus.UCSC.mm10.knownGene
#exons = exonsBy(mm10, by = "gene")

args = commandArgs(TRUE)
#args = c("exons", "TRA00028710_ls_1.uniqalign.genenames.sorted.bam")

## Make intelligible command line variable names
bam_file_name =  args[2]
prefix = strsplit(bam_file_name, split = "\\.")[[1]][1]

## Print the command line
cat("command line: Rscript add_umi_id.R", args, "\n")
cat("current working directory:", getwd(), "\n")
cat("working on file:", bam_file_name, "\n")
cat("counting reads in:", args[1], "\n")

ptm <- proc.time()
cat("PART1: Correcting for UMIs:\n")
cat("Reads bam and makes a data frame of it\n")
cat("Alos:watch 1:\n")
bam = scanBam(bam_file_name, param = ScanBamParam(what = scanBamWhat(), tag=c("YB")))
#header = scanBamHeader("accepted_hits.uniqalign.genenames.sorted.bam")
lst = lapply(names(bam[[1]]), function(elt) { do.call(c, unname(lapply(bam, "[[", elt))) })
names(lst) = names(bam[[1]]) #transform list of list in 1 list
df = do.call("DataFrame", lst) #make a data frame of the list
proc.time() - ptm
cat("Alos:watch 2:\n")
ptm <- proc.time()
cat("Alos:watch 3:\n")
#write.table(df,"df.txt")
cat("Keeps only reads with a gene name assigned...\n")
df$genes = sapply(df$YB, function(x) strsplit(strsplit(x, split = ",")[[1]],split = " ")[[1]][1]) # keeps first gene name
df = as.data.frame(df)
#write.table(df$YB,"df_2.txt")
df = df[!is.na(df$genes),] # removes reads not assigned to gene names
proc.time() - ptm
cat("Extracts UMIs from the read's IDs...\n")
umis = c()
#testing new idea
qname = df$qname
w = sapply(qname, function(x) as.character(x))
v = sapply(w, function(x) strsplit(x, split = "[:]"))
n = sapply(v, function(x) unlist(x, use.names = FALSE)[5])
rownames(n) <- NULL
umis = n
df = cbind(df,umis)
write.table(df,"df_all.txt", row.names = FALSE)
df <- fread("df_all.txt",header=TRUE)
#testing new idea

#df %>% filter(genes == "Il2rb") %>% select(genes, umis)
cat("Alos:watch 4:\n")
df = arrange(df, genes) 

df_genes = unique(df$genes) 
lenght_df_gene_list = length(df_genes)
cat("Alos:watch 4_2:\n")
ptm <- proc.time()
#*** For later use
dirCode = args[3]
lecseqPath = args[4]
result_directory = args[5]
#Outsource the work to the cluster - Alos
#system("factory.sh dirCode lecseqPath result_directory lenght_df_gene_list df_genes")
#
cat("Filters UMIs to keep distinct ones per gene...\n")

#data.table working
setDT(df)
filter_umis = unique(df, by = c("genes", "umis"))
filter_umis = as.data.frame(filter_umis)
#data.table working


#filter_umis = df %>% distinct(genes, umis)
cat("Alos:done new work:\n")
#filter_umis = df %>% distinct(genes, umis)
#write.table(filter_umis,"df_4.txt")
proc.time() - ptm


ptm <- proc.time()
cat("Alos:watch 5:\n")
cat("Writes the UMI corrected bam file...\n")
want = filter_umis$qname 
filter_factory = function(want ) { list(KeepQname = function(x) x$qname %in% want) }
filter = FilterRules(filter_factory(want))
destfile = paste(prefix, "_umicorrected.bam", sep = "")
dest = filterBam(file = bam_file_name, destination = destfile, filter = filter)
proc.time() - ptm

ptm <- proc.time()
cat("Alos:watch 6:Start\n")
cat("PART2: Counts reads in genes\n")
if (args[1] == "exons") { 
  load("/groups/cbdm_lab/dp133/scripts/allon_scripts/exons.Rda") } else 
    if (args[1] == "genes") { 
      load("/groups/cbdm_lab/dp133/scripts/allon_scripts/genes.Rda") } else 
        if (args[1] == "genes_5kb") {
          load("/groups/cbdm_lab/dp133/scripts/allon_scripts/genes_5kb.Rda") } else { print("choose between exons/genes/genes_5kb")}

ref
proc.time() - ptm
cat("Alos:watch 6:End\n")

ptm <- proc.time()
cat("Alos:watch 7:\n")
counts_by = summarizeOverlaps(features = ref, reads = destfile, mode = "IntersectionNotEmpty", ignore.strand = F)
proc.time() - ptm
ptm <- proc.time()
counts = data.frame(rownames(counts_by), assay(counts_by))
colnames(counts) = c("ENTREZID", prefix)
cat("Alos:watch 8:\n")
proc.time() - ptm
cat("Writes the counts file...\n")
write.table(file = sprintf("%s.%s.counts", paste(prefix, "_umicorrected", sep = ""), args[1]), x = counts, row.names = F, quote = F)
