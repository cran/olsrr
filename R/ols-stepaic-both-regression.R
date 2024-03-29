#' Stepwise AIC regression
#'
#' @description
#' Build regression model from a set of candidate predictor variables by
#' entering and removing predictors based on akaike information criteria, in a
#' stepwise manner until there is no variable left to enter or remove any more.
#'
#' @param model An object of class \code{lm}.
#' @param include Character or numeric vector; variables to be included in selection process.
#' @param exclude Character or numeric vector; variables to be excluded from selection process.
#' @param progress Logical; if \code{TRUE}, will display variable selection progress.
#' @param details Logical; if \code{TRUE}, details of variable selection will
#'   be printed on screen.
#' @param x An object of class \code{ols_step_both_*}.
#' @param print_plot logical; if \code{TRUE}, prints the plot else returns a plot object.
#' @param digits Number of decimal places to display.
#' @param ... Other arguments.
#'
#' @return List containing the following components:
#'
#' \item{model}{final model; an object of class \code{lm}}
#' \item{metrics}{selection metrics}
#' \item{others}{list; info used for plotting and printing}
#'
#' @references
#' Venables, W. N. and Ripley, B. D. (2002) Modern Applied Statistics with S. Fourth edition. Springer.
#'
#' @examples
#' \dontrun{
#' # stepwise regression
#' model <- lm(y ~ ., data = stepdata)
#' ols_step_both_aic(model)
#'
#' # stepwise regression plot
#' model <- lm(y ~ ., data = stepdata)
#' k <- ols_step_both_aic(model)
#' plot(k)
#'
#' # selection metrics
#' k$metrics
#'
#' # final model
#' k$model
#'
#' # include or exclude variables
#' # force variable to be included in selection process
#' model <- lm(y ~ ., data = stepdata)
#'
#' ols_step_both_aic(model, include = c("x6"))
#'
#' # use index of variable instead of name
#' ols_step_both_aic(model, include = c(6))
#'
#' # force variable to be excluded from selection process
#' ols_step_both_aic(model, exclude = c("x2"))
#'
#' # use index of variable instead of name
#' ols_step_both_aic(model, exclude = c(2))
#'
#' # include & exclude variables in the selection process
#' ols_step_both_aic(model, include = c("x6"), exclude = c("x2"))
#'
#' # use index of variable instead of name
#' ols_step_both_aic(model, include = c(6), exclude = c(2))
#' }
#'
#' @family both direction selection procedures
#'
#' @export
#'
ols_step_both_aic <- function(model, ...) UseMethod("ols_step_both_aic")

#' @export
#' @rdname ols_step_both_aic
#'
ols_step_both_aic.default <- function(model, include = NULL, exclude = NULL, progress = FALSE, details = FALSE, ...) {
  out <- ols_step_both(model, "aic", include, exclude, progress, details)
  class(out) <- "ols_step_both_aic"
  return(out)
}

#' @export
#'
print.ols_step_both_aic <- function(x, ...) {
  if (length(x$metrics$step) > 0) {
    print_step_output(x, "both")
  } else {
    print("No variables have been added to or removed from the model.")
  }
}

#' @rdname ols_step_both_aic
#' @export
#'
plot.ols_step_both_aic <- function(x, print_plot = TRUE, details = TRUE, digits = 3, ...) {

  p <- ols_stepaic_plot(x, details, digits)

  if (print_plot) {
    print(p)
  } else {
    return(p)
  }

}

#' Stepwise SBC regression
#'
#' @description
#' Build regression model from a set of candidate predictor variables by
#' entering and removing predictors based on schwarz bayesian criterion, in a
#' stepwise manner until there is no variable left to enter or remove any more.
#'
#' @inheritParams ols_step_both_aic
#'
#' @inherit ols_step_both_aic return references
#'
#' @examples
#' \dontrun{
#' # stepwise regression
#' model <- lm(y ~ ., data = stepdata)
#' ols_step_both_sbc(model)
#'
#' # stepwise regression plot
#' model <- lm(y ~ ., data = stepdata)
#' k <- ols_step_both_sbc(model)
#' plot(k)
#'
#' # selection metrics
#' k$metrics
#'
#' # final model
#' k$model
#'
#' # include or exclude variables
#' # force variable to be included in selection process
#' model <- lm(y ~ ., data = stepdata)
#'
#' ols_step_both_sbc(model, include = c("x6"))
#'
#' # use index of variable instead of name
#' ols_step_both_sbc(model, include = c(6))
#'
#' # force variable to be excluded from selection process
#' ols_step_both_sbc(model, exclude = c("x2"))
#'
#' # use index of variable instead of name
#' ols_step_both_sbc(model, exclude = c(2))
#'
#' # include & exclude variables in the selection process
#' ols_step_both_sbc(model, include = c("x6"), exclude = c("x2"))
#'
#' # use index of variable instead of name
#' ols_step_both_sbc(model, include = c(6), exclude = c(2))
#' }
#'
#' @family both direction selection procedures
#'
#' @export
#'
ols_step_both_sbc <- function(model, ...) UseMethod("ols_step_both_sbc")

