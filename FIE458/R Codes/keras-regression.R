n.rows <- 2000
n.cols <- 2

set.seed(1)

x.train <- matrix(rnorm(n.rows * n.cols), nrow=n.rows, ncol=n.cols)
y.train <- x.train[,1] + x.train[,2] + rnorm(n.rows)

model <- keras_model_sequential()
model %>% layer_dense(units = 1)
model %>% compile(
              loss = "mse",
              optimizer = optimizer_sgd(learning_rate=0.01)
          )

history <- model %>% fit( x.train, y.train, epochs=100)

plot(history)

plot(model %>% predict(x.train), y.train)
model %>% evaluate(x.train, y.train)

model2 <- keras_model_sequential()
model2 %>% layer_dense(units=20, activation="relu")
model2 %>% layer_dense(units = 1)
model2 %>% compile(
              loss = "mse",
              optimizer = optimizer_sgd(learning_rate=0.01)
          )

history2 <- model2 %>% fit( x.train, y.train, epochs=100)

plot(history2)

plot(model2 %>% predict(x.train), y.train)
model2 %>% evaluate(x.train, y.train)

## What happens if we look at new data?
x.test <-  matrix(rnorm(n.rows), nrow=n.rows, ncol=n.cols)
y.test <- x.test[,1] + x.test[,2] + rnorm(n.rows)

model %>% evaluate(x.test, y.test)
model2 %>% evaluate(x.test, y.test)


model3 <- keras_model_sequential()
model3 %>% layer_dense(units = 1)
model3 %>% compile(
              loss = "mse",
              optimizer = optimizer_sgd(learning_rate=0.01)
           )

history3 <- model3 %>% fit( x.train, y.train, epochs=100, validation_split=0.2)

plot(history3)

model4 <- keras_model_sequential()
model4 %>% layer_dense(units=20, activation="relu")
model4 %>% layer_dense(units = 1)
model4 %>% compile(
              loss = "mse",
              optimizer = optimizer_sgd(learning_rate=0.01)
          )

history4 <- model4 %>% fit( x.train, y.train, epochs=100, validation_split=0.2)

plot(history4)
