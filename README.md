Getting and Cleaning Data Course Project
========================================

The `run_analysis.R` script takes the [UCI Human Activity Recognition Using
Smartphones Data Set][UCILink] and produces a `tideData.txt` file that contains the
average of the means and standard deviations for each activity and each
subject.

The script assumes that the data is stored in a zip file named
`getdata-projectfiles-UCI HAR Dataset.zip` in the current working directory.
The zip file must contain the data in the following directories:

* UCI HAR Dataset/features.txt
* UCI HAR Dataset/train/X_train.txt
* UCI HAR Dataset/train/y_train.txt
* UCI HAR Dataset/train/subject_train.txt
* UCI HAR Dataset/test/X_test.txt
* UCI HAR Dataset/test/y_test.txt
* UCI HAR Dataset/test/subject_test.txt
* UCI HAR Dataset/activity_labels.txt

The script uses the `unz` function to create a connection to the zip 
file and its contents directly.

Files are read in the following order and purposes:

1.  `UCI HAR Dataset/features.txt`: to obtain the variable names of the data in
the data files.  Stored in a data frame called `header`.
2.  `UCI HAR Dataset/train/X_train.txt`: the training data containing the 
measurements.  The variable names, i.e., headers, are taken from the `header`
data frame and passed to the `read.table()` function's `header` parameter.  
Note that characters such as `(`, `)`, `-` and `,` are converted to `.` by R.  
3.  `UCI HAR Dataset/train/y_train.txt`: the activity label data for each of the
measurements in `UCI HAR Dataset/train/X_train.txt`.  The activities are 
represented by integers 1 through 6.
4.  The training activity label data from 3 is appended to the training data.
5.  `UCI HAR Dataset/train/subject_train.txt`: the subject numbers for each of
the observations in the training data set.
6.  The subject numbers are appended to the training data.
7.  Steps 2 - 6 are repeated for the test data in the `test` directory.
8.  Merge the training and test data sets together using the `rbind()` function.
9.  `UCI HAR Dataset/activity_labels.txt`: the conversion table of the activities
from integers to descriptive phases (e.g., LYING).
10.  Join the activity labels with the merged data set using the `merge()` 
function.  As the first column of the merged data frame contains the common
variable, i.e., the activity label as an integer, it is dropped when assigning
to an environment variable.
11.  Extract only the mean and standard deviation variables.  This is done by
`grep`ing the names in the header containing `mean()` or `std()`.  As the
header names have been loaded into the `header` data frame, a vector of column
indexes is created for the columns containing `mean()` or `std()`.  The
last two columms of the data frame, `Subject`, and `Activity` are also 
included.
12.  Calculate the average of each of the variables in the result of step 11
by activity and subject using the `aggregate()` function.
13.  Write the result of step 12 to file 
`GettingAndCleaningDataCourseProjectTidyData.txt`.,

[UCILink]: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones