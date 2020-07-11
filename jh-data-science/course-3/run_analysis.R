##
## Script: run_analysis.R
##
## Description: Programming Assignment for Week 3 of the 'Getting and Cleaning
## Data' course of the Johns Hopkins Data Science Specialization on Coursera.
## This script performs the function of cleaning up and organizing the UCI 
## "Human Activity Recognition using Smart Phones" Data Set. 
##
##

##
## Function: cleanup_paired_list
##
## Description: This function receives a vector of strings that have a numeric 
## identifier followed by a string name. It removes the numeric identifiers
## and returns only the string names. 
##
## Returns: vector - cleaned up string list
##
## Parameters: vector - original paired list
##
cleanup_paired_list <- function(orig_list)
{
    # Chop off the leading numeric IDs from the paired list
    mat <- matrix(unlist(strsplit(orig_list, " ")), ncol=2, byrow=TRUE)
    
    # Return the new list
    new_list <- mat[,2]
}

## 
## Function: read_data_set_and_process
##
## Description: This function receives a folder as input. It opens the data set
## files in that folder, reads them, combines them into a cleaned up data frame,
## and returns the cleaned up data frame.
##
## Returns: data frame - Final, combined data frame
##
## Parameters: string - Folder Name
##
read_data_set_and_process <- function(folder_name, x_col_names, y_labels)
{
    # Form the proper folder path
    folder_path <- file.path(getwd(), folder_name)
    
    # Load the X_* Data Set
    x_fname <- sprintf("X_%s.txt", folder_name)
    x_path <- file.path(folder_path, x_fname)
    
    x_data <- read.table(x_path) 
    
    # Set Column Names
    colnames(x_data) <- x_col_names
    
    # Load the y_* Data Set
    y_fname <- sprintf("y_%s.txt", folder_name)
    y_path <- file.path(folder_path, y_fname)
    
    y_data <- read.table(y_path) 
    
    colnames(y_data) <- c("activity code")
    
    # Load the subject_* Data Set
    subj_fname <- sprintf("subject_%s.txt", folder_name)
    subj_path <- file.path(folder_path, subj_fname)
    
    subj_data <- read.table(subj_path) 
    
    # Set Column Name
    colnames(subj_data) <- c("test subject id")
    
    # The y_data frame contains the codes for the activities. We will now
    # create one more column for the final data frame that contains the names
    # of the activities. Create that vector now. 
    colnames(y_labels) <- c("activity code", "activity label")
    
    activity_table <- merge(y_data, y_labels, 
                            by.x="activity code", by.y="activity code")
    
    # We will now add the subject data set as a column in the final data set
    final_data <- cbind(x_data, subj_data, activity_table)
    
    final_data
}

## 
## Function: run_analysis
##
## Description: This is the top level function that performs the complete clean
## up and organization of the input data files. This function calls other 
## functions to accomplish its task. 
##
## Returns: None (No return values)
##
## Parameters: None (Takes no input parameters)
##
run_analysis <- function()
{
    
    library(data.table)
    
    # We assume that the current working directory is where we start from. 
    current_dir <- getwd()
    
    # The features file is in the current working directory. Read it first. 
    features_con <- file("features.txt")
    
    features_list <- readLines(features_con)
    
    # Clean up the numeric ids and get only the string names 
    features_list <- cleanup_paired_list(features_list)
    
    close(features_con)
    
    # The activity labels are in the current working directory. Read it next. 
    activity_list <- read.table("activity_labels.txt")

    # Read and process the Training Data Set
    training_set <- read_data_set_and_process(
                            "train", 
                            features_list, 
                            activity_list)
    
    # Read and process the Test Data Set
    test_set <- read_data_set_and_process(
                            "test", 
                            features_list,
                            activity_list)
    
    # We can now merge the training and test datasets to create one merged set
    merged_set <- rbind(training_set, test_set)
    
    # For debugging purposes, we will now write each data set to a file
    # Uncomment this code only when it is needed for debugging
    #write.csv(training_set, "debug-training-set.csv", row.names=FALSE)
    #write.csv(test_set, "debug-test-set.csv", row.names=FALSE)
    #write.csv(merged_set, "debug-merged-set.csv", row.names=FALSE)
    
    # Now that we have a merged data set, we should calculate the mean and 
    # standard deviation for all measurement columns. 
    means <- data.frame(sapply(merged_set[,1:561], mean))
    stdvs <- data.frame(sapply(merged_set[,1:561], sd))
    
    t_means<-transpose(means)
    colnames(t_means)<-rownames(means)
    
    t_stdvs<-transpose(stdvs)
    colnames(t_stdvs)<-rownames(stdvs)

   # Print the mean and standard output values into separate files 
    write.table(t_means, "output-mean.csv", sep=",", row.names=FALSE, col.names=TRUE)
    write.table(t_stdvs, "output-stdev.csv", sep=",", row.names=FALSE, col.names=TRUE)
    
    # Group the means by test subject id and activity. 
    # Write it to a separate file. 
    output <- aggregate(as.matrix(merged_set[,1:561]), as.list(merged_set[,562:564]), mean)

    write.csv(output, "output-grouped-means.csv", row.names=FALSE)
    
} 

