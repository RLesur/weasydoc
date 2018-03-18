#' Add conversion to pdf
#'
#' @param base_format Any `HTML` format.
#'
#' @return R Markdown output format to pass to `rmarkdown::render`.
#' @export
html2pdf <- function(base_format) {
  post_processor <- function(metadata, input_file, output_file, clean, verbose) {
    output <- paste0(tools::file_path_sans_ext(output_file), ".pdf")
    system2("prince", c("--javascript", output_file, "-o", output))
    output
  }

  rmarkdown::output_format(
    knitr = NULL,
    pandoc = NULL,
    clean_supporting = FALSE,
    post_processor = post_processor,
    base_format = base_format
  )
}
