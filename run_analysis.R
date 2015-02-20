## v04 20/2/2015

run_analysis <- function() {

 ##ACTIVITY
 ## Read activity labels
	classes <- c("integer","character")
	activity_labels <- read.table("./activity_labels.txt", colClasses=classes, nrows=6, comment.char="", header=FALSE)
	names(activity_labels) <- c("activityid", "activityname") 

 ## FEATURES
 ## Read features (variable names)
	features <- read.table("./features.txt", colClasses=classes, nrows=561, comment.char="", header=FALSE)
	
 ## Index and names to features mean and std
	features_mean_std_index <- grep("mean\\(\\)|std\\(\\)",features[[2]])
	features_mean_std <- tolower(features[features_mean_std_index,2])
	features_mean_std_w <- gsub("\\(\\)","",features_mean_std)
	features_mean_std_vars <- sapply(features_mean_std_w, function(x) paste0("meanactivitysubject-",x))
 
 
 ## TEST
 ## Read test sets
	classes <- "integer"
	subject_test <- read.table("./test/subject_test.txt", colClasses=classes, nrows=2947, comment.char="", header=FALSE)
	activity_test <- read.table ("./test/y_test.txt", colClasses=classes, nrows=2947, comment.char="", header=FALSE)
	
	classes <- rep("numeric",561)
	x_test <- read.table("./test/X_test.txt", colClasses=classes, nrows=2947, comment.char="", header=FALSE)

 ## Extract features and give names to variables in test sets
	names(subject_test) <- "subjectid"
	names(activity_test) <- "activityid"

	features_test <- x_test[,features_mean_std_index]
	names(features_test) <- features_mean_std_vars

 ## Bind test sets
	test_df <- cbind(subject_test, activity_test, features_test)


 ## TRAIN
 ## Read training sets
	classes <- "integer"
	subject_train <- read.table("./train/subject_train.txt", colClasses=classes, nrows=7352, comment.char="", header=FALSE)
	activity_train <- read.table ("./train/y_train.txt", colClasses=classes, nrows=7352, comment.char="", header=FALSE)
	
	classes <- rep("numeric",561)
	x_train <- read.table("./train/X_train.txt", colClasses=classes, nrows=7352, comment.char="", header=FALSE)

 ## Extract features and give names to variables in train sets
	names(subject_train) <- "subjectid"
	names(activity_train) <- "activityid"	

	features_train <- x_train[,features_mean_std_index]
	names(features_train) <- features_mean_std_vars

 ## Bind train sets
	train_df <- cbind(subject_train, activity_train, features_train)
 
 ## TEST + TRAIN
 ## Bind test dataset and train dataset
	test_train_df <- rbind(test_df, train_df)	

 ## Merge activity by id
	total_df <- merge(activity_labels, test_train_df, by.x="activityid", by.y="activityid", all=FALSE) 
 
 ## Mean by activity and subject
	library(reshape2)
	total_melt <- melt(total_df,id=c("subjectid","activityname"),measure.vars=features_mean_std_vars)
	total_cast <- dcast(total_melt,activityname + subjectid ~ variable,mean)
	write.table (total_cast, file="average_ds.txt", quote=FALSE, row.names=FALSE)

}
