library(tidyverse)
library(caret)
library(mlbench)


## train control
## change resampling technique

## golden rule : K-Fold CV
set.seed(42)
ctrl <- trainControl(
  method = "cv",
  number = 5,
  verboseIter = TRUE
)


model <- train(medv ~ rm + b + crim,
               data = train_data,
               method = "lm",
               trControl = ctrl) #trControl is train control

# variable Importance
varImp(model)

# see stat of model
model$finalModel %>%
  summary()


set.seed(25)
ctrl <- trainControl(
  method = "cv",
  number = 5,
  verboseIter = TRUE
)
# add preProcess
model <- train(medv ~ rm + b + crim,
               data = train_data,
               method = "lm",
               preProcess = c("center","scale"),
               trControl = ctrl)


# Do K-nearest Neightbors
set.seed(25)
ctrl <- trainControl(
  method = "cv",
  number = 5,
  verboseIter = TRUE
)
# add preProcess
# hyperparameter tuning in train process
model <- train(medv ~ rm + b + crim + lstat + age,
               data = train_data,
               method = "knn",
               preProcess = c("range","zv","nzv"),
               tuneLength = 5,
               trControl = ctrl)
## predict test set
p <- predict(model,newdata = test_data)

# rmse for test set
cal_rmse(actual = test_data$medv , p)


## train final model using k = 5 
model_k5 <- train(medv ~ rm + b + crim + lstat + age,
      data = train_data,
      method = "knn",
      tuneGRid = data.frame(k=5),
      preProcess = c("range","zv","nzv"),
      trControl = trainControl(method = "none"))

p_train <- predict(model_k5)
p_test <- predict(model_k5,newdata = test_data)

rmse_train <- cal_rmse(train_data$medv, p_train)
rmse_test <- cal_rmse(test_data$medv , p_test)

rmse_train; rmse_test






