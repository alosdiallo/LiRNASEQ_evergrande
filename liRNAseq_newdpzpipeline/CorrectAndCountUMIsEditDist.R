# Counts UMI and genes
# usage Rscript /groups/cbdm_lab/dp133/scripts/umi_scripts/CorrectAndCountUMIsEditDist.R [feature to count in: choice of: exons, genes, genes_5kb] [sorted bam file name]
# requires a sorted and indexed bam file

suppressWarnings(suppressMessages(library(GenomicAlignments)))
suppressWarnings(suppressMessages(library(Rsamtools)))
suppressWarnings(suppressMessages(library(dplyr)))
suppressWarnings(suppressMessages(library(stringdist)))

#library(TxDb.Mmusculus.UCSC.mm10.knownGene)
#mm10 = TxDb.Mmusculus.UCSC.mm10.knownGene
#exons = exonsBy(mm10, by = "gene")

args = commandArgs(TRUE)
#args = c("exons", "reads_99_159.uniqalign.genenames.sorted.bam")

## Make intelligible command line variable names
bam_file_name =  args[2]
prefix = strsplit(bam_file_name, split = "\\.")[[1]][1]

## Print the command line
cat("command line: Rscript add_umi_id.R", args, "\n")
cat("current working directory:", getwd(), "\n")
cat("working on file:", bam_file_name, "\n")
cat("counting reads in:", args[1], "\n")


cat("PART1: Correcting for UMIs:\n")
cat("Reads bam and makes a data frame of it\n")
bam = scanBam(bam_file_name, param = ScanBamParam(what = scanBamWhat(), tag=c("YB")))
#header = scanBamHeader("accepted_hits.uniqalign.genenames.sorted.bam")
lst = lapply(names(bam[[1]]), function(elt) { do.call(c, unname(lapply(bam, "[[", elt))) })
names(lst) = names(bam[[1]]) #transform list of list in 1 list
df = do.call("DataFrame", lst) #make a data frame of the list

cat("Keeps only reads with a gene name assigned...\n")
df$genes = sapply(df$YB, function(x) strsplit(strsplit(x, split = ",")[[1]],split = " ")[[1]][1]) # keeps first gene name
df = as.data.frame(df)
#dim(df %>% filter( is.na(df$genes)) %>% select(genes, umis))
df = df[!is.na(df$genes),] # removes reads not assigned to gene names

cat("Extracts UMIs from the read's IDs...\n")
umis = c()
for (i in 1:nrow(df)) { umis = c(umis, strsplit(as.character(df$qname[i]), split = ":")[[1]][5]) }
df$umis = unlist(umis)
#df %>% filter(genes == "Actb") %>% select(genes, umis)

cat("Filters UMIs to keep distinct ones per gene...\n")
filter_umis = df %>% distinct(genes, umis)
cat("...Number of UMIs before edit distance: ", dim(filter_umis)[1], "\n")

cat("Filters UMIs to keep distinct Umis per gene with edit distance >= 2...\n")
edit.dist = 1
filter_umis = filter_umis %>% group_by(genes) %>% mutate(numberumisbygenes = length(umis))
filter_umis_1umipergene = filter_umis %>% filter(numberumisbygenes <=1)
filter_umis_1umipergene$notmutant = rep(T,nrow(filter_umis_1umipergene) )
filter_umis_morethan1umipergene_edist = filter_umis %>% filter(numberumisbygenes >1) %>% group_by(genes) %>% mutate(notmutant = !duplicated(cutree(tree = hclust(d = as.dist(stringdistmatrix(umis, umis, method='lv'))), h = edit.dist)))
filter_umis_morethan1umipergene_edist_nomutant = filter_umis_morethan1umipergene_edist %>% filter(notmutant == T)
filter_umis_nomutant = rbind(filter_umis_1umipergene, filter_umis_morethan1umipergene_edist_nomutant)
cat("...Number of UMIs after edit distance: ", dim(filter_umis_nomutant)[1], "\n")
# method='hamming': substitutions only ; lv = levenshtein = substitution/insertion/deletion

#To Test edit distance code:
#sort(unique(filter_umis %>% filter(numberumisbygenes >1) %>% select(genes))$genes)
#filter_umis %>% filter(genes == "Rpl18a") %>% select(umis) %>%  mutate(notmutant = !duplicated(cutree(tree = hclust(d = as.dist(stringdistmatrix(umis, umis, method='lv'))), h = edit.dist)))
#z = filter_umis %>% filter(genes == "Rpl18a") %>% select(umis)
#z2 = adist(z$umis, z$umis)
#rownames(z2) = z$umis
#colnames(z2) = z$umis
#hc = hclust(d = as.dist(z2))
#plot(hc)
#abline(h = 1.1, col = "red")
#cutree(tree = hc, h = 1)
#!duplicated(cutree(tree = hc, h = 1))

cat("Writes the UMI corrected bam file...\n")
want = filter_umis_nomutant$qname 
filter_factory = function(want ) { list(KeepQname = function(x) x$qname %in% want) }
filter = FilterRules(filter_factory(want))
destfile = paste(prefix, "_umicorrected.bam", sep = "")
dest = filterBam(file = bam_file_name, destination = destfile, filter = filter)

cat("PART2: Counts reads in genes\n")
if (args[1] == "exons") { 
  load("exons.Rda") } else
    if (args[1] == "genes") { 
      load("genes.Rda") } else 
        if (args[1] == "genes_5kb") {
          load("genes_5kb.Rda") } else { print("choose between exons/genes/genes_5kb")}

ref

counts_by = summarizeOverlaps(features = ref, reads = destfile, mode = "IntersectionNotEmpty", ignore.strand = F)

counts = data.frame(rownames(counts_by), assay(counts_by))
colnames(counts) = c("ENTREZID", prefix)

cat("Writes the counts file...\n")
write.table(file = sprintf("%s.%s.counts", paste(prefix, "_umicorrected", sep = ""), args[1]), x = counts, row.names = F, quote = F)
