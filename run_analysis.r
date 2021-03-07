# Getting and cleaning data project
# Gumer Freire

# Script to perform data processing
# It is assumed that the data is in a "/dataset" subfolder of working directory

# Output of the script
# complete_table - contains the complete tidy dataset
# summary_table - contains average and std deviation per subject and activity

# Steps of the script:
# 1. Load data
# 2. Add columns and join data from two different data sets
# 3. Assign column names and change variable names for readability
# 4. Summary and output




#Load libraries
library(dplyr)

# Load common information. Labels for features and activities
features <- read.table("dataset/features.txt", header=FALSE)
activity_labels <- read.table("dataset/activity_labels.txt", header=FALSE)

# Load test dataset
x_test <- read.table("dataset/test/X_test.txt", header=FALSE)
y_test <- read.table("dataset/test/y_test.txt", header=FALSE)
subject_test <- read.table("dataset/test/subject_test.txt", header=FALSE)

# Test dataset table
# Build a table adding the subject and activity columns to each observation
# train_table contains columns for subject, activity and the 512 features.
test_table <- cbind(subject_test, y_test, x_test)

# Load train dataset
x_train <- read.table("dataset/train/X_train.txt", header=FALSE)
y_train <- read.table("dataset/train/y_train.txt", header=FALSE)
subject_train <- read.table("dataset/train/subject_train.txt", header=FALSE)

# Train dataset table
# Build a table adding the subject and activity columns to each observation
#train_table contains columns for subject, activity and the 512 features.
train_table <- cbind(subject_train, y_train, x_train)

# Complete table
# Build a table the two datasets
# complete_table contains the complete set of data and train observations.
complete_table <- rbind(test_table, train_table)

# Assign column names to the table
# Extract feature names from loaded data and add subject and activity labels
column_names <- c("subject","activity", as.vector(features[,2]))
colnames(complete_table) = column_names

# Assign readable activity names to the original codes in the dataset
# First the names of the activities are changed to lowercase
# Second, the codes in the table are changed for the activity name
activity_labels[2] <- lapply(activity_labels[2], tolower)

for (i in c(1:6)) {
  complete_table$activity <- sub(as.character(activity_labels[i,1]), activity_labels[i,2], complete_table$activity)
}


# Select variables for mean and std data and summarize data set
complete_table <- complete_table %>% select(subject, activity, contains("mean"), contains("std"))
summary_table <- complete_table %>%   group_by(subject, activity) %>%   summarise_all(funs(mean))


# Export final file
write.table(complete_table, "TidyData.txt", row.name=FALSE)
