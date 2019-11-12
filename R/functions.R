#' @name pathd8
#' @title PATHd8
#' @description Run PATHd8, see \url{https://www2.math.su.se/PATHd8/PATHd8manual.pdf}
#' for more information.
#' @param input_file File path to input file containing tree and constraint
#' information.
#' @param output_file File path to output file.
#' @example /examples/example.R
#' @export
pathd8 <- function(input_file, output_file) {
  if (!file.exists(input_file)) {
    stop('No `input_file` found.', call. = FALSE)
  }
  wd <- file.path(tempdir(), '.om_pathd8')
  if (!dir.exists(wd)) {
    dir.create(wd)
  }
  on.exit(unlink(x = wd, recursive = TRUE, force = TRUE))
  # copy input_file to wd
  copy_res <-  file.copy(from = input_file, to = file.path(wd, 'input_file'),
                         overwrite = TRUE)
  if (!copy_res) {
    stop('Unable to copy `input_file`', call. = FALSE)
  }
  otsdr <- outsider_init(pkgnm = 'om..pathd8', cmd = 'PATHd8',
                         files_to_send = file.path(wd, 'input_file'), wd = wd,
                         arglist = c('input_file', 'output_file'))
  otsdr$ignore_errors <- TRUE
  # run the command
  run_res <- run(otsdr)
  # move output file
  copy_res <-  file.copy(from = file.path(wd, 'output_file'), to = output_file,
                         overwrite = TRUE)
  invisible(run_res && copy_res)
}
