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

#' @importFrom bookdown html_document2
NULL

#' @export
wpdf_document2 <- function(..., number_sections = TRUE, pandoc_args = NULL,
                           base_format = rmarkdown::html_document) {
  config <- bookdown::html_document2(...,
                                     number_sections = number_sections,
                                     pandoc_args = pandoc_args,
                                     base_format = base_format)

  post <- config$post_processor
  config$post_processor <- function(metadata, input_file, output_file, clean, verbose) {
    if (is.function(post)) {
      output_file <- post(metadata, input_file, output_file, clean, verbose)
    }
    output <- paste0(tools::file_path_sans_ext(output_file), ".pdf")
    system2("prince", c("--javascript", output_file, "-o", output))
    output
  }

  config$bookdown_output_format <- 'pdf'
  config <- bookdown:::set_opts_knit(config)
  config
}
