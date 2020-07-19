##
## Function: PowerConsumption
##
## Description: This is the main entry function for this programming exercise. 
## The PowerConsumption function loads the data set and calls each plot function
## in turn to create each of the plots for this exercise. 
##
## Returns: None
##
## Parameters: None
##
PowerConsumption <- function()
{
    # We will assume that the input text file is in the current working directory
    my_data <- read.table("household_power_consumption.txt", sep=";", header=TRUE)
    
    # The dataset has been read. But, most of the fields that should be numeric
    # are being read in as character vectors. Do the conversion. 
    cols.num <- 3:9
    
    my_data[cols.num] <- sapply(my_data[cols.num],as.numeric)
    
    # We are only interested in a filtered data set of two days. 
    # Create a filtered data list
    filt_dates <- 
        c(which(my_data$Date=="1/2/2007"), which(my_data$Date=="2/2/2007"))
    
    filt_data <- my_data[filt_dates,]
    
    # Create Plot #1.
    ret_val <- CreatePlot1(filt_data$Global_active_power)
    
    # Create Plot #2.
    ret_val <- CreatePlot2(filt_data)
    
    # Create Plot #3.
    ret_val <- CreatePlot3(filt_data)
    
    # Create Plot #4
    ret_val <- CreatePlot4(filt_data)
    
    # Nothing to return
}
