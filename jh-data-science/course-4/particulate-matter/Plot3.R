##
## Function: Plot3
##
## Description: This function answers Question #3: "Of the four types of sources
## indicated by the type (point nonpoint, onroad, nonroad) variable, which of 
## these four sources have seen decreases in emissions from 1999-2008 for 
## Baltimore City? Which have seen increases in emissions from 1999-2008? Use 
## the ggplot2 plotting system to make a plot answer this question. 
##
## Returns: None
##
## Parameters: None
##
Plot3 <- function()
{
    library(ggplot2)
    library(ggpubr)
    library(grid)
    
    # Open the files and load the data
    scc_file_path <- file.path(
                        "exdata_data_NEI_data", 
                        "Source_Classification_Code.rds")
    
    sum_file_path <- file.path(
                        "exdata_data_NEI_data", 
                        "summarySCC_PM25.rds")
    
    scc_data <- readRDS(scc_file_path)
    summary_data <- readRDS(sum_file_path)
   
    summary_data$year <- as.character(summary_data$year)
    
    # Filter the dataset for just Baltimore City, Maryland
    filter_data <- subset(summary_data, summary_data$fips=="24510")
   
    # We will be calculating the total sum of emissions grouped by year and type. 
    # For good effect, we will also calculate mean, max and median grouped by 
    # year and type, draw one plot with all 4.
    sums <- filter_data %>% 
            group_by(type, year) %>% 
            summarize(sum(Emissions,na.rm=TRUE))
    colnames(sums) <- c("Type", "Year", "Sum")
    
    maxes <- filter_data %>% 
             group_by(type, year) %>% 
             summarize(max(Emissions,na.rm=TRUE))
    colnames(maxes) <- c("Type", "Year", "Max")
    
    means <- filter_data %>% 
             group_by(type, year) %>% 
             summarize(mean(Emissions,na.rm=TRUE))
    colnames(means) <- c("Type", "Year", "Mean")
    
    medians <- filter_data %>% 
               group_by(type, year) %>% 
               summarize(median(Emissions,na.rm=TRUE))
    colnames(medians) <- c("Type", "Year", "Median")

    # Create a Bar Plot of Sums
    p1 <- ggplot(
            data=sums, 
            aes(x=Year, y=Sum, fill=Type))+
                geom_bar(stat="identity", color="black", position=position_dodge())+
                scale_fill_manual(values=c("#999999", "#E69F00", "#56B4E9", "#882534"))+
                ylab("Sums")+
                ggtitle("Sums of Emissions (Baltimore)")
                theme_minimal()
    
    # Create a Bar Plot of Means
    p2 <- ggplot(
            data=means, 
            aes(x=Year, y=Mean, fill=Type))+
                geom_bar(stat="identity", color="black", position=position_dodge())+
                scale_fill_manual(values=c("#999999", "#E69F00", "#56B4E9", "#882534"))+
                ylab("Means")+
                ggtitle("Means of Emissions (Baltimore)")
                theme_minimal()
                
    # Create a Bar Plot of Medians
    p3 <- ggplot(
            data=medians, 
            aes(x=Year, y=Median, fill=Type))+
                geom_bar(stat="identity", color="black", position=position_dodge())+
                scale_fill_manual(values=c("#999999", "#E69F00", "#56B4E9", "#882534"))+
                ylab("Medians")+
                ggtitle("Medians of Emissions (Baltimore)")
                theme_minimal()
                
    # Create a Bar Plot of Maxes
    p4 <- ggplot(
            data=maxes, 
            aes(x=Year, y=Max, fill=Type))+
                geom_bar(stat="identity", color="black", position=position_dodge())+
                scale_fill_manual(values=c("#999999", "#E69F00", "#56B4E9", "#882534"))+
                ylab("Maxes")+
                ggtitle("Maxes of Emissions (Baltimore)")
                theme_minimal()
                
    figure <- ggarrange(p1, p2, p3, p4, ncol=2, nrow=2, common.legend = TRUE, legend="bottom")
    ggsave("Plot3.png", plot=figure, width=10, height=6, units="in")
}