## Script: run_analysis.R

## Methods:
1. getData
  - Method to download data from web and extract in data dir
  -  Takes in basePath directory defaulting on my PC to dropBox location
  -  Creates data dir if not there
2. getCombinedJustMeanAndStd
  - Method to get combined dataset with just Mean and Std
  -  Takes in basePath directory defaulting on my PC to dropBox location
  -  Reads files in dataDir
  - 1. Merges the training and the test sets to create one data set.
  - 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
  - 3. Uses descriptive activity names to name the activities in the data set
  - 4. Appropriately labels the data set with descriptive variable names. 
3. getTidyAverageDataSet
  - Method to create tidy average dataset
  -  Takes in a dataset like one created in getCombinedJustMeanAndStd() above
  -  If passed no parameters it runs the first method
  -  From the data set in step 4, creates a second, independent tidy data set 
  -   with the average of each variable for each activity and each subject.
4. writeFinalAverageDataSet
  - Method to write final output in txt file as required
  -  takes in final dataset or creates one

## Usage:
1. To down load data first run "getData( <your working directory> )"
2. To generate data sets run step 2. or 3. above
3. To save final dataset run writeFinalAverageDataSet( <your data set> ) 
