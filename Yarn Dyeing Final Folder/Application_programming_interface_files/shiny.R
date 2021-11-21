library(shiny)
library(randomForest)
library(readxl)
library(ggplot2)

# define a function to deal with user input
format_conv <- function(V0,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14){
  user_input <- read_excel("new data.xlsx")
  user_input[,'DyestuffUsage'] <- V0
  user_input[,'Dyeing_Ratio'] <- V1
  user_input[,'Dye_Weight'] <- V2

  lV3 <-  c("N123","N124","N125","N127","N128","N129","N130","N131","N132","N133","N134","N210","N211","N212","N213","N214","N215","N216","N219","N220","N221","N222","N223","N224","N308","N309","N310","N409","N414","N415","N416","N511","N512","N513","N514","N515","N516","N517","N518","N519","N520","N521","N522","N523","N524","N525","N605","N606","N607","N608","N610","N611",'other')
  if(V3 %in% lV3 ){
    V3n <- paste("Machine_Name_",V3,sep = "")
    user_input[,V3n] <- 1
  }
  
  lV4 <-  c('1',"11","12",'24','27','30',"302","308",'335','344','351','403','47','49','5','61','7','8','9','dongmf','fangzf','haoxl','liushj','LUOHAIF','other','xiexianf','zengbo','zhaoyp','0')
  if(V4 %in% lV4 ){
    V4n <- paste("Colorist_",V4,sep = "")
    user_input[,V4n] <- 1
  }
  
  lV5 <-  c('1','0')
  if(V5 %in% lV5 ){
    V5n <- paste("Is_Repair_",V5,sep = "")
    user_input[,V5n] <- 1
  }
  
  lV6 <-  c("VL","RW",'WH','BG','BK','BL','BR','GN','GY','KK','NY','OR','PK','RD','YW','TQ','WHNY','YW','0')
  if(V6 %in% lV6 ){
    V6n <- paste("ColorOnly_",V6,sep = "")
    user_input[,V6n] <- 1
  }
  
  lV7 <-  c("1","2",'3','4a','4b','5','6a','6b','7a','7b')
  if(V7 %in% lV7 ){
    V7n <- paste("Remark_label_",V7,sep = "")
    user_input[,V7n] <- 1
  }
  
  lV8 <- c("Sanban",'Baiban','0')
  if(V8 %in% lV8 ){
    V8n <- paste("Colorist_Type_",V8,sep = "")
    user_input[,V8n] <- 1
  }
  
  lV9 <-c("zhenzhi",'suozhi','0')
  if(V9 %in% lV9 ){
    V9n <- paste("Fabric_",V9,sep = "")
    user_input[,V9n] <- 1
  }
  
  lV10 <-  c('1202','1204','1209','1211','1215','1221','1227','1229','1301','1308','1313','1429','1502','1504','1715','1727','1741','1801','1802','1804','1815','1821','1827','1829','1901','1902','1904','1908','1915','1929','4008','4041','4141','other','0')
  if(V10 %in% lV10 ){
    V10n <- paste("Pre_Art_No_",V10,sep = "")
    user_input[,V10n] <- 1
  }
  
  lV11 <-  c('2339','2340','2401','2402','2412','2501','2502','2503','2504','2506','2507','2512','2517','2601','2602','2604','2612','2703','2704','2802','other','0')
  if(V11 %in% lV11 ){
    V11n <- paste("Dye_Art_No_",V11,sep = "")
    user_input[,V11n] <- 1
  }
  
  lV12 <-  c('3011','3012','3013','3014','3015','3016','3017','3018','3034','3036','3043','3049','3211','3212','3213','3216','3234','3249','3302','3402','3403','3514','3515','3518','3617','3618','3621','3622','3623','3805','other','0')
  if(V12 %in% lV12 ){
    V12n <- paste("After_Art_No_",V12,sep = "")
    user_input[,V12n] <- 1
  }
  
  lV13 <-  c('3001','3002','3003','3004','3006','3007','3008','3101','3102','3103','3104','0')
  if(V13 %in% lV13 ){
    V13n <- paste("Fix_Art_No_",V13,sep = "")
    user_input[,V13n] <- 1
  }
  
  user_input <- as.matrix(user_input)
  
  return(user_input)
}

