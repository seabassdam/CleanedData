### Cleaning Data Project - run_analysis
### Merge training sets , tidy data, add descriptive activity names
### to data set, and add descriptive labels.



library(data.table)
library(reshape2)

## Download and unzip the dataset:
filename <- "getdata_dataset.zip"
if (!file.exists(filename)){
        fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
        download.file(fileURL, filename, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
        unzip(filename) 
}


## load Features and Activity Labels
activity <- read.table("UCI HAR Dataset/activity_labels.txt")
activity[,2] <- as.character(activity[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

## Select feature names
features.cols <- grep("-mean()|-std()",features[,2])
features.names <- features[features.cols,2]

## load training/test data

xtrain<-read.table(file="UCI HAR Dataset/train/x_train.txt")[features.cols]
ytrain<-read.table(file="UCI HAR Dataset/train/y_train.txt")
subXtrain<-read.table(file="UCI HAR Dataset/train/subject_train.txt")

train <- cbind(subXtrain,ytrain,xtrain)

xtest<-read.table(file="UCI HAR Dataset/test/x_test.txt")[features.cols]
ytest<-read.table(file="UCI HAR Dataset/test/y_test.txt")
subXtest<-read.table(file="UCI HAR Dataset/test/subject_test.txt")

test <- cbind(subXtest,ytest,xtest)

## Merge training/test data and add labels
combine <- rbind(train,test)
colnames(combine) <- c("volunteer","activity",features.names)
combine$activity <- factor(combine$activity, levels = activity[,1],labels=activity[,2])


## Melt data to have voluteer,activity, and features on y axis
combine.melt <- melt(combine, id=c("volunteer","activity"))

## Average all variables
combine.mean <- dcast(combine.melt, volunteer + activity ~ variable, mean)

## Export table as text
write.table(combine.mean, "cleanedData.txt", row.names = FALSE, quote = FALSE)