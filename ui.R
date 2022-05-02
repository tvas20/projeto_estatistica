header <- dashboardHeader(title = "Projeto de Estatística")

sidebar <- dashboardSidebar(
    sidebarMenu(
        menuItem("Métricas", tabName = "m", icon = icon("chart-line")),
        menuItem('Comparando Ações', tabName = 'comp', icon = icon('chart-bar'))
    )
)

body <- dashboardBody(
    tabItems(
        tabItem(tabName = 'm',
                fluidRow(
                    box(title = 'Selecione suas opções', width=12, solidHeader = TRUE, status='warning',
                        selectInput('stock', 'Ação', stock_list, multiple=FALSE),
                        uiOutput("timedate"),
                        actionButton('go', 'Submeter')
                        )
                ),
                fluidRow(
                    box(title = "Informações sobre a ação", width = 12, solidHeader = TRUE,
                        DTOutput('info')
                    )
                ),
                fluidRow(
                    box(title = "Gráfico de Linha", width = 12, solidHeader = TRUE,
                        plotOutput('sh')
                    )
                ),
                fluidRow(
                  box(title = "Histograma", width = 12, solidHeader = TRUE,
                      plotOutput('hist')
                  )
                ),
                fluidRow(
                  box(title = "Boxplot", width = 6, solidHeader = TRUE,
                      plotOutput('bxp')
                  )
                ),
        ),
        tabItem(tabName = 'comp',
                fluidRow(
                    box(title = 'Selecione suas opções', width=12, solidHeader = TRUE, status='warning',
                        selectInput('stock_comp1', 'Ação', stock_list, multiple=FALSE),
                        selectInput('stock_comp2', 'Ação', stock_list, multiple=FALSE),
                        uiOutput("timedate_comp"),
                        actionButton('go_comp', 'Submeter')
                    )
                ),   
                fluidRow(
                  box(title = "Correlação entre as ações", width = 12, solidHeader = TRUE,
                      DTOutput('info_comp')
                  )
                ),
                fluidRow(
                  box(title = "Gráfico da correlação entre as ações", width = 12, solidHeader = TRUE,
                      plotOutput('ls')
                  )
                ),
                fluidRow(
                  box(title = "Gráfico de barra das médias das ações", width = 6, solidHeader = TRUE,
                      plotOutput('brr')
                  )
                ),
                fluidRow(
                  box(title = "Scatterplot das ações", width = 6, solidHeader = TRUE,
                      plotOutput('sct')
                  )
                ),
                
        )
    )
)

ui <- dashboardPage(
    skin = 'blue',
    header, sidebar, body)
