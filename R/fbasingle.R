
#' fbasingle_ui
#'
#' @param title a text
#' @author Reinhard Simon
#'
#' @return shiny tag list
#' @export
fbasingle_ui <- function(title){
  tagList(
    h2(title),
    fluidRow(
      column(width = 12,
             box(width = NULL, collapsible = TRUE,
                 title = "Fieldbook",
                 uiOutput("fbList")
             )
      )
    )
    ,
    fluidRow(
      column(width = 12,
             tabBox(width = NULL, #selected = "Map",
                    id = "tabAnalysis",
                    tabPanel("Density",
                             uiOutput("phDensUI")
                             ,
                             div(id = "plot-container",
                                 plotOutput('phDens_output', height = 400)
                             )
                    ),
                    tabPanel("Correlation",
                             uiOutput("fbCorrVarsUI"),
                             #tags$img(src = "www/35.gif"),
                             #div(id = "plot-container",
                             qtlcharts::iplotCorr_output('vcor_output', height = 900)
                             #)
                    ),

                    tabPanel("Heatmap",
                             uiOutput("phHeatCorrVarsUI"),
                             d3heatmap::d3heatmapOutput('phHeat_output', height = 1400)
                    ),
                    tabPanel("Dendrogram",
                             uiOutput("phDendCorrVarsUI"),
                             plotOutput('phDend_output', height = 1400)
                    ),

                    tabPanel("Map",
                             d3heatmap::d3heatmapOutput("fieldbook_heatmap")
                    )
                    ,
                    tabPanel(title = "Report",

                             uiOutput("aovVarsUI"),

                             radioButtons("aovFormat","Report format",
                                          c("HTML", "WORD" #, "PDF"
                                          ),
                                          inline = TRUE),
                             radioButtons("expType", "Experiment type",
                                          c("RCBD", "ABD", "CRD", "A01D"), inline = TRUE),
                             conditionalPanel("input.expType == 'A01D'",
                                              selectInput("block", "BLOCK", c("BLOC", "BLOCK")),
                                              numericInput("k", "k", 2, 2, 5, step = 1)
                             ),

                             actionButton("fbRepoDo", "Create report!"),
                             HTML("<center>"),
                             uiOutput("fbRep"),
                             HTML("</center>")

                    )

             )
      )

    )
  )
}