#' @export
#' @rdname ols_step_both_sbc
#'
ols_step_both_sbc.default <- function(model, include = NULL, exclude = NULL, progress = FALSE, details = FALSE, ...) {
  out <- ols_step_both(model, "sbc", include, exclude, progress, details)
  class(out) <- "ols_step_both_sbc"
  return(out)
}

#' @export
#'
print.ols_step_both_sbc <- function(x, ...) {
  if (length(x$metrics$step) > 0) {
    print_step_output(x, "both")
  } else {
    print("No variables have been removed from the model.")
  }
}

#' @rdname ols_step_both_sbc
#' @export
#'
plot.ols_step_both_sbc <- function(x, print_plot = TRUE, details = TRUE, digits = 3, ...) {
  p <- ols_stepaic_plot(x, details, digits)
  if (print_plot) {
    print(p)
  } else {
    return(p)
  }
}

#' Stepwise SBIC regression
#'
#' @description
#' Build regression model from a set of candidate predictor variables by
#' entering and removing predictors based on sawa bayesian criterion, in a
#' stepwise manner until there is no variable left to enter or remove any more.
#'
#' @inheritParams ols_step_both_aic
#'
#' @inherit ols_step_both_aic return references
#'
#' @examples
#' \dontrun{
#' # stepwise regression
#' model <- lm(y ~ ., data = stepdata)
#' ols_step_both_sbic(model)
#'
#' # stepwise regression plot
#' model <- lm(y ~ ., data = stepdata)
#' k <- ols_step_both_sbic(model)
#' plot(k)
#'
#' # selection metrics
#' k$metrics
#'
#' # final model
#' k$model
#'
#' # include or exclude variables
#' # force variable to be included in selection process
#' model <- lm(y ~ ., data = stepdata)
#'
#' ols_step_both_sbic(model, include = c("x6"))
#'
#' # use index of variable instead of name
#' ols_step_both_sbic(model, include = c(6))
#'
#' # force variable to be excluded from selection process
#' ols_step_both_sbic(model, exclude = c("x2"))
#'
#' # use index of variable instead of name
#' ols_step_both_sbic(model, exclude = c(2))
#'
#' # include & exclude variables in the selection process
#' ols_step_both_sbic(model, include = c("x6"), exclude = c("x2"))
#'
#' # use index of variable instead of name
#' ols_step_both_sbic(model, include = c(6), exclude = c(2))
#' }
#'
#' @family both direction selection procedures
#'
#' @export
#'
ols_step_both_sbic <- function(model, ...) UseMethod("ols_step_both_sbic")

#' @export
#' @rdname ols_step_both_sbic
#'
ols_step_both_sbic.default <- function(model, include = NULL, exclude = NULL, progress = FALSE, details = FALSE, ...) {
  out <- ols_step_both(model, "sbic", include, exclude, progress, details)
  class(out) <- "ols_step_both_sbic"
  return(out)
}

#' @export
#'
print.ols_step_both_sbic <- function(x, ...) {
  if (length(x$metrics$step) > 0) {
    print_step_output(x, "both")
  } else {
    print("No variables have been removed from the model.")
  }
}

#' @rdname ols_step_both_sbic
#' @export
#'
plot.ols_step_both_sbic <- function(x, print_plot = TRUE, details = TRUE, digits = 3, ...) {
  p <- ols_stepaic_plot(x, details, digits)
  if (print_plot) {
    print(p)
  } else {
    return(p)
  }
}

