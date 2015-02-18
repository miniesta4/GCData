# GCData
Getting and cleaning data course.

run_analysis script

The script works as follows.

1.- Merges the training and the test sets to create one data set.

Read activity, subject, test and train sets.
Set variable names to sets using features to test and train sets.
For test and train: column bind activity, subject and features vectors.
Row bind test and train.
The result is one dataset with one observation per row and one named variable per column.

2.- Extracts only the measurements on the mean and standard deviation for each measurement.
Uses grep to select by feature names the mean and std variables
The result dataset has only mean and std measurements

3.- Uses descriptive activity names to name the activities in the data set
Merge activity labels with the dataset to incluide descriptive activity names.

4.- Appropriately labels the data set with descriptive variable names.
Uses grep to give feature names to mean and std variables.

5.- From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
Uses library reshape 2 to melt and cast the previous data set and calculate means.
The result is written to table.txt in current directory.
