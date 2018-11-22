library(shiny)
library(shinydashboard)

header <- dashboardHeader(
  
  title = "Trans Lives Matter"
  
)

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Trigger Warning", tabName = "triggerWarning", icon = icon("exclamation-triangle")),
    menuItem("How to Contribute", tabName = "contribute", icon = icon("hand-holding-heart"))
  )
)

body <- dashboardBody(
  tabItems(
    tabItem(tabName="triggerWarning",
            h1("TRIGGER WARNING: VIOLENCE. MURDER"),
            h4("This dashboard provides a way to interactively explore the data on killings and suicides of transgender people, as memorialized in the Transgender Day of Remembrance 2007-2018."),
            h4("This data can be accessed via the R package tdor: https://github.com/CaRdiffR/tdor"),
            h4("More information can be found here: https://tdor.translivesmatter.info/")
    ),
    
    tabItem(tabName="contribute",
            h2("How to Contribute to This Dashboard"),
            h4("1. Fork the repository: https://github.com/rlgbtq/TDoR2018"),
            h4("2. Clone the fork to your workspace."),
            h4("3. Make changes to shinyDashboard/app.R"),
            h4("3a. Create a new menuItem in the sidebar function."),
            h4("3b. Create a new tabItem in the body function. Make sure tabName is equivalent to the tabName you specified in menuItem."),
            h4("3c. Add plots to server function."),
            h4("4. Submit a pull request."),
            h4("More guidance on shinydashboard here: https://rstudio.github.io/shinydashboard/"),
            h4("More guidance on GitHub logistics here: https://help.github.com/articles/creating-a-pull-request-from-a-fork/"),
            h2("How to Contribute in Other Ways"),
            h4("Check out the issues here: https://github.com/rlgbtq/TDoR2018")
    )
  )
)

ui <- dashboardPage(
        header,
        sidebar,
        body,
        skin="red"
    
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
