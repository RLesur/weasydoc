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
#' @inheritParams wpdf_document_base
#' @return R Markdown output format to pass to `rmarkdown::render`.
#' @export
wpdf_document <- function(toc = FALSE,
                          toc_depth = 3,
                          fig_width = 5,
                          fig_height = 4,
                          fig_caption = TRUE,
                          dev = "png",
                          dpi = 96,
                          fig_retina = 8,
                          df_print = NULL,
                          attach_code = FALSE,
                          highlight = "default",
                          math_engine = "webtex_svg",
                          template = "default",
                          keep_md = FALSE,
                          keep_html = FALSE,
                          self_contained = TRUE,
                          wpdf_engine = "weasyprint",
                          smart = TRUE,
                          verbose = FALSE,
                          css = NULL,
                          includes = NULL,
                          md_extensions = NULL,
                          pandoc_args = NULL) {
  if (identical(template, "default")) {
    template <- system.file("templates", "default", "default.html")
  }

  wpdf_document_base(toc = toc,
                     toc_depth = toc_depth,
                     fig_width = fig_width,
                     fig_height = fig_height,
                     fig_caption = fig_caption,
                     dev = dev,
                     dpi = dpi,
                     fig_retina = fig_retina,
                     df_print = df_print,
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
                     pandoc_args = pandoc_args)
}
