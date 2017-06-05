## ---- echo=FALSE, message=FALSE------------------------------------------
library(olsrr)
library(dplyr)
library(ggplot2)
library(gridExtra)
library(purrr)
library(tibble)
library(nortest)
library(goftest)

## ----bartlett1-----------------------------------------------------------
model <- lm(mpg ~ disp + hp, data = mtcars)
resid <- residuals(model)
cyl <- as.factor(mtcars$cyl)
ols_bartlett_test(resid, group_var = cyl)

## ----bartlett2-----------------------------------------------------------
ols_bartlett_test(hsb$read, hsb$write)

## ----bartlett3-----------------------------------------------------------
mt <- mtcars
mt$cyl <- as.factor(mt$cyl)
ols_bartlett_test(mpg ~ cyl, data = mt)

## ----bartlett4-----------------------------------------------------------
mtcars$cyl <- as.factor(mtcars$cyl)
model <- lm(mpg ~ cyl, data = mtcars)
ols_bartlett_test(model)

## ----bp1-----------------------------------------------------------------
model <- lm(mpg ~ disp + hp + wt + drat, data = mtcars)
ols_bp_test(model)

## ----bp2-----------------------------------------------------------------
model <- lm(mpg ~ disp + hp + wt + drat, data = mtcars)
ols_bp_test(model, rhs = TRUE)

## ----bp3-----------------------------------------------------------------
model <- lm(mpg ~ disp + hp + wt + drat, data = mtcars)
ols_bp_test(model, rhs = TRUE, multiple = TRUE)

## ----bp4-----------------------------------------------------------------
model <- lm(mpg ~ disp + hp + wt + drat, data = mtcars)
ols_bp_test(model, rhs = TRUE, multiple = TRUE, p.adj = 'bonferroni')

## ----bp5-----------------------------------------------------------------
model <- lm(mpg ~ disp + hp + wt + drat, data = mtcars)
ols_bp_test(model, rhs = TRUE, multiple = TRUE, p.adj = 'sidak')

## ----bp6-----------------------------------------------------------------
model <- lm(mpg ~ disp + hp + wt + drat, data = mtcars)
ols_bp_test(model, rhs = TRUE, multiple = TRUE, p.adj = 'holm')

## ----score1--------------------------------------------------------------
model <- lm(mpg ~ disp + hp + wt + qsec, data = mtcars)
ols_score_test(model)

## ----score2--------------------------------------------------------------
model <- lm(mpg ~ disp + hp + wt + qsec, data = mtcars)
ols_score_test(model, rhs = TRUE)

## ----score3--------------------------------------------------------------
model <- lm(mpg ~ disp + hp + wt + qsec, data = mtcars)
ols_score_test(model, vars = c('disp', 'hp'))

## ----ftest1--------------------------------------------------------------
model <- lm(mpg ~ disp + hp + wt + qsec, data = mtcars)
ols_f_test(model)

## ----ftest2--------------------------------------------------------------
model <- lm(mpg ~ disp + hp + wt + qsec, data = mtcars)
ols_f_test(model, rhs = TRUE)

## ----ftest3--------------------------------------------------------------
model <- lm(mpg ~ disp + hp + wt + qsec, data = mtcars)
ols_f_test(model, vars = c('disp', 'hp'))

