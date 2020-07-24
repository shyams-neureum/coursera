##
## Function: Plot5
##
## Description: This function answers Question #5: "How have emissions from 
## motor vehicle sources changed from 1999-2008 in Baltimore City?"
##
## Returns: None
##
## Parameters: None
##
Plot5 <- function()
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
    
    # We have two types of sources - "Motor Vehicles" and "Motorcycles". We will
    # assume the question covers both sources. 
    
    mv_list <- grep("[Mm]otor [Vv]ehicle", scc_data$Short.Name)
    mc_list <- grep("[Mm]otorcycle", scc_data$Short.Name)
    
    mv_scc <- scc_data[mv_list,]$SCC
    mc_scc <- scc_data[mc_list,]$SCC

    # Filter the dataset for just Baltimore City, Maryland
    balt_data <- subset(summary_data, summary_data$fips=="24510")
    
    balt_mv_data <- subset(balt_data, balt_data$SCC %in% mv_scc)
    balt_mc_data <- subset(balt_data, balt_data$SCC %in% mc_scc)
    balt_co_data <- rbind(balt_mv_data, balt_mc_data)
   
    # We will plot the following:
    
    # 1. Total Motor Vehicle Emissions grouped by year
    # 2. Total Motor Cycle Emissions grouped by year
    # 3. Total Combined Emissions grouped by year
    # 4. Average Motor Vehicle Emissions grouped by year
    # 5. Average Motor Cycle Emissions grouped by year
    # 6. Average Combined Emissions grouped by year
    #
    # All 6 plots will be drawn in one image
    
    balt_mv_sums <- balt_mv_data %>% 
                    group_by(year) %>% 
                    summarize(sum(Emissions,na.rm=TRUE))
    colnames(balt_mv_sums) <- c("Year","Sum")
    
    balt_mc_sums <- balt_mc_data %>% 
        group_by(year) %>% 
        summarize(sum(Emissions,na.rm=TRUE))
    colnames(balt_mc_sums) <- c("Year","Sum")
    
    balt_co_sums <- balt_co_data %>% 
                    group_by(year) %>% 
                    summarize(sum(Emissions,na.rm=TRUE))
    colnames(balt_co_sums) <- c("Year","Sum")
    
    balt_mv_means <- balt_mv_data %>% 
                     group_by(year) %>% 
                     summarize(mean(Emissions,na.rm=TRUE))
    colnames(balt_mv_means) <- c("Year","Mean")
    
    balt_mc_means <- balt_mc_data %>% 
                     group_by(year) %>% 
                     summarize(mean(Emissions,na.rm=TRUE))
    colnames(balt_mc_means) <- c("Year","Mean")
    
    balt_co_means <- balt_co_data %>% 
                     group_by(year) %>% 
                     summarize(mean(Emissions,na.rm=TRUE))
    colnames(balt_co_means) <- c("Year","Mean")

    # Create Bar Plots of the Motor Vehicle, Motor Cycle and Cumulative Sums
    p1 <- ggplot(
            data=balt_mv_sums, 
            aes(x=Year, y=Sum, fill=Year))+
                geom_bar(stat="identity", color="black", position=position_dodge())+
                scale_fill_manual(values=c("#999999", "#E69F00", "#56B4E9", "#882534"))+
                ylab("Sums")+
                ggtitle("Sums of Motor-Vehicle-related Emissions")+
                scale_y_continuous(labels = comma)+
                theme_minimal()
    
    p2 <- ggplot(
            data=balt_mc_sums, 
            aes(x=Year, y=Sum, fill=Year))+
                geom_bar(stat="identity", color="black", position=position_dodge())+
                scale_fill_manual(values=c("#999999", "#E69F00", "#56B4E9", "#882534"))+
                ylab("Sums")+
                ggtitle("Sums of Motorcycle-related Emissions")+
                theme_minimal()
                
    p3 <- ggplot(
            data=balt_co_sums, 
            aes(x=Year, y=Sum, fill=Year))+
            geom_bar(stat="identity", color="black", position=position_dodge())+
            scale_fill_manual(values=c("#999999", "#E69F00", "#56B4E9", "#882534"))+
            ylab("Sums")+
            ggtitle("Sums of Combined Emissions")+
            theme_minimal()
                
    # Create Bar Plots of the Motor Vehicle, Motor Cycle and Cumulative Means
    p4 <- ggplot(
        data=balt_mv_means, 
        aes(x=Year, y=Mean, fill=Year))+
        geom_bar(stat="identity", color="black", position=position_dodge())+
        scale_fill_manual(values=c("#999999", "#E69F00", "#56B4E9", "#882534"))+
        ylab("Means")+
        ggtitle("Means of Motor-Vehicle-related Emissions")+
        scale_y_continuous(labels = comma)+
        theme_minimal()
    
    p5 <- ggplot(
        data=balt_mc_means, 
        aes(x=Year, y=Mean, fill=Year))+
        geom_bar(stat="identity", color="black", position=position_dodge())+
        scale_fill_manual(values=c("#999999", "#E69F00", "#56B4E9", "#882534"))+
        ylab("Means")+
        ggtitle("Means of Motorcycle-related Emissions")+
        theme_minimal()
    
    p6 <- ggplot(
        data=balt_co_means, 
        aes(x=Year, y=Mean, fill=Year))+
        geom_bar(stat="identity", color="black", position=position_dodge())+
        scale_fill_manual(values=c("#999999", "#E69F00", "#56B4E9", "#882534"))+
        ylab("Means")+
        ggtitle("Means of Combined Emissions")+
        theme_minimal()
    
    figure <- ggarrange(p1, p2, p3, p4, p5, p6, ncol=3, nrow=2, legend="bottom")
    ggsave("Plot5.png", plot=figure, width=12, height=8, units="in")
}