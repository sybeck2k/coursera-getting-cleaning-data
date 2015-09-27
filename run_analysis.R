# read data
subject_train_ds <- read.table(file.path("train","subject_train.txt"))
subject_test_ds <- read.table(file.path("test","subject_test.txt"))
x_train_ds <- read.table(file.path("train","X_train.txt"))
x_test_ds <- read.table(file.path("test","X_test.txt"))
y_train_ds <- read.table(file.path("train","y_train.txt"))
y_test_ds <- read.table(file.path("test","y_test.txt"))
features <- read.table("features.txt")
activities <- read.table("activity_labels.txt")

# fix column names
names(subject_train_ds) <- "subject"
names(subject_test_ds) <- "subject"
names(x_train_ds) <- features$V2
names(x_test_ds) <- features$V2
names(y_train_ds) <- "activity"
names(y_test_ds) <- "activity"

# combine ds
train_ds <- cbind(subject_train_ds, y_train_ds, x_train_ds)
test_ds <- cbind(subject_test_ds, y_test_ds, x_test_ds)
combined_ds <- rbind(train_ds, test_ds)

#filter cols of means and std + subject and activity
keepcols <- grepl("\\-mean|\\-std|activity|subject", names(combined_ds))
combined_ds <- combined_ds[, keepcols]

# convert the activity column from integer to factor
combined_ds$activity <- factor(combined_ds$activity, labels=activities$V2)

tidy = aggregate(combined_ds, by=list(subject=combined_ds$subject,activity = combined_ds$activity), mean)

# cleanup
tidy <- tidy[,-c(3,4)]
write.table(tidy, "tidy.txt", sep="\t")

return(tidy)
