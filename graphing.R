authorGraph <- function(data, authName) {
  tempData <- filter(data, author_name == authName)
  tempData <- arrange(tempData, published_date)
  intrvl <- interval(tempData$published_date[1], tempData$published_date[nrow(tempData)])
  nmonths <- intrvl %/% months(1)
  ggplot(tempData, aes(x=published_date)) +
    geom_histogram(binwidth = nmonths)
  
  #notes: change y scale to be max 6 or 7, add title with author name, make x-axis more readable
}

filterData <- function(data, authName=NA, topic=NA, topicSig=1, before=NA, after=NA) {
  tempData = arrange(data, published_date)
  
  if(!is.na(authName)) {
    tempData = filter(tempData, author_name == authName)
  }
  
  if(!is.na(topic)) {
    if(topicSig==1){
      tempData = filter(tempData, X1 == topic)
    }
    else if(topicSig==2) {
      tempData = filter(tempData, X1 == topic | X2 == topic)
    }
    else{
      tempData = filter(tempData, X1 == topic | X2 == topic | X3 == topic)
    }
  }
  
  if(!is.na(before) && !is.na(after)) {
    intrvl = interval(ymd(before), ymd(after))
    tempData = filter(tempData, published_date %within% intrvl)
  }
  else if(!is.na(before)) {
    intrvl = interval(tempData$published_date[1], ymd(before))
    tempData = filter(tempData, published_date %within% intrvl)
  }
  else if(!is.na(after)) {
    intrvl = interval(ymd(after), tempdData$published_date[nrow(tempData)])
    tempData = filter(tempData, published_date %within% intrvl)
  }
  
  tempData
}

topicgraph <- function(data, topic, topic.sig, divide="m") {
  tempData <- filterData(data, topic=topic,topicSig =topic.sig)
  intrvl <- interval(data$published_date[1], data$published_date[nrow(data)])
  if(divide=="m") {
    nbins <- intrvl %/% months(1)
  }
  else if(divide=="w") {
    nbins <- intrvl %/% weeks(1)
  }
  else if(divide=="d") {
    nbins <- intrvl %/% days(1)
  }
  else{
    nbins <- intrvl %/% years(1)
  }
  
  ggplot(tempData, aes(x=published_date)) +
    geom_histogram(binwidth = nbins)
}

#sub-function used to test for bigger filtering function
timeFilter <- function(data, before=NA, after=NA) {
  tempData = arrange(data, published_date)
  if(!is.na(before) && !is.na(after)) {
    intrvl = interval(ymd(before), ymd(after))
    tempData = filter(tempData, published_date %within% intrvl)
  }
  else if(!is.na(before)) {
    intrvl = interval(tempData$published_date[1], ymd(before))
    tempData = filter(tempData, published_date %within% intrvl)
  }
  else if(!is.na(after)) {
    intrvl = interval(ymd(after), tempdData$published_date[nrow(tempData)])
    tempData = filter(tempData, published_date %within% intrvl)
  }
  
  tempData
}
