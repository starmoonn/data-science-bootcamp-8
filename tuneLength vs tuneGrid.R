
## tuneLength vs tuneGrid (set K manually)

set.seed(42)
ctrl <- trainControl(
  method = "cv", #k-fold cv
  number = 5,
  verboseIter = TRUE
)

# tuneLength
model <- train(medv ~ rm + b + crim + lstat + age,
               data = train_data,
               method = "knn",
               tuneLength = 5,
               preProcess = c("center","scale"),
               trControl = ctrl)

# tuneGrid
model <- train(medv ~ rm + b + crim + lstat + age,
               data = train_data,
               method = "knn",
               tuneGrid = data.frame(k=c(5,7,13)),
               preProcess = c("center","scale"),
               trControl = ctrl)

model <- train(medv ~ rm + b + crim + lstat + age,
               data = train_data,
               method = "knn",
               metric = "Rsquared",
               tuneGrid = data.frame(k=c(5,7,13)),
               preProcess = c("center","scale"),
               trControl = ctrl)

## ML == Experimentation


## this is better k fold cv
# This Example will repeat model 25 round is k = 5 * repeates = 5 so = 25
set.seed(42)
ctrl <- trainControl(
  method = "repeatedcv", 
  number = 5, # k = 5
  repeats = 5, # repeates = 5
  verboseIter = TRUE
)

model <- train(medv ~ rm + b + crim + lstat + age,
               data = train_data,
               method = "knn",
               metric = "Rsquared",
               tuneGrid = data.frame(k=c(5,7,13)),
               preProcess = c("center","scale"),
               trControl = ctrl)




