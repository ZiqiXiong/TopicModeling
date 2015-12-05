source('dependencies.R')
source('helpers.R')
articles <- readData()

trash <- c('rsquo10','rsquo11','ldquoi','ldquoth','rsquo12','ldquow','rsquo13','ldquoit',
            'collegersquo','donrsquot','ldquoitrsquo','yearrsquo','itrsquo','irsquom',
            'ldquoi','yoursquor','thatrsquo','didnrsquot','canrsquot','doesnrsquot',
            'irsquov','wersquor','therersquo','theyrsquor','dont','people','your','ive','thing',
           'lot', 'didnt')
#create the corpus
myReader <- readTabular(mapping=list(content="content",id="id"))
myCorpus<-VCorpus(DataframeSource(articles), readerControl=list(reader=myReader))
myCorpus <- tm_map(myCorpus, content_transformer(tolower))
myCorpus <- tm_map(myCorpus, removePunctuation)
myCorpus <- tm_map(myCorpus, removeWords, c(stopwords("english"),stopwords("SMART"),trash))
myCorpus <- tm_map(myCorpus, stemDocument,lazy=TRUE)

dtm = DocumentTermMatrix(myCorpus) 
dtm <- removeSparseTerms(dtm, 0.99)
ks <- c(20,25,30,35,40,45,50)

for(k in ks){
  SEED <- 47
  topic.model <- LDA(dtm,k,control=list(seed=SEED))
  save(topic.model,file=paste(k,"topics"))
}




