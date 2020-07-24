##
## Function: Plot1
##
## Description: This function answers question #1: "Have total emissions from 
## PM2.5 decreased in the United States from 1999 to 2008? Using the base 
## plotting system, make a plot showing the total PM2.5 emission from all 
## sources for each of the years 1999, 2002, 2005, and 2008."
##
## Returns: None
##
## Parameters: None
##
Plot1 <- function()
{
    # Open the files and load the data
    scc_file_path <- file.path(
                        "exdata_data_NEI_data", 
                        "Source_Classification_Code.rds")
    
    sum_file_path <- file.path(
                        "exdata_data_NEI_data", 
                        "summarySCC_PM25.rds")
    
    scc_data <- readRDS(scc_file_path)
    summary_data <- readRDS(sum_file_path)
    
    # We will be calculating the total sum of emissions grouped by year. For 
    # good effect, we will also calculate mean, max and median grouped by year
    # draw one plot with all 4.
    sums <- summary_data %>% 
            group_by(year) %>% 
            summarize(sum(Emissions,na.rm=TRUE))
    colnames(sums) <- c("Year", "Sum")
    
    maxes <- summary_data %>% 
             group_by(year) %>% 
             summarize(max(Emissions,na.rm=TRUE))
    colnames(maxes) <- c("Year", "Max")
    
    means <- summary_data %>% 
             group_by(year) %>% 
             summarize(mean(Emissions,na.rm=TRUE))
    colnames(means) <- c("Year", "Mean")
    
    medians <- summary_data %>% 
               group_by(year) %>% 
               summarize(median(Emissions,na.rm=TRUE))
    colnames(medians) <- c("Year", "Median")
    
    png("Plot1.png", width=1000, height=500)
    
    par(mfrow=c(2,2))
    
    # Plot for Total Emissions
    max_sums <- max(sums$Sum)
    marks <- c(0, max_sums/2, max_sums)
    marks_str <-c("0", 
                  sprintf("%.2fM", (max_sums/2)/1000000),
                  sprintf("%.2fM", (max_sums)/1000000))
    
    barplot(
        sums$Sum~sums$Year, 
        main="Total Emissions by Year",
        xlab="Year",
        ylab="Total Emissions",
        col=c("red","blue","green","yellow"),
        yaxt="n",
        ylim=c(0, max_sums)
    )
    
    axis(2, at=marks, labels=marks_str)

    # Plot for Average Emissions 
    max_means <- max(means$Mean)
    marks <- c(0, max_means/2, max_means)
    marks_str <- c("0", sprintf("%.2f", max_means/2), sprintf("%.2f", max_means))
    
    barplot(
        means$Mean~means$Year, 
        main="Average Emissions by Year",
        xlab="Year",
        ylab="Average Emissions",
        col=c("red","blue","green","yellow"),
        yaxt="n",
        ylim=c(0, max_means)
    )
    
    axis(2, at=marks, labels=marks_str)
    
    # Plot for Median Emissions
    max_median <- max(medians$Median)
    marks <- c(0, max_median/2, max_median)
    marks_str <- c("0", sprintf("%.2f", max_median/2), sprintf("%.2f", max_median))
    
    barplot(
        medians$Median~medians$Year, 
        main="Median Emissions by Year",
        xlab="Year",
        ylab="Median Emissions",
        col=c("red","blue","green","yellow"),
        yaxt="n",
        ylim=c(0, max_median)
    )
    
    axis(2, at=marks, labels=marks_str)
    
    # Plot for Maximum Emissions
    max_maxes <- max(maxes$Max)
    marks <- c(0, max_maxes/2, max_maxes)
    marks_str <- c("0", 
                   sprintf("%.2fK", max_maxes/2/1000), 
                   sprintf("%.2fK", max_maxes/1000))
    
    barplot(
        maxes$Max~maxes$Year, 
        main="Maximum Emissions by Year",
        xlab="Year",
        ylab="Maximum Emissions",
        col=c("red","blue","green","yellow"),
        yaxt="n",
        ylim=c(0, max_maxes)
    )
    
    axis(2, at=marks, labels=marks_str)
    
    dev.off()
}