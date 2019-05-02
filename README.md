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
install.packages("fastAdaboaost")
```
Data Import
===========

Read in the data set as data frame for each image separately and rename the column in the order according to the data dictionary 
```
as.data.frame(read.table("image_data/imageX.txt"))
colnames(imageX) [1:11] <- c("y_coordinate", "x_coordinate", "label", 
                             "NDAI", "SD", "CORR", "DF_angle", "CF_angle" , 
                             "BF_angle", "AF_angle", "AN_angle")
```


How to generate the report
==========================
### 1b Summarize data
First set of image generated are the maps of labels using x,y coordinates. 

Then check for any missing value before generating the second image, the histogram of %of pixels for different class for each image.  

```
ggplot(imageX)+ geom_point(alpha = 0.5, aes(x= x_coordinate, y = y_coordinate, 
                                            color = factor(label)))+
  xlab(" x coordinate") +
  ylab(" y coordinate") +
  ggtitle("Coordinate Map imageX with label ")+ 
  theme_bw()
```
### 1c EDA
The first visual EDA plot is the correlation plot of each feature in pairs. The second EDA plot is the distribution of label class for each feature. 

```
corrplot.mixed(cor(total_df[,c(-3, -12)]))
```

The quantitative EDA is a linear model for each feature and compute the r squared value to determine the fit.
```
summary(lm(as.numeric(label)~Features, data = training_data))$r.squared
```

### 2a Data Split
We first remove data points with expert label 0 
```
imageX<- imageX %>% filter(label !=0)
```
The first section generates the train, validation and test set by block, 80-20

The second section generates the train, validation and test set by outcome strata, 80-20

### 2d
CVgeneric function that takes input classifier, features, labels, K, data, loss, seed and returns the CV error across folds. 
```
CVgeneric = function(classifier, features, labels, K, data, loss, seed)
```
### 3 Models
There are four models in total, LDA, logistic regression, decision tree and random forest. The default loss function is accuracy. If want to get other model metrics, change the loss function imput to the desired metric. 

Use the code for ROC function to find the optimum cutoff.

Usage
=====
```
accuracy <- function(pred, actual){
  return(mean(pred == actual))
}
recall <- function(pred, actual){
  tp <- sum(pred==1 & actual == 1)
  fn <- sum(pred == -1 & actual == 1)
  return(tp/(tp+fn))
}
precision <- function(pred, actual){
  tp <- sum(pred == 1 & actual ==1)
  fp <- sum(pred ==1 & actual ==-1)
  return(tp/(tp+fp))
}

```
### 4a
Further analysis on decision tree, using the code to generate the diagram for the optimal tree and feature importance 

```
fit <- rpart(label~.,
   method="anova", data=train_val)
printcp(fit) # display the results 
plotcp(fit)  # Plot the cost complexity and error trade off
varImp(tree) # Importance feature
```
### 4b
Visualize misclassification using ggplot.

Visualize confusion matrix
```
fourfoldplot(table(Predicted, Actual))
```

### 4c
4c 
Run the code for a new model adaboost and the same metrics for other four models
```
adaboost(label~y_coordinate + x_coordinate  + NDAI + SD + CORR + DF_angle + CF_angle+ BF_angle + AF_angle + AN_angle ,data=training data, nIter=10)
```
### 4d
Scatter Plot for misclassification error on decision tree and random forest for both data splitting method



