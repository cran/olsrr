#' Added variable plot data
#'
#' Data for generating the added variable plots.
#'
#' @param model An object of class \code{lm}.
#'
#' @examples
#' model <- lm(mpg ~ disp + hp + wt, data = mtcars)
#' ols_prep_avplot_data(model)
#'
#' @importFrom stats model.frame residuals as.formula
#'
#' @export
#'
ols_prep_avplot_data <- function(model) {

  m1 <- as.data.frame(model.frame(model))[1]
  m2 <- as.data.frame(model.matrix(model))[, -1]
  as.data.frame(cbind(m1, m2))

}

#' Regress predictor on other predictors
#'
#' Regress a predictor in the model on all the other predictors.
#'
#' @param data A \code{data.frame}.
#' @param i A numeric vector (indicates the predictor in the model).
#'
#' @examples
#' model <- lm(mpg ~ disp + hp + wt, data = mtcars)
#' data <- ols_prep_avplot_data(model)
#' ols_prep_regress_x(data, 1)
#'
#' @importFrom stats lsfit
#'
#' @export
#'
ols_prep_regress_x <- function(data, i) {

  x <- remove_columns(data, i)
  y <- select_columns(data, i)
  lsfit(x, y)$residuals

}

#' Regress y on other predictors
#'
#' Regress y on all the predictors except the ith predictor.
#'
#' @param data A \code{data.frame}.
#' @param i A numeric vector (indicates the predictor in the model).
#'
#' @examples
#' model <- lm(mpg ~ disp + hp + wt, data = mtcars)
#' data <- ols_prep_avplot_data(model)
#' ols_prep_regress_y(data, 1)
#'
#' @export
#'
ols_prep_regress_y <- function(data, i) {

  x <- remove_columns(data, i)
  y <- select_columns(data)
  lsfit(x, y)$residuals

}

#' Cooks' D plot data
#'
#' Prepare data for cook's d bar plot.
#'
#' @param model An object of class \code{lm}.
#' @param type An integer between 1 and 5 selecting one of the 6 methods for computing the threshold.
#'
#'
#' @examples
#' model <- lm(mpg ~ disp + hp + wt, data = mtcars)
#' ols_prep_cdplot_data(model)
#'
#' @export
#'
ols_prep_cdplot_data <- function(model, type = 1) {

  cooksd    <- cooks.distance(model)
  n         <- length(cooksd)
  obs       <- seq_len(n)
  ckd       <- data.frame(obs = obs, cd = cooksd)
  ts        <- ols_cooks_ts(model, type)
  cooks_max <- max(cooksd)

  ckd$color     <- ifelse(ckd$cd >= ts, "outlier", "normal")
  ckd$fct_color <- ordered(factor(ckd$color), levels = c("normal", "outlier"))
  maxx          <- cooks_max * 0.01 + cooks_max
  
  list(ckd = ckd, maxx = maxx, ts = ts)

}

ols_cooks_ts <- function(model, type = 1) {

  cooksd <- cooks.distance(model)
  n      <- length(cooksd)
  k      <- length(model$coefficients) - 1

  switch(type,
         `1` = (4 / n),
         `2` = (4 / (n - k - 1)),
         `3` = (1),
         `4` = (1 / (n - k - 1)),
         `5` = (3 * mean(cooksd)))

}

#' Cooks' D outlier observations
#'
#' Identify outliers in cook's d plot.
#'
#' @param k Cooks' d bar plot data.
#'
#' @examples
#' model <- lm(mpg ~ disp + hp + wt, data = mtcars)
#' k <- ols_prep_cdplot_data(model)
#' ols_prep_outlier_obs(k)
#'
#' @export
#'
ols_prep_outlier_obs <- function(k) {

  data <- k$ckd
  data$txt <- ifelse(data$color == "outlier", data$obs, NA)
  return(data)

}

#' Cooks' d outlier data
#'
#' Outlier data for cook's d bar plot.
#'
#' @param k Cooks' d bar plot data.
#'
#' @examples
#' model <- lm(mpg ~ disp + hp + wt, data = mtcars)
#' k <- ols_prep_cdplot_data(model)
#' ols_prep_cdplot_outliers(k)
#'
#' @export
#'
ols_prep_cdplot_outliers <- function(k) {

  result <- k$ckd[k$ckd$color == "outlier", c("obs", "cd")]
  names(result) <- c("observation", "cooks_distance")
  return(result)

}

#' DFBETAs plot data
#'
#' Prepares the data for dfbetas plot.
#'
#' @param d A \code{tibble} or \code{data.frame} with dfbetas.
#' @param threshold The threshold for outliers.
#'
#' @examples
#' model <- lm(mpg ~ disp + hp + wt + qsec, data = mtcars)
#' dfb <- dfbetas(model)
#' n <- nrow(dfb)
#' threshold <- 2 / sqrt(n)
#' dbetas  <- dfb[, 1]
#' df_data <- data.frame(obs = seq_len(n), dbetas = dbetas)
#' ols_prep_dfbeta_data(df_data, threshold)
#'
#' @export
#'
ols_prep_dfbeta_data <- function(d, threshold) {

  d$color     <- ifelse(((d$dbetas >= threshold) | (d$dbetas <= -threshold)), c("outlier"), c("normal"))
  d$fct_color <- ordered(factor(d$color), levels = c("normal", "outlier"))
  d$txt       <- ifelse(d$color == "outlier", d$obs, NA)

  return(d)

}

