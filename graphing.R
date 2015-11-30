authorGraph <- function(data, authName) {
  require(ggplot2)
  require(lubridate)
  require(dplyr)
  
  tempData <- filter(data, author_name == authName)
  tempData <- arrange(tempData, published_date)
  intrvl <- interval(tempData$published_date[1], tempData$published_date[nrow(tempData)])
  nmonths <- intrvl %/% months(1)
  nmonths
  ggplot(tempData, aes(x=published_date)) +
    geom_histogram(binwidth = nmonths)
  
  #notes: change y scale to be max 6 or 7, add title with author name, make x-axis more readable
}

filterData <- function(data, authName=NA, topic=NA, topicSig=1, before=NA, after=NA) {
  require(dplyr)
  require(lubridate)
  
  tempData = arrange(data, published_date)
  
  if(is.na(authName == FALSE)) {
    tempData = filter(tempData, author_name == authName)
  }
  else{}
  
  if(is.na(topic) == FALSE) {
    
  }
  
  if(is.na(before)==FALSE && is.na(after)==FALSE) {
    intrvl = interval(ymd(before), ymd(after))
    tempData = filter(tempData, published_date %within% intrvl)
  }
  else if(is.na(before)==FALSE) {
    intrvl = interval(tempData$published_date[1], ymd(before))
    tempData = filter(tempData, published_date %within% intrvl)
  }
  else if(is.na(after)==FALSE) {
    intrvl = interval(ymd(after), tempdData$published_date[nrow(tempData)])
    tempData = filter(tempData, published_date %within% intrvl)
  }
  else{}
  
  tempData
}

topicgraph <- function(data, topic, numTopics=1, timeRange=NA) {
  require(ggplot2)
  require(lubridate)
  
  if(timeRange != NA) {
    
  }
  else{}
  
  
}

#sub-function used to test for bigger filtering function
timeFilter <- function(data, before=NA, after=NA) {
  tempData = arrange(data, published_date)
  if(is.na(before)==FALSE && is.na(after)==FALSE) {
    intrvl = interval(ymd(before), ymd(after))
    tempData = filter(tempData, published_date %within% intrvl)
  }
  else if(is.na(before)==FALSE) {
    intrvl = interval(tempData$published_date[1], ymd(before))
    tempData = filter(tempData, published_date %within% intrvl)
  }
  else if(is.na(after)==FALSE) {
    intrvl = interval(ymd(after), tempdData$published_date[nrow(tempData)])
    tempData = filter(tempData, published_date %within% intrvl)
  }
  else{}
  
  tempData
}
