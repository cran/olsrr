model <- lm(mpg ~ disp + hp + wt + drat + qsec, data = mtcars)

test_that("correlations output match", {
  data <- c(
    -0.848, -0.776, -0.868, 0.681, 0.419, 0.151, -0.256, -0.569,
    0.289, 0.264, 0.059, -0.103, -0.269, 0.117, 0.106
  )
  expt <- ols_correlations(model) %>% unlist(use.names = FALSE)

  expect_equal(round(expt, 3), data)
})


