
library(shinydashboard)
library(dashboardthemes)
library(tidyverse)
# Barra lateral ----
# ·······························································································
sidebar <- dashboardSidebar(
    hr(),
    sidebarMenu(#id = "tabs",
                menuItem("Visualisation", icon = icon("line-chart"),  tabName = "Visualisation",  selected=TRUE),
                menuItem("Data",         icon = icon("table"),       tabName = "Data"),
                menuItem("Codes",         icon = icon("file-text-o"),
                         menuSubItem("Mlxtran",  tabName = "pkmodel", icon = icon("angle-right")),
                         menuSubItem("ui.R",     tabName = "ui",      icon = icon("angle-right")),
                         menuSubItem("server.R", tabName = "server",  icon = icon("angle-right"))
                ),
                menuItem("ReadMe", tabName = "readme", icon = icon("mortar-board")),
                menuItem("About",  tabName = "about",  icon = icon("question"))
    ),
    hr(),
    conditionalPanel("input.tabs == 'plot'",
                     fluidRow(
                         column(1),
                         column(10,
                                checkboxInput("first",      "First order",        TRUE),
                                checkboxInput("zero",       "Zero order",         TRUE),
                                checkboxInput("al",         "alpha order",        FALSE),
                                checkboxInput("sequential", "Sequential (0-1)",   FALSE),
                                checkboxInput("mixed",      "Simultaneous (0-1)", FALSE),
                                checkboxInput("saturated",  "Saturated",          FALSE),
                                checkboxInput("legend",     "Legend",             TRUE)
                         )
                     )
    )
)



# Pagina 1 ----
# ·······························································································
pagina.1 <- tabItem("Visualisation", 
                    
                # Primera fila
                fluidRow(
                    
                    box(title = "Temperature over the last month", plotOutput("temp", height = 300), 
                        width = 6),
                    
                    box(title = "Daily rainfall over the last month", plotOutput("rain", height = 300),
                        width = 6)
                    
                ),
                
                # Second Row
                fluidRow(
                    
                    valueBoxOutput("maxTemp"),
                    
                    valueBoxOutput("minTemp"), 
                    
                    valueBoxOutput("averageRainfall")
                    
                )
            
)


# Pagina 2 ----
# ······························································································· 
pagina.2 <- tabItem("Data", 
                  
                    sidebarLayout(
                        sidebarPanel( width = 3,
                            conditionalPanel(
                            'input.Tabla === "Usuarios"',
                            checkboxGroupInput(inputId  = "show_usuarios", 
                                               label    = "Columnas disponibles:",
                                               choices  = names(diamonds), 
                                               selected = names(diamonds))
                            ),
                            conditionalPanel(
                                'input.Tabla === "Tweets"',
                                checkboxGroupInput(inputId  = "show_tweets", 
                                                   label    = "Columnas disponibles:",
                                                   choices  = names(diamonds), 
                                                   selected = names(diamonds)),
                                helpText("Display 5 records by default.")
                            ),
                            conditionalPanel(
                                'input.Tabla === "Menciones"',
                                helpText("Display 5 records by default.")
                            )
                        ),
                    
                        mainPanel(
                            navbarPage(
                            id = 'Tabla',
                            title = 'DataTable Options',
                            tabPanel('Usuarios',     DT::dataTableOutput('ex1')),
                            tabPanel('Tweets',        DT::dataTableOutput('ex2')),
                            tabPanel('Menciones',      DT::dataTableOutput('ex3')),
                            tabPanel('Seguidores',       DT::dataTableOutput('ex4'))
                            )
                        )
                      )
                    
                    
)

# Cuerpo ----
# ·······························································································
body <- dashboardBody(
    tabItems(
          pagina.1, 
          pagina.2
    )
) 
# Ejecucion ----
# ·······························································································
dashboardPage(
    dashboardHeader(title = "Mi perfil de Twitter"),
    sidebar,
    body
)