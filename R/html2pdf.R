# weasydoc - Convert R Markdown to PDF Using Weasyprint
# Copyright (C) 2018 Ministère de la Justice, République Française
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

#' @importFrom rmarkdown html_document
NULL

#' Add conversion to pdf
#'
#' @param ... Arguments to be passed to a specific output format function.
#' @param base_format Any `HTML` format.
#' @inheritParams make_pdf
#'
#' @return R Markdown output format to pass to [rmarkdown::render()].
#' @export
html2pdf <- function(...,
                     engine = c("weasyprint", "prince"),
                     engine_opts = NULL,
                     base_format = rmarkdown::html_document) {
  base_format <- get_base_format(base_format)
  config <- base_format(...)

  post <- config$post_processor
  config$post_processor <- function(metadata, input_file, output_file, clean, verbose) {
    if (is.function(post)) {
      output_file <- post(metadata, input_file, output_file, clean, verbose)
    }
    if (clean) {
      on.exit(unlink(output_file), add = TRUE)
    }
    make_pdf(output_file, engine = engine, engine_opts = engine_opts)
  }
  config
}

# Since the bookdown package does not export the get_base_format function
# the source code of this function is copied below.
# Source: https://github.com/rstudio/bookdown
# License: GPL-3
# Copyright holders: RStudio Inc
get_base_format <- function(format) {
  if (is.character(format)) {
    format = eval(parse(text = format))
  }
  if (!is.function(format))
    stop("The output format must be a function")
  format
}
