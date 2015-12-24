library(shiny)
source("dependencies.R")
source('helpers.R')
source("graphing.R")
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
                   tabPanel("About",
                            h2("About"),
                            p("This shiny app visualizes the result of Benji Lu, Kai Fukutaki,
                              and Ziqi Xiong's semester project for MATH154: Computational Statistics."),
                            p("We used ", a("Latent Dirichlet Allocation", href="https://en.wikipedia.org/wiki/Latent_Dirichlet_allocation"),
                              " model to analyze the content of 5000+
                              articles published by ",a("The Student Life",href="http://tsl.news"),
                            ". This gives us the popular topics (as distributions of words) among TSL articles and the
                            topic composition of each article, which makes it possible to answer questions such as: ",
                            tags$ul(tags$li("What is article 'Who Is the Happiest at the Happiest College in America?' about?"),
                               tags$li("How did the popularity of the topic about Divestment change over time?"),
                               tags$li("What topic does TSL editorial board care most about?"))),
                            p('You can click on the five tabs in the navigation bar to know more about our project:',
                              tags$ol(tags$li("Topic Keywords: This tab displays the key words of each topic and the labels
                                              we manually assigned to the topics based on their key words. You can choose a
                                              different number of topics using the drop down widget."),
                                      tags$li("Source articles: This tab takes the id of a TSL articles and returns the
                                              top 3 topics in that article. If you disable 'unsafe script blocking' in your
                                              browser address bar, you can also view the original content of the article."),
                                      tags$li("Analyze new article: This tab takes a new article from the textbox as input
                                              and returns the top 3 topics in the article along with their weight."),
                                      tags$li("Author Chart: This tab takes the name of a TSL writer from the text field as input
                                                        and returns the 5 topics that he/she writes most about."),
                                      tags$li("Topic vs Time: This tab takes the id of a topic from the text field as input
                                                        and returns frequency of that topic (the number of related articles) over time.")
                              )
                            )),
                   tabPanel("Topic Keywords",
                            selectInput("topic.number",label=h3("Number of topics:"),
                                        choices=list("20"="20 topics","25"="25 topics","30"="30 topics","35"="35 topics",
                                                     "40"="40 topics","45"="45 topics","50"="50 topics"),
                                                     selected="40 topics"),
                            dataTableOutput('topic.label'),
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
                   
                   tabPanel("Author Chart",
                            h4("Author Chart"),
                            textInput("author.name", h4("Author Name:"),"Editorial Board"),
                            ggvisOutput('a')
                            ),
                   
                   tabPanel("Topic vs Time",
                            h4("Popularity of topic over time"),
                            textInput("graph.topic.id", h4("Topic ID:"),"1"),
                            ggvisOutput("p")
                            )
                   

))

