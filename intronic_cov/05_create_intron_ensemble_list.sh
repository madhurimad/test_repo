#!/bin/bash

ls LXL_introns_bed/*_introns.bed | awk -F '/' '{print $2}' | awk -F '_' '{print $1}'  > genelist_LXL.txt ###[select only genes names; delete path] ###
grep -f genelist_LXL.txt biomart_ensemble_ids_position.txt > biomart_ensemble_ids_position_LXL.txt

