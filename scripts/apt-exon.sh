#! /bin/bash

# fill in project directory
PROJECT=

## run APT with exon summarization
apt-probeset-summarize \
-p $PROJECT/library/HuEx-1_0-st-v2.r2.pgf \
-c $PROJECT/library/HuEx-1_0-st-v2.r2.clf \
-a rma-sketch -a dabg \
-b $PROJECT/library/HuEx-1_0-st-v2.r2.antigenomic.bgp \
-s $PROJECT/library/HuEx-1_0-st-v2.r2.dt1.hg18.core.ps \
--qc-probesets $PROJECT/library/HuEx-1_0-st-v2.r2.qcc \
-o $PROJECT/apt-exon/ \
--cel-files $PROJECT/raw_data/celFiles.txt