shinyUI(fluidPage(
    titlePanel("Find the terrorist!"),
    
    sidebarLayout(
        sidebarPanel(
            helpText("Find terrorists among 10,000 citizens using a test with a given accuracy.  
                     You control the accuracy of the test and the percent of the population that 
                     is actually a terrorist.  Try to keep innocent people of out jail!"),
            
            sliderInput("testAccy", 
                        label = "Accuracy of Test:",
                        min = 0, max = 1, value = 0.9, step =.0005),
            
            sliderInput("pctTerrorist", 
                    label = "Per cent of population Terrorist",
                    min = 0, max = 1, value = 0.005, step =.001)
            ),
        
        mainPanel(
            plotOutput('barChart')
        )
    )
))