# define a function to calculate the range of time
result_pred <- function(V0,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15){
  user_input <- format_conv(V0,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14)
  
  if (V15 == "Yes") {
    bst <-  readRDS("mymodel.rds")
    time_pred <- predict(bst,newdata = user_input)
    time <- paste('The predicted time is :',round(time_pred,2),'min',sep = ' ')
    
    res <- read_excel('mymodel_residuals.xlsx')$residuals
    log_res <- read_excel('mymodel_log_residuals.xlsx')$residuals
    new_res <- res - mean(res)
  } else if (V15 == "No") {
    # To be updated!
    bst <- readRDS("mymodel_v2.rds")
    time_pred <- predict(bst,newdata = user_input)
    time <- paste('The predicted time is :',round(time_pred,2),'min',sep = ' ')
    
    res <- read_excel('mymodel_residuals_v2.xlsx')$residuals
    log_res <- read_excel('mymodel_log_residuals_v2.xlsx')$residuals
    new_res <- res - mean(res)
  }
  
  time_dist <- log_res + log(time_pred)
  time_dist <- exp(time_dist)
  #time_dist <- data.frame(time_dist)
  
  thirty_up <- round((time_pred + 30),2)
  thirty_low <- round(max((time_pred - 30),0),2)
  
  sixty_up <- round(time_pred + 60,2)
  sixty_low <- round(max((time_pred - 60),0),2)
  
  ninety_up <- round(time_pred + 90,2)
  ninety_low <- round(max(time_pred - 90,0),2)
  
  range <- ''
  if(V14 == "60min" ){
    range = paste('The probability of time within','[',thirty_low, ',' ,thirty_up,'] is :',round(length(time_dist[time_dist<thirty_up&time_dist>thirty_low])/length(time_dist)*100,2),'%')
  }
  
  if(V14 == "120min" ){
    range = paste('The probability of time within','[',sixty_low, ',' ,sixty_up,'] :',round(length(time_dist[time_dist<sixty_up&time_dist>sixty_low])/length(time_dist)*100,2),'%')
  }
  
  if(V14 == "180min" ){
    range = paste('The probability of time within','[',ninety_low, ',',ninety_up,'] :',round(length(time_dist[time_dist<ninety_up&time_dist>ninety_low])/length(time_dist)*100,2),'%')
  }
  
  time_dist <- data.frame(time_dist)

  output <- list(time=time,range=range,dist=time_dist)
  
  return(output)
  
}




