require('tm')
require('topicmodels')
require('SnowballC')
source('readData.R')
articles <- readData()

#create the corpus
myReader <- readTabular(mapping=list(content="content",id="id"))
myCorpus<-VCorpus(DataframeSource(articles), readerControl=list(reader=myReader))
myCorpus <- tm_map(myCorpus, content_transformer(tolower))
myCorpus <- tm_map(myCorpus, removePunctuation)
myCorpus <- tm_map(myCorpus, removeWords, c(stopwords("english"),stopwords("SMART")))
myCorpus <- tm_map(myCorpus, stemDocument,lazy=TRUE)

dtm = DocumentTermMatrix(myCorpus) 
dtm <- removeSparseTerms(dtm, 0.99)

k <- 18
SEED <- 47
topic.model <- LDA(dtm,k,control=list(seed=SEED))

topic.result <- data.frame(topics(topic.model,5))



