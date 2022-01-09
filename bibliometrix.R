rms=ls()
rm(list=rms)
pacman::p_load(tidyverse,bibliometrix)
es.files<-c("scopus.bib")
bib_all<-convert2df(es.files,dbsource = "scopus",format = "bibtex")
authorProdOverTime(bib_all)
save.image("res.RData")
# Citiation analysis
biblioAnalysis(bib_all)->results
summary(results,k=10,pause=FALSE)

# Thematic analysis
thematicEvolution(bib_all,years = c(2004,2010,2016),repel = TRUE, stemming = TRUE)->themes_all

# Create a historical citation network
options(width=130)
histResults <- histNetwork(bib_all, min.citations = 1, sep = ";")
# Plot a historical co-citation network
hist_all<-histPlot(histResults,title_as_label = FALSE,labelsize = 4,size = 2,n = 20)
histResults <- histNetwork(bib_cabs, min.citations = 1, sep = ";")
# Plot a historical co-citation network
hist_cabs<-histPlot(histResults,title_as_label = FALSE,labelsize = 4,size = 2,n = 20)

# Conceptual structure
CS_all <- conceptualStructure(bib_all,field="ID", method="CA", minDegree=4, clust=4, stemming=FALSE, labelsize=8, documents=10)
CS_cabs <- conceptualStructure(bib_cabs,field="ID", method="CA", minDegree=4, clust=4, stemming=FALSE, labelsize=8, documents=10)

# Create keyword co-occurrences network
NetMatrix <- biblioNetwork(bib_all, analysis = "co-occurrences", network = "keywords", sep = ";")
# Plot the network
co_occur_all<-networkPlot(NetMatrix, normalize="association", weighted=T, n = 30, Title = "Keyword Co-occurrences", type = "fruchterman", size=T,edgesize = 5,labelsize=0.7)

# Create keyword co-occurrences network
NetMatrix <- biblioNetwork(bib_cabs, analysis = "co-occurrences", network = "keywords", sep = ";")
# Plot the network
co_occur_cabs<-networkPlot(NetMatrix, normalize="association", weighted=T, n = 30, Title = "Keyword Co-occurrences", type = "fruchterman", size=T,edgesize = 5,labelsize=0.7)


results_all <- biblioAnalysis(bib_all, sep = ";")
results_cabs<-biblioAnalysis(bib_cabs,sep=";")
results_csmath <- biblioAnalysis(bib_csmath, sep = ";")
results_efbm<-biblioAnalysis(bib_efbm,sep=";")
results_other<-biblioAnalysis(bib_other,sep=";")
summary(results_all,k=30,pause=FALSE)->all_sums
summary(results_cabs,k=20,pause=FALSE)->cabs_sums
summary(results_csmath,k=20,pause=FALSE)->csmath_sums
summary(results_efbm,k=20,pause=FALSE)->efbm_sums
summary(results_other,k=20,pause=FALSE)->other_sums

save.image("data/biblio_dat.RData")