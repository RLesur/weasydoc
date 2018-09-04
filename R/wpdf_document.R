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

#' @include wpdf_document_base.R
NULL

#' Convert a RMarkdown file to pdf using Weasyprint
#'
#' Format for converting from R Markdown to a PDF using Weasyprint.
#'
#' @param template `Pandoc` template to use for rendering.  Pass "default" to
#'   use the weasydoc package default template; pass `NULL` to use
#'   `pandoc`'s built-in template; pass a path to use a custom template that
#'   you've created. See the documentation on
#'   [`pandoc` online documentation](http://pandoc.org/MANUAL.html#templates)
#'   for details on creating custom templates.
#' @param number_sections `TRUE` to number section headings.
#' @inheritParams wpdf_document_base
#' @return R Markdown output format to pass to `rmarkdown::render`.
#' @export
#' @keywords internal
wpdf_document <- function(toc = FALSE,
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
                          template = "default",
                          wpdf_engine = "weasyprint",
                          css = NULL,
                          includes = NULL,
                          keep_md = FALSE,
                          keep_html = FALSE,
                          self_contained = TRUE,
                          verbose = FALSE,
                          md_extensions = NULL,
                          pandoc_args = NULL) {
  notes <- match.arg(notes)

  # init args
  args <- c()

  if (identical(template, "default")) {
    template <- system.file("templates", "default", "h5default.html", package = "weasydoc")
  }

  if (isTRUE(number_sections)) {
    args <- c("-V", "number-sections", args)
  }

  args <- c(args, pandoc_args)

  wpdf_document_base(toc = toc,
                     toc_depth = toc_depth,
                     fig_width = fig_width,
                     fig_height = fig_height,
                     fig_caption = fig_caption,
                     dev = dev,
                     dpi = dpi,
                     fig_retina = fig_retina,
                     df_print = df_print,
                     notes = notes,
                     attach_code = attach_code,
                     highlight = highlight,
                     math_engine = math_engine,
                     template = template,
                     keep_md = keep_md,
                     keep_html = keep_html,
                     self_contained = self_contained,
                     wpdf_engine = wpdf_engine,
                     smart = smart,
                     verbose = verbose,
                     css = css,
                     includes = includes,
                     md_extensions = md_extensions,
                     pandoc_args = args)
}
