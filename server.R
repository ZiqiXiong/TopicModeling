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
shinyServer(function(input, output) {
  
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
  
  output$topic.time.graph <- renderPlot({
    topicgraph(joined.articles(),input$graph.topic.id,3,7)
  })
  
  
  
  
  
})