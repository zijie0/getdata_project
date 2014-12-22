# Load various datasets
test.subject <- read.table("UCI HAR Dataset/test/subject_test.txt")
test.x <- read.table("UCI HAR Dataset/test/X_test.txt")
test.y <- read.table("UCI HAR Dataset/test/y_test.txt")

train.subject <- read.table("UCI HAR Dataset/train/subject_train.txt")
train.x <- read.table("UCI HAR Dataset/train/X_train.txt")
train.y <- read.table("UCI HAR Dataset/train/y_train.txt")

features <- read.table("UCI HAR Dataset/features.txt")
activity.labels <- read.table("UCI HAR Dataset/activity_labels.txt")

# Merge the test and train subject datasets
subject <- rbind(test.subject, train.subject)
colnames(subject) <- "subject"

# Merge the test and train labels, applying the text labels
label <- rbind(test.y, train.y)
label[,1] <- as.factor(label[,1])
levels(label[,1]) <- as.vector(activity.labels[,2])
colnames(label) <- "Activity"

# Merge the test and train main datasets, applying the text headings
data <- rbind(test.x, train.x)
colnames(data) <- features[, 2]

# Merge all three datasets
data <- cbind(subject, label, data)

# Create a smaller dataset containing only the mean and std variables
col_idx <- grep("-mean|-std", colnames(data))
mean.std.data <- data[,c(1,2,col_idx)]

# Compute the means, grouped by subject/label
means <- aggregate(as.matrix(mean.std.data[,3:81]), 
                   as.list(mean.std.data[,1:2]), FUN=mean)

# Save the resulting dataset
write.table(means, file="tidy_data.txt", row.name=FALSE)

# Output final dataset
means
