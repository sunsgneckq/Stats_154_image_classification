# Stats 154 Project 2 image classification 
Overview
========
In this project, we explore different classification models for three MISR images, expert labels of cloudiness and ten other features. We evaluate the fit for each model by the following metrics: accuracy, precision, recall, F1 score and sensitivity. After our compare and contrast, we discuss the applicability of each model to new images, potentially without expert labels.
  
Required packages
=================
```
install.packages("ggplot2")
install.packages("glmnet")
install.packages("adabag")
install.packages("MASS")
install.packages("dplyr")
install.packages("gridExtra")
install.packages("grid")
install.packages("randomForest")
install.packages("corrplot")
install.packages("plot.matrix")
install.packages("cowplot")
install.packages("caret")
install.packages("nnet")
install.packages('e1071')
install.packages("ROCR")
install.packages("precrec")
install.packages("PRROC")
install.packages("pROC")
install.packages("rpart")
install.packages("InformationValue")
install.packages("rpart.plot")
install.packages("rattle")
install.packages("RColorBrewer")
install.packages("dvmisc")
install.packages("MLmetrics")
install.packages("fastAdaboost")
```
Data Import
===========

Read in the data set as data frame for each image separately and rename the column in the order according to the data dictionary 
```
as.data.frame(read.table("image_data/imageX.txt"))
```

How to generate the report
==========================
### 1b Summarize data
First set of image generated are the maps of labels using x,y coordinates. 

Then check for any missing value before generating the second image, the histogram of %of pixels for different class for each image.  

### 1c EDA
The first visual EDA plot is the correlation plot of each feature in pairs. The second EDA plot is the distribution of label class for each feature. 

The quantitative EDA is a linear model for each feature and compute the r squared value to determine the fit.

### 2a Data Split
We first remove data points with expert label 0 

The first section generates the train, validation and test set by block, 80-20

The second section generates the train, validation and test set by outcome strata, 80-20

### 2d
CVgeneric function that takes input classifier, features, labels, K, data, loss, seed and returns the CV error across folds. 

### 3 Models
There are four models in total, LDA, logistic regression, decision tree and random forest. The default loss function is accuracy. If want to get other model metrics, change the loss function imput to the desired metric. 

Usage
=====
```

```

Use the code for ROC function to find the optimal cutoff









