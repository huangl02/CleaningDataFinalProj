library(dplyr)
library(data.table)

#Change the directory to UCI HAR Dataset
##to go to higher direct use setwd("../")

#read the following txt files using read.table("filename.txt")
#1)activity_lables.txt (6 x 2, which has 6 activity names)
#2)features.txt (561 x 2 which has column names for X_train and X_test)
#3)X_train (7352 x 561,which has all training raw data of all measurements)
#4)y_train (7352 x 1, which has all training activity index)
#5)subject_train (7352 x 1, which has all training subject index)
#6)X_test (2947 x 561, which has all test raw data of all measurements)
#7)y_test (2947 x 1, which has all test activity index)
#8)subject_test (2947 x 1, which has all test subject index)
activity_labels<-read.table("./activity_labels.txt")
features<-read.table("./features.txt")
X_train<-read.table("./train/X_train.txt")
y_train<-read.table("./train/y_train.txt")
subject_train<-read.table("./train/subject_train.txt")
X_test<-read.table("./test/X_test.txt")
y_test<-read.table("./test/y_test.txt")
subject_test<-read.table("./test/subject_test.txt")

#column bind subject index, activity index, and raw data 
#for both train and test sets
train<-cbind(subject_train, y_train, X_train)
test<-cbind(subject_test, y_test, X_test)

#row bind train and test sets
merged<-rbind(train, test)

#Extract column names from features.txt
y<-features$V2

#Change column names (1st column called subject, 2nd column called activity,
#and pass y to the rest of the column names
colnames(merged)<-c("subject", "activity",as.character(y))

#change values in the activity column to the name of activity
z<-activity_labels$V2 # extract activity names
merged$activity<-factor(merged$activity, labels=z) 

#Extract column names than contain mean() or std()
#\\ is used here to get mean() or std(), otherwise (), a metacharacter, has other function
i<-grep("mean\\()|std\\()", names(merged))
merged2<-merged[,c(1,2,i)] #also need column 1 and 2

#Save the merged dataset to "meanstd.txt"
write.table(merged2, file="meanstd.txt")

#question 5

#group by subject then activity, summarize with mean of each column
q5<-merged2 %>% group_by(subject, activity) %>% summarise_all(funs(mean))

write.table(q5, file="./secondDataSet.txt")


