#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#-------------------------------------------------------------------------
#  This application is governed by the CeCILL-B license. 
#  You can  use, modify and/ or redistribute this code under the terms
#  of the CeCILL license:  http://www.cecill.info/index.en.html
#
#  Marc Lavielle, Inria Saclay
#  April 29th, 2015
#-------------------------------------------------------------------------

library(shinydashboard)
library(dashboardthemes)
shinyDashboardThemes(
    theme = "blue_gradient"
)
sidebar <- dashboardSidebar(
    hr(),
    sidebarMenu(id="tabs",
                menuItem("Plot", tabName="plot", icon=icon("line-chart"), selected=TRUE),
                menuItem("Table", tabName = "table", icon=icon("table")),
                menuItem("Codes",  icon = icon("file-text-o"),
                         menuSubItem("Mlxtran", tabName = "pkmodel", icon = icon("angle-right")),
                         menuSubItem("ui.R", tabName = "ui", icon = icon("angle-right")),
                         menuSubItem("server.R", tabName = "server", icon = icon("angle-right"))
                ),
                menuItem("ReadMe", tabName = "readme", icon=icon("mortar-board")),
                menuItem("About", tabName = "about", icon = icon("question"))
    ),
    hr(),
    conditionalPanel("input.tabs=='plot'",
                     fluidRow(
                         column(1),
                         column(10,
                                checkboxInput("first", "First order", TRUE),
                                checkboxInput("zero", "Zero order", TRUE),
                                checkboxInput("al", "alpha order", FALSE),
                                checkboxInput("sequential", "Sequential (0-1)", FALSE),
                                checkboxInput("mixed", "Simultaneous (0-1)", FALSE),
                                checkboxInput("saturated", "Saturated", FALSE),
                                checkboxInput("legend", "Legend", TRUE)
                         )
                     )
    )
)

dashboardPage(
    dashboardHeader(title = "Absorption processes"),
    sidebar,
    dashboardBody()
)