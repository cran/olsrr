#' Residual QQ plot
#'
#' Graph for detecting violation of normality assumption.
#'
#' @param model An object of class \code{lm}.
#' @param print_plot logical; if \code{TRUE}, prints the plot else returns a plot object.
#'
#' @examples
#' model <- lm(mpg ~ disp + hp + wt, data = mtcars)
#' ols_plot_resid_qq(model)
#'
#' @family residual diagnostics
#'
#' @importFrom stats qqnorm qqline
#'
#' @export
#'
ols_plot_resid_qq <- function(model, print_plot = TRUE) {

  check_model(model)

  resid <- residuals(model)
  y     <- quantile(resid[!is.na(resid)], c(0.25, 0.75))
  x     <- qnorm(c(0.25, 0.75))
  slope <- diff(y) / diff(x)
  int   <- y[1L] - slope * x[1L]
  d     <- data.frame(x = resid)

  p <-
    ggplot(d, aes(sample = x)) +
    geom_abline(slope = slope, intercept = int, color = "red") +
    stat_qq(color = "blue") +
    xlab("Theoretical Quantiles") +
    ylab("Sample Quantiles") +
    ggtitle("Normal Q-Q Plot")

  if (print_plot) {
    print(p)
  } else {
    return(p)
  }

}
