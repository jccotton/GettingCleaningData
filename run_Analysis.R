
##The following R script will:
##1. Merges the training and the test sets to create one data set.
##2. Extracts only the measurements on the mean and standard deviation for each measurement.
##3. Uses descriptive activity names to name the activities in the data set
##4. Appropriately labels the data set with descriptive variable names.
##5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.



##Step 1. Merges the data sets
require("dplyr")


##This script assumes the data has beend downloaded and unpacked to:
setwd("C:/Users/cottonj/Documents/Coursera/UCI HAR Dataset")

##The below section reads in the various tables
datTrain <- tbl_df(read.table("./train/X_train.txt"))
datTest <- tbl_df(read.table("./test/X_test.txt"))

subTrain <- tbl_df(read.table("./train/subject_train.txt"))
subTest <- tbl_df(read.table("./test/subject_test.txt"))

actTrain <- tbl_df(read.table("./train/Y_train.txt"))
actTest <- tbl_df(read.table("./test/Y_test.txt"))


##This part row binds the two subject datasets
subject <- rbind(subTrain, subTest)
colnames(subject) <- c("Subject")

##This part row binds the two activity datasets
activities <- rbind(actTrain, actTest)
colnames(activities) <- c("Activity")


##This part row binds the two data datasets and reads in the features file to name the columns
data <- rbind(datTrain, datTest)
features <- read.table("./features.txt")
colnames(data) <- as.vector(features[,2])


##This line column binds the three data sets together producing the merged data set
merData <- cbind(subject, activities, data)


##2. Extracts only the columns with means and standard deviations
extract <- merData[,grepl("mean|std", colnames(merData))]


##3. Adds in the activity labels to the data set
actLabels <- read.table("./activity_labels.txt")
colnames(actLabels) <- c("ID", "Label")
merData <- merge(actLabels, merData , by.x="ID", by.y = "Activity", all.x=TRUE)

##4. Labels the variable names as descriptive

colnames(merData) <- gsub("std()", "Standard Deviation", colnames(merData))
colnames(merData) <-gsub("^t", "Time", colnames(merData))
colnames(merData) <-gsub("Gyro", "Gyroscope", colnames(merData))
colnames(merData) <-gsub("Mag", "Magnitude", colnames(merData))
colnames(merData) <-gsub("^f", "Frequency", colnames(merData))
colnames(merData) <-gsub("Acc", "Accelerometer", colnames(merData))

##5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

tidy <- merData %>% group_by(Label, Subject) %>% summarise_each(funs(mean))
