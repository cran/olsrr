## ---- echo=FALSE, message=FALSE------------------------------------------
library(olsrr)
library(dplyr)
library(ggplot2)
library(gridExtra)
library(purrr)
library(tibble)
library(nortest)
library(goftest)

## ----ckdbp, fig.width=7, fig.height=5, fig.align='center'----------------
model <- lm(mpg ~ disp + hp + wt + qsec, data = mtcars)
ols_cooksd_barplot(model)

## ----ckchart, fig.width=5, fig.height=5, fig.align='center'--------------
model <- lm(mpg ~ disp + hp + wt + qsec, data = mtcars)
ols_cooksd_chart(model)

## ----dfbpanel, fig.width=5, fig.height=5, fig.align='center'-------------
model <- lm(mpg ~ disp + hp + wt, data = mtcars)
ols_dfbetas_panel(model)

## ----dfitsplot, fig.width=5, fig.height=5, fig.align='center'------------
model <- lm(mpg ~ disp + hp + wt + qsec, data = mtcars)
ols_dffits_plot(model)

## ----srplot, fig.width=5, fig.height=5, fig.align='center'---------------
model <- lm(mpg ~ disp + hp + wt + qsec, data = mtcars)
ols_srsd_plot(model)

## ----srchart, fig.width=5, fig.height=5, fig.align='center'--------------
model <- lm(mpg ~ disp + hp + wt + qsec, data = mtcars)
ols_srsd_chart(model)

## ----studlev, fig.width=7, fig.height=5, fig.align='center'--------------
model <- lm(read ~ write + math + science, data = hsb)
ols_rsdlev_plot(model)

## ----dsrvsp, fig.width=7, fig.height=5, fig.align='center'---------------
model <- lm(mpg ~ disp + hp + wt + qsec, data = mtcars)
ols_dsrvsp_plot(model)

## ----hadiplot, fig.width=5, fig.height=5, fig.align='center'-------------
model <- lm(mpg ~ disp + hp + wt + qsec, data = mtcars)
ols_hadi_plot(model)

## ----potres, fig.width=5, fig.height=5, fig.align='center'---------------
model <- lm(mpg ~ disp + hp + wt + qsec, data = mtcars)
ols_potrsd_plot(model)

