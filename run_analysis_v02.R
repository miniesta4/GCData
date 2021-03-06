## v02 19/2/2015

run_analysis <- function() {

 library(data.table)

 ##ACTIVITY
 ## Read activity labels
	activity_labels <- fread("./activity_labels.txt")
	setnames(activity_labels, c("activity_id", "activity_name")) 

 ## FEATURES
 ## Read features (variable names)
	features <- fread("./features.txt")
	
 ## Select features mean and std
	features_mean_std_index <- grep("mean[/(]|std[/(]",features[[2]])
	features_mean_std_vars <- grep("mean[/(]|std[/(]",features[[2]],value=TRUE)
 
 ## Col classes vector
	classes <- rep("numeric",561)
	

 ## TEST
 ## Read test sets
	subject_test <- fread("./test/subject_test.txt")
	activity_test <- fread ("./test/y_test.txt")
	x_test <- as.data.table(read.table("./test/X_test.txt", colClasses=classes, nrows=2947, comment.char=""))

 ## Extract features and give names to variables in test sets
	setnames(subject_test,"subject_id")
	setnames(activity_test,"activity_id")

	features_test <- x_test[,features_mean_std_index,with=FALSE]
	setnames(features_test,features_mean_std_vars)

 ## Bind test sets
	test_table <- cbind(subject_test, activity_test, features_test)


 ## TRAIN
 ## Read training sets
	subject_train <- fread("./train/subject_train.txt")
	activity_train <- fread ("./train/y_train.txt")
	x_train <- as.data.table(read.table("./train/X_train.txt", colClasses=classes, nrows=7352, comment.char=""))

 ## Extract features and give names to variables in train sets
	setnames(subject_train, "subject_id")
	setnames(activity_train, "activity_id")

	features_train <- x_train[,features_mean_std_index,with=FALSE]
	setnames(features_train,features_mean_std_vars)

 ## Bind train sets
	train_table <- cbind(subject_train, activity_train, features_train)
 
 ## TEST + TRAIN
 ## Bind test dataset and train dataset
	test_train_table <- rbind(test_table, train_table)	

 ## Merge activity by id
	setkey(activity_labels,activity_id)
	setkey(test_train_table,activity_id)
	total_table <- merge(activity_labels, test_train_table) 
 
 ## Mean by activity and subject
	library(reshape2)
	total_melt <- melt(total_table,id=c("subject_id","activity_name"),measure.vars=features_mean_std_vars)
	total_cast <- dcast(total_melt,activity_name + subject_id ~ variable,mean)
	write.table (total_cast, file="table_table_v02.txt", quote=FALSE, row.names=FALSE)

}
