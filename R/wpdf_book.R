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

#' @importFrom rmarkdown from_rmarkdown
#' @include wpdf_document.R
NULL

#' @export
wpdf_book <- function(fig_caption = TRUE, md_extensions = NULL, pandoc_args = NULL, ...) {
  from <- rmarkdown::from_rmarkdown(fig_caption, md_extensions)

  config <- wpdf_document(
    fig_caption = fig_caption, md_extensions = md_extensions, pandoc_args = pandoc_args, ...
  )
  pre <- config$pre_processor
  config$pre_processor <- function(metadata, input_file, ...) {
    # Pandoc does not support numbered sections for Word, so figures/tables have
    # to be numbered globally from 1 to n
    bookdown:::process_markdown(input_file, from, pandoc_args, TRUE, TRUE)
    if (is.function(pre)) pre(metadata, input_file, ...)
  }
  post <- config$post_processor
  config$post_processor <- function(metadata, input, output, clean, verbose) {
    if (is.function(post)) {
      output <- post(metadata, input, output, clean, verbose)
    }
    bookdown:::move_output(output)
  }
  config$bookdown_output_format <- 'pdf'
  config <- bookdown:::set_opts_knit(config)
  config
}
