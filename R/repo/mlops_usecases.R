# MLOPS with vetiver
# Link https://vetiver.rstudio.com/get-started/
# use case from link relates to mtcars dataset

# install vetiver from CRAN


# import library
library(vetiver)

# import dataset for review
mtcars <- datasets::mtcars

# create regression model
car_mod <- 
  lm(mpg ~ ., data = mtcars)

# create model object
v <- vetiver_model(car_mod, "cars_mpg")

# Store and version model
library(pins)

# write first model to board
model_board <- board_temp(versioned = TRUE)
model_board %>% vetiver_pin_write(v)

# Training a decision tree model
library(rpart)
car_mod <-
  rpart(mpg ~ ., method = "anova", data = mtcars)

# create model object
v <- vetiver_model(car_mod, "cars_mpg")

model_board %>% vetiver_pin_write(v)

# review model versions created
model_board %>% pin_versions("cars_mpg")

# Create a REST API for deployment
library(plumber)

pr() %>%
  vetiver_api(v) %>%
  pr_run(port = 8080)

# Deploy to connect
# authenticates via environment variables:
vetiver_deploy_rsconnect(model_board, "user.name/cars_mpg")
endpoint <- vetiver_endpoint("http://127.0.0.1:8080/predict")
endpoint

# Slice of mtcars for predictions
new_car <- tibble(cyl = 4,  disp = 200, 
                  hp = 100, drat = 3,
                  wt = 3,   qsec = 17, 
                  vs = 0,   am = 1,
                  gear = 4, carb = 2)
predict(endpoint, new_car)

# Article to work with the endpoints and API
# https://appsilon.com/r-rest-api/
