The R script "run_analysis.R" does the following:

1. Downloads the zip folder if it does not already exist in the working directory and then unzips it.
2. Reads the files in the unzipped directory and build datasets.
3. Combines the datasets built in step 3 to form a master data set.
4. Subsets the master dataset to include only the relevant columns, i.e., those that have mean or standard deviation.
5. Gives meaningful, descriptive labels to the Variables.
6. Creates a second, independent tidy dataset with the average of each variable for each activity and each subject.
