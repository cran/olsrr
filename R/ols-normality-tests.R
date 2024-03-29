#' Correlation test for normality
#'
#' @description
#' Correlation between observed residuals and expected residuals under normality.
#'
#' @param model An object of class \code{lm}.
#'
#' @return Correlation between fitted regression model residuals and expected
#' values of residuals.
#'
#' @examples
#' model <- lm(mpg ~ disp + hp + wt + qsec, data = mtcars)
#' ols_test_correlation(model)
#'
#' @importFrom stats qnorm
#'
#' @family residual diagnostics
#'
#' @export
#'
ols_test_correlation <- function(model) {

  check_model(model)
  corrout(model)

}

corrout <- function(model) {

  n      <- model_rows(model)
  stderr <- summary(model)[[6]]
  h      <- ka(seq_len(n), stderr = stderr, n = n)
  out    <- sort(residuals(model))

  cor(h, out)

}

ka <- function(k, stderr, n) {
  stderr * qnorm((k - 0.375) / (n + 0.25))
}


#' Test for normality
#'
#' Test for detecting violation of normality assumption.
#'
#' @param y A numeric vector or an object of class \code{lm}.
#' @param ... Other arguments.
#'
#' @return \code{ols_test_normality} returns an object of class \code{"ols_test_normality"}.
#' An object of class \code{"ols_test_normality"} is a list containing the
#' following components:
#'
#' \item{kolmogorv}{kolmogorv smirnov statistic}
#' \item{shapiro}{shapiro wilk statistic}
#' \item{cramer}{cramer von mises statistic}
#' \item{anderson}{anderson darling statistic}
#'
#' @examples
#' model <- lm(mpg ~ disp + hp + wt + qsec, data = mtcars)
#' ols_test_normality(model)
#'
#' @importFrom stats ks.test shapiro.test
#' @importFrom goftest cvm.test
#' @importFrom nortest ad.test
#'
#' @family residual diagnostics
#'
#' @export
#'
ols_test_normality <- function(y, ...) UseMethod("ols_test_normality")

#' @export
#'
ols_test_normality.default <- function(y, ...) {

  if (!is.numeric(y)) {
    stop("y must be numeric")
  }

  ks  <- ks.test(y, "pnorm", mean(y), sd(y))
  sw  <- shapiro.test(y)
  cvm <- cvm.test(y)
  ad  <- ad.test(y)

  result <- list(kolmogorv = ks, shapiro = sw, cramer = cvm, anderson = ad)

  class(result) <- "ols_test_normality"
  return(result)
}

#' @export
#' @rdname ols_test_normality
#'
ols_test_normality.lm <- function(y, ...) {

  if (!all(class(y) == "lm")) {
    stop("Please specify a OLS linear regression model.", call. = FALSE)
  }

  ols_test_normality.default(residuals(y))

}

#' @export
#'
print.ols_test_normality <- function(x, ...) {
  print_norm_test(x)
}