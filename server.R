
# Define server logic required to draw a histogram
server <- function(input, output) {
    ################### INPUT ####################
    select_stock <- eventReactive(input$go, {
        
        stock_name <- input$stock
        twin <- input$true_date
        
        df_stock <- master_df %>% 
            filter(Name == stock_name,
                   Date > as.POSIXct(twin[1]) & Date < as.POSIXct(twin[2])) 
        
        return(df_stock)
    })
    
    multiple_stocks <- eventReactive(input$go_comp, {
      
      stock_name1 <- input$stock_comp1
      stock_name2 <- input$stock_comp2
      twin <- input$true_date_comp
      
      df_stock <- master_df %>% 
        filter(Name == stock_name,
               Date > as.POSIXct(twin[1]) & Date < as.POSIXct(twin[2])) 
      
      print(stock_name1)
      print(stock_name2)
      
      return(df_stock)
    })
    
    output$timedate <- renderUI({
        
        stock_name <- input$stock
        
        df <- master_df %>% 
            filter(Name == stock_name)
        
        min_time <- min(df$Date)
        max_time <- max(df$Date)
        
        dateRangeInput("true_date", "Período de análise",
                       end = max_time,
                       start = min_time,
                       min  = min_time,
                       max  = max_time,
                       format = "dd/mm/yy",
                       separator = " - ",
                       language='pt-BR')
    })
    
    output$timedate_comp <- renderUI({
        
        stock_name_1 <- input$stock_comp1
        stock_name_2 <- input$stock_comp2
      
        df_1 <- master_df %>% 
          filter(Name %in% stock_name_1)
        df_2 <- master_df %>% 
          filter(Name %in% stock_name_2)
      
        min_time_1 <- min(df_1$Date)
        max_time_1 <- max(df_1$Date)
      
        min_time_2 <- min(df_2$Date)
        max_time_2 <- max(df_2$Date)
      
        min_time <- min(min_time_1,min_time_2)
        max_time <- max(max_time_1,max_time_2)
        
        dateRangeInput("true_date_comp", "Período de análise",
                       end = max_time,
                       start = min_time,
                       min    = min_time,
                       max    = max_time,
                       format = "dd/mm/yy",
                       separator = " - ",
                       language='pt-BR')
    })
    
    ################ OUTPUT #####################
    Info_DataTable <- eventReactive(input$go, {
        df <- select_stock()
        
        abc <- df %>% select(Close)
        
        mean <- colMeans(abc)
        Media <- mean[[1]]
        
        med <- colMedians(as.matrix(abc))
        Mediana <- med[[1]]
        
        dp <- sd(as.matrix(abc))
        Desvio.Padrão <- dp[[1]]
        
        mod <- table(abc)
        Moda <- names(mod[mod == max(mod)])
        #print(Moda)

        Máximo <- max(abc)

        Mínimo <- min(abc)

        Ação <- input$stock
        
        df_tb <-  data.frame(Ação, Moda, Media, Mediana, Desvio.Padrão, Máximo, Mínimo)
        
        df_tb <- as.data.frame(t(df_tb))

        return(df_tb)
    })
    
    output$info <- renderDT({
        Info_DataTable() %>%
            as.data.frame() %>% 
            DT::datatable(options=list(
                language=list(
                    url = '//cdn.datatables.net/plug-ins/1.10.11/i18n/Portuguese-Brasil.json'
                )
            ))
    })
    
    output$info_comp <- renderDT({
      Info_DataTable_comp() %>%
            as.data.frame() %>%
            DT::datatable(options=list(
                language=list(
                    url = '//cdn.datatables.net/plug-ins/1.10.11/i18n/Portuguese-Brasil.json'
                )
            ))
      
    })
    
    output$sh <- renderPlot({
      # All the inputs
      df <- select_stock()
      
      aux <- df$Close %>% na.omit() %>% as.numeric()
      aux1 <- min(aux)
      aux2 <- max(aux)
      
      df$Date <- ymd(df$Date)
      a <- df %>% 
        ggplot(aes(Date, Close, group=1)) +
        geom_path() +
        xlab('Data') +
        ylab('Preço da Ação em $') +
        coord_cartesian(ylim = c(aux1, aux2)) +
        theme_bw() +
        scale_x_date(date_labels = "%Y-%m-%d")
      
      a
    })
    
    output$hist <- renderPlot({
      
      df <- select_stock()
      
      aux <- df$Close %>% na.omit() %>% as.numeric()
      x <- (max(aux) - min(aux)) / 15
      x <- round(x)

      df$Date <- ymd(df$Date)
      b <- df %>%
        ggplot(aes(Close, group=1)) +
        geom_histogram(binwidth = x, fill="#69b3a2", color="#e9ecef", alpha=0.9) +
        xlab('Preço da Ação em $') + 
        ylab('Frequência') +
        theme(
          plot.title = element_text(size=15)
        )
      
      b
    })
    
    output$bxp <- renderPlot({
      
      df <- select_stock()
      
      aux <- df$Close %>% na.omit() %>% as.numeric()
      
      df$Date <- ymd(df$Date)
      c <- df %>%
        ggplot(aes(x=Date,y=Close, group=1)) + 
        geom_boxplot(fill="slateblue", alpha=0.2) +
        xlab('Ano') + 
        ylab('Preço da Ação em $')
      
      c
    })
    
    
}
