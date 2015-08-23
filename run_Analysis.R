#Load the labels
labels <- read.table("UCI HAR Dataset/activity_labels.txt")
labels[,2] <- as.character(labels[,2])
#get the features
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

#Get the data that is necessary
featuresNeeded <- grep(".*mean.*|.*std.*", features[,2])
featuresNeeded.names <- features[featuresNeeded,2]
featuresNeeded.names = gsub('-mean', 'Mean', featuresNeeded.names)
featuresNeeded.names = gsub('-std', 'Std', featuresNeeded.names)
featuresNeeded.names <- gsub('[-()]', '', featuresNeeded.names)


# Load the datasets
train <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresNeeded]
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)

test <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresNeeded]
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)

# merge datasets and add labels
allData <- rbind(train, test)
colnames(allData) <- c("subject", "activity", featuresNeeded.names)

# turn activities & subjects into factors
allData$activity <- factor(allData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
allData$subject <- as.factor(allData$subject)

allData.melted <- melt(allData, id = c("subject", "activity"))
allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean)

write.table(allData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)