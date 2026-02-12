#!/bin/bash

awk '{a[FNR]=$1;b[FNR]+=$2;} END{for (i=1;i<=FNR;i++) print a[i], b[i]}' /demo_folder/brain_samples/average_cov_bin/coverage*_SM604.tsv > sum_coverage_SM604.tsv
awk '{a[FNR]=$1;b[FNR]+=$2;} END{for (i=1;i<=FNR;i++) print a[i], b[i]}' /demo_folder/brain_samples/average_cov_bin/coverage*_SM983.tsv > sum_coverage_SM983.tsv
awk '{a[FNR]=$1;b[FNR]+=$2;} END{for (i=1;i<=FNR;i++) print a[i], b[i]}' /demo_folder/brain_samples/average_cov_bin/coverage*_SM285.tsv > sum_coverage_SM285.tsv
awk '{a[FNR]=$1;b[FNR]+=$2;} END{for (i=1;i<=FNR;i++) print a[i], b[i]}' /demo_folder/brain_samples/average_cov_bin/coverage*_SM698.tsv > sum_coverage_SM698.tsv
