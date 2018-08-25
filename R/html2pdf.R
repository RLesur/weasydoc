#' Add conversion to pdf
#'
#' @param ... Arguments to be passed to a specific output format function.
#' @param base_format Any `HTML` format.
#'
#' @return R Markdown output format to pass to `rmarkdown::render`.
#' @export
html2pdf <- function(..., base_format = rmarkdown::html_document) {
  base_format <- get_base_format(base_format)
  config = base_format(...)

  post <- config$post_processor
  config$post_processor <- function(metadata, input_file, output_file, clean, verbose) {
    if (is.function(post)) {
      output_file <- post(metadata, input_file, output_file, clean, verbose)
    }
    output <- paste0(tools::file_path_sans_ext(output_file), ".pdf")
    system2("prince", c("--javascript", output_file, "-o", output))
    output
  }

  config
}

get_base_format <- function(format) {
  if (is.character(format)) {
    format = eval(parse(text = format))
  }
  if (!is.function(format))
    stop("The output format must be a function")
  format
}
