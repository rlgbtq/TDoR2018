library(shiny)
library(shinydashboard)

header <- dashboardHeader(
  
  title = "Trans Lives Matter"
  
)

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
    menuItem("Widgets", tabName = "widgets", icon = icon("th"))
  )
)

body <- dashboardBody(
  tabItems(
    tabItem(tabName="dashboard",
            fluidRow(
              box(plotOutput("plot1",height=250)),
              box(
                title = "Controls",
                sliderInput("slider","Number of observations:",1,100,50)
              )
            )
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
