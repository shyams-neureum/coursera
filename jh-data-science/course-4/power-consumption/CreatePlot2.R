##
## Function: CreatePlot2
##
## Description: This function will plot the averages of Global Active Power 
## consumed by the household on Thursdays and Fridays during the period. 
##
## Returns: None
##
## Parameters: Date, Time, Global_active_power
##
CreatePlot2 <- function(data_set)
{
    png("Plot-2.png", height=480, width=480)
    
    # The data is already filtered. 
    # 2007-02-01 is Thursday & 2007-02-02 is Friday
    data_set$dt_num <- as.POSIXct(
                            paste(data_set$Date, data_set$Time), 
                            tz="",
                            "%d/%m/%Y %H:%M:%S"
                        )
    
    axis_point_1 <- as.numeric(as.POSIXct("1/2/2007 0:00:00", 
                                          tz="", 
                                          "%d/%m/%Y %H:%M:%S"))

    axis_point_2 <- as.numeric(as.POSIXct("2/2/2007 0:00:00", 
                                          tz="", 
                                          "%d/%m/%Y %H:%M:%S"))
    
    axis_point_3 <- as.numeric(as.POSIXct("3/2/2007 0:00:00", 
                                          tz="", 
                                          "%d/%m/%Y %H:%M:%S"))
    
    plot(
        as.numeric(data_set$dt_num), 
        data_set$Global_active_power, 
        type="l",
        main="Plot 2 - Global Active Power vs. Time",
        ylab="Global Active Power (Kilowatts)",
        xlab="",
        xaxt="n")
    
    axis(
        1, 
        at=c(axis_point_1, axis_point_2, axis_point_3),
        labels=c("Thu", "Fri", "Sat")
    )    
    
    dev.off()
    
}
