#' locationsAddin
#'
#' Displays a dialog view in RStudio and is accessible via the Addins menu.
#'
#' @return string status
#' @family addin
#' @export
locationsAddin <- function(){
  ui <- miniUI::miniPage(
    miniUI::gadgetTitleBar("Locations"),
    miniUI::miniTabstripPanel( selected = "Map",
        miniUI::miniTabPanel("Data", icon = icon("table"),
           miniUI::miniContentPanel(
          #locationsUI("locations")
          p(class = 'text-center', shiny::downloadButton('locsDL', 'Download Filtered Data')),
          DT::dataTableOutput("tableLocs")
        )
      ),
      miniUI::miniTabPanel("Map", icon = icon("map-o"),
                           miniUI::miniContentPanel(padding = 0,
                                    leaflet::leafletOutput("mapLocs", height = "100%")
                   )
      ),
      miniUI::miniTabPanel("Histogram", icon = icon("bar-chart"),
                           miniUI::miniContentPanel(padding = 0,
                                    shiny::plotOutput("histogram")
                   )
      ),
      miniUI::miniTabPanel("Single site info", icon = icon("info"),
                           miniUI::miniContentPanel(padding = 0,
                                    shiny::htmlOutput("siteInfo")
                   )
      ),
      miniUI::miniTabPanel("Site group report", icon = icon("book"),
                           miniUI::miniContentPanel(padding = 0,
                                    shiny::htmlOutput("rep_loc")
                   )
      ),
      miniUI::miniTabPanel("Trial per site", icon = icon("info"),
                           miniUI::miniContentPanel(padding = 0,
                                    shiny::htmlOutput("site_fieldtrials")
                   )
      ),
      miniUI::miniTabPanel("Genotypes per site", icon = icon("info"),
                           miniUI::miniContentPanel(padding = 0,
                                    htmlOutput("site_genotypes")
                   )
      )
      # ,
      # miniUI::miniTabPanel("Site scatter chart", icon = icon("line-chart"),
      #                      miniUI::miniContentPanel(padding = 0,
      #                               shiny::uiOutput("sitesScatter")
      #              )
      # )
    )

  )

  ##################################

  server <- function(input, output, session) {
    values <- shiny::reactiveValues(crop = "sweetpotato", mode = "brapi")

    fp = file.path(fbglobal::get_base_dir("brapi"), "brapi_session.rda")
    if(file.exists(fp)){
      #load("brapi_session.rda")
      brapi <<- readRDS(fp)

    } else (
      stopApp(msg)
    )

    locations(input, output, session, values)
    #brapi_locations <<- locs

    shiny::observeEvent(input$done, {

      stopApp("Bye!")
    })

    shiny::observeEvent(input$cancel, {
      stopApp("Bye!")
    })

  }

  viewer <- shiny::paneViewer(300)

  shiny::runGadget(ui, server, viewer = viewer)


}
