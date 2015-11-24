classifyNewArticle <- function(content,topic.model){
  new.article = data.frame(id=10000, content=content)
  myReader <- readTabular(mapping=list(content="content",id="id"))
  myCorpus<-VCorpus(DataframeSource(new.article), readerControl=list(reader=myReader))
  myCorpus <- tm_map(myCorpus, content_transformer(tolower))
  myCorpus <- tm_map(myCorpus, removePunctuation)
  myCorpus <- tm_map(myCorpus, removeWords, c(stopwords("english"),stopwords("SMART")))
  myCorpus <- tm_map(myCorpus, stemDocument,lazy=TRUE)
  dtm = DocumentTermMatrix(myCorpus) 
  topic.probs <- posterior(topic.model,dtm)$topics
  topic.probs
}

classifyResult <- function(content,topic.model){
  topic.probs <- classifyNewArticle(content,topic.model)
  topic.probs.table <- data.frame(Topic.ID=seq(1,length(topic.probs),1))
  topic.probs.table$Weight = as.numeric(t(topic.probs))
  topic.probs.table <- topic.probs.table[order(-topic.probs.table$Weight),]
  result = topic.probs.table[1:5,]
  result
}