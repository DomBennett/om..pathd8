#' @name pathd8
#' @title pathd8
#' @description Run pathd8
#' @param ... Arguments
#' @example /examples/example.R
#' @export
pathd8 <- function(arglist = arglist_get(...)) {
  otsdr <- outsider_init(pkgnm = 'om..pathd8', cmd = 'pathd8',
                         arglist = arglist)
  # run the command
  run(otsdr)
}
