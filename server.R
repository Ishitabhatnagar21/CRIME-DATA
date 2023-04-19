library(DT)
library(shinycssloaders)
library(ggplot2)
library(ggtext)
library(ggcorrplot)
library(maps)

function(input, output,session)
{
  output$structure <- renderPrint(dataset1 %>% str())
  output$summary <- renderPrint(dataset1 %>% summary())
 # output$dataT <- renderDataTable(dataset1)
  #stacked histogram and  boxplot
  
  #first creating histogram and boxplot 
  #rendering histogram - histplot that we have passed in UI as an element
  
  output$histplot <- renderPlotly({
    #getting input v1 which gets selected from the choices and is passed from UI and the same gets printed on xaxis via layout method.
    p1 <- dataset1 %>% plot_ly() %>% add_histogram(x = ~get(input$v1)) %>% 
      layout(xaxis = list(title=input$v1))
    #rendering boxplot 
    p2 <- dataset1 %>% plot_ly() %>%  add_boxplot(x=~get(input$v1))%>%layout(yaxis = list(showticklabels = F))
    
    #stacking plot over each other
    subplot(p2 , p1, nrows=2, shareX=TRUE) %>%
      hide_legend() %>% 
      layout(title="Distribution chart - Histogram and Boxplot" , yaxis = list(title="Frequency") )
  })
  
  
  ### Bar Charts - State wise trend
  ## it renders a barchart according to the input or the type of crime selected by user
  output$bar <- renderPlotly({
    dataset1 %>% 
      plot_ly() %>% 
      add_bars(x=~agency_jurisdiction, y=~get(input$var2) )%>% #add_bars() is used to add the bar chart to the plot_ly()
      layout(title = paste("City-wise Arrests for", input$var2),
             xaxis = list(title = "City"),
             yaxis = list(title = paste(input$var2, "Arrests per 100,000 residents") ))
  })
  ## Correlation plot
  output$cor <- renderPlotly({
    my_df <- dataset1 %>% 
      select( crimes_percapita, homicides_percapita, rapes_percapita    
              , assaults_percapita,  robberies_percapita )
    
    # Compute a correlation matrix
    corr <- round(cor(my_df), 1)
    
    # Computing a matrix of correlation p-values
    p.mat <- cor_pmat(my_df)
    
    corr.plot <- ggcorrplot(
      corr, 
      hc.order = TRUE, 
      lab= TRUE,
      outline.col = "white",
      p.mat = p.mat
    )
    
    ggplotly(corr.plot)
    
  })
  
  
  output$head1 <- renderText(
    paste("5 cities with high rate of", input$var2, "Arrests"))
  
  # Rendering the box header 
  output$head2 <- renderText(paste("5 cities with low rate of", input$var2, "Arrests"))
  
  
  # Rendering table with 5 states with high arrests for specific crime type
  output$top5 <- renderTable({
    dataset1 %>% 
      select(agency_jurisdiction, input$var2) %>% 
      arrange(desc(get(input$var2))) %>% 
      distinct(agency_jurisdiction) %>%
      head(5)
    
  })
  
  # Rendering table with 5 cities with low arrests for specific crime type 
  #using select query , arrange function which by default takes ascending order unlesss specified , and then rendering 5 distinct agency jurisdoctions
  output$low5 <- renderTable({
    
    dataset1 %>% 
      select(agency_jurisdiction, input$var2) %>% 
      arrange(get(input$var2)) %>% 
      distinct(agency_jurisdiction) %>%
      head(5)
    
    
    
  })
  
  
  
  
  
  
  
}

