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