#' DFBETAs plot outliers
#'
#' Data for identifying outliers in dfbetas plot.
#'
#' @param d A \code{tibble} or \code{data.frame}.
#'
#' @examples
#' model <- lm(mpg ~ disp + hp + wt + qsec, data = mtcars)
#' dfb <- dfbetas(model)
#' n <- nrow(dfb)
#' threshold <- 2 / sqrt(n)
#' dbetas  <- dfb[, 1]
#' df_data <- data.frame(obs = seq_len(n), dbetas = dbetas)
#' d <- ols_prep_dfbeta_data(df_data, threshold)
#' ols_prep_dfbeta_outliers(d)
#'
#' @export
#'
ols_prep_dfbeta_outliers <- function(d) {

  d[d$color == "outlier", c("obs", "dbetas")]

}


#' Deleted studentized residual plot data
#'
#' Generates data for deleted studentized residual vs fitted plot.
#'
#' @param model An object of class \code{lm}.
#' @param threshold Threshold for detecting outliers. Default is 2.
#'
#' @examples
#' model <- lm(mpg ~ disp + hp + wt + qsec, data = mtcars)
#' ols_prep_dsrvf_data(model)
#' ols_prep_dsrvf_data(model, threshold = 3)
#'
#' @export
#'
ols_prep_dsrvf_data <- function(model, threshold = NULL) {

  pred    <- fitted(model)
  dsresid <- unname(rstudent(model))
  n       <- length(dsresid)
  ds      <- data.frame(obs = seq_len(n), dsr = dsresid)

  if (is.null(threshold)) {
    threshold <- 2
  }

  ds$color     <- ifelse((abs(ds$dsr) >= threshold), "outlier", "normal")
  ds$fct_color <- ordered(factor(ds$color), levels = c("normal", "outlier"))

  ds2 <- data.frame(obs       = seq_len(n),
                    pred      = pred,
                    dsr       = ds$dsr,
                    color     = ds$color,
                    fct_color = ds$fct_color)

  minx  <- min(ds2$dsr) - 1
  maxx  <- max(ds2$dsr) + 1
  cminx <- ifelse(minx < -threshold, minx, (-threshold - 0.5))
  cmaxx <- ifelse(maxx > threshold, maxx, (threshold + 0.5))

  list(ds = ds2, cminx = cminx, cmaxx = cmaxx)

}


#' Residual fit spread plot data
#'
#' Data for generating residual fit spread plot.
#'
#' @param model An object of class \code{lm}.
#'
#' @examples
#' model <- lm(mpg ~ disp + hp + wt + qsec, data = mtcars)
#' ols_prep_rfsplot_fmdata(model)
#' ols_prep_rfsplot_rsdata(model)
#'
#' @export
#'
ols_prep_rfsplot_fmdata<- function(model) {

  predicted <- fitted(model)
  pred_m    <- mean(predicted)
  y         <- predicted - pred_m
  percenti  <- ecdf(y)
  x         <- percenti(y)

  data.frame(x, y)

}

#' @rdname ols_prep_rfsplot_fmdata
#' @export
#'
ols_prep_rfsplot_rsdata <- function(model) {

  y         <- residuals(model)
  residtile <- ecdf(y)
  x         <- residtile(y)

  data.frame(x, y)

}

#' Residual vs regressor plot data
#'
#' Data for generating residual vs regressor plot.
#'
#' @param model An object of class \code{lm}.
#'
#' @examples
#' model <- lm(mpg ~ disp + hp + wt + qsec, data = mtcars)
#' ols_prep_rvsrplot_data(model)
#'
#' @export
#'
ols_prep_rvsrplot_data <- function(model) {

  np     <- length(coefficients(model)) - 1
  dat    <- model.frame(model)[, -1]
  pnames <- names(coefficients(model))[-1]

  list(np = np, dat = dat, pnames = pnames)

}

