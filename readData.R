readData <- function(file.name="articles.csv"){
  
  #read data from raw csv file
  articles <- read.csv(file.name)
  articles <- articles[,c(1,2,3,7)]
  
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
  
  
  
  articles
}


