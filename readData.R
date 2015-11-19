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
  
  articles
}


