#' fieldbook_analysisAddin
#'
#' Adds an addin to the addins menu and shows a view within RStudio.
#'
#' @param fieldbook a dataframe
#' @family addin
#'
#' @return string message
#' @export
fieldbook_analysisAddin <- function(fieldbook = NULL){

  if(is.null(fieldbook)){
    #print("no fieldbook passed in!")
  }
  hidap_fieldbook <- NULL

  ui <- miniUI::miniPage(
    miniUI::gadgetTitleBar("Fieldbook Analysis"),
    miniUI::miniTabstripPanel( selected = "Field Map",
                               miniUI::miniTabPanel("Parameters", icon = icon("list-alt"),
                                                    miniUI::miniContentPanel(padding = 0,
                                      #fieldbook_analysisInput("fb")
                                      #shiny::numericInput("fbaInput", "Fieldbook ID", 142, 1, 9999)
                                      uiOutput("fbList")
                                    )
                       ),
                       miniUI::miniTabPanel("Data", icon = icon("table"),
                                            miniUI::miniContentPanel(padding = 0,
                                      DT::dataTableOutput("hotFieldbook")
                                    )
                       ),
                       miniUI::miniTabPanel("Correlations", icon = icon("line-chart"),
                                            miniUI::miniContentPanel(padding = 0,
                                                                     uiOutput("fbCorrVarsUI"),
                                      qtlcharts::iplotCorr_output("vcor_output")
                                    )
                       )
                       ,


                       miniUI::miniTabPanel("Field Map", icon = icon("map-o"),
                                            miniUI::miniContentPanel(padding = 0,
                                      d3heatmap::d3heatmapOutput("fieldbook_heatmap")
                                      )
                       ),



                       miniUI::miniTabPanel("Fieldbook report", icon = icon("book"),
                                            miniUI::miniContentPanel(padding = 0
                                                     ,
                                                     uiOutput("aovVarsUI"),

                                                     radioButtons("aovFormat","Report format",
                                                                  c("HTML", "WORD", "PDF"),
                                                                  inline = TRUE),

                                                     actionButton("fbRepDo", "Create report!"),
                                                     HTML("<center>"),
                                                     uiOutput("fbRep"),
                                                     HTML("</center>")
                                    )
                       )
    )

  )

  ##################################

  server <- function(input, output, session) {
    values <- shiny::reactiveValues(crop = "sweetpotato", amode = "brapi")
    #brapi::locations(input, output, session)

    if(file.exists("brapi_session.rda")){
      load("brapi_session.rda")
    }

    brapps::fieldbook_analysis(input, output, session, values)

    observeEvent(input$done, {

      hidap_fieldbook <<- brapi::study_table(input$fbaInput)

      msg = c(
             #  "The fieldbook is available in your session",
             #  "through the variable:",
             #  "",
             # "'hidap_fieldbook' (see the metadata for details)!",
             # "",
             # attr(hidap_fieldbook, "meta")$studyName,
             # "",
             "Bye!"
      )


      stopApp(msg)
    })

    shiny::observeEvent(input$cancel, {
      stopApp("Bye!")
    })

  }

  viewer <- paneViewer(300)

  runGadget(ui, server, viewer = viewer)
}

