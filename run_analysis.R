# download the zip folder
if(!file.exists("./data")){
  dir.create("./data")
  fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileUrl, destfile="./data/dataset.zip")
}

# unzip the dataset
unzip("./data/dataset.zip", exdir="./data")

# read the files and build datasets
activity <- read.table("UCI HAR Dataset/activity_labels.txt")

features <- read.table("UCI HAR Dataset/features.txt")
features.names <- as.character(features[,2])

train <- read.table("UCI HAR Dataset/train/X_train.txt")
train.subjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train.activities <- read.table("UCI HAR Dataset/train/y_train.txt")
train <- cbind(train.subjects, train.activities, train)

test <- read.table("UCI HAR Dataset/test/X_test.txt")
test.subjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test.activities <- read.table("UCI HAR Dataset/test/y_test.txt")
test <- cbind(test.subjects, test.activities, test)

# combine all data to form a master dataset
MasterData <- rbind(train, test)
colnames(MasterData) <- c("Subject", "Activity", features.names)

# subset the relevant data
relevant.features.names <- grep(".*mean.*|.*std.*", features.names, value = TRUE)
relevant.columns <- c("Subject", "Activity", relevant.features.names)
MasterData <- subset(MasterData, select = relevant.columns)

# add descriptive activity labels to and factorize Activity
MasterData$Activity <- factor(MasterData$Activity, levels = activity[,1], labels = activity[,2])

# add descriptive labels to Features
names(MasterData) <- gsub("^t", "time", names(MasterData))
names(MasterData) <- gsub("^f", "frequency", names(MasterData))
names(MasterData) <- gsub("-mean()", "Mean", names(MasterData))
names(MasterData) <- gsub("-std()", "Std", names(MasterData))
names(MasterData) <- gsub("()", "",names(MasterData))

# create a second independent, tidy data set
library(plyr);
Dataset2 <- aggregate(. ~Subject + Activity, MasterData, mean)
Dataset2 <- Dataset2[order(Dataset2$Subject,Dataset2$Activity),]

write.table(Dataset2, file = "TidyData.txt", row.name=FALSE)

