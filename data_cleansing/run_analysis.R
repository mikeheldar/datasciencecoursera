## Method to download data from web and extract in data dir
##  Takes in basePath directory defaulting on my PC to dropBox location
##  Creates data dir if not there
getData <- function( basePath = "~/Dropbox/Coursera") {
  # switch to basePath directory 
  setwd(basePath)
  # set data directory name 
  dataDir = "dataDir"
  
  # Create data directory if it doesn't exist
  if(!dir.exists(dataDir)){
    dir.create(dataDir)
  }
  
  # Set destination name for zip file to be downlowded
  zipFileName = "UCI_HAR_Dataset.zip"
  
  # If zip file doesn't exist, download and unzip it to data directory
  if(file.exists(zipFileName)){
    message = "zip file already exists"
  }else{
    message = "file doesn't exist"
    linkToData = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(linkToData,zipFileName)
    message = "file downloaded"
    unzip(zipFileName, overwrite = TRUE, junkpaths = TRUE, exdir = dataDir)
    message = "file unzipped"
  }
  
  # For this we just return the latest message 
  message
}

## Method to get combined dataset with just Mean and Std
##  Takes in basePath directory defaulting on my PC to dropBox location
##  Reads files in dataDir
##  1. Merges the training and the test sets to create one data set.
##  2. Extracts only the measurements on the mean and standard deviation for each measurement. 
##  3. Uses descriptive activity names to name the activities in the data set
##  4. Appropriately labels the data set with descriptive variable names. 
getCombinedJustMeanAndStd <- function(basePath = "~/Dropbox/Coursera") {
  # set data directory name 
  dataDir = "dataDir"
  # switch to dataDir directory 
  setwd(dataDir)
  
  # Read in features and actiities to be labels
  features = read.table("features.txt")
  activitylabels = read.table("activity_labels.txt", col.names = c("activity_id","activity_name"))
  
  # Read in train files using features (and "activity_id") for column names
  xTrain = read.table("X_train.txt",col.names = features[,2])
  yTrain = read.table("Y_train.txt", col.names = c("activity_id"))
  # Read subjects in for train data set
  subject = read.table("subject_train.txt", col.names = c("subject"))
  # Build column to label rows "train" data incase we need later
  dataType = rep("train",nrow(yTrain))
  # bind columns of train together
  train = cbind(dataType,subject,yTrain,xTrain)
  
  # Read in test files using featrues (and "activity_id") for column names
  xTest = read.table("X_test.txt",col.names = features[,2])
  yTest = read.table("Y_test.txt", col.names = c("activity_id"))
  # Read subjects in for test data set
  subject = read.table("subject_test.txt", col.names = c("subject"))
  # Build column to label rows "test" data incase we need later
  dataType = rep("test",nrow(yTest))
  # bind columns of train together
  test = cbind(dataType,subject,yTest,xTest)
  
  # combine train and test rows
  mergedDataSet = rbind(train,test)
  
  # merge activity labels with combined traing and test rows on "activity_id"
  mergedWithLabels = merge(activitylabels,mergedDataSet)
  
  # Filter only columns with subject, activity_name, mean and std (standard deviation)
  justMeanAndStd = mergedWithLabels[ , grepl( "subject" , names( mergedWithLabels ) ) | grepl( "activity_name" , names( mergedWithLabels ) ) | grepl( "mean[.]" , names( mergedWithLabels ) ) | grepl( "std[.]" , names( mergedWithLabels ) )  ]
  
  # switch back to basPath to make sourcing file easier in workspace
  setwd(basePath)
  
  # return dataset built above
  return(justMeanAndStd)
}

## Method to create tidy average dataset
##  Takes in a dataset like one created in getCombinedJustMeanAndStd() above
##  If passed no parameters it runs the first method
##  From the data set in step 4, creates a second, independent tidy data set 
##   with the average of each variable for each activity and each subject.
getTidyAverageDataSet <- function(justMeanAndStd = getCombinedJustMeanAndStd()) {
  library("reshape2")
  
  # melts data on activity_name and subject
  meltedData = melt(justMeanAndStd, id=c("activity_name","subject"))
  
  # summarizes with mean for subject and activity name
  averageData = dcast(meltedData,subject + activity_name ~ variable,mean)
  
  # Returns dataset
  return(averageData)
}

## Method to write final output in txt file as required
##  takes in final dataset or creates one
writeFinalAverageDataSet <- function(finalAverageDataSet = getTidyAverageDataSet()){
  write.table(finalAverageDataSet, file = "~/Dropbox/Coursera/finalAverageDataSet.txt", row.name=FALSE)
}