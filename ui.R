library(shiny)

default.content="I have a dream that one day on the red hills of Georgia, 
the sons of former slaves and the sons of former slave owners will be able to sit down 
together at the table of brotherhood. I have a dream that one day even the state 
of Mississippi, a state sweltering with the heat of injustice, sweltering with the heat 
of oppression, will be transformed into an oasis of freedom and justice. I have a dream that 
my four little children will one day live in a nation where they will not be judged by the 
color of their skin but by the content of their character."

selectInput("topic.number",label=h3("Number of topics:"),
                               choices=list("20"="20 topics","25"="25 topics","30"="30 topics","35"="35 topics",
                                            "40"="40 topics","45"="45 topics","50"="50 topics"),
                               selected="40 topics")

shinyUI(navbarPage("Topic Analysis of TSL articles",
                   tabPanel("Topic Keywords",
                            selectInput("topic.number",label=h3("Number of topics:"),
                                        choices=list("20"="20 topics","25"="25 topics","30"="30 topics","35"="35 topics",
                                                     "40"="40 topics","45"="45 topics","50"="50 topics"),
                                                     selected="40 topics"),
                            dataTableOutput('topic.table')
                            ),
                   
                   tabPanel("Source Articles",
                            textInput("article.id", h4("Article ID:"),"5000"),
                            dataTableOutput('article.table'), htmlOutput("article.page")
                            ),
                   
                   tabPanel("Analyze New Article",
                            h4("New article content:"),
                            tags$textarea(id="new.article", cols=40, default.content),
                            dataTableOutput('new.article.table')),
                   
                   tabPanel("Topic vs Time",
                            h4("Popularity of topic over time"),
                            textInput("graph.topic.id", h4("Topic ID:"),"1"),
                           plotOutput("topic.time.graph")
                   )
))

