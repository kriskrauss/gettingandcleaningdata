gettingandcleaningdata
======================

Course Project work for Getting and Cleaning Data class


What is the project all about?
-------------------------

Data for the project is available at:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

Create a script:
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

Assumption
-------------------------
Samsung data is in the working directory


Implementation
-------------------------
Steps in run_analysis.R are described below:
1. Load the different data files into R
2. Set column names for easy readability and processing
3. Extract mean and standard deviation for each measurement
4. Combine activity, subject and signal data
5. Merge test and train sets
6. Make the column names more readable and usable
   * remove extraneous characters ("-","(",")")
   * change column prefix 't' to denote time, 'f' to denote freq
   * remove extra "Body" in some column names
   * make them all lower case
7. Compute the average of each variable for each activity and each subject
8. Set up the tidy data set with proper column names and ordered by subject and activity
9. Confirm each subject has all 6 activities
