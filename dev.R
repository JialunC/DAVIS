# enrichrExample.R
# Boris, March 16 2016
# ==========================================================


# Enrichr result pages are ajax pages. In order to parse them,
# we need to figure out the correct calls to make. Unfortunately
# their help page does not contain enough information to do so.
# Therefore we need to reverse-engineer the API. The Chrome browser
# makes this relatively easy because in View -> Developer ->
# Developer Tools one can watch what POST and GET headers
# are sent for a call and what Response is received.
#
# Here is a working example for the result of this reverse
# engineering.
install.packages("jsonlite")
library(httr)
library(jsonlite)

baseURL <- "http://amp.pharm.mssm.edu/Enrichr"


testGeneSymbols <- c("Nsun3", "Polrmt", "Nlrx1", "Sfxn5",
                     "Zc3h12c", "Slc25a39", "Arsg", "Defb29",
                     "Ndufb6", "Zfand1", "Tmem77")


# ===== step 1: upload a Dataset and get its temporary ID

URL <- sprintf('%s%s', baseURL, "/addList")

addListResp <- POST(URL,
                    body = list(species = "HUMAN",
                                list = paste(testGeneSymbols, collapse="\n"),
                                description = "test"))


addListResp$status_code   # check for code 200 (OK)

# content is JSON in an HTML page. Parse out the JSON:
respHTML <- content(addListResp, as="text")
respHTML
m <- regexec('.*(\\{.*\\})', respHTML)
m
respJSON <- regmatches(respHTML, m)[[1]][2]
respJSON
# interpret the JSON
respIDs <- fromJSON(respJSON)
respIDs

# ===== step 2: use the list ID to get the enrichment information
#               first, the list of tables we can retrieve data for.

URL <- sprintf('%s%s%s', baseURL, "/enrich?dataset=", respIDs$shortId)

tablesResult <- GET(URL)
tablesResult
strsplit(content(tablesResult, as="text"), "\n")
tablesHTML <- unlist(strsplit(content(tablesResult, as="text"), "\n"))
tablesHTML
# parse out all available Background definitions
tableLines <- tablesHTML[grep("openResult\\(", tablesHTML)]
tableLines
m <- regexec("openResult\\('([^']+)", tableLines)
tableList <- regmatches(tableLines, m)
tableList
tableTypes <- character(length(tableList))
tableTypes
for (i in 1:length(tableList)) {
  tableTypes[i] <- tableList[[i]][2]
}

# ===== step 3. Iterate through the table types and extract results
#               into a dataframe

# In this example we use table number 26: "GO_Cellular_Component_2015"

tableTypes[25]

URL <- sprintf('%s/enrich?backgroundType=%s&userListId=%s',
               baseURL, tableTypes[25], respIDs$userListId)

JSONResult <- GET(URL)
JSONResult
resultList <- fromJSON(content(JSONResult, as="text"))
resultList
nRows <- length(resultList[[1]])
nRows
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

resultDF


# [END]

Sys.Date()
Sys.time()
