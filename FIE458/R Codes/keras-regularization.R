N.row <- 2000
N.col <- 20

set.seed(1)

x.train <- matrix(rnorm(N.row * N.col), ncol=N.col)
y.train <- x.train[,1] + x.train[,2] + x.train[,3] + rnorm(N.row, 0, 100)

x.test <-  matrix(rnorm(N.row * N.col), ncol=N.col)
y.test <- x.test[,1] + x.test[,2] + x.test[,3] + rnorm(N.row, 0, 100)


model.reg <- keras_model_sequential()
model.reg %>% layer_dense(units = 1)
model.reg %>% compile(
                  loss = "mse",
                  optimizer = optimizer_sgd(learning_rate=0.01)
              )

history.reg <- model.reg %>% fit( x.train, y.train, epochs=100, validation_split = 0.1)

plot(history.reg)

model.ridge <- keras_model_sequential()
model.ridge %>% layer_dense(units = 1, kernel_regularizer = regularizer_l2(1))
model.ridge %>% compile(
                  loss = "mse",
                  optimizer = optimizer_sgd(learning_rate=0.01)
              )

history.ridge <- model.ridge %>% fit( x.train, y.train, epochs=100, validation_split = 0.1)

plot(history.ridge)

model.lasso <- keras_model_sequential()
model.lasso %>% layer_dense(units = 1, kernel_regularizer = regularizer_l1(1))
model.lasso %>% compile(
                  loss = "mse",
                  optimizer = optimizer_sgd(learning_rate=0.01)
              )

history.lasso <- model.lasso %>% fit( x.train, y.train, epochs=100, validation_split = 0.1)

plot(history.lasso)

model.enet <- keras_model_sequential()
model.enet %>% layer_dense(units = 1, kernel_regularizer = regularizer_l1_l2(0.5, 0.5))
model.enet %>% compile(
                  loss = "mse",
                  optimizer = optimizer_sgd(learning_rate=0.01)
              )

history.enet <- model.enet %>% fit( x.train, y.train, epochs=100, validation_split = 0.1)

plot(history.enet)

model.dropout <- keras_model_sequential()
model.dropout %>% layer_dropout(input_shape=N.col, rate=0.5)
model.dropout %>% layer_dense(units = 1, kernel_regularizer = regularizer_l1_l2(0.05, 0.05))

model.dropout %>% compile(
                  loss = "mse",
                  optimizer = optimizer_sgd(learning_rate=0.01)
                  )

history.dropout <- model.dropout %>% fit( x.train, y.train, epochs=100, validation_split = 0.1)

best <- function (history) {
    c(loss=min(history$metrics$val_loss), epoch=which.min(history$metrics$val_loss))
}

print("Regression")
print(best(history.reg))
print("Ridge")
print(best(history.ridge))
print("Lasso")
print(best(history.lasso))
print("Elastic Net")
print(best(history.enet))
print("Dropout")
print(best(history.dropout))

print(model.reg %>% evaluate(x.test, y.test))
print(model.ridge %>% evaluate(x.test, y.test))
print(model.lasso %>% evaluate(x.test, y.test))
print(model.enet %>% evaluate(x.test, y.test))
print(model.dropout %>% evaluate(x.test, y.test))










