if (!require(httr, quietly=TRUE)) { 
  install.packages("jsonlite")
  library(jsonlite)
}

if (!require(httr, quietly=TRUE)) { 
  install.packages("httr")
  library(httr)
}

if (!require(httr, quietly=TRUE)) { 
  install.packages("ggplot2")
  library(ggplot2)
}
#======= parameter

baseURL <- "http://amp.pharm.mssm.edu/Enrichr"
URL <- sprintf('%s%s', baseURL, "/addList")
featuregeneset <- c("2","6","10","11","12","25","26","27","55","57")

#===== test 

input <- c("Nsun3", "Polrmt", "Nlrx1", "Sfxn5",
           "Zc3h12c", "Slc25a39", "Arsg", "Defb29",
           "Ndufb6", "Zfand1", "Tmem77")
# ===== get ID
getID <- function(input){
  addListResp <- POST(URL,
                      body = list(species = "HUMAN",
                                  list = paste(input, collapse="\n"),
                                  description = "test"))
  if (addListResp$status_code == 200) {
    message("Response OK")}
  else {
    message("No response")}
  respHTML <- content(addListResp, as="text")
  m <- regexec('.*(\\{.*\\})', respHTML)
  respJSON <- regmatches(respHTML, m)[[1]][2]
  respIDs <- fromJSON(respJSON)
}

#======= upload gene list as a string

ReturnLibrary <- function(input){
  # ===== get IDs
  addListResp <- POST(URL,
                      body = list(species = "HUMAN",
                                  list = paste(input, collapse="\n"),
                                  description = "test"))
  if (addListResp$status_code == 200) {
    message("Response OK")}
  else {
    message("No response")}
  respHTML <- content(addListResp, as="text")
  m <- regexec('.*(\\{.*\\})', respHTML)
  respJSON <- regmatches(respHTML, m)[[1]][2]
  respIDs <- fromJSON(respJSON)
  
  # ==== submit form
  
  URL_library <- sprintf('%s%s%s', baseURL, "/enrich?dataset=", respIDs$shortId)
  tablesResult <- GET(URL_library)
  if (tablesResult$status_code == 200) {
    message("Libraries Response OK")}
  else {
    message("No response")}
  strsplit(content(tablesResult, as="text"), "\n")
  tablesHTML <- unlist(strsplit(content(tablesResult, as="text"), "\n"))
  tableLines <- tablesHTML[grep("openResult\\(", tablesHTML)]
  m <- regexec("openResult\\('([^']+)", tableLines)
  tableList <- regmatches(tableLines, m)
  libraries <- data.frame()
  libraries <- data.frame(ID=numeric(length(tableList)), 
                          Geneset=character(length(tableList)), 
                          stringsAsFactors=FALSE)
  for (i in 1:length(tableList)) {
    libraries$ID[i] <- i
    libraries$Geneset[i] <- tableList[[i]][2]
  }
  message("Select Gene-set library using function: Analyze(input,x), where x is the corresponding library in the geneset libraries")
  save(libraries, file ="libraries.Rda")
  return(libraries)
}

# ===== test 

ReturnLibrary(input)
libraries$Geneset[libraries$ID == 3]

# ===== Analyze function

Analyze <- function(input, x, y) {
  load("~/DAVIS/libraries.Rda")
  type <- libraries$Geneset[libraries$ID == x]
  addListResp <- POST(URL,
                      body = list(species = "HUMAN",
                                  list = paste(input, collapse="\n"),
                                  description = "test"))
  if (addListResp$status_code == 200) {
    message("Response OK")}
  else {
    message("No response")}
  respHTML <- content(addListResp, as="text")
  m <- regexec('.*(\\{.*\\})', respHTML)
  respJSON <- regmatches(respHTML, m)[[1]][2]
  respIDs <- fromJSON(respJSON)
  URL_analysis <- sprintf('%s/enrich?backgroundType=%s&userListId=%s',
                          baseURL, type, respIDs$userListId)
  JSONResult <- GET(URL_analysis)
  resultList <- fromJSON(content(JSONResult, as="text"))
  nRows <- length(resultList[[1]])
  resultDF <- data.frame(name=character(nRows),
                         genes=character(nRows),
                         P=numeric(nRows),
                         Z=numeric(nRows),
                         score=numeric(nRows),
                         stringsAsFactors=FALSE)
  for (i in 1:nRows) {
    resultDF$name[i]  <- resultList[1][[1]][[i]][[2]]
    resultDF$genes[i] <- paste(resultList[1][[1]][[i]][[6]], collapse=" ")
    resultDF$P[i]     <- resultList[1][[1]][[i]][[3]]
    resultDF$Z[i]     <- resultList[1][[1]][[i]][[4]]
    resultDF$score[i] <- resultList[1][[1]][[i]][[5]]
  }
  date <- Sys.Date()
  filename <- paste(date, "_", y, "_", type, ".Rda", sep = "")
  save(resultDF, file = filename)

}

