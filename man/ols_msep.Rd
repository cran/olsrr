% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ols-information-criteria.R
\name{ols_msep}
\alias{ols_msep}
\title{MSEP}
\usage{
ols_msep(model)
}
\arguments{
\item{model}{An object of class \code{lm}.}
}
\value{
Estimated error of prediction of the model.
}
\description{
Estimated error of prediction, assuming multivariate normality.
}
\details{
Computes the estimated mean square error of prediction assuming that both
independent and dependent variables are multivariate normal.

\deqn{MSE(n + 1)(n - 2) / n(n - p - 1)}

where \eqn{MSE = SSE / (n - p)}, n is the sample size and p is the number of
predictors including the intercept
}
\examples{
model <- lm(mpg ~ disp + hp + wt + qsec, data = mtcars)
ols_msep(model)

}
\references{
Stein, C. (1960). “Multiple Regression.” In Contributions to Probability and Statistics: Essays in Honor
of Harold Hotelling, edited by I. Olkin, S. G. Ghurye, W. Hoeffding, W. G. Madow, and H. B. Mann,
264–305. Stanford, CA: Stanford University Press.

Darlington, R. B. (1968). “Multiple Regression in Psychological Research and Practice.” Psychological
Bulletin 69:161–182.
}
\seealso{
Other model selection criteria: 
\code{\link{ols_aic}()},
\code{\link{ols_apc}()},
\code{\link{ols_fpe}()},
\code{\link{ols_hsp}()},
\code{\link{ols_mallows_cp}()},
\code{\link{ols_sbc}()},
\code{\link{ols_sbic}()}
}
\concept{model selection criteria}
