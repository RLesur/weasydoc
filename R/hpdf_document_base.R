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

#' @include convert_html2pdf_format.R
#' @importFrom rmarkdown from_rmarkdown html_document_base includes_to_pandoc_args
#'     knitr_options output_format pandoc_available pandoc_highlight_args pandoc_options
#'     pandoc_path_arg pandoc_toc_args
NULL

#' A basic PDF document output format
#'
#' This output format is compatible with the `htmltools` package.
#'
#' @inheritParams extd_html_document_base
#' @inheritParams convert_html2pdf_format
#' @export
hpdf_document_base <- function(toc = FALSE,
                               toc_depth = 3,
                               number_sections = FALSE,
                               section_divs = TRUE,
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
                               template = NULL,
                               html_format = c("html4", "html5"),
                               engine = c("weasyprint", "prince"),
                               engine_opts = NULL,
                               extra_dependencies = NULL,
                               css = NULL,
                               includes = NULL,
                               keep_md = FALSE,
                               keep_html = FALSE,
                               self_contained = TRUE,
                               lib_dir = NULL,
                               md_extensions = NULL,
                               pandoc_args = NULL,
                               ...) {
  if (!isTRUE(keep_html)) {
    self_contained <- TRUE
  }

  html_format <- match.arg(html_format)

  base_format <- extd_html_document_base(
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
    extra_dependencies = extra_dependencies,
    css = css,
    includes = includes,
    keep_md = keep_md,
    self_contained = self_contained,
    lib_dir = lib_dir,
    md_extensions = md_extensions,
    pandoc_args = pandoc_args,
    ...
  )

  notes <- match.arg(notes)
  engine <- match.arg(engine)

  convert_html2pdf_format(engine = engine,
                          engine_opts = engine_opts,
                          attach_code = attach_code,
                          keep_html = keep_html,
                          notes = notes,
                          base_format = function() base_format)
}


#' An extended HTML base output format
#'
#' The original [rmarkdown::html_document_base()] output format offers few
#' options. This HTML output format offers many options and can be re-used by
#' other developers.
#'
#' @param fig_retina Setting this option to a ratio (for example, 2) will
#'   change the `dpi` parameter to `dpi * fig.retina`, and `fig_width` to
#'   `fig_width * dpi / fig_retina` internally; for example, the physical size
#'   of an image is doubled and its display size is halved when `fig_retina = 2`.
#' @param dpi The DPI (dots per inch) for bitmap devices.
#' @param df_print Method to be used for printing data frames. Valid values
#'   include `"default"`, `"kable"` and `"tibble"`. The `"default"` method uses
#'   `print.data.frame`. The `"kable"` method uses the [knitr::kable()]
#'   function. The `"tibble"` method uses the [tibble::tibble-package] to print a
#'   summary of the data frame. In addition to the named methods you can also
#'   pass an arbitrary function to be used for printing data frames. You can
#'   disable the `df_print` behavior entirely by setting the option
#'   `rmarkdown.df_print` to `FALSE`.
#' @param math_engine Method to be used to render `TeX` math. Valid values
#'   include `"unicode"`, `"mathjax"`, `"mathml"`, `"webtex_svg"`, `"webtex_png"`
#'   and `"katex"`. See the
#'   [`pandoc` manual](https://pandoc.org/MANUAL.html#math-rendering-in-html)
#'   for details.
#' @param template `Pandoc` template to use for rendering. Pass `NULL` to use
#'   `pandoc`'s built-in template; pass a path to use a custom template that
#'   you've created. See the documentation on
#'   [`pandoc` online documentation](http://pandoc.org/MANUAL.html#templates)
#'   for details on creating custom templates.
#' @param html_format HTML format of the intermediate HTML file.
#' @param self_contained Use `self_contained` to indicate if external
#'   dependencies are embedded in `HTML` file.
#' @param ... Additional arguments passed to [rmarkdown::html_document_base()].
#' @inheritParams rmarkdown::html_document
#' @export
#' @keywords internal
extd_html_document_base <- function(toc = FALSE,
                                    toc_depth = 3,
                                    number_sections = FALSE,
                                    section_divs = TRUE,
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
                                    template = NULL,
                                    html_format = c("html4", "html5"),
                                    extra_dependencies = NULL,
                                    css = NULL,
                                    includes = NULL,
                                    keep_md = FALSE,
                                    self_contained = TRUE,
                                    lib_dir = NULL,
                                    md_extensions = NULL,
                                    pandoc_args = NULL,
                                    ...) {

  base_html_format <-
    rmarkdown::html_document_base(
      smart = smart,
      theme = NULL,
      self_contained = self_contained,
      lib_dir = NULL,
      mathjax = NULL,
      pandoc_args = NULL, # keep pandoc_args for later
      template = template,
      extra_dependencies = extra_dependencies,
      bootstrap_compatible = FALSE,
      ...
    )

  # knitr options
  knitr <- rmarkdown::knitr_options(
    opts_chunk = list(dev = dev,
                      dpi = dpi,
                      fig.width = fig_width,
                      fig.height = fig_height,
                      fig.retina = fig_retina)
  )

  # from extensions
  md_extensions <- c(md_extensions,
                     if (isTRUE(smart) && rmarkdown::pandoc_available(2)) "+smart")
  from <- rmarkdown::from_rmarkdown(fig_caption, md_extensions)

  if (!is.null(highlight)) {
    highlight <- match.arg(highlight, highlighters())
  }

  # pandoc arguments
  args <-
    c(# ensure a standalone html
      if (!isTRUE(self_contained)) "--standalone",
      # number sections
      if (isTRUE(number_sections)) "--number-sections",
      # math engine
      pandoc_math_engine_args(math_engine),
      # section_divs
      if (isTRUE(section_divs)) "--section-divs",
      # table of contents
      rmarkdown::pandoc_toc_args(toc, toc_depth),
      # highlighting
      rmarkdown::pandoc_highlight_args(highlight),
      # template
      if (!is.null(template)) c("--template", rmarkdown::pandoc_path_arg(template)),
      # content includes
      rmarkdown::includes_to_pandoc_args(includes),
      # additional css
      pandoc_css_arg(css),
      # pandoc args
      pandoc_args
    )

  pandoc <- rmarkdown::pandoc_options(
    to = match.arg(html_format),
    from = from,
    args = args
  )

  rmarkdown::output_format(knitr = knitr,
                           pandoc = pandoc,
                           keep_md = keep_md,
                           clean_supporting = self_contained,
                           df_print = df_print,
                           base_format = base_html_format)
}


pandoc_math_engine_args <- function(math_engine = c("unicode",
                                                    "mathjax",
                                                    "mathml",
                                                    "webtex_svg",
                                                    "webtex_png",
                                                    "katex")) {
  math_engine <- match.arg(math_engine)
  args <- c()
  math_args <-
    switch(math_engine,
           unicode = NULL,
           mathjax = "--mathjax",
           mathml = "--mathml",
           webtex_svg = c("--webtex=https://latex.codecogs.com/svg.latex?"),
           webtex_png = c("--webtex=https://latex.codecogs.com/png.latex?"),
           katex = "--katex"
    )
  c(args, math_args)
}

highlighters <- function() {
  c("default",
    "tango",
    "pygments",
    "kate",
    "monochrome",
    "espresso",
    "zenburn",
    "haddock",
    "breezedark"
  )
}