# ===== Test Analyze

Analyze(input, 55, "Feb")

# ===== Featured Geneset and analysis 
 
# ======= TRANSFAC_and_JASPAR_PWMs[2] --- rank top 20 - need to select human
# ======= ENCODE_TF_ChIP-seq_2015[6] --- rank top20
# ======= KEGG_2015[10]  --- rank top 20
# ======= WikiPathways_2015[11] --- rank top 20
# ======= Reactome_2015[12] --- rank top 20
# ======= GO_Biological_Process_2015[25] --- rank top 20
# ======= GO_Cellular_Component_2015[26] --- rank top20
# ======= GO_Molecular_Function_2015[27] --- rank top20
# ======= Chromosome_Location[57] --- 
# ======= Tissue_Protein_Expression_from_Human_Proteome[55] ---rank top20

GetFeature <- function(input, y){
  load("~/DAVIS/libraries.Rda")
  for (x in featuregeneset){
  type <- libraries$Geneset[libraries$ID == x]
  addListResp <- POST(URL,
                      body = list(species = "HUMAN",
                                  list = paste(input, collapse="\n"),
                                  description = "test"))
  if (addListResp$status_code == 200) {
    message("Response OK")}
  else {
    message("No response")}
  respHTML <- content(addListResp, as="text")
  m <- regexec('.*(\\{.*\\})', respHTML)
  respJSON <- regmatches(respHTML, m)[[1]][2]
  respIDs <- fromJSON(respJSON)
  URL_analysis <- sprintf('%s/enrich?backgroundType=%s&userListId=%s',
                          baseURL, type, respIDs$userListId)
  JSONResult <- GET(URL_analysis)
  resultList <- fromJSON(content(JSONResult, as="text"))
  nRows <- length(resultList[[1]])
  resultDF <- data.frame(name=character(nRows),
                         genes=character(nRows),
                         P=numeric(nRows),
                         Z=numeric(nRows),
                         score=numeric(nRows),
                         stringsAsFactors=FALSE)
  for (i in 1:nRows) {
    resultDF$name[i]  <- resultList[1][[1]][[i]][[2]]
    resultDF$genes[i] <- paste(resultList[1][[1]][[i]][[6]], collapse=" ")
    resultDF$P[i]     <- resultList[1][[1]][[i]][[3]]
    resultDF$Z[i]     <- resultList[1][[1]][[i]][[4]]
    resultDF$score[i] <- resultList[1][[1]][[i]][[5]]
  }
  date <- Sys.Date()
  filename <- paste(date, "_", y,"_ft", "_", type, ".Rda", sep = "")
  save(resultDF, file = filename)}
}

# ==== Test

GetFeature(input, "mar")


# =================TRANSFAC
type <- libraries$Geneset[libraries$ID == 2]
addListResp <- POST(URL,
                    body = list(species = "HUMAN",
                                list = paste(input, collapse="\n"),
                                description = "test"))

respHTML <- content(addListResp, as="text")
m <- regexec('.*(\\{.*\\})', respHTML)
respJSON <- regmatches(respHTML, m)[[1]][2]
respIDs <- fromJSON(respJSON)
URL_analysis <- sprintf('%s/enrich?backgroundType=%s&userListId=%s',
                        baseURL, type, respIDs$userListId)
JSONResult <- GET(URL_analysis)
resultList <- fromJSON(content(JSONResult, as="text"))
nRows <- length(resultList[[1]])
resultDF <- data.frame(name=character(nRows),
                       genes=character(nRows),
                       P=numeric(nRows),
                       Z=numeric(nRows),
                       score=numeric(nRows),
                       stringsAsFactors=FALSE)
for (i in 1:nRows) { #only store the top10 ranked by combined scores
  resultDF$name[i]  <- resultList[1][[1]][[i]][[2]]
  resultDF$genes[i] <- paste(resultList[1][[1]][[i]][[6]], collapse=" ")
  resultDF$P[i]     <- resultList[1][[1]][[i]][[3]]
  resultDF$Z[i]     <- resultList[1][[1]][[i]][[4]]
  resultDF$score[i] <- resultList[1][[1]][[i]][[5]]
}
load("~/DAVIS/2016-03-29_testv1_TRANSFAC_and_JASPAR_PWMs.Rda")
resultDF <- resultDF[grep("human",resultDF$name),]
resultDF
resultDF <- resultDF[1:3,]
