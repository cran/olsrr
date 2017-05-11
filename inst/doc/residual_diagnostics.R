## ---- echo=FALSE, message=FALSE------------------------------------------
library(olsrr)
library(dplyr)
library(ggplot2)
library(gridExtra)
library(purrr)
library(tibble)
library(nortest)
library(goftest)

## ----qqresid, fig.width=5, fig.height=5, fig.align='center'--------------
model <- lm(mpg ~ disp + hp + wt + qsec, data = mtcars)
ols_rsd_qqplot(model)

## ----normtest------------------------------------------------------------
model <- lm(mpg ~ disp + hp + wt + qsec, data = mtcars)
ols_norm_test(model)

## ----corrtest------------------------------------------------------------
model <- lm(mpg ~ disp + hp + wt + qsec, data = mtcars)
ols_corr_test(model)

## ----rvsfplot, fig.width=5, fig.height=5, fig.align='center'-------------
model <- lm(mpg ~ disp + hp + wt + qsec, data = mtcars)
ols_rvsp_plot(model)

## ----residhist, fig.width=5, fig.height=5, fig.align='center'------------
model <- lm(mpg ~ disp + hp + wt + qsec, data = mtcars)
ols_rsd_hist(model)

