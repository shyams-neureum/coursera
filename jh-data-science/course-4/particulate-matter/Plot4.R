##
## Function: Plot4
##
## Description: This function answers Question #4: "Across the United States,
## how have emissions from coal combustion-related sources changed from 
## 1999-2008?
##
## Returns: None
##
## Parameters: None
##
Plot4 <- function()
{
    library(ggplot2)
    library(ggpubr)
    library(grid)
    library(scales)
    
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
    
    # Look for Short.Name variables that have the text "Comb" (for Combustion)
    # and "Coal". The intersection of these gives us the SCCs for Coal Combustion
    coal_list <- grep("[Cc]oal", scc_data$Short.Name)
    comb_list <- grep("[Cc]omb", scc_data$Short.Name)
    
    inters_list <- intersect(coal_list, comb_list)
    
    coal_scc <- scc_data[inters_list,]$SCC
    
    # Filter the dataset for Coal Combustion Sources
    filter_data <- subset(summary_data, summary_data$SCC %in% coal_scc)
   
    # We will be calculating the total sum of emissions grouped by year. 
    # For good effect, we will also calculate mean, max and median grouped by 
    # year, draw one plot with all 4.
    sums <- filter_data %>% 
            group_by(year) %>% 
            summarize(sum(Emissions,na.rm=TRUE))
    colnames(sums) <- c("Year","Sum")
    
    maxes <- filter_data %>% 
             group_by(year) %>% 
             summarize(max(Emissions,na.rm=TRUE))
    colnames(maxes) <- c("Year", "Max")
    
    means <- filter_data %>% 
             group_by(year) %>% 
             summarize(mean(Emissions,na.rm=TRUE))
    colnames(means) <- c("Year", "Mean")
    
    medians <- filter_data %>% 
               group_by(year) %>% 
               summarize(median(Emissions,na.rm=TRUE))
    colnames(medians) <- c("Year", "Median")

    # Create a Bar Plot of Sums
    p1 <- ggplot(
            data=sums, 
            aes(x=Year, y=Sum, fill=Year))+
                geom_bar(stat="identity", color="black", position=position_dodge())+
                scale_fill_manual(values=c("#999999", "#E69F00", "#56B4E9", "#882534"))+
                ylab("Sums")+
                ggtitle("Sums of Coal-Combustion-related Emissions")+
                scale_y_continuous(labels = comma)+
                theme_minimal()
    
    # Create a Bar Plot of Means
    p2 <- ggplot(
            data=means, 
            aes(x=Year, y=Mean, fill=Year))+
                geom_bar(stat="identity", color="black", position=position_dodge())+
                scale_fill_manual(values=c("#999999", "#E69F00", "#56B4E9", "#882534"))+
                ylab("Means")+
                ggtitle("Means of Coal-Combustion-related Emissions")
                theme_minimal()
                
    # Create a Bar Plot of Medians
    p3 <- ggplot(
            data=medians, 
            aes(x=Year, y=Median, fill=Year))+
                geom_bar(stat="identity", color="black", position=position_dodge())+
                scale_fill_manual(values=c("#999999", "#E69F00", "#56B4E9", "#882534"))+
                ylab("Medians")+
                ggtitle("Medians of Coal-Combustion-related Emissions")
                theme_minimal()
                
    # Create a Bar Plot of Maxes
    p4 <- ggplot(
            data=maxes, 
            aes(x=Year, y=Max, fill=Year))+
                geom_bar(stat="identity", color="black", position=position_dodge())+
                scale_fill_manual(values=c("#999999", "#E69F00", "#56B4E9", "#882534"))+
                ylab("Maxes")+
                ggtitle("Maxes of Coal-Combustion-related Emissions")
                theme_minimal()
                
    figure <- ggarrange(p1, p2, p3, p4, ncol=2, nrow=2, common.legend = TRUE, legend="bottom")
    ggsave("Plot4.png", plot=figure, width=10, height=6, units="in")
}