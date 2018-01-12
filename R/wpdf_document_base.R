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
#'   function. The `"tibble"` method uses the **tibble** package to print a
#'   summary of the data frame. In addition to the named methods you can also
#'   pass an arbitrary function to be used for printing data frames. You can
#'   disable the `df_print` behavior entirely by setting the option
#'   `rmarkdown.df_print` to `FALSE`.
#' @param wpdf_engine `HTML` to `PDF` engine for producing `PDF` output. Options
#'   are `"wkhtmltopdf"`, `"weasyprint"` and `"prince"`. Default is
#'   [`weasyprint`](http://weasyprint.org/).
#' @param verbose Is `--verbose` option passed to `pandoc`? Use `TRUE` to
#'   inspect `pandoc`'s `HTML`.
#' @inheritParams rmarkdown::html_document
#' @inheritParams rmarkdown::output_format
#'
#' @return `R Markdown` output format to pass to [rmarkdown::render()].
#' @importFrom rmarkdown knitr_options includes_to_pandoc_args includes pandoc_options from_rmarkdown output_format pandoc_path_arg pandoc_toc_args pandoc_highlight_args pandoc_latex_engine_args
#' @export
wpdf_document_base <- function(toc = FALSE,
                               toc_depth = 3,
                               fig_width = 5,
                               fig_height = 4,
                               fig_caption = TRUE,
                               dev = "png",
                               df_print = NULL,
                               highlight = "default",
                               template = NULL,
                               keep_md = FALSE,
                               wpdf_engine = "weasyprint",
                               smart = TRUE,
                               verbose = FALSE,
                               includes = NULL,
                               md_extensions = NULL,
                               pandoc_args = NULL) {

  # knitr options and hooks
  knitr <- rmarkdown::knitr_options(
    opts_chunk = list(dev = dev,
                      dpi = 96,
                      fig.width = fig_width,
                      fig.height = fig_height)
  )

  # smart extension
  md_extensions <- c(md_extensions, if (smart) "+smart")

  # base pandoc options for all HTML/CSS to PDF output
  args <- c("--section-divs")

  # table of contents
  args <- c(args, rmarkdown::pandoc_toc_args(toc, toc_depth))

  # highlighting
  if (!is.null(highlight))
    highlight <- match.arg(highlight, highlighters())
  args <- c(args, rmarkdown::pandoc_highlight_args(highlight))

  # HTML to PDF engine
  wpdf_engine <- match.arg(wpdf_engine, c("wkhtmltopdf", "weasyprint", "prince"))
  args <- c(args, rmarkdown::pandoc_latex_engine_args(wpdf_engine))

  # verbose pandoc execution (use to inspect intermediate HTML)
  args <- c(args, if (verbose) "--verbose")

  # template
  if (!is.null(template))
    args <- c(args, "--template", rmarkdown::pandoc_path_arg(template))

  # content includes
  args <- c(args, rmarkdown::includes_to_pandoc_args(includes))

  # pandoc args
  args <- c(args, pandoc_args)

  pandoc <- rmarkdown::pandoc_options(
    to = "html",
    from = rmarkdown::from_rmarkdown(fig_caption, md_extensions),
    args = args,
    ext = ".pdf"
  )

  # Pre-processor to include intermediates_dir as base url in temporary pandoc's HTML
  # Use verbose=TRUE option to debug
  pre_processor <- function(metadata, input_file, runtime, knit_meta, files_dir, output_dir) {
    # This is dirty, but it is the only way I found to get intermediates_dir
    # Retrieve intermediates_dir
    intermediates_dir <- dynGet('intermediates_dir')
    if (is.null(intermediates_dir)) intermediates_dir <- normalizePath(".", winslash = "/")
    # write HTML <base> element to a temp file:
    in_header <- tempfile()
    writeLines(sprintf('<base href="file:///%s/">', intermediates_dir), in_header)
    rmarkdown::includes_to_pandoc_args(rmarkdown::includes(in_header = rmarkdown::pandoc_path_arg(in_header)))
  }

  rmarkdown::output_format(knitr = knitr,
                           pandoc = pandoc,
                           keep_md = keep_md,
                           clean_supporting = TRUE,
                           df_print = df_print,
                           pre_processor = pre_processor)
}
