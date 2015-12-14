library(shiny)
source("dependencies.R")
source('helpers.R')
source("graphing.R")

#load all the topic objects
topic.file.names <- c("20 topics","25 topics","30 topics","35 topics","40 topics",
                      "45 topics","50 topics")
topic.objects <- list()
for (topic.file.name in topic.file.names){
  load(topic.file.name)
  topic.objects[[topic.file.name]] <- topic.model
}
remove(topic.model)

#load articles
articles <- readData()
getPage<-function(article.id) {
  return(tags$iframe(src=paste("http://tsl.news/article/",article.id,sep=''),
                  style="width:100%;",  frameborder="0"
                     ,id="iframe"
                     , height = "500px"))
}


# Define server logic required to draw a histogram
shinyServer(function(input, output,session) {
  
  tooltipFunc <- function(x) {
      if (is.null(x)) return(NULL)
      else {
        articles = filterData(joined.articles(),topic=input$graph.topic.id,topicSig=2)
        index = articles$title; value = articles$published_date
        strwrap(
          paste(index[ (value >= convertSecondsToDate(x$xmin_) ) 
                       & (value <= convertSecondsToDate(x$xmax_))
                       ],
                collapse=', '),
          width = 60)
      }
  }
  
  
  tooltipFunc2 <- function(x) {
    if (is.null(x)) return(NULL)
    else {
      works = filterData(joined.articles(),topic=x$label,authName=input$author.name,topicSig=2)
      titles = works$title
      strwrap(paste(titles,collapse=', '),width = 60)
    }
  }

  
  # Expression that generates a histogram. The expression is
  # wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should re-execute automatically
  #     when inputs change
  #  2) Its output type is a plot
  
  joined.articles <- reactive({
    topic.number <- input$topic.number
    joined.articles = join.articles.with.topics(articles,topic.objects[[topic.number]],3)
    joined.articles
  })
 
  output$test.table <- renderDataTable({
    joined.articles.with.topic  
  })
  
  output$topic.table <- renderDataTable({
    topic.number <- input$topic.number
    get.topic.terms(topic.objects[[topic.number]],20)
  },options = list(pageLength = 10))
  
  output$article.page <- renderUI({
    article.id <- input$article.id
    getPage(article.id)
  })
  
  output$article.table <- renderDataTable({
    topic.num <- input$topic.number
    get.article.topic(topic.objects[[topic.num]],input$article.id)
  })
  
  output$new.article.table <- renderDataTable({
    topic.number <- input$topic.number
    content <- input$new.article
    classifyResult(content,topic.objects[[topic.number]])
  })
  
  
  reactive({
    authorChart(joined.articles(),input$author.name,2) %>%
      add_tooltip(tooltipFunc2, 'hover') 
      
  }) %>% bind_shiny("a")  
  
  reactive({
    topicgraph2(joined.articles(),input$graph.topic.id,2,7) %>%
      add_tooltip(tooltipFunc, 'hover') %>%
    set_options(width = 1000, height = 550)
  }) %>% bind_shiny("p")
  
  
})