ui <- fluidPage(
  
  tags$style(type="text/css",
             ".shiny-output-error { visibility: hidden; }",
             ".shiny-output-error:before { visibility: hidden; }"
  ),
  
  tags$head(
    # Note the wrapping of the string in HTML()
    tags$style(HTML("
      html,body,.container-fluid,.row{
        height:100%;
        overflow:hidden;
      }
      .col-sm-4{
        height: calc(100% - 30px);
        overflow: auto;
      }"))
  ),
  
  # App title ----
  titlePanel("Yarn Dyeing Time Prediction"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Text for providing a caption ----
      # Note: Changes made to the caption in the textInput control
      # are updated in the output area immediately as you type
      
      # Input: Numeric entry for number of DyestuffUsagew ----
      numericInput(inputId = "V0",
                   label = "DyestuffUsage",
                   value = 0),
      
      # Input: Numeric entry for number of Dyeing_Rati ----
      numericInput(inputId = "V1",
                   label = "Dyeing_Ratio",
                   value = 0),
      
      # Input: Numeric entry for number of Dye_Weight ----
      numericInput(inputId = "V2",
                   label = "Dye_Weight",
                   value = 0),
      
      # Input: Selector for choosing machine name ----
      selectInput(inputId = "V3",
                  label = "Choose a machine name:",
                  choices = c("N123","N124","N125","N127","N128","N129","N130","N131","N132","N133","N134","N210","N211","N212","N213","N214","N215","N216","N219","N220","N221","N222","N223","N224","N308","N309","N310","N409","N414","N415","N416","N511","N512","N513","N514","N515","N516","N517","N518","N519","N520","N521","N522","N523","N524","N525","N605","N606","N607","N608","N610","N611",'other')),
      
      # Input: Selector for choosing machine name ----
      selectInput(inputId = "V4",
                  label = "Choose a colorist:",
                  choices = c('1',"11","12",'24','27','30',"302","308",'335','344','351','403','47','49','5','61','7','8','9','dongmf','fangzf','haoxl','liushj','LUOHAIF','other','xiexianf','zengbo','zhaoyp','0')),
      
      # Input: Selector for whether is  repaired or not ----
      selectInput(inputId = "V5",
                  label = "whether is  repaired or not:",
                  choices = c("1","0")),
      
      # Input: Selector for choosing the color ----
      selectInput(inputId = "V6",
                  label = "Select the color:",
                  choices = c("VL","RW",'WH','BG','BK','BL','BR','GN','GY','KK','NY','OR','PK','RD','YW','TQ','WHNY','YW','0')),
      
      # Input: Selector for choosing the remark label ----
      selectInput(inputId = "V7",
                  label = "Select the remark label:",
                  choices = c("1","2",'3','4a','4b','5','6a','6b','7a','7b')),
      
      # Input: Selector for choosing the colorist type ----
      selectInput(inputId = "V8",
                  label = "Select the colorist type:",
                  choices = c("Sanban",'Baiban','0')),
      
      # Input: Selector for choosing the fabric type ----
      selectInput(inputId = 'V9',
                  label = "Select the fabric type:",
                  choices = c("zhenzhi",'suozhi','0')),
      
      # Input: Selector for choosing pre art number ----
      selectInput(inputId = "V10",
                  label = "Choose a pre_art number:",
                  choices = c('1202','1204','1209','1211','1215','1221','1227','1229','1301','1308','1313','1429','1502','1504','1715','1727','1741','1801','1802','1804','1815','1821','1827','1829','1901','1902','1904','1908','1915','1929','4008','4041','4141','other','0')),
      
      # Input: Selector for choosing dye art number ----
      selectInput(inputId = "V11",
                  label = "Choose a dye_art number:",
                  choices = c('2339','2340','2401','2402','2412','2501','2502','2503','2504','2506','2507','2512','2517','2601','2602','2604','2612','2703','2704','2802','other','0')),
      
      # Input: Selector for choosing after art number ----
      selectInput(inputId = "V12",
                  label = "Choose a after_art number:",
                  choices = c('3011','3012','3013','3014','3015','3016','3017','3018','3034','3036','3043','3049','3211','3212','3213','3216','3234','3249','3302','3402','3403','3514','3515','3518','3617','3618','3621','3622','3623','3805','other','0')),
      
      selectInput(inputId = "V13",
                  label = "Choose a fix_art number:",
                  choices = c('3001','3002','3003','3004','3006','3007','3008','3101','3102','3103','3104','0')),
      
      # Input: Selector for time range ----
      selectInput(inputId = "V14",
                  label = "Choose a time range:",
                  choices = c("60min", "120min", "180min")),
      
      
      p("*Please notice that larger interval brings higher possibility but  less practical importance."),
      
      radioButtons("V15", "Whether add sample time to the total time",
                   c("Yes", "No")),
      
      actionButton("goButton","Confirm",class = "btn-primary")
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: predicted value range ----
      textOutput("value"),
      # Output: predicted error range ----
      textOutput("range"),
      hr(),
      plotOutput("plot", width = 500, height = 500)
      
    )
  )
)

server <- function(input,output) {
  results <-reactiveValues()
  
  observeEvent(input$goButton, {
    results$data <-result_pred(input$V0,input$V1,input$V2,input$V3,input$V4,input$V5,input$V6,input$V7,input$V8,input$V9,input$V10,input$V11,input$V12,input$V13,input$V14,input$V15)
  })
  
  output$value <- renderText({
    return (results$data$time)
  })
  
  
  output$range <- renderText({
    return (results$data$range)
  })
  
  
  output$plot <- renderPlot({
    
    hist(results$data$dist$time_dist,
         probability = TRUE,
         breaks = as.numeric(20),
         xlab = "Total time (minutes)",
         ylab = 'Density',
         main = 'Probability Distribution of Predicted Total Time',
         col = "#75AADB", border = "white"
    )
    # tend to follow log normal distribution
    dens <- density(results$data$dist$time_dist,adjust = 2)
    lines(dens, col = "red")

  })
  
}

shinyApp(ui, server)




