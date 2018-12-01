library(shiny)
library(shinydashboard)
library(tdor)
#https://bhaskarvk.github.io/user2017.geodataviz/notebooks/03-Interactive-Maps.nb.html#using_rbokeh
#library(maps)
#library(rbokeh) 
#library(widgetframe) 
library(dplyr)
library(leaflet)
library(ggplot2)
library(ggthemes)


header <- dashboardHeader(
  
  title = "Trans Lives Matter"
  
)

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Trigger Warning", tabName = "triggerWarning", icon = icon("exclamation-triangle")),
    menuItem("Map",tabName="map",icon=icon("globe")),
    menuItem("Summaries",tabName="summaries",icon=icon("clipboard-list")),
    menuItem("How to Contribute", tabName = "contribute", icon = icon("hand-holding-heart"))
  )
)

body <- dashboardBody(
  tabItems(
    tabItem(tabName="triggerWarning",
            h1("TRIGGER WARNING: VIOLENCE. MURDER"),
            h4("This dashboard provides a way to interactively explore the data on killings
               and suicides of transgender people, as memorialized in the Transgender Day of Remembrance
               2007-2018."),
            h4("This data can be accessed via the R package tdor: https://github.com/CaRdiffR/tdor"),
            h4("More information can be found here: https://tdor.translivesmatter.info/")
    ),
    
    tabItem(tabName="map",
            
            selectInput("selectCountry", 
                        h3("Select country"), 
                        c("All",sort(unique(tdor$Country)))),
           HTML("<br>"),
           HTML("<br>"),
           HTML("<br>"),
            dateRangeInput("selectDate",h3("Select date range"),
                           start = min(tdor$Date), end = max(tdor$Date),
                           min = min(tdor$Date), max = max(tdor$Date)),
            #widgetframeOutput("plot1")
            #plotOutput("plot1")
            leafletOutput("map",height=500,width=750)
    ),
    
    tabItem(tabName="summaries",
            # from https://github.com/CaRdiffR/tdor/blob/master/vignettes/exploring_data_set.Rmd
            plotOutput("overTime"),
            plotOutput("byAge"),
            #plotOutput("byAge2"),
            plotOutput("top10"),
            plotOutput("animate")
    ),
    
    tabItem(tabName="contribute",
            h2("How to Contribute to This Dashboard"),
            h4("1. Fork the repository: https://github.com/rlgbtq/TDoR2018"),
            h4("2. Clone the fork to your workspace."),
            h4("3. Make changes to shinyDashboard/app.R"),
            h4("3a. Create a new menuItem in the sidebar function."),
            h4("3b. Create a new tabItem in the body function. Make sure tabName is
               equivalent to the tabName you specified in menuItem."),
            h4("3c. Add plots to server function."),
            h4("4. Submit a pull request."),
            h4("More guidance on shinydashboard here: https://rstudio.github.io/shinydashboard/"),
            h4("More guidance on GitHub logistics here: 
               https://help.github.com/articles/creating-a-pull-request-from-a-fork/"),
            h2("How to Contribute in Other Ways"),
            h4("Check out the issues here: https://github.com/rlgbtq/TDoR2018")
    ) ## end tabItem
    
  ) #end tabItems
) # dashboardBody

ui <- dashboardPage(
        header,
        sidebar,
        body,
        skin="red"
    
)

server <- function(input, output) { 
  

  #renderWidgetframe
  #renderPlot
  output$map <- renderLeaflet({
    if(input$selectCountry=="All"){
      data=tdor
      names(data)=gsub(" ",".",names(tdor))
      data=subset(data,Date >= input$selectDate[1] & Date <=input$selectDate[2])
      data$photoURL=paste("https://bytebucket.org/annajayne/tdor_data/raw/default/Data/TDoR%20",data$Year,"/photos/",data$Photo,sep="")
     
    }else{
      data=subset(tdor,Country==input$selectCountry)
      names(data)=gsub(" ",".",names(tdor))
      data=subset(data,Date >= input$selectDate[1] & Date <=input$selectDate[2])
      data$photoURL=paste("https://bytebucket.org/annajayne/tdor_data/raw/default/Data/TDoR%20",data$Year,"/photos/",data$Photo,sep="")
    }
   
    # plot <- suppressWarnings(
    #           figure(
    #                 width = 800, height = 450,
    #                 padding_factor = 0) %>%
    #                 ly_map("world", col = "gray") %>%
    #                 ly_points(Longitude, Latitude, data = data, size = 5,
    #                 hover = c(Name, Age,Date,Location,Cause.of.death )))
    # plot
    

    
    ## add images 
    ## https://github.com/CaRdiffR/tdor/issues/3
    
    
    p <- leaflet(data =data) %>% 
      addProviderTiles(providers$CartoDB.Positron) %>% 
      addMarkers(~Longitude, ~Latitude,
          popup=paste(
            "<a href = ",data$Permalink,">", data$Name,"</a> <br>",
                      "Age ", data$Age, "<br>",
                      data$Date, "<br>",
                      data$Location, "<br>",
                      data$Cause.of.death, "<br>",
                      "<img src = ",
                      data$photoURL,
                      " width=75% ",
                      ">", ## will display an icon if no photo
                      
                      sep="")
                                                                                          )
    p
    
    
  })
  
  output$overTime <- renderPlot({
    
    ggplot(tdor, aes(Year)) + geom_bar() +
      ggtitle("Deaths by year")
    
  })
  
  output$byAge <- renderPlot({
   tdor %>% 
      filter(Age_min > 0 & Age_max > 0) %>%
      ggplot(aes(x = (Age_min + Age_max)/2)) + 
      geom_bar() +
      ggtitle("Deaths by age") +
      labs(y = "Deaths")
  })

  output$byAge2<- renderPlot({
    tdor %>% 
      filter(Age_min > 0 & Age_max > 0) %>%
      ggplot(aes(x = (Age_min + Age_max)/2)) +
      geom_histogram(binwidth = 5) +
      ggtitle("Deaths by age") +
      labs(y = "Deaths")
  })
  
  output$top10 <- renderPlot({
    tdor %>%
      group_by(Country) %>%
      summarise(n = n()) %>%
      arrange(desc(n)) -> by_country
    ggplot(by_country[1:10,],
           aes(x = Country,
               y = n)) +
      theme_bw() +
      labs(y = "Deaths", x = "") +
      geom_bar(stat="identity") +
      theme(axis.text.x = element_text(angle=45, hjust=1)) +
      ggtitle("Ten countries with the most reported deaths")
    
  })
  
  
  
  } ## end server

shinyApp(ui, server) ## run the app

