#' All possible regression
#'
#' @description
#' Fits all regressions involving one regressor, two regressors, three
#' regressors, and so on. It tests all possible subsets of the set of potential
#' independent variables.
#'
#' @param model An object of class \code{lm}.
#' @param max_order Maximum subset order.
#' @param x An object of class \code{ols_step_all_possible}.
#' @param print_plot logical; if \code{TRUE}, prints the plot else returns a plot object.
#' @param ... Other arguments.
#'
#' @return \code{ols_step_all_possible} returns an object of class \code{"ols_step_all_possible"}.
#' An object of class \code{"ols_step_all_possible"} is a data frame containing the
#' following components:
#'
#' \item{mindex}{model index}
#' \item{n}{number of predictors}
#' \item{predictors}{predictors in the model}
#' \item{rsquare}{rsquare of the model}
#' \item{adjr}{adjusted rsquare of the model}
#' \item{rmse}{root mean squared error of the model}
#' \item{predrsq}{predicted rsquare of the model}
#' \item{cp}{mallow's Cp}
#' \item{aic}{akaike information criteria}
#' \item{sbic}{sawa bayesian information criteria}
#' \item{sbc}{schwarz bayes information criteria}
#' \item{msep}{estimated MSE of prediction, assuming multivariate normality}
#' \item{fpe}{final prediction error}
#' \item{apc}{amemiya prediction criteria}
#' \item{hsp}{hocking's Sp}
#'
#' @references
#' Mendenhall William and  Sinsich Terry, 2012, A Second Course in Statistics Regression Analysis (7th edition).
#' Prentice Hall
#'
#' @examples
#' model <- lm(mpg ~ disp + hp, data = mtcars)
#' k <- ols_step_all_possible(model)
#' k
#'
#' # plot
#' plot(k)
#' 
#' # maximum subset
#' model <- lm(mpg ~ disp + hp + drat + wt + qsec, data = mtcars)
#' ols_step_all_possible(model, max_order = 3)
#'
#' @importFrom utils combn
#'
#' @export
#'
ols_step_all_possible <- function(model, ...) UseMethod("ols_step_all_possible")

#' @export
#' @rdname ols_step_all_possible
#'
ols_step_all_possible.default <- function(model, max_order = NULL, ...) {

  check_model(model)
  check_npredictors(model, 2)

  metrics <- allpos_helper(model, max_order)

  ui <- data.frame(
    n          = metrics$lpreds,
    predictors = unlist(metrics$preds),
    rsquare    = unlist(metrics$rsq),
    adjr       = unlist(metrics$adjrsq),
    rmse       = unlist(metrics$rmse),
    predrsq    = unlist(metrics$predrsq),
    cp         = unlist(metrics$cp),
    aic        = unlist(metrics$aic),
    sbic       = unlist(metrics$sbic),
    sbc        = unlist(metrics$sbc),
    msep       = unlist(metrics$msep),
    fpe        = unlist(metrics$fpe),
    apc        = unlist(metrics$apc),
    hsp        = unlist(metrics$hsp),
    stringsAsFactors = F
  )

  sorted <- c()

  for (i in seq_len(metrics$lc)) {
    temp   <- ui[metrics$q[i]:metrics$t[i], ]
    temp   <- temp[order(temp$rsquare, decreasing = TRUE), ]
    sorted <- rbind(sorted, temp)
  }

  mindex <- seq_len(nrow(sorted))
  sorted <- cbind(mindex, sorted)
  out    <- list(result = sorted)
  class(out) <- c("ols_step_all_possible")

  return(out)
}

#' @export
#'
print.ols_step_all_possible <- function(x, ...) {

  n <- max(x$result$mindex)
  k <- data.frame(x$result)[, c(1:5, 7)]
  names(k) <- c("Index", "N", "Predictors", "R-Square", "Adj. R-Square", "Mallow's Cp")
  print(k)

}

