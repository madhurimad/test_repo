#!/bin/bash

## Required applications:
# module load python/anaconda3.6
# module load samtools/1.6
# module load bedtools/2.30.0


## working directory
cd /demo_folder/brain_samples/

CPU=1  ## number of CPU-s, depending on your system

sampDir1=/demo_folder/BAMs_to_analyze/
sampDir2=/demo_folder/brain_samples/
sampDir3=/demo_folder/LXL_introns_bed/

### Extract only L and XL introns for respective genes ###
while IFS=$'\t' read -r -a genelist; 
do
        echo ${genelist[4]}

## NOTE: In this version sample names to process were hard-coded, we will change it to read from the file
#### BAM input files: SM604.bam,SM983.bam,SM285.bam,SM698.bam

## Calculate coverage over all bins ##

###########################
### Only intronic coverage is picked up; overlapping exons of genes in opposite strand are ignored; checked in IGV ###
#bedtools intersect -sorted -f 1.0 -a ${genelist[4]}_SM604.bam -b ${genelist[4]}_introns_minus_exons.bed | bedtools coverage -sorted -a ${genelist[4]}_introns_minus_exons.bed -b - > coverage_${genelist[4]}_SM604_window_a.bedgraph
###########################

	for samples in SM604 SM983 SM285 SM698
	do
	
		samtools view -@ ${CPU} -b ${sampDir1}${samples}.bam ${genelist[0]}:${genelist[1]}-${genelist[2]} > ${genelist[4]}_${samples}.bam

		bedtools intersect -sorted -f 1.0 -a ${genelist[4]}_${samples}.bam -b ${sampDir3}${genelist[4]}_introns_minus_exons_bins.bed | bedtools coverage -sorted -counts -a ${sampDir3}${genelist[4]}_introns_minus_exons_bins.bed -b - > coverage_${genelist[4]}_${samples}_window.bedgraph
		sort -n -k4 coverage_${genelist[4]}_${samples}_window.bedgraph > coverage_${genelist[4]}_${samples}_window.sorted.bedgraph

## Sorting coverage with respect to binsize order ##
		bedtools groupby -i coverage_${genelist[4]}_${samples}_window.sorted.bedgraph -g 4 -c 5 -o mean > ${sampDir2}average_cov_bin/coverage_${genelist[4]}_${samples}.tsv

	done
done < /demo_folder/biomart_ensemble_ids_position_LXL.txt 
