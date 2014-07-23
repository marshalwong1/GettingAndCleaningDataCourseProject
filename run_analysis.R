#  Check that data file exists otherwise exit

if (file.exists("getdata-projectfiles-UCI HAR Dataset.zip")) {

## 1. Merges the training and test sets to create one data set and
## 4. Appropriately label the data set with descriptive variable names.
  
  ## Read headers for descriptive variable names.
  headersCon <- unz("getdata-projectfiles-UCI HAR Dataset.zip", 
                    "UCI HAR Dataset/features.txt")
  headers <- read.table(headersCon, row.names = 1, 
                        col.names = c("row", "name"))
  
  ## Read training data
  trainDataCon <- unz("getdata-projectfiles-UCI HAR Dataset.zip", 
                      "UCI HAR Dataset/train/X_train.txt")
  trainData <- read.table(trainDataCon, col.names = headers$name)

  ## Read training data labels
  trainLabelsCon <- unz("getdata-projectfiles-UCI HAR Dataset.zip", 
                        "UCI HAR Dataset/train/y_train.txt")
  trainLabels <- read.table(trainLabelsCon, col.names = "LabelCode")
  
  ## append training data labels to training data
  trainData$LabelCode <- trainLabels$LabelCode
  
  ## Read training data subjects
  trainSubjectsCon <- unz("getdata-projectfiles-UCI HAR Dataset.zip", 
                          "UCI HAR Dataset/train/subject_train.txt")
  trainSubjects <- read.table(trainSubjectsCon, col.names = "Subject")

  ## append training data labels to training data
  trainData$Subject <- trainSubjects$Subject
  
  ## Read test data
  testDataCon <- unz("getdata-projectfiles-UCI HAR Dataset.zip", 
                     "UCI HAR Dataset/test/X_test.txt")
  testData <- read.table(testDataCon, col.names = headers$name)
  
  ## Read test data labels
  testLabelsCon <- unz("getdata-projectfiles-UCI HAR Dataset.zip", 
                       "UCI HAR Dataset/test/y_test.txt")
  testLabels <- read.table(testLabelsCon, col.names = "LabelCode")
  
  ## append test data labels to test data
  testData$LabelCode <- testLabels$LabelCode

  ## Read test data subjects
  testSubjectsCon <- unz("getdata-projectfiles-UCI HAR Dataset.zip", 
                         "UCI HAR Dataset/test/subject_test.txt")
  testSubjects <- read.table(testSubjectsCon, col.names = "Subject")
  
  ## append training data labels to training data
  testData$Subject <- testSubjects$Subject
    
  ## merge data sets
  data <- rbind(trainData, testData)

## 3. Uses descriptive activity names to name the activities in the data set.

  ## Read activity labels
  activityLabelsCon <- unz("getdata-projectfiles-UCI HAR Dataset.zip", 
                           "UCI HAR Dataset/activity_labels.txt")
  activityLabels <- read.table(activityLabelsCon, 
                               col.names = c("LabelCode", "Activity"))

  ## join the activity labels based on the labelcodes
  ## coder's note: Not a big fan of assuming order of columns (coming from
  ## SQL), but it's the easiest way, I think, without making a long vector of
  ## variable names.
  dataWithActivityLabels <- merge(data, activityLabels, all.x = TRUE)[ , 2:564]
  
## 2. Extract only the measurements on the mean and standard deviation for each 
## measurement, i.e., mean() or std() is in the header name
  meanAndSDData <- dataWithActivityLabels[ , c(grep("mean\\(\\)|std\\(\\)", 
                                                    headers$name), 562, 563)]

## 5. Create a second, independent tidy data set with the average of each
## variable for each activity and each subject.
  tidyData <- aggregate(meanAndSDData[, 1:66], 
                        list(Subject = meanAndSDData$Subject, 
                             Activity = meanAndSDData$Activity), 
                        mean)

## Export tidyData to file
  write.table(tidyData, file="GettingAndCleaningDataCourseProjectTidyData.txt")

} else {
  print("Data file not found.  Please put zipped data in file 
        'getdata-projectfiles-UCI HAR Dataset.zip' in working directory")
  flush.console
}