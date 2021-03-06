#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinyjs)
library(raster)
library(leaflet)
library(DT)




ui <- fluidPage(
  shinyjs::useShinyjs(),


  navbarPage(
    "Global Sampling Grid",
    id = "nav",

    tabPanel(
      "Interactive map",
      value = "gomap",

      div(
        class = "outer",
        tags$head(# Include our custom CSS
          includeCSS("styles.css")
          ),

        leafletOutput("map", height = "100%", width = "100%")
      )
    ),

    tabPanel("Data Explorer",
             DT::dataTableOutput('mytable')),


    tabPanel("Generate/ download GSG",

             div(id = "settings",
                 fluidRow(
                   column(4,
                          wellPanel(
                     # Inputs
                     h4("GSG Area"),

                     # Select country code
                     selectInput(
                       "country_code",
                       "Select countries",
                       c("World", raster::ccodes()[, 1]),
                       c("world", raster::ccodes()[, 2]),
                       multiple = TRUE
                     ),

                     # Input administrative level
                     selectInput(
                       "adm_level",
                       "Administrative level",
                       c(
                         "Level 0" = "0",
                         "Level 1" = "1",
                         "Level 2" = "2"
                       )
                     ),

                     radioButtons(
                       inputId = 'inputformat',
                       label = 'Upload specific aoi as shapefile (epsg:4326) or KML',
                       choices = c('Shapefile' = 'shp', 'KML' = 'kml'),
                       inline = TRUE
                     ),

                     # File input for aoi
                     fileInput(
                       "aoi",
                       "For .shp upload select the .shp, .prj, .shx and .dbf file simultaneously!",
                       accept = c('.shp', '.dbf', '.sbn', '.sbx', '.shx', ".prj", ".kml"),
                       multiple = TRUE
                     )
                   )),

                   column(4,
                          wellPanel(
                            h4("GSG settings"),
                     # grid distance in km
                     numericInput("dist", "Grid distance:", 250),

                     # Cluster generation
                     numericInput("clusterpoints", "Points per cluster", 4),

                     # Cluster configuration
                     selectInput(
                       "configuration",
                       "Cluster configuration",
                       c(
                         "Line" = "line",
                         "L-shape" = "lshape",
                         "Square" = "square"
                       )
                     ),

                     # point distance
                     sliderInput(
                       "pointdist",
                       "Point distance:",
                       min = 0,
                       max = 500,
                       value = 70
                     ),

                     # Button "generate"
                     actionButton("reset_input", "Reset inputs"),
                     actionButton("go", "Generate")
                   )),

                   column(4,
                          wellPanel(
                     h4("Download GSG"),
                     textOutput("text1"),
                     selectInput(
                       "format",
                       "Select output format:",
                       c("ESRI Shapefile" = "shp",
                         "KML" = "kml")
                     ),

                     # Button "download"
                     downloadButton("download", "Download")

                   ))
                 )),
             #
             plotOutput("se_plot", width = 450)
             )
  )
)