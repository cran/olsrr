% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ols-regression.R
\name{ols_regress}
\alias{ols_regress}
\alias{ols_regress.lm}
\title{Ordinary least squares regression}
\usage{
ols_regress(object, ...)

\method{ols_regress}{lm}(object, ...)
}
\arguments{
\item{object}{An object of class "formula" (or one that can be coerced to
that class): a symbolic description of the model to be fitted or class
\code{lm}.}

\item{...}{Other inputs.}
}
\value{
\code{ols_regress} returns an object of class \code{"ols_regress"}.
An object of class \code{"ols_regress"} is a list containing the following
components:

\item{r}{square root of rsquare, correlation between observed and predicted values of dependent variable}
\item{rsq}{coefficient of determination or r-square}
\item{adjr}{adjusted rsquare}
\item{rmse}{root mean squared error}
\item{cv}{coefficient of variation}
\item{mse}{mean squared error}
\item{mae}{mean absolute error}
\item{aic}{akaike information criteria}
\item{sbc}{bayesian information criteria}
\item{sbic}{sawa bayesian information criteria}
\item{prsq}{predicted rsquare}
\item{error_df}{residual degrees of freedom}
\item{model_df}{regression degrees of freedom}
\item{total_df}{total degrees of freedom}
\item{ess}{error sum of squares}
\item{rss}{regression sum of squares}
\item{tss}{total sum of squares}
\item{rms}{regression mean square}
\item{ems}{error mean square}
\item{f}{f statistis}
\item{p}{p-value for \code{f}}
\item{n}{number of predictors including intercept}
\item{betas}{betas; estimated coefficients}
\item{sbetas}{standardized betas}
\item{std_errors}{standard errors}
\item{tvalues}{t values}
\item{pvalues}{p-value of \code{tvalues}}
\item{df}{degrees of freedom of \code{betas}}
\item{conf_lm}{confidence intervals for coefficients}
\item{title}{title for the model}
\item{dependent}{character vector; name of the dependent variable}
\item{predictors}{character vector; name of the predictor variables}
\item{mvars}{character vector; name of the predictor variables including intercept}
\item{model}{input model for \code{ols_regress}}
}
\description{
Ordinary least squares regression.
}
\section{Interaction Terms}{

If the model includes interaction terms, the standardized betas
are computed after scaling and centering the predictors.
}

\examples{
ols_regress(mpg ~ disp + hp + wt, data = mtcars)

# if model includes interaction terms set iterm to TRUE
ols_regress(mpg ~ disp * wt, data = mtcars, iterm = TRUE)

}
\references{
https://www.ssc.wisc.edu/~hemken/Stataworkshops/stdBeta/Getting\%20Standardized\%20Coefficients\%20Right.pdf
}
