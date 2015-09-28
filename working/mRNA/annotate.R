annCols = c("PROBEID", "ENTREZID", "SYMBOL", "GENENAME")

## EXON LEVEL SUMMARIZATION
library(huex10stprobeset.db)

idList = keys(huex10stprobeset.db)

idTable = select(huex10stprobeset.db, 
                 keys=idList, keytype="PROBEID", columns=annCols)

exonIDs = read.table("../apt-exon/exon_rma_ids.txt", quote="", header=TRUE)

exonMerge = merge(exonIDs, idTable, by.x="probeset_id", by.y="PROBEID", all.x=TRUE)

write.table(exonMerge, file="../apt-exon/exon_annotated_ids.tsv", 
            sep="\t", row.names=FALSE, col.names=TRUE, quote=FALSE)

## GENE LEVEL SUMMARIZATION
library(huex10sttranscriptcluster.db)

idList = keys(huex10sttranscriptcluster.db)

idTable = select(huex10sttranscriptcluster.db,
                 keys=idList, keytype="PROBEID", columns=annCols)

geneIDs = read.table("../apt-gene/gene_rma_ids.txt", quote="", header=TRUE)

geneMerge = merge(geneIDs, idTable, by.x="probeset_id", by.y="PROBEID", all.x=TRUE)

write.table(geneMerge, file="../apt-gene/gene_annotated_ids.tsv", 
            sep="\t", row.names=FALSE, col.names=TRUE, quote=FALSE)

#
# huex10stprobeset.db version 8.3.1
#
# huex10sttranscriptcluster.db 8.3.1
#

# > huex10stprobeset.db
# ChipDb object:
# | DBSCHEMAVERSION: 2.1
# | Db type: ChipDb
# | Supporting package: AnnotationDbi
# | DBSCHEMA: HUMANCHIP_DB
# | ORGANISM: Homo sapiens
# | SPECIES: Human
# | MANUFACTURER: Affymetrix
# | CHIPNAME: huex10
# | MANUFACTURERURL: http://www.affymetrix.com
# | EGSOURCEDATE: 2015-Mar17
# | EGSOURCENAME: Entrez Gene
# | EGSOURCEURL: ftp://ftp.ncbi.nlm.nih.gov/gene/DATA
# | CENTRALID: ENTREZID
# | TAXID: 9606
# | GOSOURCENAME: Gene Ontology
# | GOSOURCEURL: ftp://ftp.geneontology.org/pub/go/godatabase/archive/latest-lite/
# | GOSOURCEDATE: 20150314
# | GOEGSOURCEDATE: 2015-Mar17
# | GOEGSOURCENAME: Entrez Gene
# | GOEGSOURCEURL: ftp://ftp.ncbi.nlm.nih.gov/gene/DATA
# | KEGGSOURCENAME: KEGG GENOME
# | KEGGSOURCEURL: ftp://ftp.genome.jp/pub/kegg/genomes
# | KEGGSOURCEDATE: 2011-Mar15
# | GPSOURCENAME: UCSC Genome Bioinformatics (Homo sapiens)
# | GPSOURCEURL: ftp://hgdownload.cse.ucsc.edu/goldenPath/hg19
# | GPSOURCEDATE: 2010-Mar22
# | ENSOURCEDATE: 2015-Mar13
# | ENSOURCENAME: Ensembl
# | ENSOURCEURL: ftp://ftp.ensembl.org/pub/current_fasta
# | UPSOURCENAME: Uniprot
# | UPSOURCEURL: http://www.UniProt.org/
# | UPSOURCEDATE: Tue Mar 17 18:48:15 2015

# > huex10sttranscriptcluster.db
# ChipDb object:
# | DBSCHEMAVERSION: 2.1
# | Db type: ChipDb
# | Supporting package: AnnotationDbi
# | DBSCHEMA: HUMANCHIP_DB
# | ORGANISM: Homo sapiens
# | SPECIES: Human
# | MANUFACTURER: Affymetrix
# | CHIPNAME: huex10
# | MANUFACTURERURL: http://www.affymetrix.com
# | EGSOURCEDATE: 2015-Mar17
# | EGSOURCENAME: Entrez Gene
# | EGSOURCEURL: ftp://ftp.ncbi.nlm.nih.gov/gene/DATA
# | CENTRALID: ENTREZID
# | TAXID: 9606
# | GOSOURCENAME: Gene Ontology
# | GOSOURCEURL: ftp://ftp.geneontology.org/pub/go/godatabase/archive/latest-lite/
# | GOSOURCEDATE: 20150314
# | GOEGSOURCEDATE: 2015-Mar17
# | GOEGSOURCENAME: Entrez Gene
# | GOEGSOURCEURL: ftp://ftp.ncbi.nlm.nih.gov/gene/DATA
# | KEGGSOURCENAME: KEGG GENOME
# | KEGGSOURCEURL: ftp://ftp.genome.jp/pub/kegg/genomes
# | KEGGSOURCEDATE: 2011-Mar15
# | GPSOURCENAME: UCSC Genome Bioinformatics (Homo sapiens)
# | GPSOURCEURL: ftp://hgdownload.cse.ucsc.edu/goldenPath/hg19
# | GPSOURCEDATE: 2010-Mar22
# | ENSOURCEDATE: 2015-Mar13
# | ENSOURCENAME: Ensembl
# | ENSOURCEURL: ftp://ftp.ensembl.org/pub/current_fasta
# | UPSOURCENAME: Uniprot
# | UPSOURCEURL: http://www.UniProt.org/
# | UPSOURCEDATE: Tue Mar 17 18:48:15 2015