#' @export
#' @rdname ols_step_all_possible
#'
plot.ols_step_all_possible <- function(x, model = NA, print_plot = TRUE, ...) {

  k <- x$result
  d <- data.frame(index   = k$mindex, 
                  n       = k$n, 
                  rsquare = k$rsquare, 
                  adjr    = k$adjr,
                  cp      = k$cp, 
                  aic     = k$aic, 
                  sbic    = k$sbic, 
                  sbc     = k$sbc)

  d$cps <- abs(d$n - d$cp)

  p1 <- all_possible_plot(d, "rsquare", title = "R-Square")
  p2 <- all_possible_plot(d, "adjr", title = "Adj. R-Square")
  p3 <- all_possible_plot(d, "cps", title = "Cp")
  p4 <- all_possible_plot(d, "aic", title = "AIC")
  p5 <- all_possible_plot(d, "sbic", title = "SBIC")
  p6 <- all_possible_plot(d, "sbc", title = "SBC")

  myplots <- list(plot_1 = p1, plot_2 = p2, plot_3 = p3,
                  plot_4 = p4, plot_5 = p5, plot_6 = p6)

  if (print_plot) {
    marrangeGrob(myplots, nrow = 2, ncol = 2, top = "All Possible Regression")
  } else {
    return(myplots)
  }

}

#' All possible regression plot
#'
#' Generate plots for best subset regression.
#'
#' @importFrom ggplot2 ggtitle scale_shape_manual scale_size_manual scale_color_manual ggtitle geom_text
#'
#' @param d1 A data.frame.
#' @param d2 A data.frame.
#' @param title Plot title.
#'
#' @noRd
#'
all_possible_plot <- function(d, var, title = "R-Square") {

  d1    <- d[, c("n", var)]
  colnames(d1) <- c("x", "y")
  maxs  <- all_pos_maxs(d, var, title)
  lmaxs <- all_pos_lmaxs(maxs)
  index <- all_pos_index(d, var, title)

  d2 <- data.frame(x = lmaxs, y = maxs, tx = index, shape = 6, size = 4)

  ggplot(d1, aes(x = x, y = y)) + 
    geom_point(color = "blue", size = 2) +
    geom_point(data = d2, aes(x = x, y = y, shape = factor(shape),
      color = factor(shape), size = factor(size))) +
    geom_text(data = d2, aes(label = tx), hjust = 0, nudge_x = 0.1) +
    scale_shape_manual(values = c(2), guide = "none") +
    scale_size_manual(values = c(4), guide = "none") +
    scale_color_manual(values = c("red"), guide = "none") +
    xlab("") + 
    ylab("") + 
    ggtitle(title)

}

all_pos_maxs <- function(d, var, title = "R-Square") {

  if (title == "R-Square" | title == "Adj. R-Square") {
    as.numeric(lapply(split(d[[var]], d$n), max))
  } else {
    as.numeric(lapply(split(d[[var]], d$n), min))
  }

}

all_pos_lmaxs <- function(maxs) {

  seq_len(length(maxs))

}

all_pos_index <- function(d, var, title = "R-Square") {

  index   <- c()

  if (title == "R-Square" | title == "Adj. R-Square") {
    n <- as.numeric(lapply(split(d[[var]], d$n), max))
    m <- data.frame(n = seq_len(length(n)), maximum = n)
  } else {
    n <- as.numeric(lapply(split(d[[var]], d$n), min))
    m <- data.frame(n = seq_len(length(n)), minimum = n)
  }

  colnames(m) <- c("n", var)
  k  <- split(d[c("index", var)], d$n)

  for (i in m$n) {
    j <- which(part_2(m, var, i) == part_3(k, var, i))
    index[i] <- part_1(k, i)[j]
  }

  return(index)

}


part_1 <- function(k, i) {
  k[[i]]$index
}

part_2 <- function(m, var, i) {
  m[[var]][i]
}

part_3 <- function(k, var, i) {
  k[[i]][[var]]
}


