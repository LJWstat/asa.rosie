#' Gaussian kernel function
#'
#' Computes the Gaussian kernel value between two vectors x and z.
#'
#' @param x A numeric vector.
#' @param z A numeric vector of the same length as x.
#' @param rho Kernel hyper-parameter (default = 1).
#'
#' @return A numeric scalar representing the kernel value.
#' @export
#'
#' @examples
#' gaussian_kernel(c(1,2), c(1,2))
#' gaussian_kernel(c(1,0), c(0,1), rho = 0.5)
gaussian_kernel = function(x, z, rho = 1){
  return(- rho * crossprod(x - z))
}



#' Kernel Ridge Regression fitting function
#'
#' Fits a Kernel Ridge Regression model using a Gaussian kernel.
#'
#' @param X A numeric matrix of predictors (n × p).
#' @param y A numeric response vector of length n.
#' @param rho Kernel bandwidth parameter (default = 1).
#' @param lambda Regularization parameter (default = 0.0001).
#'
#' @return An object of class \code{"krr"} containing:
#' \itemize{
#'   \item coefficients: estimated coefficients
#'   \item fitted_values: fitted values
#'   \item rho: kernel parameter
#'   \item X: training data
#'   \item y: response vector
#' }
#' @export
#'
#' @examples
#' X <- matrix(runif(20), nrow = 5)
#' y <- rnorm(5)
#' model <- krr_fit(X, y)
#' model$fitted_values
krr_fit = function(X, y, rho = 1, lambda = 0.0001){
  n = nrow(X)
  K = matrix(0, ncol = n, nrow = n)
  for(i in 1:n)
    for(j in 1:n)
      K[i, j] = exp(- rho * sum((X[i, ] - X[j, ])^2))

  coef_hat = solve(K + diag(lambda, n), y)

  rslt = list(
    "coefficients" = coef_hat,
    "fitted_values" = K %*% coef_hat,
    "rho" = rho,
    "X" = X,
    "y" = y
  )

  class(rslt) = "krr"
  return(rslt)
}

devtools::document()


