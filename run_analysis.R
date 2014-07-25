
## Requirements:
# You should create one R script called run_analysis.R that does the following. 
# 1.Merges the training and the test sets to create one data set.
# 2.Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3.Uses descriptive activity names to name the activities in the data set
# 4.Appropriately labels the data set with descriptive variable names. 
# 5.Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 


## Read in the data

# metadata
activity_lables<-read.table("./UCI HAR Dataset/activity_labels.txt", header=FALSE)
features<-read.table("./UCI HAR Dataset/features.txt", header=FALSE)

# test set
x_test<-read.table("./UCI HAR Dataset/test/x_test.txt", header=FALSE)
y_test<-read.table("./UCI HAR Dataset/test/y_test.txt", header=FALSE)
subject_test<-read.table("./UCI HAR Dataset/test/subject_test.txt", header=FALSE)

# train set
x_train<-read.table("./UCI HAR Dataset/train/x_train.txt", header=FALSE)
y_train<-read.table("./UCI HAR Dataset/train/y_train.txt", header=FALSE)
subject_train<-read.table("./UCI HAR Dataset/train/subject_train.txt", header=FALSE)

# get the columns set for the x dataset
colnames(x_test)<-features$V2
colnames(x_train)<-features$V2

# extract only the columns we need: mean and standard deviation for each measurement
x_test<-x_test[,grep("mean\\(\\)|std()", colnames(x_test))]
x_train<-x_train[,grep("mean\\(\\)|std()", colnames(x_train))]

# combine activity, subject and signal data
x_test<-cbind(subject_test,y_test,x_test)
x_train<-cbind(subject_train,y_train,x_train)

# set the columns names so we can do subsequent joins
colnames(x_test)[1:2]<-c("subjectid","activityid")
colnames(x_train)[1:2]<-c("subjectid","activityid")

# merge the test and train sets
mydata<-rbind(x_test, x_train)

# make column names more readable and usable after join
colnames(activity_lables)<-c("activityid", "activity")

# now get the activity lable names
mydata<-merge(mydata, activity_lables, by.x="activityid", by.y="activityid")

# rearrange columns: subjectid, activity, rest of measurements
mydata<-mydata[,c(2,69,3:68)]

# make the column names more readable and usable

# remove "-"
colnames(mydata)<-gsub("-", "", colnames(mydata))

# remove paren
colnames(mydata)<-sub("\\(", "", colnames(mydata))
colnames(mydata)<-sub(")", "", colnames(mydata))

# measurement prefix 't' denotes time, 'f' indicates frequency domain signals
colnames(mydata)<-sub("^t", "time", colnames(mydata))
colnames(mydata)<-sub("^f", "freq", colnames(mydata))

# change BodyBody to Body
colnames(mydata)<-sub("BodyBody", "Body", colnames(mydata))

# change all column names to lower case
colnames(mydata)<-tolower(colnames(mydata))

# get the average of each variable for each activity and each subject
mymeans<-aggregate(mydata[,3:68], by=list(mydata$subjectid, mydata$activity), FUN=mean)

# set group column names back to proper values
colnames(mymeans)[1:2]<-c("subjectid", "activity")

# now we have the final tidy data set
# ordered by subject, so we can see easily that each subject should have all 6 activities
mymeans<-mymeans[order(mymeans$subjectid, mymeans$activity),]

