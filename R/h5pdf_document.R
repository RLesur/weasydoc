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

#' @include html5_document.R
NULL

#' A PDF output format using CSS for Paged Media
#'
#' This is a format relying on CSS for Paged Media using HTML5.
#'
#' @inheritParams html5_document
#' @inheritParams html2pdf
#' @export
h5pdf_document <- function(toc = FALSE,
                           toc_depth = 3,
                           number_sections = FALSE,
                           fig_width = 5,
                           fig_height = 4,
                           fig_retina = 8,
                           fig_caption = TRUE,
                           dev = "png",
                           dpi = 96,
                           df_print = NULL,
                           notes = c("endnotes", "footnotes"),
                           attach_code = FALSE,
                           smart = TRUE,
                           highlight = "default",
                           math_engine = "webtex_svg",
                           engine = c("weasyprint", "prince"),
                           engine_opts = NULL,
                           css = NULL,
                           includes = NULL,
                           keep_md = FALSE,
                           keep_html = FALSE,
                           self_contained = TRUE,
                           md_extensions = NULL,
                           pandoc_args = NULL) {

  if (!isTRUE(keep_html)) {
    self_contained <- TRUE
  }

  base_format <- html5_document(toc = toc,
                                toc_depth = toc_depth,
                                number_sections = number_sections,
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
                                css = css,
                                includes = includes,
                                keep_md = keep_md,
                                self_contained = self_contained,
                                md_extensions = md_extensions,
                                pandoc_args = pandoc_args)
  notes <- match.arg(notes)
  engine <- match.arg(engine)

  html2pdf(engine = engine,
           engine_opts = engine_opts,
           attach_code = attach_code,
           keep_html = keep_html,
           notes = notes,
           base_format = function() base_format)
}