#' Stepwise R-Squared regression
#'
#' @description
#' Build regression model from a set of candidate predictor variables by
#' entering and removing predictors based on r-squared, in a stepwise manner
#' until there is no variable left to enter or remove any more.
#'
#' @inheritParams ols_step_both_aic
#'
#' @inherit ols_step_both_aic return references
#'
#' @examples
#' \dontrun{
#' # stepwise regression
#' model <- lm(y ~ ., data = stepdata)
#' ols_step_both_r2(model)
#'
#' # stepwise regression plot
#' model <- lm(y ~ ., data = stepdata)
#' k <- ols_step_both_r2(model)
#' plot(k)
#'
#' # selection metrics
#' k$metrics
#'
#' # final model
#' k$model
#'
#' # include or exclude variables
#' # force variable to be included in selection process
#' model <- lm(y ~ ., data = stepdata)
#'
#' ols_step_both_r2(model, include = c("x6"))
#'
#' # use index of variable instead of name
#' ols_step_both_r2(model, include = c(6))
#'
#' # force variable to be excluded from selection process
#' ols_step_both_r2(model, exclude = c("x2"))
#'
#' # use index of variable instead of name
#' ols_step_both_r2(model, exclude = c(2))
#'
#' # include & exclude variables in the selection process
#' ols_step_both_r2(model, include = c("x6"), exclude = c("x2"))
#'
#' # use index of variable instead of name
#' ols_step_both_r2(model, include = c(6), exclude = c(2))
#' }
#'
#' @family both direction selection procedures
#'
#' @export
#'
ols_step_both_r2 <- function(model, ...) UseMethod("ols_step_both_r2")

#' @export
#' @rdname ols_step_both_r2
#'
ols_step_both_r2.default <- function(model, include = NULL, exclude = NULL, progress = FALSE, details = FALSE, ...) {
  out <- ols_step_both(model, "rsq", include, exclude, progress, details)
  class(out) <- "ols_step_both_r2"
  return(out)
}

#' @export
#'
print.ols_step_both_r2 <- function(x, ...) {
  if (length(x$metrics$step) > 0) {
    print_step_output(x, "both")
  } else {
    print("No variables have been removed from the model.")
  }
}

#' @rdname ols_step_both_r2
#' @export
#'
plot.ols_step_both_r2 <- function(x, print_plot = TRUE, details = TRUE, digits = 3, ...) {
  p <- ols_stepaic_plot(x, details, digits)
  if (print_plot) {
    print(p)
  } else {
    return(p)
  }
}

#' Stepwise Adjusted R-Squared regression
#'
#' @description
#' Build regression model from a set of candidate predictor variables by
#' entering and removing predictors based on adjusted r-squared, in a stepwise
#' manner until there is no variable left to enter or remove any more.
#'
#' @inheritParams ols_step_both_aic
#'
#' @inherit ols_step_both_aic return references
#'
#' @examples
#' \dontrun{
#' # stepwise regression
#' model <- lm(y ~ ., data = stepdata)
#' ols_step_both_adj_r2(model)
#'
#' # stepwise regression plot
#' model <- lm(y ~ ., data = stepdata)
#' k <- ols_step_both_adj_r2(model)
#' plot(k)
#'
#' # selection metrics
#' k$metrics
#'
#' # final model
#' k$model
#'
#' # include or exclude variables
#' # force variable to be included in selection process
#' model <- lm(y ~ ., data = stepdata)
#'
#' ols_step_both_adj_r2(model, include = c("x6"))
#'
#' # use index of variable instead of name
#' ols_step_both_adj_r2(model, include = c(6))
#'
#' # force variable to be excluded from selection process
#' ols_step_both_adj_r2(model, exclude = c("x2"))
#'
#' # use index of variable instead of name
#' ols_step_both_adj_r2(model, exclude = c(2))
#'
#' # include & exclude variables in the selection process
#' ols_step_both_adj_r2(model, include = c("x6"), exclude = c("x2"))
#'
#' # use index of variable instead of name
#' ols_step_both_adj_r2(model, include = c(6), exclude = c(2))
#' }
#'
#' @family both direction selection procedures
#'
#' @export
#'
ols_step_both_adj_r2 <- function(model, ...) UseMethod("ols_step_both_adj_r2")

#' @export
#' @rdname ols_step_both_adj_r2
#'
ols_step_both_adj_r2.default <- function(model, include = NULL, exclude = NULL, progress = FALSE, details = FALSE, ...) {
  out <- ols_step_both(model, "adjrsq", include, exclude, progress, details)
  class(out) <- "ols_step_both_adj_r2"
  return(out)
}

#' @export
#'
print.ols_step_both_adj_r2 <- function(x, ...) {
  if (length(x$metrics$step) > 0) {
    print_step_output(x, "both")
  } else {
    print("No variables have been removed from the model.")
  }
}

#' @rdname ols_step_both_adj_r2
#' @export
#'
plot.ols_step_both_adj_r2 <- function(x, print_plot = TRUE, details = TRUE, digits = 3, ...) {
  p <- ols_stepaic_plot(x, details, digits)
  if (print_plot) {
    print(p)
  } else {
    return(p)
  }
}
