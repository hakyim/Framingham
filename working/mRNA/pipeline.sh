#! /bin/bash

# fill in project directory
PROJECT=

## run APT with exon summarization
$PROJECT/apt-exon.sh

## run APT with gene summarization
$PROJECT/apt-gene.sh

## extract IDs from APT output which need annotation
cat $PROJECT/apt-exon/rma-sketch.summary.txt | grep -v -e '^#' | cut -f 1 > $PROJECT/apt-exon/exon_rma_ids.txt

## extract IDs from APT output which need annotation
cat $PROJECT/apt-gene/rma-sketch.summary.txt | grep -v -e '^#' | cut -f 1 > $PROJECT/apt-gene/gene_rma_ids.txt

## merge IDs with annotation table from R
Rscript $PROJECT/scripts/annotate.R
