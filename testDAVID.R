# testDavid.R
# Boris
# 

# After reading the notes on the DAVID Website, it's clear that
# the proper way to use DAVID is after registering, via the
# DAVID Webservice.
# Details here: 
# https://david.ncifcrf.gov/content.jsp?file=DAVID_WebService.html

# 1. Register with your eMail address

# 2. Documentation for the RDAVIDWebService package is in this document:
# http://bioinformatics.oxfordjournals.org/content/29/21/2810.abstract

# 3. Install the package:
# https://www.bioconductor.org/packages/release/bioc/html/RDAVIDWebService.html

source("https://bioconductor.org/biocLite.R")
biocLite("RDAVIDWebService")         # ...a bit over 110 Mb
browseVignettes("RDAVIDWebService")  # loads the vignette in your browser


EMAIL <- "<your-email-address-here>"

# 4. The url has changed and is no longer the default in the packages...
URL <- "https://david.ncifcrf.gov/webservice/services/DAVIDWebService.DAVIDWebServiceHttpSoap12Endpoint/"

# 5. Then you need to install a Java version > 1.8 and a security
# certificate. Cf.
#   https://support.bioconductor.org/p/70090/
#
# The process is ridiculously involved, but I have followed
# the steps and it worked - mostly. It required downloading
# and compiling a new version of openssl from source. (Incidentally
# if you do this on the Mac, there is an error in the script.)
# It also required installing a newer Java version over an older
# one while keeping the older one alive, reconfiguring the dll
# paths for Java and several other surgical interventions.
#
# I consider this a broken process overall
# and I can't recommend DAVID for general use, or 
# incorporation into the critical path of our workflow at
# this time.
#
# But I did get it to work in the end:


library("RDAVIDWebService")
davidService <- DAVIDWebService$new(email=EMAIL,
                                    url=URL)

testData <- read.csv("test.csv") # The dataset you had sent me:
                                 # affymetrix IDs
head(testData)

serverResponse <- addList(davidService, testData$AFFY_ID,
                          idType="AFFYMETRIX_3PRIME_IVT_ID",
                          listName="testData",
                          listType="Gene")                                 

davidService
# DAVIDWebService object to access DAVID's website. 
# User email:  ... 
# Available Gene List/s:  
      # Name Using
# 1 testData     *
# Available Specie/s:  
               # Name Using
# 1 Homo sapiens(190)     *
# Available Background List/s:  
          # Name Using
# 1 Homo sapiens     *

testTermCluster <- getClusterReport(davidService, type="Term")
head(summary(testTermCluster))
  # Cluster Enrichment Members
# 1       1   2.558328      17
# 2       2   2.119114      22
# 3       3   2.010314       5
# 4       4   1.723711       4
# 5       5   1.706646       4
# 6       6   1.703885       9

plot2D(testTermCluster, 1)

# ... etc.

# [END]


