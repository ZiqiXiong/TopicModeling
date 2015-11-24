library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel(h1("Topic Analysis of TSL articles")),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      selectInput("topic.number",label=h3("Number of topics:"),
                  choices=list("20"="20 topics","25"="25 topics","30"="30 topics","35"="35 topics",
                               "40"="40 topics","45"="45 topics","50"="50 topics"),
                  selected="40 topics")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      dataTableOutput('topic.table')
    )
  )
))