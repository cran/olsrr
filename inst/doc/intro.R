## ---- echo=FALSE, message=FALSE------------------------------------------
library(olsrr)
library(dplyr)
library(ggplot2)
library(gridExtra)
library(purrr)
library(tibble)
library(nortest)
library(goftest)

## ----regress-------------------------------------------------------------
ols_regress(mpg ~ disp + hp + wt + qsec, data = mtcars)

## ----rvsfplot, fig.width=5, fig.height=5, fig.align='center'-------------
model <- lm(mpg ~ disp + hp + wt + qsec, data = mtcars)
ols_rvsp_plot(model)

## ----dfbpanel, fig.width=5, fig.height=5, fig.align='center'-------------
model <- lm(mpg ~ disp + hp + wt, data = mtcars)
ols_dfbetas_panel(model)

## ----rfsplot, fig.width=10, fig.height=5, fig.align='center'-------------
model <- lm(mpg ~ disp + hp + wt + qsec, data = mtcars)
ols_rfs_plot(model)

## ----bp1-----------------------------------------------------------------
model <- lm(mpg ~ disp + hp + wt + drat, data = mtcars)
ols_bp_test(model)

## ----colldiag------------------------------------------------------------
model <- lm(mpg ~ disp + hp + wt + qsec, data = mtcars)
ols_coll_diag(model)

## ----stepwise1-----------------------------------------------------------
# stepwise regression
model <- lm(y ~ ., data = surgical)
ols_stepwise(model)

## ----stepwise2, fig.width=10, fig.height=15, fig.align='center'----------
model <- lm(y ~ ., data = surgical)
k <- ols_stepwise(model)
plot(k)

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

