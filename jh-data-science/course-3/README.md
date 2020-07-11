README for run_analysis.R
~~~~~~~~~~~~~~~~~~~~~~~~~

This script consists of one source file 'run_analysis.R'. To invoke the script, 
type 'run_analysis()' in the R console. 

Internally, the 'run_analysis()' function calls other functions which are also
defined in the same 'run_analysis.R' file. These are helper functions that 
should not be called by the user directly. 

Usage
~~~~~

        Type 'run_analysis()' on the R console

Inputs
~~~~~~
There are no input parameters for the 'run_analysis()' function. However, the
function expects to be run from the current working directory and the input 
dataset placed in the current working directory in the following structure.

                <current working directory>
                        |
                        |--- <train>
                        |        |--- <Inertial Signals>
                        |        |--- subject_train.txt
                        |        |--- X_train.txt
                        |        |--- y_train.txt
                        |
                        |--- <test>
                        |        |--- <Inertial Signals>
                        |        |--- subject_test.txt
                        |        |--- X_test.txt
                        |        |--- y_test.txt
                        |
                        |--- activity_labels.txt
                        |--- features.txt 
                        |--- features_info.txt
                        |--- README.txt
                        |--- run_analysis.R
                        
Outputs
~~~~~~~
This script produces two .csv files in the working directory. 

                <current working directory>
                        |
                        |--- mean-and-stdev.csv     // Output File #1
                        |--- grouped-means.csv      // Output File #2
                        

The first file is 'mean-and-stdev.csv'. This file contains two rows of data. The
first row corresponds to the mean/average of all the numeric measured variables 
in the input data set. The second row corresponds to the standard deviation of 
all the numeric measured variables in the input data set. 

The second file is 'grouped-means.csv'. This file contains multiple rows of data,
all rows corresponding to mean/average of the numeric measured variables in the 
input data set, grouped by the 'test subject' and the 'activity'. The number of 
rows in this file depends on the number of test subjects and the number of 
activities the data is measured for each test subject. 

