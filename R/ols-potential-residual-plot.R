#' Potential residual plot
#'
#' @description
#' Plot to aid in classifying unusual observations as high-leverage points,
#' outliers, or a combination of both.
#'
#' @param model An object of class \code{lm}.
#' @param print_plot logical; if \code{TRUE}, prints the plot else returns a plot object.
#'
#' @references
#' Chatterjee, Samprit and Hadi, Ali. Regression Analysis by Example. 5th ed. N.p.: John Wiley & Sons, 2012. Print.
#'
#' @examples
#' model <- lm(mpg ~ disp + hp + wt, data = mtcars)
#' ols_plot_resid_pot(model)
#'
#' @seealso [ols_plot_hadi()]
#'
#' @export
#'
ols_plot_resid_pot <- function(model, print_plot = TRUE) {

  check_model(model)
  d <- data.frame(res = hadio(model, 3), pot = hadio(model, 2))

  p <-
    ggplot(d, aes(x = res, y = pot)) +
    geom_point(colour = "blue", shape = 1) +
    xlab("Residual") +
    ylab("Potential") +
    ggtitle("Potential-Residual Plot")

  if (print_plot) {
    print(p)
  } else {
    return(p)
  }

}

hadio <- function(model, n) {
  ols_hadi(model)[[n]]
}
