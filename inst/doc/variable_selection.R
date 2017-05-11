## ---- echo=FALSE, message=FALSE------------------------------------------
library(olsrr)
library(dplyr)
library(ggplot2)
library(gridExtra)
library(purrr)
library(tibble)
library(nortest)
library(goftest)

## ----allsub--------------------------------------------------------------
model <- lm(mpg ~ disp + hp + wt + qsec, data = mtcars)
ols_all_subset(model)

## ----allsubplot, fig.width=10, fig.height=15, fig.align='center'---------
model <- lm(mpg ~ disp + hp + wt + qsec, data = mtcars)
k <- ols_all_subset(model)
plot(k)

## ----bestsub, size='tiny'------------------------------------------------
model <- lm(mpg ~ disp + hp + wt + qsec, data = mtcars)
ols_best_subset(model)

## ----bestsubplot, fig.width=10, fig.height=15, fig.align='center'--------
model <- lm(mpg ~ disp + hp + wt + qsec, data = mtcars)
k <- ols_best_subset(model)
plot(k)

## ----stepf1--------------------------------------------------------------
# stepwise forward regression
model <- lm(y ~ ., data = surgical)
ols_step_forward(model)

## ----stepf2, fig.width=10, fig.height=15, fig.align='center'-------------
model <- lm(y ~ ., data = surgical)
k <- ols_step_forward(model)
plot(k)

## ----stepwisefdetails----------------------------------------------------
# stepwise forward regression
model <- lm(y ~ ., data = surgical)
ols_step_forward(model, details = TRUE)

## ----stepb, fig.width=10, fig.height=15, fig.align='center'--------------
# stepwise backward regression
model <- lm(y ~ ., data = surgical)
ols_step_backward(model)

## ----stepb2, fig.width=10, fig.height=15, fig.align='center'-------------
model <- lm(y ~ ., data = surgical)
k <- ols_step_backward(model)
plot(k)

## ----stepwisebdetails----------------------------------------------------
# stepwise backward regression
model <- lm(y ~ ., data = surgical)
ols_step_backward(model, details = TRUE)

## ----stepwise1-----------------------------------------------------------
# stepwise regression
model <- lm(y ~ ., data = surgical)
ols_stepwise(model)

## ----stepwise2, fig.width=10, fig.height=15, fig.align='center'----------
model <- lm(y ~ ., data = surgical)
k <- ols_stepwise(model)
plot(k)

## ----stepwisedetails-----------------------------------------------------
# stepwise regression
model <- lm(y ~ ., data = surgical)
ols_stepwise(model, details = TRUE)

## ----stepaicf1-----------------------------------------------------------
# stepwise aic forward regression
model <- lm(y ~ ., data = surgical)
ols_stepaic_forward(model)

## ----stepaicf2, fig.width=5, fig.height=5, fig.align='center'------------
model <- lm(y ~ ., data = surgical)
k <- ols_stepaic_forward(model)
plot(k)

## ----stepwiseaicfdetails-------------------------------------------------
# stepwise aic forward regression
model <- lm(y ~ ., data = surgical)
ols_stepaic_forward(model, details = TRUE)

## ----stepaicb1-----------------------------------------------------------
# stepwise aic backward regression
model <- lm(y ~ ., data = surgical)
k <- ols_stepaic_backward(model)
k

### Plot


## ----stepaicb2, fig.width=5, fig.height=5, fig.align='center'------------
model <- lm(y ~ ., data = surgical)
k <- ols_stepaic_backward(model)
plot(k)

## ----stepwiseaicbdetails-------------------------------------------------
# stepwise aic backward regression
model <- lm(y ~ ., data = surgical)
ols_stepaic_backward(model, details = TRUE)

## ----stepwiseaic1--------------------------------------------------------
# stepwise aic regression
model <- lm(y ~ ., data = surgical)
ols_stepaic_both(model)

## ----stepwiseaic2, fig.width=5, fig.height=5, fig.align='center'---------
model <- lm(y ~ ., data = surgical)
k <- ols_stepaic_both(model)
plot(k)

## ----stepwiseaicdetails--------------------------------------------------
# stepwise aic regression
model <- lm(y ~ ., data = surgical)
ols_stepaic_both(model, details = TRUE)

