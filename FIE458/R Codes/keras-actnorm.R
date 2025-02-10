N.row <- 2000
N.col <- 20
N.epochs <- 20

set.seed(1)

fn <- function (x) {
  sin(x[,1] * x[,2] * x[,3] + x[,4] * x[,5]) + cos(x[,6] * x[,7])*x[,8] + (x[,9] > x[,10])*x[,11]
}

x.train <- matrix(rnorm(N.row * N.col), ncol=N.col)
y.train <- fn(x.train)  + rnorm(N.row, 0, 1)

x.test <-  matrix(rnorm(N.row * N.col), ncol=N.col)
y.test <- fn(x.test)  + rnorm(N.row, 0, 1)

sigmoid.model <- keras_model_sequential()
sigmoid.model %>%
    layer_dense(units=64, activation="sigmoid") %>%
    layer_dense(units=32, activation="sigmoid") %>%
    layer_dense(units=16, activation="sigmoid") %>%
    layer_dense(units=1)
sigmoid.model %>% compile(loss="mse", optimizer="adam")
sigmoid.history <- sigmoid.model %>% fit(x.train, y.train, epochs=N.epochs, validation_split=0.2)

relu.model <- keras_model_sequential()
relu.model %>%
    layer_dense(units=64, activation="relu") %>%
    layer_dense(units=32, activation="relu") %>%
    layer_dense(units=16, activation="relu") %>%
    layer_dense(units=1)
relu.model %>% compile(loss="mse", optimizer="adam")
relu.history <- relu.model %>% fit(x.train, y.train, epochs=N.epochs, validation_split=0.2)

leaky.relu.model <- keras_model_sequential()
leaky.relu.model %>%
    layer_dense(units=64) %>%
    layer_activation_leaky_relu(alpha=0.3) %>%
    layer_dense(units=32) %>%
    layer_activation_leaky_relu(alpha=0.3) %>%
    layer_dense(units=16) %>%
    layer_activation_leaky_relu(alpha=0.3) %>%
    layer_dense(units=1)
leaky.relu.model %>% compile(loss="mse", optimizer="adam")
leaky.relu.history <- leaky.relu.model %>% fit(x.train, y.train, epochs=N.epochs, validation_split=0.2)

param.relu.model <- keras_model_sequential()
param.relu.model %>%
    layer_dense(units=64) %>%
    layer_activation_parametric_relu() %>%
    layer_dense(units=32) %>%
    layer_activation_parametric_relu() %>%
    layer_dense(units=16) %>%
    layer_activation_parametric_relu() %>%
    layer_dense(units=1)
param.relu.model %>% compile(loss="mse", optimizer="adam")
param.relu.history <- param.relu.model %>% fit(x.train, y.train, epochs=N.epochs, validation_split=0.2)

swish.model <- keras_model_sequential()
swish.model %>%
    layer_dense(units=64, activation="swish") %>%
    layer_dense(units=32, activation="swish") %>%
    layer_dense(units=16, activation="swish") %>%
    layer_dense(units=1)
swish.model %>% compile(loss="mse", optimizer="adam")
swish.history <- swish.model %>% fit(x.train, y.train, epochs=N.epochs, validation_split=0.2)


gelu.model <- keras_model_sequential()
gelu.model %>%
    layer_dense(units=64, activation="gelu") %>%
    layer_dense(units=32, activation="gelu") %>%
    layer_dense(units=16, activation="gelu") %>%
    layer_dense(units=1)
gelu.model %>% compile(loss="mse", optimizer="adam")
gelu.history <- gelu.model %>% fit(x.train, y.train, epochs=N.epochs, validation_split=0.2)

bn.relu.model <- keras_model_sequential()
bn.relu.model %>%
    layer_dense(units=64, activation="relu") %>%
    layer_batch_normalization() %>%
    layer_dense(units=32, activation="relu") %>%
    layer_batch_normalization() %>%
    layer_dense(units=16, activation="relu") %>%
    layer_batch_normalization() %>%
    layer_dense(units=1)
bn.relu.model %>% compile(loss="mse", optimizer="adam")
bn.relu.history <- bn.relu.model %>% fit(x.train, y.train, epochs=N.epochs, validation_split=0.2)