#' Studentized residual vs leverage plot data
#'
#' Generates data for studentized resiudual vs leverage plot.
#'
#' @param model An object of class \code{lm}.
#' @param threshold Threshold for detecting outliers. Default is 2.
#'
#' @examples
#' model <- lm(read ~ write + math + science, data = hsb)
#' ols_prep_rstudlev_data(model)
#' ols_prep_rstudlev_data(model, threshold = 3)
#'
#'
#' @export
#'
ols_prep_rstudlev_data <- function(model, threshold = NULL) {

  if (is.null(threshold)) {
    threshold <- 2
  }

  leverage  <- unname(hatvalues(model))
  rstudent  <- unname(rstudent(model))
  k         <- length(coefficients(model))
  n         <- nrow(model.frame(model))
  lev_thrsh <- (2 * k) / n
  rst_thrsh <- threshold
  miny      <- min(rstudent) - 3
  maxy      <- max(rstudent) + 3
  minx      <- min(leverage)
  maxx      <- ifelse((max(leverage) > lev_thrsh), max(leverage), (lev_thrsh + 0.05))
  levrstud  <- data.frame(obs = seq_len(n), leverage, rstudent)

  levrstud$color1 <- ifelse((levrstud$leverage < lev_thrsh & abs(levrstud$rstudent) < rst_thrsh), "normal", NA)
  levrstud$color2 <- ifelse((levrstud$leverage > lev_thrsh & abs(levrstud$rstudent) < rst_thrsh), "leverage", NA)
  levrstud$color3 <- ifelse((levrstud$leverage < lev_thrsh & abs(levrstud$rstudent) > rst_thrsh), "outlier", NA)
  levrstud$color4 <- ifelse((levrstud$leverage > lev_thrsh & abs(levrstud$rstudent) > rst_thrsh), "outlier & leverage", NA)

  d1 <- levrstud[!is.na(levrstud$color1), c("obs", "leverage", "rstudent", "color1")]
  d2 <- levrstud[!is.na(levrstud$color2), c("obs", "leverage", "rstudent", "color2")]
  d3 <- levrstud[!is.na(levrstud$color3), c("obs", "leverage", "rstudent", "color3")]
  d4 <- levrstud[!is.na(levrstud$color4), c("obs", "leverage", "rstudent", "color4")]

  colnames(d1) <- c("obs", "leverage", "rstudent", "color")
  colnames(d2) <- c("obs", "leverage", "rstudent", "color")
  colnames(d3) <- c("obs", "leverage", "rstudent", "color")
  colnames(d4) <- c("obs", "leverage", "rstudent", "color")

  out <- rbind(d1, d2, d3, d4)
  out$fct_color <- ordered(factor(out$color), levels = c("normal", "leverage", "outlier", "outlier & leverage"))
  levdata <- out[order(out$obs), ]

  list(levrstud  = levdata,
       lev_thrsh = lev_thrsh,
       minx      = minx,
       miny      = miny,
       maxx      = maxx,
       maxy      = maxy
  )

}

#' Studentized residual plot data
#'
#' Generates data for studentized residual plot.
#'
#' @param model An object of class \code{lm}.
#' @param threshold Threshold for detecting outliers. Default is 3.
#'
#' @examples
#' model <- lm(read ~ write + math + science, data = hsb)
#' ols_prep_srplot_data(model)
#'
#' @export
#'
ols_prep_srplot_data<- function(model, threshold = NULL) {

  if (is.null(threshold)) {
    threshold <- 3
  }

  dstud <- unname(rstudent(model))
  obs   <- seq_len(length(dstud))
  dsr   <- data.frame(obs = obs, dsr = dstud)
  dsr$color     <- ifelse((abs(dsr$dsr) >= threshold), "outlier", "normal")
  dsr$fct_color <- ordered(factor(dsr$color), levels = c("normal", "outlier"))

  cminxx <- floor(min(dsr$dsr) - 1)
  cmaxxx <- ceiling(max(dsr$dsr) + 1)
  cminx  <- ifelse(cminxx > -threshold, -threshold, cminxx)
  cmaxx  <- ifelse(cmaxxx < threshold, threshold, cmaxxx)
  nseq   <- seq_len(abs(cminx + 1)) * -1
  pseq   <- seq_len(cmaxx - 1)

  list(cminx = cminx,
       cmaxx = cmaxx,
       nseq  = nseq,
       pseq  = pseq,
       dsr   = dsr)

}

#' Standardized residual chart data
#'
#' Generates data for standardized residual chart.
#'
#' @param model An object of class \code{lm}.
#' @param threshold Threshold for detecting outliers. Default is 2.
#'
#' @examples
#' model <- lm(read ~ write + math + science, data = hsb)
#' ols_prep_srchart_data(model)
#' ols_prep_srchart_data(model, threshold = 3)
#'
#' @export
#'
ols_prep_srchart_data <- function(model, threshold = NULL) {

  if (is.null(threshold)) {
    threshold <- 2
  }

  sdres         <- rstandard(model)
  sdres_out     <- abs(sdres) > threshold
  outlier       <- sdres[sdres_out]
  obs           <- seq_len(length(sdres))

  out           <- data.frame(obs = obs, sdres = sdres)
  out$color     <- ifelse(((out$sdres >= threshold) | (out$sdres <= -threshold)), c("outlier"), c("normal"))
  out$fct_color <- ordered( factor(out$color), levels = c("normal", "outlier"))
  out$txt       <- ifelse(out$color == "outlier", out$obs, NA)

  return(out)

}

remove_columns <- function(data, i) {
	as.matrix(data[, c(-1, -i)])
}

select_columns <- function(data, i = 1) {
	as.matrix(data[, i])
}