
data <- read.csv("~/DAVIS/test.csv")

#Funtional Annotation Summary Page (for test data only)
FuntionalAnnotationSummaryPage <- function(data){
  ids <- data$AFFY_ID
  idsum <- c()
  for (n in 1:length(ids)) {
    if (n != length(ids)) { 
    idsum <- paste(idsum, ids[n], ",", sep = "")
    }
    if (n == length(ids)) {
    idsum <- paste(idsum, ids[n], sep = "")
    }
  }
  url <- paste("http://david.abcc.ncifcrf.gov/api.jsp?type=AFFYMETRIX_3PRIME_IVT_ID&ids=",idsum,"&tool=summary", sep="")
  BROWSE(url)
}

#FunctionalAnnotationTable
FunctionalAnnotationTable <- function(data){
  ids <- data$AFFY_ID
  idsum <- c()
  for (n in 1:length(ids)) {
    if (n != length(ids)) { 
      idsum <- paste(idsum, ids[n], ",", sep = "")
    }
    if (n == length(ids)) {
      idsum <- paste(idsum, ids[n], sep = "")
    }
  }
  url <- paste("http://david.abcc.ncifcrf.gov/api.jsp?type=AFFYMETRIX_3PRIME_IVT_ID&ids=",idsum,"&tool=annotationReport&annot=GOTERM_BP_FAT,GOTERM_CC_FAT,GOTERM_MF_FAT,INTERPRO,PIR_SUPERFAMILY,SMART,BBID,BIOCARTA,KEGG_PATHWAY,COG_ONTOLOGY,SP_PIR_KEYWORDS,UP_SEQ_FEATURE,GENETIC_ASSOCIATION_DB_DISEASE,OMIM_DISEASE", sep="")
  BROWSE(url)
}

#FunctionalAnnotationChart
FunctionalAnnotationChart <- function(data){
  ids <- data$AFFY_ID
  idsum <- c()
  for (n in 1:length(ids)) {
    if (n != length(ids)) { 
      idsum <- paste(idsum, ids[n], ",", sep = "")
    }
    if (n == length(ids)) {
      idsum <- paste(idsum, ids[n], sep = "")
    }
  }
  url <- paste("http://david.abcc.ncifcrf.gov/api.jsp?type=AFFYMETRIX_3PRIME_IVT_ID&ids=",idsum,"&tool=chartReport&annot=GOTERM_BP_FAT,GOTERM_CC_FAT,GOTERM_MF_FAT,INTERPRO,PIR_SUPERFAMILY,SMART,BBID,BIOCARTA,KEGG_PATHWAY,COG_ONTOLOGY,SP_PIR_KEYWORDS,UP_SEQ_FEATURE,GENETIC_ASSOCIATION_DB_DISEASE,OMIM_DISEASE", sep="")
  BROWSE(url)
}

#Functional Annotation Clustering
FunctionalAnnotationClustering <- function(data){
  ids <- data$AFFY_ID
  idsum <- c()
  for (n in 1:length(ids)) {
    if (n != length(ids)) { 
      idsum <- paste(idsum, ids[n], ",", sep = "")
    }
    if (n == length(ids)) {
      idsum <- paste(idsum, ids[n], sep = "")
    }
  }
  url <- paste("http://david.abcc.ncifcrf.gov/api.jsp?type=AFFYMETRIX_3PRIME_IVT_ID&ids=",idsum,"&tool=term2term&annot=GOTERM_BP_FAT,GOTERM_CC_FAT,GOTERM_MF_FAT,INTERPRO,PIR_SUPERFAMILY,SMART,BBID,BIOCARTA,KEGG_PATHWAY,COG_ONTOLOGY,SP_PIR_KEYWORDS,UP_SEQ_FEATURE,GENETIC_ASSOCIATION_DB_DISEASE,OMIM_DISEASE", sep="")
  BROWSE(url)
}

#Gene Full Report
GeneFullReport <- function(data){
  ids <- data$AFFY_ID
  idsum <- c()
  for (n in 1:length(ids)) {
    if (n != length(ids)) { 
      idsum <- paste(idsum, ids[n], ",", sep = "")
    }
    if (n == length(ids)) {
      idsum <- paste(idsum, ids[n], sep = "")
    }
  }
  url <- paste("http://david.abcc.ncifcrf.gov/api.jsp?type=AFFYMETRIX_3PRIME_IVT_ID&ids=",idsum,"&tool=geneReportFull", sep="")
  BROWSE(url)
}

#Gene Report
GeneReport <- function(data){
  ids <- data$AFFY_ID
  idsum <- c()
  for (n in 1:length(ids)) {
    if (n != length(ids)) { 
      idsum <- paste(idsum, ids[n], ",", sep = "")
    }
    if (n == length(ids)) {
      idsum <- paste(idsum, ids[n], sep = "")
    }
  }
  url <- paste("http://david.abcc.ncifcrf.gov/api.jsp?type=AFFYMETRIX_3PRIME_IVT_ID&ids=",idsum,"&tool=geneReport", sep="")
  BROWSE(url)
}


#Show Gene List Names in Batch

GeneListNamesInBatch <- function(data){
  ids <- data$AFFY_ID
  idsum <- c()
  for (n in 1:length(ids)) {
    if (n != length(ids)) { 
      idsum <- paste(idsum, ids[n], ",", sep = "")
    }
    if (n == length(ids)) {
      idsum <- paste(idsum, ids[n], sep = "")
    }
  }
  url <- paste("http://david.abcc.ncifcrf.gov/api.jsp?type=AFFYMETRIX_3PRIME_IVT_ID&ids=",idsum,"&tool=list", sep="")
  BROWSE(url)
}


#Gene Functional Classfication
GeneFunctionalClassification <- function(data){
  ids <- data$AFFY_ID
  idsum <- c()
  for (n in 1:length(ids)) {
    if (n != length(ids)) { 
      idsum <- paste(idsum, ids[n], ",", sep = "")
    }
    if (n == length(ids)) {
      idsum <- paste(idsum, ids[n], sep = "")
    }
  }
  url <- paste("http://david.abcc.ncifcrf.gov/api.jsp?type=AFFYMETRIX_3PRIME_IVT_ID&ids=",idsum,"&tool=gene2gene", sep="")
  BROWSE(url)
}
