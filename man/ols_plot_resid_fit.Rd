% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ols-residual-vs-predicted-plot.R
\name{ols_plot_resid_fit}
\alias{ols_plot_resid_fit}
\title{Residual vs fitted plot}
\usage{
ols_plot_resid_fit(model, print_plot = TRUE)
}
\arguments{
\item{model}{An object of class \code{lm}.}

\item{print_plot}{logical; if \code{TRUE}, prints the plot else returns a plot object.}
}
\description{
Scatter plot of residuals on the y axis and fitted values on the
x axis to detect non-linearity, unequal error variances, and outliers.
}
\details{
Characteristics of a well behaved residual vs fitted plot:

\itemize{
\item The residuals spread randomly around the 0 line indicating that the relationship is linear.
\item The residuals form an approximate horizontal band around the 0 line indicating homogeneity of error variance.
\item No one residual is visibly away from the random pattern of the residuals indicating that there are no outliers.
}
}
\examples{
model <- lm(mpg ~ disp + hp + wt, data = mtcars)
ols_plot_resid_fit(model)

}
\seealso{
Other residual diagnostics: 
\code{\link{ols_plot_resid_box}()},
\code{\link{ols_plot_resid_hist}()},
\code{\link{ols_plot_resid_qq}()},
\code{\link{ols_test_correlation}()},
\code{\link{ols_test_normality}()}
}
\concept{residual diagnostics}
