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

#' @importFrom rmarkdown knitr_options includes_to_pandoc_args includes
#'   pandoc_options from_rmarkdown output_format pandoc_path_arg pandoc_toc_args
#'   pandoc_highlight_args pandoc_latex_engine_args pandoc_convert
#' @importFrom tools file_path_sans_ext file_path_as_absolute
#' @include utils.R
#' @include hpdf_document_base.R
NULL

#' Base output format for PDF/HTML/CSS output formats
#'
#' Creates a `PDF` base output format for `HTML/CSS` to `PDF` output formats.
#'
#' @param template `Pandoc` template to use for rendering. Pass `NULL` to use
#'   `pandoc`'s built-in template; pass a path to use a custom template that
#'   you've created. See the documentation on
#'   [`pandoc` online documentation](http://pandoc.org/MANUAL.html#templates)
#'   for details on creating custom templates.
#' @param df_print Method to be used for printing data frames. Valid values
#'   include `"default"`, `"kable"` and `"tibble"`. The `"default"` method uses
#'   `print.data.frame`. The `"kable"` method uses the [knitr::kable()]
#'   function. The `"tibble"` method uses the [tibble::tibble-package] to print a
#'   summary of the data frame. In addition to the named methods you can also
#'   pass an arbitrary function to be used for printing data frames. You can
#'   disable the `df_print` behavior entirely by setting the option
#'   `rmarkdown.df_print` to `FALSE`.
#' @param attach_code Add the `Rmd` source code as an attachment to the `PDF`
#'   document.
#' @param wpdf_engine `HTML` to `PDF` engine for producing `PDF` output. Options
#'   are `"weasyprint"` and `"prince"`. Default is
#'   [`weasyprint`](http://weasyprint.org/).
#' @param verbose Is `--verbose` option passed to `pandoc`? Use `TRUE` to
#'   inspect `pandoc`'s `HTML`.
#' @param keep_html,self_contained Keep intermediate `HTML` file. Use
#'   `self_contained` to indicate if external dependencies are embedded in
#'   `HTML` file.
#' @param dpi The DPI (dots per inch) for bitmap devices.
#' @param fig_retina Setting this option to a ratio (for example, 2) will
#'   change the `dpi` parameter to `dpi * fig.retina`, and `fig_width` to
#'   `fig_width * dpi / fig_retina` internally; for example, the physical size
#'   of an image is doubled and its display size is halved when `fig_retina = 2`.
#' @param math_engine Method to be used to render `TeX` math. Valid values
#'   include `"unicode"`, `"mathjax"`, `"mathml"`, `"webtex_svg"`, `"webtex_png"`
#'   and `"katex"`. See the `pandoc` manual for details.
#' @inheritParams rmarkdown::html_document
#' @inheritParams rmarkdown::output_format
#'
#' @return `R Markdown` output format to pass to [rmarkdown::render()].
#' @export
wpdf_document_base <- function(toc = FALSE,
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
                               template = NULL,
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
  # test Pandoc version
  if (!is_pandoc_compatible()) {
    stop("Pandoc version 2.1.3 or greater is required.\n")
  }

  # initialize pre and post processors
  pre_processor <- NULL
  post_processor <- NULL

  # knitr options and hooks
  knitr <- rmarkdown::knitr_options(
    opts_chunk = list(dev = dev,
                      dpi = dpi,
                      fig.width = fig_width,
                      fig.height = fig_height,
                      fig.retina = fig_retina,
                      screenshot.force = TRUE)
  )

  # smart extension
  md_extensions <- c(md_extensions, if (isTRUE(smart)) "+smart")
  from <- rmarkdown::from_rmarkdown(fig_caption, md_extensions)

  # base pandoc options for all HTML/CSS to PDF output
  args <- c("--section-divs")

  # table of contents
  args <- c(args, rmarkdown::pandoc_toc_args(toc, toc_depth))

  # highlighting
  if (!is.null(highlight)) {
    highlight <- match.arg(highlight, highlighters())
  }
  args <- c(args, rmarkdown::pandoc_highlight_args(highlight))

  # verbose pandoc execution (use to inspect intermediate HTML)
  args <- c(args, if (isTRUE(verbose)) "--verbose")

  # math engine
  args <- c(args, pandoc_math_engine_args(math_engine))

  # template
  if (!is.null(template)) {
    args <- c(args, "--template", rmarkdown::pandoc_path_arg(template))
  }

  # additional css
  for (css_file in css)
    args <- c(args, "--css", rmarkdown::pandoc_path_arg(css_file))

  # content includes
  args <- c(args, rmarkdown::includes_to_pandoc_args(includes))

  # pandoc args
  args <- c(args, pandoc_args)

  # HTML to PDF engine
  wpdf_engine <- match.arg(wpdf_engine, c("weasyprint", "prince"))
  args_with_engine <- c(args, rmarkdown::pandoc_latex_engine_args(wpdf_engine))

  # Activate HTML presentation hints for WeasyPrint
  if (identical(wpdf_engine, "weasyprint")) {
    args_with_engine <- c(args_with_engine, "--pdf-engine-opt", "-p")
  }

  # Run JavaScript by default with Prince
  if (identical(wpdf_engine, "prince")) {
    args_with_engine <- c(args_with_engine, "--pdf-engine-opt", "--javascript")
  }

  if (!isTRUE(keep_html)) {
    self_contained <- TRUE
  }
  clean_supporting <- self_contained

  pandoc <- rmarkdown::pandoc_options(
    to = "html5",
    from = from,
    args = args_with_engine,
    ext = ".pdf"
  )

  # get the rmd_file path using a pre_knit
  # it is useful only with attach_code=TRUE
  rmd_file <- NULL
  pre_knit <- function(input, ...) {
    rmd_file <<- input
  }

  if (isTRUE(attach_code)) {
    pre_processor <- function(metadata, input_file, runtime, knit_meta, files_dir,
                              output_dir) {
      # Attach Rmd file
      if (identical(wpdf_engine, "weasyprint"))
        return(c("--pdf-engine-opt", "-a","--pdf-engine-opt", rmd_file))
      if (identical(wpdf_engine, "prince"))
        return(c("--pdf-engine-opt", paste0("--attach=", rmd_file)))
    }
  }

  if (isTRUE(keep_html)) {
    post_processor <- function(metadata, input_file, output_file, clean,
                               verbose) {
      output <- paste0(tools::file_path_sans_ext(output_file), ".html")
      options <- c(args, "--standalone", if (isTRUE(self_contained)) "--self-contained")
      wd <- dirname(tools::file_path_as_absolute(input_file))
      rmarkdown::pandoc_convert(
        input = input_file,
        to = "html5",
        from = from,
        output = output,
        options = options,
        verbose = verbose,
        wd = wd
      )
      output_file
    }
  }

  rmarkdown::output_format(knitr = knitr,
                           pandoc = pandoc,
                           keep_md = keep_md,
                           clean_supporting = clean_supporting,
                           df_print = df_print,
                           pre_knit = pre_knit,
                           pre_processor = pre_processor,
                           post_processor = post_processor)
}
