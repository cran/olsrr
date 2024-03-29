#' DFFITS plot
#'
#' Plot for detecting influential observations using DFFITs.
#'
#' @param model An object of class \code{lm}.
#' @param size_adj_threshold logical; if \code{TRUE} (the default), size 
#' adjusted threshold is used to determine influential observations.
#' @param print_plot logical; if \code{TRUE}, prints the plot else returns a 
#' plot object.
#'
#' @details
#' DFFIT - difference in fits, is used to identify influential data points. It
#' quantifies the number of standard deviations that the fitted value changes
#' when the ith data point is omitted.
#'
#' Steps to compute DFFITs:
#'
#' \itemize{
#'   \item Delete observations one at a time.
#'   \item Refit the regression model on remaining \eqn{n - 1} observations
#'   \item examine how much all of the fitted values change when the ith observation is deleted.
#' }
#'
#' An observation is deemed influential if the absolute value of its DFFITS value is greater than:
#' \deqn{2\sqrt((p + 1) / (n - p -1))}
#'
#' A size-adjusted cutoff recommended by Belsley, Kuh, and Welsch is 
#' \deqn{2\sqrt(p / n)} and is used by default in **olsrr**.
#' 
#' where \code{n} is the number of observations and \code{p} is the number of predictors including intercept.
#'
#' @return \code{ols_plot_dffits} returns  a list containing the
#' following components:
#'
#' \item{outliers}{a \code{data.frame} with observation number and \code{DFFITs} that exceed \code{threshold}}
#' \item{threshold}{\code{threshold} for classifying an observation as an outlier}
#'
#' @references
#' Belsley, David A.; Kuh, Edwin; Welsh, Roy E. (1980). Regression
#' Diagnostics: Identifying Influential Data and Sources of Collinearity.
#'
#' Wiley Series in Probability and Mathematical Statistics.
#' New York: John Wiley & Sons. ISBN 0-471-05856-4.
#'
#' @examples
#' model <- lm(mpg ~ disp + hp + wt + qsec, data = mtcars)
#' ols_plot_dffits(model)
#' ols_plot_dffits(model, size_adj_threshold = FALSE)
#'
#' @seealso [ols_plot_dfbetas()]
#'
#' @importFrom stats dffits
#'
#' @export
#'
ols_plot_dffits <- function(model, size_adj_threshold = TRUE, print_plot = TRUE) {

  check_model(model)
  data <- ols_prep_dffits_plot_data(model, size_adj_threshold)

  p <-
    ggplot(data$d, aes(x = obs, y = dbetas, label = txt, ymin = 0, ymax = data$dfm)) +
    geom_linerange(colour = "blue") +
    geom_hline(yintercept = c(0, data$dft, -data$dft), colour = "red") +
    geom_point(colour = "blue", shape = 1) +
    geom_text(hjust = -0.2, nudge_x = 0.15, size = 3, family = "serif",
              fontface = "italic", colour = "darkred", na.rm = TRUE)

  # annotations
  p <-
    p +
    annotate("text", x = Inf, y = Inf, hjust = 1.5, vjust = 2,
             family = "serif", fontface = "italic", colour = "darkred",
             label = paste("Threshold:", round(data$dft, 2)))

  # guides
  p <-
    p +
    xlab("Observation") +
    ylab("DFFITS") +
    ggtitle(paste("Influence Diagnostics for", data$title))

  if (print_plot) {
    suppressWarnings(print(p))
  } else {
    return(list(plot = p, outliers = data$f, threshold = round(data$dft, 2)))
  }

}


ols_prep_dffits_plot_data <- function(model, size_adj_threshold = TRUE) {

  dffitsm    <- unlist(dffits(model))
  k          <- model_n_coeffs(model)
  n          <- model_rows(model)
  
  # threshold
  normal_t   <- 2 * sqrt((k + 1) / (n - k - 1))
  adj_t      <- sqrt(k / n) * 2
  dffits_t   <- ifelse(size_adj_threshold, adj_t, normal_t)

  title      <- names(model.frame(model))[1]
  dfits_data <- data.frame(obs = seq_len(n), dbetas = dffitsm)
  d          <- ols_prep_dfbeta_data(dfits_data, dffits_t)
  f          <- ols_prep_dfbeta_outliers(d)
  colnames(f) <- c("observation", "dffits")

  list(d = d, dft = dffits_t, title = title, f = f, dfm = dffitsm)
}