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
#' @include hpdf_document2.R
NULL

#' A PDF format for bookdown
#'
#' @inheritParams html4_document
#' @inheritParams hpdf_document2
#' @export
hpdf_book <- function(toc = FALSE,
                      toc_depth = 3,
                      number_sections = TRUE,
                      fig_width = 5,
                      fig_height = 4,
                      fig_retina = 8,
                      fig_caption = TRUE,
                      dev = "png",
                      dpi = 96,
                      df_print = NULL,
                      notes = c("endnotes", "footnotes"),
                      smart = TRUE,
                      highlight = "default",
                      math_engine = "webtex_svg",
                      engine = c("weasyprint", "prince"),
                      engine_opts = NULL,
                      css = NULL,
                      includes = NULL,
                      keep_html = FALSE,
                      self_contained = TRUE,
                      md_extensions = NULL,
                      pandoc_args = NULL
                      ) {
  engine <- match.arg(engine)
  notes <- match.arg(notes)

  hpdf_document2(toc = toc,
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
                 keep_md = FALSE,
                 self_contained = self_contained,
                 md_extensions = md_extensions,
                 engine = engine,
                 engine_opts = engine_opts,
                 keep_html = keep_html,
                 pandoc_args = pandoc_args,
                 notes = notes,
                 base_format = html4_document)
}

#' HTML4 output format with CSS for Paged Media
#'
#' This HTML format is developped only for bookdown.
#'
#' @inheritParams extd_html_document_base
#' @inheritParams rmarkdown::html_document
html4_document <- function(toc = FALSE,
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
  template <- system.file("templates", "default", "h4default.html", package = "weasydoc")
  html_format <- "html4"

  extd_html_document_base(
    toc = toc,
    toc_depth = toc_depth,
    number_sections = number_sections,
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
