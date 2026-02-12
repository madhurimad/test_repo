#!/bin/bash

## Required applications:
# module load python/anaconda3.6
# module load samtools/1.6             ## works with v1.6 or higher
# module load bedtools/2.30.0

## working directory
cd /demo_folder/LXL_introns_bed/

sampDir=/demo_folder/

### Merge introns for respective genes ###
while IFS=$'\t' read -r -a file; 
do
        echo ${file[4]}

        bedtools sort -i ${file[4]}_introns.bed > ${file[4]}_sorted_introns.bed
        mv ${file[4]}_sorted_introns.bed ${file[4]}_introns.bed

## Merge introns bed ##
        bedtools merge -i ${file[4]}_introns.bed -s -c 4,5,6 -o collapse,sum,distinct -delim "\|" > ${file[4]}_introns_merge.bed
        bedtools sort -i ${file[4]}_introns_merge.bed > ${file[4]}_introns_merge_sorted.bed
        mv ${file[4]}_introns_merge_sorted.bed ${file[4]}_introns_merge.bed

done < /demo_folder/biomart_ensemble_ids_position.txt

### Extract only L and XL introns for respective genes ###
while IFS=$'\t' read -r -a genelist; 
do
        echo ${genelist[4]}
## CHECK1: Find the number of introns for the specific gene and if > 2 then proceed ##
        number_of_lines=`wc -l < ${genelist[4]}_introns_merge.bed`
        flag=0
        
        if [ ${number_of_lines} -ge 2 ] ;
        then    
                while IFS=$'\t' read -r -a line; 
                do
                        diff=$(( ${line[2]} - ${line[1]} ))
## CHECK2: Find the intron size for the specific transcript and if > 50000 then proceed ##
                        echo ${diff}
                        if [ ${diff} -ge 50000 ] 
           		 then
                                echo -e "${line[0]}\t${line[1]}\t${line[2]}\t${line[3]}\t${line[4]}\t${line[5]}" >> ${genelist[4]}_introns_LXL.bed
                                flag=1;
                                strand=${line[5]};
                        fi
                done < ${genelist[4]}_introns_merge.bed
        elif [ ${number_of_lines} -lt 2 ] ;
        then    
                echo "less than 2 introns"
                rm ${genelist[4]}_introns_merge.bed
                rm ${genelist[4]}_introns.bed
                continue
        fi

        if [ ${flag} -eq 1 ] ;
        then
## Subtract exons (same or opposite strand) from intron ##
                bedtools subtract -a ${genelist[4]}_introns_LXL.bed -b ${sampDir}all_exons.bed -s > ${genelist[4]}_introns_minus_exons.bed
                bedtools sort -i ${genelist[4]}_introns_minus_exons.bed > ${genelist[4]}_introns_minus_exons_sorted.bed
                mv ${genelist[4]}_introns_minus_exons_sorted.bed ${genelist[4]}_introns_minus_exons.bed
## Determine the strand and divide the introns into 100 bins ## 
                if [ ${strand} == "+" ];
                then
                        bedtools makewindows -b ${genelist[4]}_introns_minus_exons.bed -n 100 -i winnum | bedtools sort > ${genelist[4]}_introns_minus_exons_bins.bed
                elif [ ${strand} == "-" ];
                then
                        bedtools makewindows -reverse -b ${genelist[4]}_introns_minus_exons.bed -n 100 -i winnum | bedtools sort > ${genelist[4]}_introns_minus_exons_bins.bed
                fi
        elif [ ${flag} -eq 0 ] ;
        then    
                echo "not l and xl"
                rm ${genelist[4]}_introns_merge.bed
                rm ${genelist[4]}_introns.bed
                continue
        fi

done < /demo_folder/biomart_ensemble_ids_position.txt

