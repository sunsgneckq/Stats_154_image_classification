#' CVgeneric in R that takes a generic classifier, training features, 
#' training labels, number of folds K and a loss function (at least 
#' classiﬁcation accuracy should be there) as inputs and outputs the 
#' K-fold CV loss on the training set.
# 
#' @param classifier A generic classifier.
#' @param features Training features.
#' @param labels Training labels.
#' @param K The number of folds K.
#' @param data Input Data Frame
#' @param loss A loss function.
#' @param seed Random Seed.
#' @return The K-fold CV loss on the training set.


# Loss metrics
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


CVgeneric = function(classifier, features, labels, K, data, loss, seed){
  set.seed(seed)
  folds = createFolds(data[,labels], k = K)
  if (classifier == "logistic"){
    loss_vec = c()
    formula = paste(paste(labels, "~"), paste(features, collapse = "+"))
    for (f in 1:length(folds) ){
      fit = glm(formula, family = 'binomial', data = data[-folds[[f]], ])
      pred = predict(fit, data[folds[[f]], features])
      pred = ifelse(pred > 0.5, 1, -1)
      loss_vec[f] = loss(pred, data[folds[[f]], labels])
      
      #print(paste("CV score for Fold", f, "is", loss_vec[f]))
    }
  }
  if (classifier=="decision tree"){
    loss_vec = c()
    formula = formula(paste(paste(labels, "~"), paste(features, collapse = "+")))
    for ( f in 1:length(folds) ){
      fit = rpart(formula, data = data[-folds[[f]],], maxdepth =10, minsplit= 10)
      pred = predict(fit, data[folds[[f]], features], type="class")
      #loss[f] = mean(pred == data[folds[[f]], labels])
      loss_vec[f] = loss(pred, data[folds[[f]], labels])
      #print(paste("CV score for Fold", f, "is", loss_vec[f]))
    }
  }
  if (classifier=="random forest"){
    loss_vec = c()
    formula_rf = formula(paste(paste(labels, "~"), paste(features, collapse = "+")))
    for ( f in 1:length(folds) ){
      fit = randomForest(formula_rf, data = data[-folds[[f]],],importance = TRUE,ntree=50,ntry=6,maxnodes= 500, nodesize = 10)
      predicted.classes_rf <- fit %>% predict(data[folds[[f]], features])
      #loss[f] =  mean(predicted.classes_rf == data[folds[[f]], labels])
      loss_vec[f] = loss(predicted.classes_rf, data[folds[[f]], labels])
    }
    
  }
  if (classifier=="lda"){
    loss_vec = c()
    formula_lda = formula(paste(paste(labels, "~"), paste(features, collapse = "+")))
    for ( f in 1:length(folds) ){
      fit = lda(formula_lda, data = data[-folds[[f]],])
      predicted.classes_lda <- fit %>% predict(data[folds[[f]], features])
      # loss[f] =  mean(predicted.classes_lda$class == data[folds[[f]], labels])
      loss_vec[f] = loss(predicted.classes_lda$class, data[folds[[f]],labels])
      #print(paste("CV score for Fold", f, "is", loss_vec[f]))
    }
  }
  result <- list(seed = seed,
                 num_of_folds = K,
                 which_max_loss = which.max(loss_vec),
                 mean_CV_score = mean(loss_vec),
                 CV = data.frame(Fold = c(1:K),
                                 CV_score = loss_vec),
                 index = folds[[which.max(loss_vec)]])
  return(result)
}


