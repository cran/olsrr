#' Leverage
#'
#' @description
#' The leverage of an observation is based on how much the observation's value
#' on the predictor variable differs from the mean of the predictor variable.
#' The greater an observation's leverage, the more potential it has to be an
#' influential observation.
#'
#' @param model An object of class \code{lm}.
#'
#' @return Leverage of the model.
#'
#' @references
#' Kutner, MH, Nachtscheim CJ, Neter J and Li W., 2004, Applied Linear Statistical Models (5th edition).
#' Chicago, IL., McGraw Hill/Irwin.
#'
#' @examples
#' model <- lm(mpg ~ disp + hp + wt + qsec, data = mtcars)
#' ols_leverage(model)
#'
#' @family influence measures
#'
#' @importFrom stats hatvalues
#'
#' @export
#'
ols_leverage <- function(model) {
  check_model(model)
  unname(hatvalues(model))  
}


#' Hadi's influence measure
#'
#' @description
#' Measure of influence based on the fact that influential observations in
#' either the response variable or in the predictors or both.
#'
#' @param model An object of class \code{lm}.
#'
#' @return Hadi's measure of the model.
#'
#' @references
#' Chatterjee, Samprit and Hadi, Ali. Regression Analysis by Example. 5th ed. N.p.: John Wiley & Sons, 2012. Print.
#'
#' @examples
#' model <- lm(mpg ~ disp + hp + wt, data = mtcars)
#' ols_hadi(model)
#'
#' @family influence measures
#'
#' @export
#'
ols_hadi <- function(model) {

  check_model(model)

  potential <- hadipot(model)
  residual  <- hadires(model)
  hi        <- potential + residual

  list(hadi      = hi,
       potential = potential,
       residual  = residual)

}

hadipot <- function(model) {

  lev <- ols_leverage(model)
  pii <- 1 - lev
  lev / pii

}

hadires <- function(model) {

  pii    <- 1 - ols_leverage(model)
  q      <- model$rank
  p      <- q - 1
  aov_m  <- anova(model)
  j      <- length(aov_m$Df)
  den    <- sqrt(aov_m[j, 2])
  dii    <- (model$residuals / den) ^ 2    
  first  <- (p + 1) / pii
  second <- dii / (1 - dii)

  first * second

}


#' PRESS
#'
#' @description
#' PRESS (prediction sum of squares) tells you how well the model will predict
#' new data.
#'
#' @param model An object of class \code{lm}.
#'
#' @details
#' The prediction sum of squares (PRESS) is the sum of squares of the prediction
#' error. Each fitted to obtain the predicted value for the ith observation. Use
#' PRESS to assess your model's predictive ability. Usually, the smaller the
#' PRESS value, the better the model's predictive ability.
#'
#' @return Predicted sum of squares of the model.
#'
#' @references
#' Kutner, MH, Nachtscheim CJ, Neter J and Li W., 2004, Applied Linear Statistical Models (5th edition).
#' Chicago, IL., McGraw Hill/Irwin.
#'
#' @examples
#' model <- lm(mpg ~ disp + hp + wt + qsec, data = mtcars)
#' ols_press(model)
#'
#' @family influence measures
#'
#' @export
#'
ols_press <- function(model) {

  check_model(model)
  lev <- ols_leverage(model)
  k   <- 1 - lev
  sum((residuals(model) / k) ^ 2) 
  
}

#' Predicted rsquare
#'
#' @description
#' Use predicted rsquared to determine how well the model predicts responses for
#' new observations. Larger values of predicted R2 indicate models of greater
#' predictive ability.
#'
#' @param model An object of class \code{lm}.
#'
#' @return Predicted rsquare of the model.
#'
#' @examples
#' model <- lm(mpg ~ disp + hp + wt + qsec, data = mtcars)
#' ols_pred_rsq(model)
#'
#' @family influence measures
#'
#' @export
#'
ols_pred_rsq <- function(model) {

  check_model(model)
  tss  <- sum(anova(model)[[2]])
  prts <- ols_press(model) / tss
  1 - prts

}
