library(shiny)
library(shinydashboard)

header <- dashboardHeader(
  
  title = "Trans Lives Matter"
  
)

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Trigger Warning", tabName = "triggerWarning", icon = icon("exclamation-triangle")),
    menuItem("Widgets", tabName = "widgets", icon = icon("th"))
  )
)

body <- dashboardBody(
  tabItems(
    tabItem(tabName="triggerWarning",
            h1("TRIGGER WARNING: VIOLENCE. MURDER")
    ),
    
    tabItem(tabName="widgets",
            h2("Widgets tab content")
            
    )
  )
)

ui <- dashboardPage(
        header,
        sidebar,
        body
    
)

server <- function(input, output) { 
  
  set.seed(122)
  histdata <- rnorm(500)
  
  output$plot1 <- renderPlot({
    data <- histdata[seq_len(input$slider)]
    hist(data)
  })
  
  }

shinyApp(ui, server)
