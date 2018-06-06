
source("../R/librerias.R")
source("funciones.R")


# Cargamos los datos
load("../datos/historico_cuentas.RData")
load("../datos/historico_seguidores.RData")
load("../datos/historico_tweets.RData")
load("../datos/historico_menciones.RData")  

# Limpiamos los datos quitando las columnas que son listsa
historico.tweets <- historico.tweets %>% select(-ends_with("coords")) %>% 
                                         select(-c(hashtags:mentions_screen_name))


historico.menciones <- historico.menciones %>% select(-ends_with("coords")) %>% 
                                               select(-c(hashtags:mentions_screen_name))

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
                    
                    box(title = "Número de tweets", plotOutput("temp", height = 300), 
                        width = 6),
                    
                    box(title = "Número de ", plotOutput("rain", height = 300),
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
                  
                    mainPanel(
                            navbarPage(
                            id = 'Tabla',
                            title = 'Datos disponibles',
                            tabPanel('Información Cuentas',     DT::dataTableOutput('tb1')),
                            tabPanel('Información Tweets',      DT::dataTableOutput('tb2')),
                            tabPanel('Información Menciones',   DT::dataTableOutput('tb3')),
                            tabPanel('Información Seguidores',  DT::dataTableOutput('tb4'))
                            )
                      )
                    
                    
)
pagina.3 <- tabItem("readme", 
                    mainPanel(
                        id = 'Ta',
                        title = 'Datos dgfdisponibles',
                        tabPanel('Información gfhCuentas',      DT::dataTableOutput('a'))
                  
                    )
)
# Cuerpo ----
# ·······························································································
body <- dashboardBody(
    tabItems(
          pagina.1, 
          pagina.2,
          pagina.3
    )
) 
# Ejecucion ----
# ·······························································································
dashboardPage(
    dashboardHeader(title = "Mi perfil de Twitter"),
    sidebar,
    body
)