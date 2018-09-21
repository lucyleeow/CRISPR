#!/bin/bash

#Description: 	Runs the MAGeCK analysis on raw fastq files.
#				The following modules are offered:
#				1. MAGeCK count - inuput: fastq files, output: count matrix. 
#				2. Remove batch effects (if required) using R package 'sva'. Input: count matrix,
#				Output: count matrix with batch effects removed.
#				3. MAGeCK mle 
#				4. MAGeCK rra  
#
#Author: Lucy Liu


#########################################################
# Arguments
#
# Change these arguments for each new project
#
#########################################################

# Directory path of file where the compressed fastq files are:

gzfastqfile="/Volumes/bioinf_pipeline/Runs/NextSeq/180917_NB501056_0192_AH3NYHBGX9/ProjectFolders/Project_Iva-Nikolic"

# Directory path of the file where you want the uncompressed fastq files to go -
# this location will be the 'working directory'

workdir="/Volumes/Users/Lucy/CRISPR/Iva20180921"

# Name of the file where the sgRNA annotation file is

# sgRNAfile=""

# # Sample labels, comma separated

# samlabels=""

#######################################
# Unzip fastq files to choosen directory
#######################################

# cd ${gzfastqfile}

# for file in $(ls */*.gz);

# do
#         echo ${file}
#         bname=$(basename ${file} .fastq.gz)
#         # get the base name of the file and also remove the '.fastq.gz' at the end
#         echo $bname
#         gzip -d -c ${file} > ${workdir}${bname}.fastq
#         # -decompress = unzip, send output to location as specified, add fastq to end of file name
# done

###############################
# Cutadapt to trim adapters
###############################
# Use 'cutadapt' to trim adaptors


# cd ${workdir}
# Change to working directory


# module load cutadapt
# Use only if on cluster


# for file in $(ls *1.fastq);

# do
# 		echo ${file}
# 		bname=$(basename ${file} .fastq)
# 		echo $bname
#       cutadapt -g TGTGGAAAGGACGAAACACCG -o ${bname}.trimmed_P5.fastq ${file} > trimP5_${bname}_log.txt
#       #trim 5' adaptor
#       cutadapt -a GTTTTAGAGCTAGAAATAGCAAG -o ${bname}.trimmed_P7.fastq ${bname}.trimmed_P5.fastq > trimP7_${bname}_log.txt
#       #trim 3' adaptor
# done


########################
# MAGeCK count
########################

# mkdir Count
# cd Count/


# mageck count -l ../Data/Annotations/${sgRNAfile} \
# -n "all" \
# --pdf-report \
# --norm "median" \
# --fastq `ls ../Data/Reads/*/*.fastq | tr '\n' ' '` \
# --sample-label ${samlabels}

# --control-sgrna ../Data/Annotations/negControl.txt \

#Note tr gets rid of the newline character at the end of each line of output
#and replaces with space


#################################
# Remove batch effect with 'sva'
#################################

# cd ..

# Rscript removeBatch.R Count/all.count_normalized.txt Data/Annotations/batchmatrix.txt


########################
# MAGeCK mle
########################

# mkdir mle
# cd mle/


# mageck mle -k all.count_normalized.txt \
# --design-matrix Data/Annotations/design_mat.txt \
# -n "Results" \
# --control-sgrna Data/Annotations/negControl.txt \
# --update-efficiency \
# --norm-method "none"


########################
# MAGeCK rra
########################

# mkdir ../rra
# cd rra/

# mageck test -k all.count_normalized_remove_batch.txt \
# -t EV21B1,EV21B2 \
# -c EV0B1,EV0B2 \
# -n "EVT0vsT21" \
# --norm-method "none" \
# --pdf-report \
# --normcounts-to-file \
# --gene-lfc-method "alphamedian" \
# --control-sgrna Data/Annotations/negControl.txt

# #--day0-label EV0
# #
# #-c EV0 \

# #--variance-from-all-samples \

# mageck test -k all.count_normalized_remove_batch.txt \
# -t SG1221B1,SG1221B2 \
# -c SG120B1,SG1221B2 \
# -n "SG12T0vsT21" \
# --norm-method "none" \
# --pdf-report \
# --normcounts-to-file \
# --gene-lfc-method "alphamedian" \
# --control-sgrna Data/Annotations/negControl.txt






