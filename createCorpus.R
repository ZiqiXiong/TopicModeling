require('tm')
require('SnowballC')
source('readData.R')
articles <- readData()
#create the corpus
myCorpus<-Corpus(VectorSource(articles$content))
myCorpus <- tm_map(myCorpus, PlainTextDocument)
myCorpus <- tm_map(myCorpus, content_transformer(tolower))
myCorpus <- tm_map(myCorpus, removePunctuation)
myCorpus <- tm_map(myCorpus, removeWords, c(stopwords("english"),stopwords("SMART")))
myCorpus <- tm_map(myCorpus, stemDocument,lazy=TRUE)

dtm = DocumentTermMatrix(myCorpus) 
dtm <- removeSparseTerms(dtm, 0.99)
dtm = as.matrix(notSparse)
rowTotals <- apply(dtm , 1, sum)
dtm <- dtm[rowTotals> 0, ] 
#frequency = colSums(a)
#frequency <- sort(frequency, decreasing=TRUE)
#head(frequency)

require('topicmodels')
k <- 30
SEED <- 47
topic.model <- LDA(dtm,k,control=list(seed=SEED))





