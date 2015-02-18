run_analysis <- function() {

 ##ACTIVITY
 ## Read activity labels
	activity_labels <- read.table("./activity_labels.txt")
	names(activity_labels) <- c("activity_id", "activity_name") 

 ## FEATURES
 ## Read features (variable names)
	features <- read.table("./features.txt")
	
 ## Select features mean and std
	features_mean_std_index <- grep("mean[/(]|std[/(]",features[[2]])
	features_mean_std_vars <- grep("mean[/(]|std[/(]",features[[2]],value=TRUE)
	

 ## TEST
 ## Read test sets
	subject_test <- read.table("./test/subject_test.txt")
	activity_test <- read.table ("./test/y_test.txt")
	x_test <- read.table("./test/X_test.txt")

 ## Extract features and give names to variables in test sets
	names(subject_test) <- "subject_id"
	names(activity_test) <- "activity_id"

	features_test <- x_test[,features_mean_std_index]
	names(features_test) <- features_mean_std_vars

 ## Bind test sets
	test_df <- cbind(subject_test, activity_test, features_test)


 ## TRAIN
 ## Read training sets
	subject_train <- read.table("./train/subject_train.txt")
	activity_train <- read.table ("./train/y_train.txt")
	x_train <- read.table("./train/X_train.txt")

 ## Extract features and give names to variables in train sets
	names(subject_train) <- "subject_id"
	names(activity_train) <- "activity_id"	

	features_train <- x_train[,features_mean_std_index]
	names(features_train) <- features_mean_std_vars

 ## Bind train sets
	train_df <- cbind(subject_train, activity_train, features_train)
 
 ## TEST + TRAIN
 ## Bind test dataset and train dataset
	test_train_df <- rbind(test_df, train_df)	

 ## Merge activity by id
	total_df <- merge(activity_labels, test_train_df, by.x="activity_id", by.y="activity_id", all=FALSE) 
 
 ## Mean by activity and subject
	library(reshape2)
	total_melt <- melt(total_df,id=c("subject_id","activity_name"),measure.vars=features_mean_std_vars)
	total_cast <- dcast(total_melt,activity_name + subject_id ~ variable,mean)
	write.table (total_cast, file="table.txt", quote=FALSE, row.names=FALSE)

}
