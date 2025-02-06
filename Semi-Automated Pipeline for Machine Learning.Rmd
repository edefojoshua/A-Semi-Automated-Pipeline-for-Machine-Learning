# Semi-Automated Pipeline in Machine Learning

# Step 1: Objective and Preparing the Pipeline Environment
## The purpose is to demonstrate how to automate a pipeline using R in machine learning

## Libraries
library(caTools)
library(dplyr)
library(tidyverse)
# install.packages("taskscheduleR")
library(taskscheduleR)
# install.packages("rdflib")
library(rdflib)

## Set working directory (Ensure this path is correct for your system)
setwd("C:/Users/joe62/OneDrive - Aberystwyth University/Apps/Desktop/Destop Folder/R code")

# Step 2 - Develop Modular R Scripts

## Data Ingestion
data <- read.csv("ep.csv", stringsAsFactors = FALSE)
### Save the ingested data
saveRDS(data, "data/ingested_data.rds")

### Save the ingestion process as an R script (if needed)
ingestion_script <- '
## Data Ingestion
data <- read.csv("ep.csv", stringsAsFactors = FALSE)
saveRDS(data, "data/ingested_data.rds")'
writeLines(ingestion_script, "scripts/ingested_data.R")


## Data Validity Check and Data Cleaning
data <- readRDS("data/ingested_data.rds") %>% 
  drop_na()

### Additional validity checks
head(data)
str(data)
summary(data)
pairs(data)  # Instead of plot(data) for better visualization

### Save the validated data
saveRDS(data, "data/validated_data.rds")

data_validation_script <- '
## Data Validity Check and Data Cleaning

library(dplyr)
library(tidyr)

# Load the ingested data
data <- readRDS("data/ingested_data.rds") %>%
  drop_na()  # Remove any rows with missing values

# Additional validity checks
head(data)
str(data)
summary(data)
pairs(data)  # Instead of plot(data) for better visualization

# Save the validated data
saveRDS(data, "data/validated_data.rds")
'
### Save the validated process as an R script (if needed)
## Data Validity Check and Data Cleaning
data_validation_script <- '
## Data Validity Check and Data Cleaning

library(dplyr)
library(tidyr)

### Load the ingested data
data <- readRDS("data/ingested_data.rds") %>%
  drop_na()  # Remove any rows with missing values

### Additional validity checks
head(data)
str(data)
summary(data)
pairs(data)  # Instead of plot(data) for better visualization

### Save the validated data
saveRDS(data, "data/validated_data.rds")
'

### Save the validation process as an R script
writeLines(data_validation_script, "scripts/validated_data.R")

## Machine Learning (Regression Algorithm)
### Set seed for reproducibility
set.seed(123)

### Load the validated data
data <- readRDS("data/validated_data.rds")

### Check for multicollinearity and correlation of independent variables with dependent variable
cor_matrix <- cor(data, method = "pearson", use = "complete.obs")
print(cor_matrix)

### No multicollinearity detected
### Correlation between `qol` and `n_med` is weak, so drop `n_med`
### Best model will be: qol ~ n_epil + adh

### Splitting the dataset (80% training, 20% testing)
split <- sample.split(data$qol, SplitRatio = 0.8)
train <- subset(data, split == TRUE)
test <- subset(data, split == FALSE)

### Create and use the features without multicollinearity

### Best R Model
R_best_model <- lm(qol ~ n_epil + adh, data = train)
summary(R_best_model)

### Using the model as a predictive tool
predictions <- predict(R_best_model, newdata = test)

### Validating the model

## Comparing predicted vs actual values
plot(test$qol, type = 'l', lty = 1.8, col = 'red')
lines(predictions, type = 'l', lty = 1.8, col = 'blue')

### Finding accuracy (RMSE)
rmse <- sqrt(mean((test$qol - predictions)^2))
rmse

### Save the validated machine learning data
saveRDS(data, "data/machine_learning_data.rds")

### Save the validated machine learning data
saveRDS(data, "data/machine_learning_data.rds")




### Save the machine learning process as an R script (if needed)
machine_learning_script <- '
## Data Validity Check and Data Cleaning

library(dplyr)
library(tidyr)

### Load the ingested data
data <- readRDS("data/ingested_data.rds") %>%
  drop_na()  # Remove any rows with missing values

### Additional validity checks
head(data)
str(data)
summary(data)
pairs(data)  # Instead of plot(data) for better visualization

### Save the validated data
saveRDS(data, "data/validated_data.rds")

## Machine Learning (Regression Algorithm)

set.seed(123)

### Load the validated data
data <- readRDS("data/validated_data.rds")

### Check for multicollinearity and correlation of independent variables with dependent variable
cor_matrix <- cor(data, method = "pearson", use = "complete.obs")
print(cor_matrix)

### No multicollinearity detected
### Correlation between `qol` and `n_med` is weak, so drop `n_med`
### Best model will be: qol ~ n_epil + adh

### Splitting the dataset (80% training, 20% testing)
split <- sample.split(data$qol, SplitRatio = 0.8)
train <- subset(data, split == TRUE)
test <- subset(data, split == FALSE)

### Best R Model
R_best_model <- lm(qol ~ n_epil + adh, data = train)
summary(R_best_model)

### Using the model as a predictive tool
predictions <- predict(R_best_model, newdata = test)

# Validating the model
plot(test$qol, type = "l", lty = 1.8, col = "red")
lines(predictions, type = "l", lty = 1.8, col = "blue")

### Finding accuracy (RMSE)
rmse <- sqrt(mean((test$qol - predictions)^2))
rmse

### Save the validated machine learning data
saveRDS(data, "data/machine_learning_data.rds")
'
### Save the machine learning process as an R script
writeLines(machine_learning_script, "scripts/machine_learning_data.R")
           
# Step 3- Create a master script that will execute all scripts sequentially
source("scripts/ingested_data.R")  
source("scripts/validated_data.R")  
source("scripts/machine_learning_data.R") 

# Step 4 - Automation execution
taskscheduler_create(
  taskname = 'Automated_machine_learning_pipeline',  
  rscript = "C:/Users/joe62/OneDrive - Aberystwyth University/Apps/Desktop/Destop Folder/R code/scripts/machine_learning_data.R",       
  schedule = "ONCE",                                
  starttime = "13:33"                           
)

