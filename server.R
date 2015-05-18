shinyServer
(
    function(input, output){
        
        createCitizenList <- function(pctChanceOfTerrorist)
        {
            r<-runif(1)
            
            if(r<pctChanceOfTerrorist)
            {
                return("Terrorist")
            }
            return("Innocent")
        }
        
        
        RunTheSim <- function( testAccy = 0.9, pctChanceofTerrorist = 0.005, fixedSeed = TRUE)
        {
            if(fixedSeed==TRUE)
            {
                set.seed(75961)
            }
            
            totalPop <- 10000 #10,000 citizens to test
            numTerrorists = 0
            citizens <- array("", dim=c(1,totalPop))
            i<-totalPop
            
            #first, create the 10,000 citizens that will be tested
            while (i>0)
            {
                citizens[i]<- createCitizenList(pctChanceofTerrorist)
                if(citizens[i]=='Terrorist')
                {
                    numTerrorists = numTerrorists + 1
                }
                i=i-1
            }
            
            #now we have an array or citizens that are either Innocent or Terrorist
            #subject them to the test
            i<-totalPop
            
            
            #set up results values
            #tp is true positives.  This is the sum of terrorists identified as terrorists
            #tn is true negatives.  This is the sum of innocent citizens identified as innocent
            #fp is false positives. This is the sum of innocent citizens identified as terrorists
            #fn is false negatives. This is the sum of terrorists identified as innocent
            tp=0
            fp=0
            tn=0
            fn=0
            
            while(i>0)
            {
                r<-runif(1)
                #4 states.  The test can be accurate or inaccurate
                #           The citizen can be innocent or a terrorists
                
                if (r<testAccy)
                {
                    #then we have accurately discovered if this person is a terrorist or innocent
                    #this code is written for simplicity of understanding, not performance
                    if(citizens[i]=="Terrorist")
                    {
                        tp=tp+1
                    }
                    if(citizens[i]=="Innocent")
                    {
                        tn=tn+1
                    }
                }
                #this means the test was inaccurate
                #again, simplicity, not performance
                if(r>= testAccy)
                {
                    if(citizens[i]=="Terrorist")
                    {
                        fp=fp+1
                    }
                    if(citizens[i]=="Innocent")
                    {
                        fn=fn+1
                    }          
                }
                i=i-1
            }
            
            #for most purposes, the sim can ignore the true negatives (innocent citizens)
            #to make the rest of the bars scale better
            zoomPlot<-c(numTerrorists,tp,fp,fn)
            ymax = which.max(zoomPlot)
            
            myPlot<-barplot(zoomPlot,main=paste("Finding Terrorists\n Accuracy = ",as.numeric(testAccy)*100,"%",
                                                "\nTerrorists Chance = ",as.numeric(pctChanceofTerrorist)*100,"%"),
                            names.arg=c(paste("Actual Terrorists", numTerrorists),
                                        paste("Terrorists Caught",tp),
                                        paste("Terrorists Missed",fp),
                                        paste("Innocents Accused",fn)),
                            col = c("blue","green","red","red"),
                            ylim=c(0,zoomPlot[ymax])
            )
            
            return (c(tp,fp,tn,fn, myPlot))
        }

            output$barChart <- renderPlot({
                                RunTheSim(input$testAccy, input$pctTerrorist)
                                })

})