library("dplyr") 
library("stringr")
library("BiocVersion")
library("BiocParallel")
library("biomaRt")

####### if  useEnsembl  does not work then this is probably due to the dbplyr upgrade. #####
### you need to update dbplyr by
### install.packages("devtools")
### devtools::install_version("dbplyr", version = "2.3.4")
### then check the version of devtools, ensuring the version is 2.3.4 Then reopen the R or R studio, redo your interest code.

setwd("/demo_folder/")
#### Full list of mm10 gene IDs collected from htseq.counts is provided in file "/demo_folder/additional_files/mouse_ensemble_genelist.csv" ####

## load your gene list:
genes <- read.csv("/demo_folder/example_ensemble_genelist.csv",header=F)
mart <- useEnsembl("ensembl",dataset="mmusculus_gene_ensembl",host="https://nov2020.archive.ensembl.org")

# change filters to mgi_symbol if input file has gene ids # 
#BM.info <- getBM(attributes=c("ensembl_gene_id","ensembl_transcript_id_version","mgi_symbol","chromosome_name", "start_position", "end_position","strand"),filters="mgi_symbol",values=genes,mart=mart)
# change filters to ensembl_gene_id if input file has ensemble ids #
BM.info <- getBM(attributes=c("ensembl_gene_id","ensembl_transcript_id_version","mgi_symbol","chromosome_name", "start_position", "end_position","strand"),filters="ensembl_gene_id",values=genes,mart=mart)
BM.info$chromosome_name <- sub("^","chr",BM.info$chromosome_name) ## add chr before chr number
BM.info$strand[BM.info$strand == 1] <- "+" ## replace 1 and -1 by + and - for plus and minus strands
BM.info$strand[BM.info$strand == -1] <- "-" ## replace 1 and -1 by + and - for plus and minus strands

## generate input files for the next step:
write.table(cbind(BM.info$chromosome_name,BM.info$strand,BM.info$start_position,BM.info$end_position,BM.info$ensembl_gene_id,BM.info$ensembl_transcript_id_version), file="biomart_transcript_ids_position.txt", row.names=FALSE, col.names=FALSE, sep = "\t", quote=FALSE)
write.table(BM.info$ensembl_transcript_id_version,file="biomart_transcript_ids.txt", sep ="\t",row.names=FALSE, col.names=FALSE, quote=FALSE)

uniq_ensemble_BM.info <- BM.info %>% distinct(chromosome_name,start_position,end_position,strand,ensembl_gene_id)
write.table(uniq_ensemble_BM.info, file="biomart_ensemble_ids_position.txt", row.names=FALSE, col.names=FALSE, sep = "\t", quote=FALSE)

