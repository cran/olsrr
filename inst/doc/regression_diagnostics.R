## ---- echo=FALSE, message=FALSE------------------------------------------
library(olsrr)
library(dplyr)
library(ggplot2)
library(gridExtra)
library(purrr)
library(tibble)
library(nortest)
library(goftest)

## ----viftol--------------------------------------------------------------
model <- lm(mpg ~ disp + hp + wt + qsec, data = mtcars)
ols_vif_tol(model)

## ----cindex--------------------------------------------------------------
model <- lm(mpg ~ disp + hp + wt + qsec, data = mtcars)
ols_eigen_cindex(model)

## ----colldiag------------------------------------------------------------
model <- lm(mpg ~ disp + hp + wt + qsec, data = mtcars)
ols_coll_diag(model)

## ----rfsplot, fig.width=10, fig.height=5, fig.align='center'-------------
model <- lm(mpg ~ disp + hp + wt + qsec, data = mtcars)
ols_rfs_plot(model)

## ----partcor-------------------------------------------------------------
model <- lm(mpg ~ disp + hp + wt + qsec, data = mtcars)
ols_correlations(model)

## ----obspred, fig.width=5, fig.height=5, fig.align='center'--------------
model <- lm(mpg ~ disp + hp + wt + qsec, data = mtcars)
ols_ovsp_plot(model)

## ----lackfit-------------------------------------------------------------
model <- lm(mpg ~ disp, data = mtcars)
ols_pure_error_anova(model)

## ----diagpanel, fig.width=10, fig.height=25, fig.align='center'----------
model <- lm(mpg ~ disp + hp + wt + qsec, data = mtcars)
ols_diagnostic_panel(model)

## ----rvsrplot, fig.width=5, fig.height=5, fig.align='center'-------------
model <- lm(mpg ~ disp + hp + wt, data = mtcars)
ols_rvsr_plot(model, mtcars$drat)

## ----avplot, fig.width=5, fig.height=5, fig.align='center'---------------
model <- lm(mpg ~ disp + hp + wt + qsec, data = mtcars)
ols_avplots(model)

## ----cplusr, fig.width=5, fig.height=5, fig.align='center'---------------
model <- lm(mpg ~ disp + hp + wt + qsec, data = mtcars)
ols_rpc_plot(model)