bn.sigmoid.model <- keras_model_sequential()
bn.sigmoid.model %>%
    layer_dense(units=64, activation="sigmoid") %>%
    layer_batch_normalization() %>%
    layer_dense(units=32, activation="sigmoid") %>%
    layer_batch_normalization() %>%
    layer_dense(units=16, activation="sigmoid") %>%
    layer_batch_normalization() %>%
    layer_dense(units=1)
bn.sigmoid.model %>% compile(loss="mse", optimizer="adam")
bn.sigmoid.history <- bn.sigmoid.model %>% fit(x.train, y.train, epochs=N.epochs, validation_split=0.2)

ln.relu.model <- keras_model_sequential()
ln.relu.model %>%
    layer_dense(units=64, activation="relu") %>%
    layer_layer_normalization() %>%
    layer_dense(units=32, activation="relu") %>%
    layer_layer_normalization() %>%
    layer_dense(units=16, activation="relu") %>%
    layer_layer_normalization() %>%
    layer_dense(units=1)
ln.relu.model %>% compile(loss="mse", optimizer="adam")
ln.relu.history <- ln.relu.model %>% fit(x.train, y.train, epochs=N.epochs, validation_split=0.2)

ln.sigmoid.model <- keras_model_sequential()
ln.sigmoid.model %>%
    layer_dense(units=64, activation="sigmoid") %>%
    layer_layer_normalization() %>%
    layer_dense(units=32, activation="sigmoid") %>%
    layer_layer_normalization() %>%
    layer_dense(units=16, activation="sigmoid") %>%
    layer_layer_normalization() %>%
    layer_dense(units=1)
ln.sigmoid.model %>% compile(loss="mse", optimizer="adam")
ln.sigmoid.history <- ln.sigmoid.model %>% fit(x.train, y.train, epochs=N.epochs, validation_split=0.2)

elu.model <- keras_model_sequential()
elu.model %>%
    layer_dense(units=64, activation="elu") %>%
    layer_dense(units=32, activation="elu") %>%
    layer_dense(units=16, activation="elu") %>%
    layer_dense(units=1)
elu.model %>% compile(loss="mse", optimizer="adam")
elu.history <- elu.model %>% fit(x.train, y.train, epochs=N.epochs, validation_split=0.2)

snn.model <- keras_model_sequential()
snn.model %>%
    layer_alpha_dropout(rate=0.05) %>%
    layer_dense(units=64, kernel_initializer="lecun_normal", activation="selu") %>%
    layer_alpha_dropout(rate=0.05) %>%
    layer_dense(units=32, kernel_initializer="lecun_normal", activation="selu") %>%
    layer_alpha_dropout(rate=0.05) %>%
    layer_dense(units=16, kernel_initializer="lecun_normal", activation="selu") %>%
    layer_alpha_dropout(rate=0.05) %>%
    layer_dense(units=1)
snn.model %>% compile(loss="mse", optimizer="adam")
snn.history <- snn.model %>% fit(x.train, y.train, epochs=N.epochs, validation_split=0.2)

scores <- list()

scores$sigmoid = sigmoid.model %>% evaluate(x.test, y.test)
scores$relu = relu.model %>% evaluate(x.test, y.test)
scores$leaky.relu = leaky.relu.model %>% evaluate(x.test, y.test)
scores$param.relu = param.relu.model %>% evaluate(x.test, y.test)
scores$swish = swish.model %>% evaluate(x.test, y.test)
scores$gelu = gelu.model %>% evaluate(x.test, y.test)
scores$bn.relu = bn.relu.model %>% evaluate(x.test, y.test)
scores$bn.sigmoid = bn.sigmoid.model %>% evaluate(x.test, y.test)
scores$ln.relu = ln.relu.model %>% evaluate(x.test, y.test)
scores$ln.sigmoid = ln.sigmoid.model %>% evaluate(x.test, y.test)
scores$elu = elu.model %>% evaluate(x.test, y.test)
scores$snn = snn.model %>% evaluate(x.test, y.test)

print(sort(simplify2array(scores)))

