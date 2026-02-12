#!/bin/bash

module load python/anaconda3.6
module load samtools/1.6
module load bedtools/2.30.0


## working directory
cd /demo_folder/

perl -a -nE 'qx( echo "$F[0]\t$F[1]\t$F[2]\t$F[3]\t$F[5]\t$F[6]" >> "LXL_introns_bed/$F[4]_introns.bed" )' biomart_transcript_ids_introns_sorted.bed
