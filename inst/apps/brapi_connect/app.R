#library(shiny)
library(brapi)
library(brapps)

ui <- fixedPage(
      brapiConnectInput("brapi")
)

server <- function(input, output, session) {
  callModule(brapiConnect, "BrAPI DB")
}

shinyApp(ui, server)
