##  Name:    run_analysis.R
##  Purpose: This script collects data from multiple sources, combine them a single dataset
##               and applies the aggregate function to produce a tidy data set that can be used
##               for further analysis.
##
##           The input data for this comes from 
##             https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
##
##  Output:  This will produce a file "tidy.txt" with the cleaned up data.

## set the working directory and download the file, and unzip it
setwd('C:/Avinash/Coursera/datasciencecoursera/Getting and Cleaning Data - Week 3 Project 2')
file <- "getdata_projectfiles_UCI HAR Dataset.zip"
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl, file, mode = "wb" )
unzip(zipfile = "getdata_projectfiles_UCI HAR Dataset.zip", exdir = "C:/Avinash/Coursera/datasciencecoursera/Getting and Cleaning Data - Week 3 Project 2" , overwrite = TRUE)

## Read the datasets
sbjtrn = read.table('./UCI HAR Dataset/train/subject_train.txt',header=FALSE); 
sbjtst = read.table('./UCI HAR Dataset/test/subject_test.txt',header=FALSE); 
xtrn   = read.table('./UCI HAR Dataset/train/x_train.txt',header=FALSE); 
ytrn   = read.table('./UCI HAR Dataset/train/y_train.txt',header=FALSE); 
xtst   = read.table('./UCI HAR Dataset/test/x_test.txt',header=FALSE); 
ytst   = read.table('./UCI HAR Dataset/test/y_test.txt',header=FALSE); 
features = read.table('./UCI HAR Dataset/features.txt',header=FALSE); 
actlbl = read.table('./UCI HAR Dataset/activity_labels.txt',header=FALSE); 

# 1. Merge the training and test sets to create one data set
cbdx <- rbind(xtrn,xtst) 
cbdy <- rbind(ytrn,ytst) 
cbds <- rbind(sbjtrn,sbjtst)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
colvw = grep("*mean*|*std*", features$V2,ignore.case = TRUE)
cbdx <- cbdx[,colvw]
colnames(cbdx) <- features[colvw, 2]

# 3. Use descriptive activity names to name the activities in the data set
cbdy[, 1] <- actlbl[cbdy[, 1], 2]
colnames(cbdy) <- "Activity"

# 4. Appropriately labels the data set with descriptive variable names
colnames(cbds) <- "Subject"
fnlcmbd <- cbind(cbdx, cbdy, cbds)

# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject
tidy <- ddply(fnlcmbd, .(subject, activity), function(x) colMeans(x[, 1:66]))
write.table(tidy, "tidy_data.txt", row.name=FALSE)

