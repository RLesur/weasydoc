#' @importFrom rmarkdown knitr_options includes_to_pandoc_args includes
#'   pandoc_options from_rmarkdown output_format pandoc_path_arg pandoc_toc_args
#'   pandoc_highlight_args pandoc_latex_engine_args pandoc_convert
#' @importFrom tools file_path_sans_ext file_path_as_absolute
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
#' @param wpdf_engine `HTML` to `PDF` engine for producing `PDF` output. Options
#'   are `"wkhtmltopdf"`, `"weasyprint"` and `"prince"`. Default is
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
                               highlight = "default",
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
  # initialize the post_processor
  post_processor <- NULL

  # knitr options and hooks
  knitr <- rmarkdown::knitr_options(
    opts_chunk = list(dev = dev,
                      dpi = dpi,
                      fig.width = fig_width,
                      fig.height = fig_height,
                      fig.retina = fig_retina)
  )

  # smart extension
  md_extensions <- c(md_extensions, if (smart) "+smart")
  from <- rmarkdown::from_rmarkdown(fig_caption, md_extensions)

  # base pandoc options for all HTML/CSS to PDF output
  args <- c("--section-divs")

  # table of contents
  args <- c(args, rmarkdown::pandoc_toc_args(toc, toc_depth))

  # highlighting
  if (!is.null(highlight))
    highlight <- match.arg(highlight, highlighters())
  args <- c(args, rmarkdown::pandoc_highlight_args(highlight))

  # verbose pandoc execution (use to inspect intermediate HTML)
  args <- c(args, if (verbose) "--verbose")

  # template
  if (!is.null(template))
    args <- c(args, "--template", rmarkdown::pandoc_path_arg(template))

  # additional css
  for (css_file in css)
    args <- c(args, "--css", rmarkdown::pandoc_path_arg(css_file))

  # content includes
  args <- c(args, rmarkdown::includes_to_pandoc_args(includes))

  # pandoc args
  args <- c(args, pandoc_args)

  # HTML to PDF engine
  wpdf_engine <- match.arg(wpdf_engine, c("wkhtmltopdf", "weasyprint", "prince"))
  args_with_engine <- c(args, rmarkdown::pandoc_latex_engine_args(wpdf_engine))

  # Activate HTML presentation hints for WeasyPrint
  if (wpdf_engine == "weasyprint")
    args_with_engine <- c(args_with_engine, "--pdf-engine-opt", "-p")

  if (!keep_html)
    self_contained <- TRUE
  clean_supporting <-  self_contained

  pandoc <- rmarkdown::pandoc_options(
    to = "html5",
    from = from,
    args = args_with_engine,
    ext = ".pdf"
  )

  if (keep_html) {
    post_processor <- function(metadata, input_file, output_file, clean, verbose) {
      output <- paste0(tools::file_path_sans_ext(output_file), ".html")
      options <- c(args, "--standalone", if (self_contained) "--self-contained")
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
                           post_processor = post_processor)
}
