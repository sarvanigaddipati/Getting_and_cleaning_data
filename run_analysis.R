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