##
## Function: CreatePlot1
##
## Description: This function creates Plot #1 of the exercise, a histogram of
## Global Active Power.
##
## Returns: histogram object
##
## Parameters: list of Global Active Power measurements
##
CreatePlot1 <- function(active_power)
{
    png("Plot-1.png", height=480, width=480)
    
    hist_obj <- hist(
        active_power, 
        main="Plot 1 - Global Active Power",
        xlab="Global Active Power (Kilowatts)",
        ylab="Frequency",
        col="red"
    )
    
    dev.off()
    
    hist_obj
    
}