#' All possible regression variable coefficients
#'
#' Returns the coefficients for each variable from each model.
#'
#' @param object An object of class \code{lm}.
#' @param ... Other arguments.
#'
#' @return \code{ols_step_all_possible_betas} returns a \code{data.frame} containing:
#'
#' \item{model_index}{model number}
#' \item{predictor}{predictor}
#' \item{beta_coef}{coefficient for the predictor}
#'
#' @examples
#' \dontrun{
#' model <- lm(mpg ~ disp + hp + wt, data = mtcars)
#' ols_step_all_possible_betas(model)
#' }
#'
#' @export
#'
ols_step_all_possible_betas <- function(object, ...) {

  if (!all(class(object) == "lm")) {
    stop("Please specify a OLS linear regression model.", call. = FALSE)
  }

  if (length(object$coefficients) < 3) {
    stop("Please specify a model with at least 2 predictors.", call. = FALSE)
  }

  metrics    <- allpos_helper(object)
  beta_names <- names(metrics$betas)
  mindex     <- seq_len(length(metrics$rsq))
  
  # detect index of intercepts
  intercepts <- grep("(Intercept)", beta_names)

  # increment length of betas  
  lbeta_nam  <- length(beta_names) + 1

  # detect length of betas in each model plus the last model with all variables
  reps       <- c(diff(intercepts), (lbeta_nam - rev(intercepts)[1]))
  m_index    <- rep(mindex, reps)
  beta       <- metrics$betas

  data.frame(model = m_index, predictor = beta_names, beta = beta)

}

#' All possible regression internal
#'
#' Internal function for all possible regression.
#'
#' @param model An object of class \code{lm}.
#'
#' @noRd
#'
allpos_helper <- function(model, max_order = NULL) {

  nam <- coeff_names(model)
  n   <- length(nam)
  
  r     <- seq_len(n)
  combs <- list()

  for (i in seq_len(n)) {
    combs[[i]] <- combn(n, r[i])
  }

  if (!is.null(max_order)) {
    check_order(n, max_order)
  }

  if (is.null(max_order)) {
    max_order <- n
  }

  pos_data  <- model$model
  predicts  <- nam
  # lc        <- length(combs)
  lc        <- max_order
  varnames  <- model_colnames(model)
  len_preds <- length(predicts)
  gap       <- len_preds - 1
  space     <- coeff_length(predicts, gap)
  colas     <- unname(unlist(lapply(combs, ncol)))
  response  <- varnames[1]
  p         <- colas
  t         <- cumsum(colas)
  q         <- c(1, t[-lc] + 1)

  mcount    <- 0
  rsq       <- list()
  adjrsq    <- list()
  sigma     <- list()
  predrsq   <- list()
  cp        <- list()
  aic       <- list()
  sbic      <- list()
  sbc       <- list()
  msep      <- list()
  fpe       <- list()
  apc       <- list()
  hsp       <- list()
  preds     <- list()
  lpreds    <- c()
  betas     <- c()

  for (i in seq_len(lc)) {
    for (j in seq_len(colas[i])) {

      predictors <- nam[combs[[i]][, j]]
      lp         <- length(predictors)

      out <- ols_regress(paste(response, "~", paste(predictors, collapse = " + ")), data = pos_data)

      mcount            <- mcount + 1
      lpreds[mcount]    <- lp
      rsq[[mcount]]     <- out$rsq
      adjrsq[[mcount]]  <- out$adjr
      sigma[[mcount]]   <- out$rmse
      predrsq[[mcount]] <- ols_pred_rsq(out$model)
      cp[[mcount]]      <- ols_mallows_cp(out$model, model)
      aic[[mcount]]     <- ols_aic(out$model)
      sbic[[mcount]]    <- ols_sbic(out$model, model)
      sbc[[mcount]]     <- ols_sbc(out$model)
      msep[[mcount]]    <- ols_msep(out$model)
      fpe[[mcount]]     <- ols_fpe(out$model)
      apc[[mcount]]     <- ols_apc(out$model)
      hsp[[mcount]]     <- ols_hsp(out$model)
      preds[[mcount]]   <- paste(predictors, collapse = " ")
      betas             <- append(betas, out$betas)
    }
  }

  result <- list(
    lpreds = lpreds, rsq = rsq, adjrsq = adjrsq, rmse = sigma,
    predrsq = predrsq, cp = cp, aic = aic, sbic = sbic,
    sbc = sbc, msep = msep, fpe = fpe, apc = apc, hsp = hsp,
    preds = preds, lc = lc, q = q, t = t, betas = betas
  )

  return(result)
}