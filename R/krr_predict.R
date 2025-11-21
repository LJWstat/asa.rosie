#' Kernel Ridge Regression (KRR) model fitting
#'
#' Fits a kernel ridge regression model using a Gaussian kernel.
#'
#' @param X A numeric matrix of predictors (n × p).
#' @param y A numeric response vector of length n.
#' @param rho Gaussian kernel bandwidth parameter.
#' @param lambda Regularization parameter.
#'
#' @return An object of class \code{"krr"} containing:
#'   \itemize{
#'     \item coefficients Estimated coefficients
#'     \item fitted_values Fitted values
#'     \item rho Kernel parameter
#'     \item X Training data
#'     \item y Response vector
#'   }
#' @export
#'
#' @examples
#' X <- matrix(runif(20), nrow = 5)
#' y <- rnorm(5)
#' model <- krr(X, y)
krr = function(X, y, rho = 1, lambda = 0.0001){
  n = nrow(X)
  K = matrix(0, ncol = n, nrow = n)
  for(i in 1:n)
    for(j in 1:n)
      K[i, j] = exp(- rho * sum((X[i, ] - X[j, ])^2))

  coef_hat = solve(K + diag(lambda, n), y)

  rslt = list(
    coefficients = coef_hat,
    fitted_values = K %*% coef_hat,
    rho = rho,
    X = X,
    y = y
  )
  class(rslt) = "krr"
  return(rslt)
}



#' Predict method for Kernel Ridge Regression (KRR)
#'
#' Generates predictions for new input data using a fitted KRR model.
#'
#' @param model A fitted KRR model object created by \code{krr()}.
#' @param X_new A numeric matrix with new predictor values (n_new × p).
#' @param ... Additional arguments (currently unused).
#'
#' @return A numeric vector of predicted values.
#' @export
#'
#' @examples
#' X <- matrix(runif(20), nrow = 5)
#' y <- rnorm(5)
#' model <- krr(X, y)
#' predict(model, X)
predict.krr = function(model, X_new, ...){
  X = model$X
  n = nrow(X)
  n_new = nrow(X_new)

  K_new = matrix(0, ncol = n, nrow = n_new)
  for(i in 1:n_new)
    for(j in 1:n)
      K_new[i, j] = exp(- model$rho * sum((X_new[i, ] - X[j, ])^2))

  pred_values = K_new %*% model$coefficients

  return(pred_values)
}
