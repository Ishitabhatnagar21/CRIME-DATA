library(shiny)
library(shinydashboard)
library(shinycssloaders)
library(plotly)
library(shinythemes)
fluidPage(theme = shinytheme("cosmo"))

dashboardPage(
  dashboardHeader(title = "CRIME REPORT OF US", titleWidth = 300 , 
                  tags$li(class="dropdown" ,tags$a(href="https://www.kaggle.com/datasets/marshallproject/crime-rates", icon("kaggle"), "Dataset" ,target="_blank")))
  
  
  
  
  
  #dashboardSidebar() creates a sidebar panel that contains a menu with items that link to different tabs within the dashboard.
  
  #The sidebarMenu() function is used to define the items within the menu and giving it an id "sidebar" to refer to the items using unique id.
  
  ,dashboardSidebar( 
    sidebarMenu( id="sidebar", # menuItem() function is used to specify the text, icon, and tab name for each item
                 menuItem(text="DATASET", tabName = "data", icon = icon("database")),
                 
                 menuItem(text="VISUALIZATION", tabName = "viz", icon=icon("chart-line")),
                 
                 #conditionalPanel() function is used to show or hide inputs or outputs based on the value of certain input elements.
                 #we use conditionPAnel to select a variable for the distribution plot, but only if they are currently on the "viz" tab and have selected the "Distribution" sub-tab.
                 #then selectInput will craete a drop down menu for me and i will store the input and choices c1 which are defined on server side
                 
                 conditionalPanel("input.sidebar == 'viz' && input.t2 == 'distro'", selectInput(inputId = "v1" , label ="Select the Variable" , choices = c1)),
                 
                 conditionalPanel("input.sidebar == 'viz' && input.t2 == 'trends' ", selectInput(inputId = "var2" , label ="Select the Arrest type" , choices = c1)
                                  
                 )))
  
  #dashboardBody
  ,dashboardBody(
    
    
    tabItems(
      tabItem( tabName = "data",
               tabBox(id="t1", width=70, 
                      tabPanel("About", icon=icon("address-card", size = "1"), 
                               fluidRow(
                                 column(width = 12),
                                 tags$br() ,
                                 h2(class = "text-center", icon("info-circle"),  "PRIME CRIME IN THE STATES",style = "text-indent: 5px; font-weight: bold;"),
                                 tags$br(),
                                 div(icon("bullseye"),style = "color: #3C8DBC; font-size: 20px; padding: 10px;",
                                     "Crime is a pervasive issue in society that affects everyone, from individuals to communities and entire nations. Whether it's theft, robbery, fraud, assault, or murder, crime comes in many forms and has many consequences. However, one thing is certain: crime doesn't pay."
                                 ),
                                 # p(icon("bullseye"),"The Marshall Project Crime Rates dataset provides statistics on arrests per 100,000 residents for assault, murder, and rape in each of the 50 US states.Additionally, the dataset includes information on the percentage of the population living in urban areas.\n The data was obtained from the Marshall Project, a non-profit news organization that covers criminal justice issues in the United States.",  style = list(textAlign = "justify", textIndent = "15px")),
                                 div(icon("bullseye"),style = "color: #3C8DBC; font-size: 20px; padding: 10px;",
                                     "The Marshall Project Crime Rates dataset provides statistics on arrests per 100,000 residents for assault, murder, and rape in each of the 50 US states. Additionally, the dataset includes information on the percentage of the population living in urban areas. The data was obtained from the Marshall Project, a non-profit news organization that covers criminal justice issues in the United States."
                                 ),
                                 div(icon("bullseye"),style = "color: #3C8DBC; font-size: 20px; padding: 10px;",
                                     "The data was obtained from the Marshall Project. For more information, visit the ", a("Marshall Project website", href = "https://www.themarshallproject.org/"), ".")
                               )
                      ),
                      
                      #tabPanel("Data", icon=icon("address-card"), dataTableOutput("dataT")),
                      tabPanel("Structure", icon=icon("address-card"), verbatimTextOutput("structure")),
                      tabPanel("Summary", icon=icon("address-card"),verbatimTextOutput("summary")))
      ),
      
      tabItem(tabName = "viz", 
              tabBox(id="t2",  width=12, 
                     tabPanel("Crime Trends by Cities", value="trends",
                              fluidRow(tags$div(align="center", box(tableOutput("top5"), title = textOutput("head1") , collapsible = TRUE, status = "primary",  collapsed = TRUE, solidHeader = TRUE)),
                                       tags$div(align="center", box(tableOutput("low5"), title = textOutput("head2") , collapsible = TRUE, status = "primary",  collapsed = TRUE, solidHeader = TRUE))
                                       
                              ),
                              # above tabPanel creates a panel within the tabBox with the name "Crime Trends by Cities" and is reffered by "trends" (which can be used to reference this panel 
                              #Inside the panel, there's a fluidRow with two boxes, each containing a tableOutput with an ID of "top5" or "low5", respectively. The boxes are collapsible, have a solid header, and are initially collapsed (hidden). 
                              # we use withSpinner function to pass bar variable to our plotlyoutput
                              
                              withSpinner(plotlyOutput("bar"))
                     ),
                     tabPanel("Distribution", value="distro", icon=icon("address-card"), withSpinner(plotlyOutput("histplot", height = "350px"))),
                     tabPanel("Correlation Matrix", id="corr" , withSpinner(plotlyOutput("cor")))
                     
              ),
             
      )
      
      
      
      
    ), 
    #tags$head(
    #tags$style(HTML(".content-wrapper {background-color: grey;}")))
  ))



