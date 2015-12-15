authorGraph <- function(data, authName) {
  tempData <- filter(data, author_name == authName)
  tempData <- arrange(tempData, published_date)
  intrvl <- interval(tempData$published_date[1], tempData$published_date[nrow(tempData)])
  nmonths <- intrvl %/% months(1)
  ggplot(tempData, aes(x=published_date)) +
    geom_histogram(binwidth = nmonths)
  
  #notes: change y scale to be max 6 or 7, add title with author name, make x-axis more readable
}

filterData <- function(tempData, authName=NA, topic=NA, topicSig=1, before=NA, after=NA) {
  if(!is.na(authName)) {
    tempData = dplyr::filter(tempData, author_name == authName)
  }
  
  if(!is.na(topic)) {
    if(topicSig==1){
      tempData = dplyr::filter(tempData, X1 == topic)
    }
    else if(topicSig==2) {
      tempData = dplyr::filter(tempData, X1 == topic | X2 == topic)
    }
    else{
      tempData = dplyr::filter(tempData, X1 == topic | X2 == topic | X3 == topic)
    }
  }
  
  if(!is.na(before) && !is.na(after)) {
    intrvl = interval(ymd(before), ymd(after))
    tempData = dplyr::filter(tempData, published_date %within% intrvl)
  }
  else if(!is.na(before)) {
    intrvl = interval(min(data$published_date), ymd(before))
    tempData = dplyr::filter(tempData, published_date %within% intrvl)
  }
  else if(!is.na(after)) {
    intrvl = interval(ymd(after), max(data$published_date))
    tempData = dplyr::filter(tempData, published_date %within% intrvl)
  }
  
  tempData
}

topicgraph <- function(data, topic, topic.sig, divide) {
  tempData <- filterData(data, topic=topic,topicSig =topic.sig)
  intrvl <- c(min(tempData$published_date), max(tempData$published_date))

  
  ggplot(tempData, aes(x=published_date)) +
    geom_histogram(binwidth=divide,fill="#119CF9")+
    scale_x_date(breaks="2 months",
                 labels=date_format("%Y-%b"),
                 limits=c(intrvl[1],intrvl[2])) +
    ylab("Frequency") + xlab("Year and Month") +
    theme_bw() + theme(text=element_text(size=40),axis.text.x=element_text(angle=90,size=25)) 
}

topicgraph2 <- function(data, topic, topic.sig=1, divide=7){
  tempData <- filterData(data, topic=topic,topicSig =topic.sig)
  date_grid = seq(as.Date('2009/3/1'), as.Date('2016/1/1'), "months")
  tempData %>% ggvis(~published_date) %>% 
    layer_histograms(width=divide,fill:="119CF9",stroke :="119CF9") %>% add_axis("x",ticks=length(date_grid), grid=FALSE,
              properties=axis_props(labels=list(angle=90, fontSize = 8, align="left"))) 
}

authorChart2 <- function(articles, author, topic.sig){
  works = dplyr::filter(articles,author_name==author)
  works.by.topic = authorChartHelper(works,topic.sig)
  ggplot(works.by.topic,aes(x=label,y=value))+geom_bar(stat='identity',aes(fill=label)) +
    ylab("Frequency") + xlab("Topics") + theme(text = element_text(size=40))
}

authorChart <- function(articles, author, topic.sig){
  works = dplyr::filter(articles,author_name==author)
  works.by.topic = authorChartHelper(works,topic.sig)
  works.by.topic %>% ggvis(~label,~value) %>% layer_bars(fill=~label) %>%
    add_axis("x", title = "Topics",grid=FALSE) %>%
    add_axis("y", title = "Frequency")
}

authorChartHelper <- function(works,topic.sig){
  if(topic.sig==3){
    topic.freq = c(works$X1,works$X2,works$X3);
  }else if(topic.sig==2){
    topic.freq = c(works$X1,works$X2);
  }else{
    topic.freq = c(works$X1);
  }
  topic.freq = data.frame(table(topic.freq))
  if (nrow(topic.freq)==0){
    topic.freq = data.frame(label=0,value=0)
    topic.freq$label= as.character(topic.freq$label)
    topic.freq
  }else{
    names(topic.freq) = c('label','value')
    topic.freq$label= as.character(topic.freq$label)
    topic.freq$value= as.numeric(topic.freq$value )
    sum.freq = sum(topic.freq$value)
    topic.perc = topic.freq$value/sum.freq
    topic.freq = dplyr::filter(topic.freq,topic.perc>0.05) %>% dplyr::arrange(value) 
    topic.freq
  }
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



