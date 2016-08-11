library(reshape2)

# set up current workspace
setwd('/Users/xiasong/Documents/Class_2016/Coursera/datasciencecoursera/Data_cleanning/Assignment')

# download data files from website
URL <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
download.file(URL, destfile='./Dataset.zip', method='curl')

# unzip data files
unzip('Dataset.zip')

# load activity labels and features, meanwhile check the structure and head of data
ActivityLabels <- read.table('UCI HAR Dataset/activity_labels.txt')
head(ActivityLabels)
str(ActivityLabels)
Features <- read.table('UCI HAR Dataset/features.txt')
head(Features)
str(Features)

# when we check the str of ActivityLabels and Features, the second colummn of two dataframes are factor, we should change them to character
ActivityLabels[,2] <- as.character(ActivityLabels[,2])
str(ActivityLabels)
Features[,2] <- as.character(Features[,2])
str(Features)

# extract only the measurements on the mean and standard deviation for each measurement
FeaturesExtracted <- grep(".*mean.*|.*std.*", Features[,2])

# check index of FeaturesExtracted
FeaturesExtracted

# load train datasets and check the structure and head of data
Train <- read.table('UCI HAR Dataset/train/X_train.txt') [FeaturesExtracted]
head(Train)
str(Train)
TrainActivities <- read.table('UCI HAR Dataset/train/Y_train.txt')
head(TrainActivities)
str(TrainActivities)
TrainSubjects <- read.table('UCI HAR Dataset/train/subject_train.txt')
head(TrainActivities)
str(TrainActivities)
Train <- cbind(TrainSubjects, TrainActivities, Train)
head(Train)
str(Train)

# load test datasets and check the structure and head of data
Test <- read.table('UCI HAR Dataset/test/X_test.txt') [FeaturesExtracted]
head(Test)
str(Test)
TestActivities <- read.table('UCI HAR Dataset/test/Y_test.txt')
head(TestActivities)
str(TestActivities)
TestSubjects <- read.table('UCI HAR Dataset/test/subject_test.txt')
head(TestSubjects)
str(TestSubjects)
Test <- cbind(TestSubjects, TestActivities, Test)
head(Test)
str(Test)

# merge train and test datasets and add colummn names
Data <- rbind(Train, Test)
head(Data)
str(Data)

# name the colummns of Data
FeaturesNames <- grep(".*mean.*|.*std.*", Features[,2], value=TRUE)
FeaturesNames <- gsub('-mean', 'Mean', FeaturesNames)
FeaturesNames <- gsub('-std', 'Std', FeaturesNames)
FeaturesNames <- gsub('[-()]', '', FeaturesNames)

colnames(Data) <- c('subject', 'activity',FeaturesNames)

# reset activities and subjects from character to factor, then to calculate the average
Data$subject <- as.factor(Data$subject)
Data$activity <- factor(Data$activity, levels = ActivityLabels[,1], labels = ActivityLabels[,2])

# use melt function to reshape Data dataframe then to calculate the average 
Data.melt <- melt(Data, id = c('subject', 'activity'))
Data.mean <- dcast(Data.melt, subject + activity ~ variable, mean)

# write the required data into your workspace
write.table(Data.mean, 'tidy.txt', row.names =FALSE, quote = FALSE)