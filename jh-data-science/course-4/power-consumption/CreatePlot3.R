##
## Function: CreatePlot3
##
## Description: This function plots the Sub Metering values against time.
##
## Returns: None
##
## Parameters: Filtered Data Frame
##
CreatePlot3 <- function(data_set)
{
    png("Plot-3.png", height=480, width=480)
    
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
        data_set$Sub_metering_1, 
        type="l",
        main="Plot 3 - Sub-metering vs. Time",
        ylab="Energy Sub-metering",
        xlab="",
        xaxt="n")
    
    axis(
        1, 
        at=c(axis_point_1, axis_point_2, axis_point_3),
        labels=c("Thu", "Fri", "Sat")
    )    
    
    lines(
        as.numeric(data_set$dt_num), 
        data_set$Sub_metering_2,
        type="l",
        col="red"
    )
    
    lines(
        as.numeric(data_set$dt_num),
        data_set$Sub_metering_3,
        type="l",
        col="blue"
    )
    
    legend(
        "topright", 
        legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
        #fill=c("black", "red", "blue"),
        col=c("black", "red", "blue"),
        lty=1,
        lwd=2
    )
    
    dev.off()
    
}