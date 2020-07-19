##
## Function: CreatePlot4
##
## Description: This function draws 4 plots in one graph. It plots the 
## Global Active Power, Voltage, Energy Sub-metering and Global Reactive Power
## in 4 plots within a single graph.
##
## Returns: None
##
## Parameters: Filtered Data Frame
##
CreatePlot4 <- function(data_set)
{
    png("Plot-4.png", height=480, width=480)
    
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
    
    par(mfrow=c(2,2))
    
    # This is the first plot on the top left. Global Active Power vs. Time. 
    plot(
        as.numeric(data_set$dt_num), 
        data_set$Global_active_power, 
        type="l",
        ylab="Global Active Power (Kilowatts)",
        xlab="",
        xaxt="n")
    
    axis(
        1, 
        at=c(axis_point_1, axis_point_2, axis_point_3),
        labels=c("Thu", "Fri", "Sat")
    )    
    
    # This is the second plot on the top right. Voltage vs. Time. 
    plot(
        as.numeric(data_set$dt_num), 
        data_set$Voltage, 
        type="l",
        ylab="Voltage",
        xlab="datetime",
        xaxt="n")
    
    axis(
        1, 
        at=c(axis_point_1, axis_point_2, axis_point_3),
        labels=c("Thu", "Fri", "Sat")
    )    
    
    # This is the third plot on the bottom left. Sub-metering vs. Time. 
    plot(
        as.numeric(data_set$dt_num), 
        data_set$Sub_metering_1, 
        type="l",
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
    
    # This is the fourth plot on the bottom right. Global Reactive Power vs. Time. 
    plot(
        as.numeric(data_set$dt_num), 
        data_set$Global_reactive_power, 
        type="l",
        ylab="Global Reactive Power",
        xlab="datetime",
        xaxt="n")
    
    axis(
        1, 
        at=c(axis_point_1, axis_point_2, axis_point_3),
        labels=c("Thu", "Fri", "Sat")
    )    
    
    dev.off()
}