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

#' @importFrom rmarkdown html_document output_format knitr_options
#'     pandoc_path_arg
NULL

#' Convert a HTML output format to a PDF output format
#'
#' This function transforms an R Markdown HTML output format to a PDF
#' output format using `WeasyPrint` or `Prince`.
#'
#' @param ... Arguments to be passed to a specific output format function.
#' @param base_format Any `HTML` format.
#' @param keep_html Keep intermediate `HTML` file.
#' @param attach_code Add the `Rmd` source code as an attachment to the `PDF`
#'   document.
#' @param notes Render notes as endnotes or footnotes. Footnotes are not
#'   yet supported by WeasyPrint and are only well rendered with Prince.
#' @inheritParams make_pdf
#'
#' @return R Markdown output format to pass to [rmarkdown::render()].
#' @export
html2pdf <- function(...,
                     engine = c("weasyprint", "prince"),
                     engine_opts = NULL,
                     attach_code = FALSE,
                     keep_html = FALSE,
                     notes = c("endnotes", "footnotes"),
                     base_format = rmarkdown::html_document) {
  pandoc_args <- NULL
  base_format <- get_base_format(base_format)
  config <- base_format(...)

  if (!config$pandoc$to %in% c("html", "html4", "html5")) {
    stop("The base format must be an HTML output format")
  }

  engine <- match.arg(engine)
  notes <- match.arg(notes)
  if (notes == "footnotes" && engine == "weasyprint") {
    stop("Notes as footnotes are not supported by WeasyPrint.\n",
         "Use endnotes or prince engine")
  }
  if (notes == "footnotes") {
    luafilter <- system.file("luafilters", "footnotes.lua", package = "weasydoc")
    css <- system.file("templates", "default", "footnotes.css", package = "weasydoc")
    pandoc_args <- c(pandoc_args,
                     "--lua-filter",
                     rmarkdown::pandoc_path_arg(luafilter),
                     "-c",
                     rmarkdown::pandoc_path_arg(css)
                     )
  }

  # get the rmd_file path using a pre_knit
  # it is useful only with attach_code=TRUE
  rmd_file <- NULL
  pre_knit <- function(input, ...) {
    rmd_file <<- input
  }

  config <- rmarkdown::output_format(
    knitr = rmarkdown::knitr_options(
      # Force screenshot
      opts_chunk = list(screenshot.force = TRUE)
      ),
    pandoc = rmarkdown::pandoc_options(to = config$pandoc$to,
                                       args = pandoc_args),
    pre_knit = pre_knit,
    base_format = config
  )

  post <- config$post_processor
  config$post_processor <- function(metadata, input_file, output_file, clean, verbose) {
    if (is.function(post)) {
      output_file <- post(metadata, input_file, output_file, clean, verbose)
    }
    if (clean && !isTRUE(keep_html)) {
      on.exit(unlink(output_file), add = TRUE)
    }
    if (isTRUE(attach_code)) {
      engine_opts <- c(attach_file_args(rmd_file, engine), engine_opts)
    }
    make_pdf(output_file, engine = engine, engine_opts = engine_opts)
  }
  config
}

attach_file_args <- function(file, engine = c("weasyprint", "prince")) {
  engine <- match.arg(engine)
  switch(engine,
    weasyprint = c("-a", shQuote(file)),
    prince = paste0("--attach=", shQuote(file))
  )
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
