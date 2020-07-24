##
## Function: Plot6
##
## Description: This function answers Question #6: "Compare emissions from motor
## vehicle sources in Baltimore City with emissions from motor vehicle sources 
## in Los Angeles County, California (fips=="06037"). Which city has seen greater
## changes over time in motor vehicle emissions?"
##
## Returns: None
##
## Parameters: None
##
Plot6 <- function()
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
   
    # Filter the dataset for just Los Angeles, California
    la_data <- subset(summary_data, summary_data$fips=="06037")
    
    la_mv_data <- subset(la_data, la_data$SCC %in% mv_scc)
    la_mc_data <- subset(la_data, la_data$SCC %in% mc_scc)
    la_co_data <- rbind(la_mv_data, la_mc_data)
    
    # We will plot the following:
    
    # Plot6-Sums
    # 1. Total Motor Vehicle Emissions grouped by year (Baltimore)
    # 2. Total Motor Cycle Emissions grouped by year (Baltimore)
    # 3. Total Combined Emissions grouped by year (Baltimore)
    # 4. Total Motor Vehicle Emissions grouped by year (Los Angeles)
    # 5. Total Motor Cycle Emissions grouped by year (Los Angeles)
    # 6. Total Combined Emissions grouped by year (Los Angeles)
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
    
    la_mv_sums <- la_mv_data %>% 
                  group_by(year) %>% 
                  summarize(sum(Emissions,na.rm=TRUE))
                  colnames(la_mv_sums) <- c("Year","Sum")
    
    la_mc_sums <- la_mc_data %>% 
                  group_by(year) %>% 
                  summarize(sum(Emissions,na.rm=TRUE))
                  colnames(la_mc_sums) <- c("Year","Sum")
    
    la_co_sums <- la_co_data %>% 
                  group_by(year) %>% 
                  summarize(sum(Emissions,na.rm=TRUE))
                  colnames(la_co_sums) <- c("Year","Sum")

    sums_scale_max <- max(max(balt_mv_sums$Sum, na.rm=TRUE),
                          max(balt_mc_sums$Sum, na.rm=TRUE),
                          max(balt_co_sums$Sum, na.rm=TRUE),
                          max(la_mv_sums$Sum, na.rm=TRUE),
                          max(la_mc_sums$Sum, na.rm=TRUE),
                          max(la_co_sums$Sum, na.rm=TRUE))
    
    # Create Bar Plots of the Motor Vehicle, Motor Cycle and Cumulative Sums
    p1 <- ggplot(
            data=balt_mv_sums, 
            aes(x=Year, y=Sum, fill=Year))+
            geom_bar(stat="identity", color="black", position=position_dodge())+
            scale_fill_manual(values=c("#E69F00", "#56B4E9"))+
            ylab("Sums")+
            ggtitle("Sums of Motor-Vehicle-related Emissions (Baltimore)")+
            scale_y_continuous(labels = comma, limits=c(0,sums_scale_max))+
            theme_minimal()
                  
    p2 <- ggplot(
            data=balt_mc_sums, 
            aes(x=Year, y=Sum, fill=Year))+
            geom_bar(stat="identity", color="black", position=position_dodge())+
            scale_fill_manual(values=c("#999999", "#E69F00", "#56B4E9", "#882534"))+
            ylab("Sums")+
            ggtitle("Sums of Motorcycle-related Emissions (Baltimore)")+
            scale_y_continuous(limits=c(0, sums_scale_max))+
            theme_minimal()
                  
    p3 <- ggplot(
            data=balt_co_sums, 
            aes(x=Year, y=Sum, fill=Year))+
            geom_bar(stat="identity", color="black", position=position_dodge())+
            scale_fill_manual(values=c("#999999", "#E69F00", "#56B4E9", "#882534"))+
            ylab("Sums")+
            ggtitle("Sums of Combined Emissions (Baltimore)")+
            scale_y_continuous(limit=c(0, sums_scale_max))+
            theme_minimal()
                  
    p4 <- ggplot(
            data=la_mv_sums, 
            aes(x=Year, y=Sum, fill=Year))+
            geom_bar(stat="identity", color="black", position=position_dodge())+
            scale_fill_manual(values=c("#999999", "#E69F00", "#56B4E9", "#882534"))+
            ylab("Sums")+
            ggtitle("Sums of Motor-Vehicle-related Emissions (Los Angeles")+
            scale_y_continuous(labels = comma, limits=c(0, sums_scale_max))+
            theme_minimal()
    
    p5 <- ggplot(
            data=la_mc_sums, 
            aes(x=Year, y=Sum, fill=Year))+
            geom_bar(stat="identity", color="black", position=position_dodge())+
            scale_fill_manual(values=c("#999999", "#E69F00", "#56B4E9", "#882534"))+
            ylab("Sums")+
            ggtitle("Sums of Motorcycle-related Emissions (Los Angeles)")+
            scale_y_continuous(limit=c(0, sums_scale_max))+
            theme_minimal()
    
    p6 <- ggplot(
            data=la_co_sums, 
            aes(x=Year, y=Sum, fill=Year))+
            geom_bar(stat="identity", color="black", position=position_dodge())+
            scale_fill_manual(values=c("#999999", "#E69F00", "#56B4E9", "#882534"))+
            ylab("Sums")+
            ggtitle("Sums of Combined Emissions (Los Angeles)")+
            scale_y_continuous(limit=c(0, sums_scale_max))+
            theme_minimal()

    figure <- ggarrange(p1, p2, p3, p4, p5, p6, ncol=3, nrow=2, legend="bottom")
    ggsave("Plot6-Sums.png", plot=figure, width=18, height=12, units="in")
    
    # Plot6-Means
    # 1. Average Motor Vehicle Emissions grouped by year (Baltimore)
    # 2. Average Motor Cycle Emissions grouped by year (Baltimore)
    # 3. Average Combined Emissions grouped by year (Baltimore)
    # 4. Average Motor Vehicle Emissions grouped by year (Los Angeles)
    # 5. Average Motor Cycle Emissions grouped by year (Los Angeles)
    # 6. Average Combined Emissions grouped by year (Los Angeles)
    #
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

    la_mv_means <- la_mv_data %>% 
                   group_by(year) %>% 
                   summarize(mean(Emissions,na.rm=TRUE))
    colnames(la_mv_means) <- c("Year","Mean")
    
    la_mc_means <- la_mc_data %>% 
                   group_by(year) %>% 
                   summarize(mean(Emissions,na.rm=TRUE))
    colnames(la_mc_means) <- c("Year","Mean")
    
    la_co_means <- la_co_data %>% 
                   group_by(year) %>% 
                   summarize(mean(Emissions,na.rm=TRUE))
    colnames(la_co_means) <- c("Year","Mean")

    means_scale_max <- max(max(balt_mv_means$Mean, na.rm=TRUE),
                           max(balt_mc_means$Mean, na.rm=TRUE),
                           max(balt_co_means$Mean, na.rm=TRUE),
                           max(la_mv_means$Mean, na.rm=TRUE),
                           max(la_mc_means$Mean, na.rm=TRUE),
                           max(la_co_means$Mean, na.rm=TRUE))
    
    # Create Bar Plots of the Motor Vehicle, Motor Cycle and Cumulative Means
    p7 <- ggplot(
            data=balt_mv_means, 
            aes(x=Year, y=Mean, fill=Year))+
            geom_bar(stat="identity", color="black", position=position_dodge())+
            scale_fill_manual(values=c("#E69F00", "#56B4E9"))+
            ylab("Means")+
            ggtitle("Means of Motor-Vehicle-related Emissions (Baltimore)")+
            scale_y_continuous(labels = comma, limits=c(0, means_scale_max))+
            theme_minimal()
    
    p8 <- ggplot(
            data=balt_mc_means, 
            aes(x=Year, y=Mean, fill=Year))+
            geom_bar(stat="identity", color="black", position=position_dodge())+
            scale_fill_manual(values=c("#999999", "#E69F00", "#56B4E9", "#882534"))+
            ylab("Means")+
            ggtitle("Means of Motorcycle-related Emissions (Baltmore)")+
            scale_y_continuous(limit=c(0, means_scale_max))+        
            theme_minimal()
    
    p9 <- ggplot(
            data=balt_co_means, 
            aes(x=Year, y=Mean, fill=Year))+
            geom_bar(stat="identity", color="black", position=position_dodge())+
            scale_fill_manual(values=c("#999999", "#E69F00", "#56B4E9", "#882534"))+
            ylab("Means")+
            ggtitle("Means of Combined Emissions (Baltimore)")+
            scale_y_continuous(limit=c(0, means_scale_max))+        
            theme_minimal()
    
    p10 <- ggplot(
            data=la_mv_means, 
            aes(x=Year, y=Mean, fill=Year))+
            geom_bar(stat="identity", color="black", position=position_dodge())+
            scale_fill_manual(values=c("#999999", "#E69F00", "#56B4E9", "#882534"))+
            ylab("Means")+
            ggtitle("Means of Motor-Vehicle-related Emissions (Los Angeles)")+
            scale_y_continuous(labels = comma, limit=c(0, means_scale_max))+
            theme_minimal()
    
    p11 <- ggplot(
                data=la_mc_means, 
                aes(x=Year, y=Mean, fill=Year))+
                geom_bar(stat="identity", color="black", position=position_dodge())+
                scale_fill_manual(values=c("#999999", "#E69F00", "#56B4E9", "#882534"))+
                ylab("Means")+
                ggtitle("Means of Motorcycle-related Emissions (Los Angeles)")+
                scale_y_continuous(limit=c(0, means_scale_max))+        
                theme_minimal()
    
    p12 <- ggplot(
                data=la_co_means, 
                aes(x=Year, y=Mean, fill=Year))+
                geom_bar(stat="identity", color="black", position=position_dodge())+
                scale_fill_manual(values=c("#999999", "#E69F00", "#56B4E9", "#882534"))+
                ylab("Means")+
                ggtitle("Means of Combined Emissions (Los Angeles)")+
                scale_y_continuous(limit=c(0, means_scale_max))+        
                theme_minimal()
    
    figure <- ggarrange(p7, p8, p9, p10, p11, p12, ncol=3, nrow=2, legend="bottom")
    ggsave("Plot6-Means.png", plot=figure, width=18, height=12, units="in")
    
}