readData <- function(){
  require('dplyr')
  
  #read data from raw csv file
  articles <- read.csv("articles.csv")
  articles <- articles %>% filter(published==1)
  articles <- articles[,c(1,2,3,7,12)]
  
  #format the data
  articles$title <- as.character(articles$title)
  articles$content <- as.character(articles$content)
  articles$id <- as.numeric(articles$id)
  articles$published_date <- as.Date(articles$published_date,format = "%Y-%m-%d %H:%M:%S")
  
  #get rid of html tag
  cleanFun <- function(htmlString) {
    return(gsub("<.*?>", "", htmlString))
  }
  articles$content <- unlist(lapply(articles$content,cleanFun))
  
  #get rid of short articles
  wordCount <- function(str){
    sapply(strsplit(str, " "), length)
  }
  articles <- articles[wordCount(articles$content)>50,]
  
  #link authors to their articles
  profile.article <- read.csv('profile_article.csv')[,c(2,3)]
  profiles <- read.csv('profiles.csv')[,c(1,3)]
  names(profiles) <- c('profile_id', 'author_name')
  profile.article <- left_join(profile.article,profiles,by="profile_id")
  names(profile.article)[1] <- 'id'
  articles <- left_join(articles,profile.article, by="id")
  articles <- articles[!duplicated(articles$id),]
  articles
}

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

toNumber <- function(str){
  x <- unlist(regmatches(str, gregexpr('\\(?[0-9,.]+', str)))
  x <- as.numeric(x)
  x
}

get.articles.topics <- function(topic.model,topic.num){
  article.topics = data.frame(t(data.frame(topics(topic.model,topic.num))))
  article.topics$id = rownames(article.topics)
  rownames(article.topics) = c()
  article.topics$id <- as.integer(sapply(article.topics$id,toNumber))
  article.topics
}

get.article.topic <- function(topic.model,article.id){
  article.topics <- get.articles.topics(topic.model,3)
  topics <- article.topics %>% dplyr::filter(id==article.id)
  topics <- topics %>% select(-id)
  names(topics) <- c("1st","2nd","3rd")
  topics
}

get.topic.terms <- function(topic.model, term.num){
  topic.terms = terms(topic.model,term.num)
}

join.articles.with.topics <- function(articles,topic.model,topic.num){
  articles.topics <- get.articles.topics(topic.model,topic.num)
  dplyr::inner_join(articles,articles.topics,by="id")
}



