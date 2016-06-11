#Alos Diallo 
#Create sub-lists of the larger gene UMI list.
args = commandArgs(TRUE)

gene = args[1]
Full_list = args[2] 
#This will take a gene and create a sublist containing only data which pretains to that gene
Full_list.sub = subset(Full_list,genes == gene) 

#This will create a unique list of gene umi pairs and filter out the copies Then convert it back to a data frame
filter_umis = unique(Full_list.sub, by = c("genes", "umis"))
filter_umis = as.data.frame(filter_umis)

#Saving the result to a file
write.table(filter_umis,"sub_df.txt",row.names = FALSE,quote = FALSE,append=TRUE)
