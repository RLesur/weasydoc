#' Base output format for PDF output formats with HTML/CSS
#'
#' Creates a PDF base output format with HTML/CSS to PDF engine.
#'
#' @inheritParams pdf_document
#' @param pdf_engine PDF engine passed to pandoc.
#' @param verbose Is `--verbose` option passed to `pandoc`?
#'
#' @return R Markdown output format to pass to `rmarkdown::render`.
#' @importFrom rmarkdown knitr_options includes_to_pandoc_args includes pandoc_options from_rmarkdown output_format
#' @export
pdf_document_base <- function (fig_width = 5,
                               fig_height = 4,
                               fig_caption = TRUE,
                               smart = TRUE,
                               keep_md = FALSE,
                               md_extensions = NULL,
                               pdf_engine = "weasyprint",
                               verbose = FALSE) {

  md_extensions <- c(md_extensions, if (smart) "+smart")
  args <- c("--section-divs", "--pdf-engine", pdf_engine, if (verbose) "--verbose")
  knitr <- rmarkdown::knitr_options(opts_chunk = list(dev = "png",
                                                      dpi = 96,
                                                      fig.width = fig_width,
                                                      fig.height = fig_height
                                                      ))
  pre_processor <- function(metadata, input_file, runtime, knit_meta, files_dir, output_dir) {
    # This is dirty, but it is the only way I found to get intermediates_dir:
    # retrieve intermediates_dir:
    intermediates_dir <- dynGet('intermediates_dir')
    if (is.null(intermediates_dir)) intermediates_dir <- normalizePath(".", winslash = "/")
    # write HTML BASE element to a temp file:
    in_header <- tempfile()
    writeLines(sprintf('<base href="file:///%s/">', intermediates_dir), in_header)
    rmarkdown::includes_to_pandoc_args(rmarkdown::includes(in_header = in_header))
  }

  pandoc <- rmarkdown::pandoc_options(to = "html",
                                      from = rmarkdown::from_rmarkdown(fig_caption, md_extensions),
                                      args = args,
                                      ext = ".pdf"
                                      )

  rmarkdown::output_format(knitr = knitr, pandoc = pandoc, keep_md = keep_md, pre_processor = pre_processor)
}
