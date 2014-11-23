<<<<<<< HEAD
##Set path to folder
path <- file.path("C://HHA Files/HaiAik Files//Personal//Coursera//Data Science//WD//UCI HAR Dataset")

##Read Activity Files
testData <- read.table(file.path(path,"test","y_test.txt"),header=FALSE)
trainData <- read.table(file.path(path,"train","y_train.txt"),header=FALSE)

##Read Subject Files
testSubject <- read.table(file.path(path, "test", "subject_test.txt"),header = FALSE)
trainSubject <- read.table(file.path(path, "train" , "subject_train.txt"),header = FALSE)

##Read Features Files
testFeatures  <- read.table(file.path(path, "test" , "X_test.txt" ),header = FALSE)
trainFeatures <- read.table(file.path(path, "train", "X_train.txt"),header = FALSE)

##Read Labels
labels <- read.table(file.path(path, "activity_labels.txt"),header = FALSE)

##Merge Data
data <- rbind(trainData, testData)
subject <- rbind(trainSubject, testSubject)
features<- rbind(trainFeatures, testFeatures)

##Name variables
names(data)<- c("activity")
names(subject)<-c("subject")
featuresNames <- read.table(file.path(path, "features.txt"),head=FALSE)
names(features)<- featuresNames$V2

##Merge columns
combinedata <- cbind(subject, data)
fulldata <- cbind(features, combinedata)

##Keep only std and mean
subfeaturesNames<-featuresNames$V2[grep("mean\\(\\)|std\\(\\)", featuresNames$V2)]
selectNames<-c(as.character(subfeaturesNames), "subject", "activity" )
fulldata<-subset(fulldata,select=selectNames)

##Label variables
names(fulldata)<-gsub("^t", "time", names(fulldata))
names(fulldata)<-gsub("^f", "frequency", names(fulldata))
names(fulldata)<-gsub("Acc", "Accelerometer", names(fulldata))
names(fulldata)<-gsub("Gyro", "Gyroscope", names(fulldata))
names(fulldata)<-gsub("Mag", "Magnitude", names(fulldata))
names(fulldata)<-gsub("BodyBody", "Body", names(fulldata))

##Creates tidy dataset
library(plyr);
data2 <- aggregate(. ~subject + activity, fulldata, mean)
data2 <- data2[order(data2$subject,data2$activity),]
write.table(data2, file = "tidydata.txt",row.name=FALSE)
=======
## Create one R script called run_analysis.R that does the following:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

if (!require("data.table")) {
        install.packages("data.table")
}

if (!require("reshape2")) {
        install.packages("reshape2")
}

require("data.table")
require("reshape2")

# Load: activity labels
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]

# Load: data column names
features <- read.table("./UCI HAR Dataset/features.txt")[,2]

# Extract only the measurements on the mean and standard deviation for each measurement.
extract_features <- grepl("mean|std", features)

# Load and process X_test & y_test data.
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

names(X_test) = features

# Extract only the measurements on the mean and standard deviation for each measurement.
X_test = X_test[,extract_features]

# Load activity labels
y_test[,2] = activity_labels[y_test[,1]]
names(y_test) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"

# Bind data
test_data <- cbind(as.data.table(subject_test), y_test, X_test)

# Load and process X_train & y_train data.
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

names(X_train) = features

# Extract only the measurements on the mean and standard deviation for each measurement.
X_train = X_train[,extract_features]

# Load activity data
y_train[,2] = activity_labels[y_train[,1]]
names(y_train) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"

# Bind data
train_data <- cbind(as.data.table(subject_train), y_train, X_train)

# Merge test and train data
data = rbind(test_data, train_data)

id_labels   = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(data), id_labels)
melt_data      = melt(data, id = id_labels, measure.vars = data_labels)

# Apply mean function to dataset using dcast function
tidy_data   = dcast(melt_data, subject + Activity_Label ~ variable, mean)

write.table(tidy_data, row.name=FALSE,file = "./tidy_data.txt")
>>>>>>> 252bbb7f610594c243fab6f9573f49bb8f24b983
