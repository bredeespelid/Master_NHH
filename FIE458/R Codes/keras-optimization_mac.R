# remove.packages("keras")
# install.packages("keras3")

library(keras3) 

N.row <- 2000
N.col <- 20
N.epochs <- 20

set.seed(1)

fn <- function (x) {
  sin(x[,1] * x[,2] * x[,3] + x[,4] * x[,5]) + cos(x[,6] * x[,7])*x[,8]
}

x.train <- matrix(rnorm(N.row * N.col), ncol=N.col)
y.train <- fn(x.train)  + rnorm(N.row, 0, 0.1)

x.test <-  matrix(rnorm(N.row * N.col), ncol=N.col)
y.test <- fn(x.test)  + rnorm(N.row, 0, 0.1)

model.shallow <- keras_model_sequential()
model.shallow %>% layer_dense(units = 10, activation="relu")
model.shallow %>% layer_dense(units = 1)
model.shallow %>% compile(
                  loss = "mse",
                  optimizer = optimizer_sgd(learning_rate=0.01)
              )

history.shallow <- model.shallow %>% fit( x.train, y.train, epochs=N.epochs, validation_split = 0.1)

plot(history.shallow)

model.shallow.adam <- keras_model_sequential()
model.shallow.adam %>% layer_dense(units = 10, activation="relu")
model.shallow.adam %>% layer_dense(units = 1)
model.shallow.adam %>% compile(
  loss = "mse",
  optimizer = optimizer_adam()
)

history.shallow.adam <- model.shallow.adam %>% fit( x.train, y.train, epochs=N.epochs, validation_split = 0.1)


plot(history.shallow.adam)


model.deep <- keras_model_sequential()
model.deep %>% layer_dense(units = 20, activation="relu")
model.deep %>% layer_dense(units = 10, activation="relu")
model.deep %>% layer_dense(units = 1)
model.deep %>% compile(
                  loss = "mse",
                  optimizer = optimizer_sgd(learning_rate=0.01)
              )

history.deep <- model.deep %>% fit( x.train, y.train, epochs=N.epochs, validation_split = 0.1)

plot(history.deep)


model.deep.adam <- keras_model_sequential()
model.deep.adam %>% layer_dense(units = 20, activation="relu")
model.deep.adam %>% layer_dense(units = 10, activation="relu")
model.deep.adam %>% layer_dense(units = 1)
model.deep.adam %>% compile(
  loss = "mse",
  optimizer = optimizer_adam()
)

history.deep.adam <- model.deep.adam %>% fit( x.train, y.train, epochs=N.epochs, validation_split = 0.1)

plot(history.deep.adam)


model.shallow %>% evaluate(x.train, y.train)
model.shallow.adam %>% evaluate(x.train, y.train)
model.deep %>% evaluate(x.train, y.train)
model.deep.adam %>% evaluate(x.train, y.train)

model.shallow %>% evaluate(x.test, y.test)
model.shallow.adam %>% evaluate(x.test, y.test)
model.deep %>% evaluate(x.test, y.test)
model.deep.adam %>% evaluate(x.test, y.test)


