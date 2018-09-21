#!/bin/bash

# Description: 	Runs the MAGeCK count on raw fastq files in a loop where each fastq file requires a different 
#               sgRNA annotation file.

#				The modules are as follows:
#               1. unzip the fastq files
#               2. Run cutadapt to trim the adapters
#				3. MAGeCK count - inuput: fastq files, output: count matrix. 
#			
#
#Author: Lucy Liu


#########################################################
# Arguments
#
# Change these arguments for each new project
#########################################################

# Directory path of file where the compressed fastq files are:

gzfastqfile="/Volumes/bioinf_pipeline/Runs/NextSeq/180917_NB501056_0192_AH3NYHBGX9/ProjectFolders/Project_Iva-Nikolic"

# Directory path of the file where you want the uncompressed fastq files to go -
# this location will be the 'working directory'

workdir="/Volumes/Users/Lucy/CRISPR/Iva20180921/"

# where the sgRNA annotation files are

sgRNAfiles=(Data/Annotations/sgRNAreformated/*)

# where the fastq files are

fastfiles=(*.trimmed_P7.fastq)

# # Sample labels, comma separated

# samlabels=""

#######################################
# Unzip fastq files to choosen directory
#######################################

# cd ${gzfastqfile}

# for file in $(ls */*.gz);

# do
#     echo ${file}
#     bname=$(basename ${file} .fastq.gz)
#     # get the base name of the file and also remove the '.fastq.gz' at the end
#     echo $bname
#     gzip -d -c ${file} > ${workdir}${bname}.fastq
#     # -decompress = unzip, send output to location as specified, add fastq to end of file name

# done

###############################
# Cutadapt to trim adapters
###############################
# Use 'cutadapt' to trim adaptors


cd ${workdir}
# Change to working directory


# module load cutadapt
# Use only if on cluster


# for file in $(ls *1.fastq);

# do
# 	echo ${file}
# 	bname=$(basename ${file} .fastq)
# 	echo $bname
#     cutadapt -g TGTGGAAAGGACGAAACACCG -o ${bname}.trimmed_P5.fastq ${file} > trimP5_${bname}_log.txt
#     #trim 5' adaptor
#     cutadapt -a GTTTTAGAGCTAGAAATAGCAAG -o ${bname}.trimmed_P7.fastq ${bname}.trimmed_P5.fastq > trimP7_${bname}_log.txt
#     #trim 3' adaptor

# done


########################
# MAGeCK count
########################

# mkdir Count
cd Count/

for i in 0 1 2 3 4 5; 

do
	bsgRNA=$(basename ${sgRNAfiles[i]} .txt)
	echo ${bsgRNA}
	mageck count -l ../${sgRNAfiles[i]} \
	-n ${bsgRNA} \
	--pdf-report \
	--norm "median" \
	--fastq ../${fastfiles[i]} \
	--sample-label ${bsgRNA}

done

# --control-sgrna ../Data/Annotations/negControl.txt \

#Note tr gets rid of the newline character at the end of each line of output
#and replaces with space









