##Remove batch effects from nomalised count data produced by MAGeCK count

args <- commandArgs(trailingOnly = TRUE)

library(sva)
#read in count matrix
edata <- read.delim(args[1], stringsAsFactors = FALSE)
genesgRNA <- edata[,1:2]

#read in batch and phenotype data
pheno <- read.delim(args[2], stringsAsFactors = FALSE)
rownames(pheno) <- pheno[,1]


#create batch vector
batch <- pheno[,2]

#make model matrix
mod <- model.matrix(~as.factor(condition), data=pheno)

#turn count df into matrix
edataMat <- as.matrix(edata[,3:ncol(edata)])
rownames(edataMat) <- edata[,1]

#logbase2 the counts
log_edataMat <- log2((edataMat+0.01))
#rownames(log_edataMat) <- edata[,1]
#sum(is.na(log_edataMat))


##Find which rows have a variance of 0
a <- which ((apply(log_edataMat, 1, var)==0) == "TRUE")

##Remove these rows from the matrix
noZero <- log_edataMat[-a,]

modcombat <- ComBat(dat=noZero, batch = batch, mod=mod)

##Put the 0 variance rows back in
modcombat_2 <- rbind(modcombat,log_edataMat[a,])

##Unlog the matrix
modRawCounts <- 2^modcombat_2


#Convert back to data frame
dfmod <- data.frame(modRawCounts)

#add the sgRNA names
dfmod$sgRNA <- rownames(dfmod)

#add gene names
dfmod <- merge(dfmod,genesgRNA, by = "sgRNA")
dfmod <- dfmod[,c(1,10,2:9)]

#Update column names
#newNames <- strsplit(colnames(dfmod),"\\.")

#newNames <- sapply(newNames, function(x) x[[1]])

#colnames(dfmod) <- newNames

write.table(dfmod, "allcount_normalized_remove_batch.txt", sep = "\t", col.names = TRUE, row.names = FALSE, quote = FALSE)
