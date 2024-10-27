library(tidyverse)
library(caret)
library(mlbench)

data("PimaIndiansDiabetes")

df <- PimaIndiansDiabetes

# split data
set.seed(42)
n <- nrow(df)
id <- sample(n, size = 0.8*n)
train_df <- df[id, ]
test_df <- df[-id, ]

#train model
set.seed(42)
ctrl <- trainControl(method = "cv",
                     number = 5,
                     verboseIter = TRUE)

logistic_model <- train(diabetes ~ .,
                        data = train_df,
                        method = "glm",
                        trControl = ctrl)

# score new dataset
p <- predict(logistic_model, newdata = test_df)

#evaluate model
confusionMatrix(p, test_df$diabetes, 
                positive = "pos",
                mode = "prec_recall")


#ridge / lasso regression 

# glmnet model
# regularized regression
#train model
set.seed(42)
ctrl <- trainControl(method = "cv",
                     number = 5,
                     verboseIter = TRUE)

my_grid <- expand.grid(alpha=0:1,
                       lambda = seq(0.0005, 0.05, length = 20))

glmnet_model <- train(diabetes ~ .,
                        data = train_df,
                        method = "glmnet",
                        tuneGrid = my_grid,
                        trControl = ctrl)

## decision tree
# install.packages("rpart")
library(rpart)
library(rpart.plot) # แถม
tree_model <- train(diabetes ~ .,
                      data = train_df,
                      method = "rpart",
                      # cp (complexity parameter)
                      # high cp => good generalization
                      tuneGrid = expand.grid(cp=c(0.02,0.1,0.25)),
                      trControl = ctrl)
rpart.plot(tree_model$finalModel)

## random forest model
## mtry hyperparameter => # columns
rf_model <- train(diabetes ~ .,
                  data = train_df,
                  method = "rf",
                  #tuneGrid = expand.grid(mtry = c(3,5)),
                  tuneLength = 3,
                  trControl = ctrl)



# score new dataset
p <- predict(rf_model, newdata = test_df)

#evaluate model
confusionMatrix(p, test_df$diabetes, 
                positive = "pos",
                mode = "prec_recall")



# resamples() => compare model performance
# predict diabetes

model1 <- train(diabetes ~ .,
                data = train_df,
                method = "glm",
                trControl = trainControl(
                  method = "cv" , number=5
                ))


model2 <- train(diabetes ~ .,
                data = train_df,
                method = "rpart",
                trControl = trainControl(
                  method = "cv" , number=5
                ))


model3 <- train(diabetes ~ .,
                data = train_df,
                method = "rf",
                trControl = trainControl(
                  method = "cv" , number=5
                ))


model4 <- train(diabetes ~ .,
                data = train_df,
                method = "glmnet",
                trControl = trainControl(
                  method = "cv" , number=5
                ))

# พอเราทำ 4 model แล้วเราจะเอาทั้ง 4 model มาเปรียบเทียบกัน
# resamples


list_models = list(
  logistic = model1,
  tree = model2,
  randomForest = model3,
  glmnet = model4
) # I create list for collect 4 model together

result <- resamples(list_models)

summary(result)



# K-Means Clustering

## see available data
data("BostonHousing")

## glimpse data
df <- BostonHousing
glimpse(df)

## clustering => segmentation

subset_df <- df %>%
  select(crim, rm, age, lstat, medv) %>%
  as_tibble()

## test different k (k= 2-5)
result <- kmeans(x = subset_df, centers = 3) # center is จำนวนค่า K
# ขั้นตอนนี้เป็นการใช้คำสั่ง K-Means เพื่อจัดกลุ่มบ้านใน dataset BostonHousing ให้เป็น 3 กลุ่ม

## membership [1,2,3]
subset_df$cluster <- result$cluster


# ลองทำด้วยตัวเอง
data("BostonHousing")

View(BostonHousing)

mini_house <- BostonHousing %>%
  select(medv,rm,age,dis)

# normalization min-max scaling [0-1]
normalize_data <- function(x){
  (x - min(x)) / (max(x)-min(x)) # สูตร ที่เราใช้ในการทำ normalization
} # สิ่งที่เราจะทำตรงนี้คือ เราจะปรับ scale ตัวแปรให้อยู่ในมาตรฐานเดียวกัน

# apply this function to all columns in dataframe
mini_house_norm <- apply(mini_house,2, normalize_data)
View(mini_house_norm)

# try see mini_house
View(mini_house)

# kmeans clustering

km_result <- kmeans(mini_house, centers = 5) 
# เราต้องใส่ center ไปด้วยเพราะ center เป็นตัวบอกว่าเราต้องการที่จะจัดกลุ่มบ้านกี่กลุ่ม
# เริ่มต้นปกติจะอยู่ที่ 3 กลุ่ม

# เราสามารถเอา cluster แต่ละอันขึ้นมาดูได้
# เช่น จะดู size
km_result$size

# assign cluster back to dataframe
mini_house$cluster <- km_result$cluster
View(mini_house)


# run descriptive statistics
mini_house %>%
  group_by(cluster) %>%
  summarise(avg_price = mean(medv),
            avg_rooms = mean(rm))
  
  
  
  
  

