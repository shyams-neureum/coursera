Power Consumption Plots
~~~~~~~~~~~~~~~~~~~~~~~

README

The scripts in this repository are organized as follows:

PowerConsumption.R
 
	This is the master script that reads the data file and filters it only for the dates of 2007-02-01 and 2007-02-02. 
	It also converts the numeric columns in the data frame to actual numeric columns. 
	It then calls CreatePlot1.R...CreatePlot4.R with the filtered data frame. 

CreatePlot1.R

	This script receives the filtered/preprocessed data frame and plots Plot-1 (Histogram of Global Active Power).

CreatePlot2.R

	This script receives the filtered/preprocessed data frame and plots Plot-2 (Global Active Power vs. Time). 

CreatePlot3.R

	This script receives the filtered/preprocessed data frame and plots Plot-3 (Sub-metering vs. Time). 

CreatePlot4.R

	This script receives the filtered/preprocessed data frame and plots the 4-plots-in-a-graph:
		
		1. Global Active Power vs. Time
		2. Voltage vs. Time
		3. Sub-metering vs. Time
		4. Global Reactive Power vs. Time
