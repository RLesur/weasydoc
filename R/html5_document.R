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

#' @include hpdf_document_base.R
NULL

#' HTML5 output format with CSS for Paged Media
#'
#' This is a basic HTML5 output format.
#'
#' @inheritParams extd_html_document_base
#' @inheritParams rmarkdown::html_document
#' @export
html5_document <- function(toc = FALSE,
                           toc_depth = 3,
                           number_sections = FALSE,
                           fig_width = 5,
                           fig_height = 4,
                           fig_retina = 8,
                           fig_caption = TRUE,
                           dev = "png",
                           dpi = 96,
                           df_print = NULL,
                           smart = TRUE,
                           highlight = "default",
                           math_engine = "webtex_svg",
                           css = NULL,
                           includes = NULL,
                           keep_md = FALSE,
                           self_contained = TRUE,
                           md_extensions = NULL,
                           pandoc_args = NULL) {

  section_divs <- TRUE
  template <- system.file("templates", "default", "default.html", package = "weasydoc")
  html_format <- "html5"

  pandoc_args <-
    c(if (isTRUE(number_sections)) c("-V", "number-sections"),
      pandoc_args
    )

  extd_html_document_base(
    toc = toc,
    toc_depth = toc_depth,
    section_divs = section_divs,
    fig_width = fig_width,
    fig_height = fig_height,
    fig_retina = fig_retina,
    fig_caption = fig_caption,
    dev = dev,
    dpi = dpi,
    df_print = df_print,
    smart = smart,
    highlight = highlight,
    math_engine = math_engine,
    template = template,
    html_format = html_format,
    extra_dependencies = NULL,
    css = css,
    includes = includes,
    keep_md = keep_md,
    self_contained = self_contained,
    lib_dir = NULL,
    md_extensions = md_extensions,
    pandoc_args = pandoc_args
  )
}
