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

#' @include make_pdf.R
#' @include utils.R
#' @importFrom bookdown html_document2
NULL

#' Output format for producing a bookdown pdf
#'
#' @inheritParams bookdown::html_document2
#' @inheritParams make_pdf
#' @inheritParams html2pdf
#' @return An R Markdown output format object to be passed to
#'   [rmarkdown::render()].
#' @export
wpdf_document2 <- function(...,
                           engine = c("weasyprint", "prince"),
                           engine_opts = NULL,
                           keep_html = FALSE,
                           number_sections = TRUE,
                           pandoc_args = NULL,
                           notes = c("endnotes", "footnotes"),
                           base_format = rmarkdown::html_document) {
  base_format <- get_base_format(base_format)
  base_config <- base_format(..., number_sections = number_sections, pandoc_args = pandoc_args)

  if (!base_config$pandoc$to %in% c("html", "html4", "html5")) {
    stop("The base format must be an HTML output format")
  }

  engine <- match.arg(engine)
  notes <- match.arg(notes)

  html_config <- function(..., number_sections, pandoc_args) {
    pandoc_args <- c(pandoc_notes_args(notes = notes,
                                       engine = engine),
                     pandoc_args
                     )
    rmarkdown::output_format(
      knitr = rmarkdown::knitr_options(
        # Force screenshot
        opts_chunk = list(screenshot.force = TRUE)
      ),
      pandoc = NULL,
      base_format = base_format(...,
                                number_sections = number_sections,
                                pandoc_args = pandoc_args)
    )
  }

  config <- bookdown::html_document2(...,
                                     number_sections = number_sections,
                                     pandoc_args = pandoc_args,
                                     base_format = html_config)

  post <- config$post_processor
  config$post_processor <- function(metadata, input_file, output_file, clean, verbose) {
    if (is.function(post)) {
      output_file <- post(metadata, input_file, output_file, clean, verbose)
    }
    if (clean && !isTRUE(keep_html)) {
      on.exit(unlink(output_file), add = TRUE)
    }
    make_pdf(output_file, engine = engine, engine_opts = engine_opts)
  }
  config$bookdown_output_format <- 'pdf'
  config
}
