


#' Title
#'
#' @param X
#' @param y
#' @param rho
#' @param lambda
#'
#' @returns
#' @export
#'
#' @examples
krr = function(X, y, rho = 1, lambda = 0.0001){
  n = nrow(X)
  K = matrix(0, ncol = n, nrow = n)
  for(i in 1:n)
    for(j in 1:n)
      K[i, j] = exp(- rho * sum((X[i, ]- X[j, ])^2))
  coef_hat = solve(K + diag(lambda, n), y)
  rslt = list("coefficients" = coef_hat,
              "fitted_values" = K %*% coef_hat,
              "rho" = rho,
              "X" = X,
              "y" = y)
  class(rslt) = "krr"

  return(rslt)
}


#' Title
#'
#' @param model
#' @param X_new
#' @param ...
#'
#' @returns
#' @export
#'
#' @examples
predict.krr = function(model, X_new, ...){
  X = model$X
  n = nrow(X)
  n_new = nrow(X_new)
  K_new = matrix(0, ncol = n, nrow = n_new)
  for(i in 1:n_new)
    for(j in 1:n)
      K_new[i, j] = exp(- model$rho * sum((X_new[i, ]- X[j, ])^2))
  pred_values = K_new %*% model$coefficients
  return(pred_values)
}
