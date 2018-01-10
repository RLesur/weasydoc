#' A simple pdf generator
#'
#' @inheritParams pdf_document
#' @param pdf_engine PDF engine passed to pandoc
#' @param verbose logical indicating if verbose option passed to pandoc
#'
#' @return R Markdown output format to pass to `rmarkdown::render`.
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

  knitr <- rmarkdown::knitr_options(opts_chunk = list(dev = "png",
                                                      dpi = 96,
                                                      fig.width = fig_width,
                                                      fig.height = fig_height
                                                      ))

  args <- c("--section-divs", "--pdf-engine", pdf_engine, if (verbose) "--verbose")

  pandoc <- rmarkdown::pandoc_options(to = "html",
                                      from = rmarkdown::from_rmarkdown(fig_caption, md_extensions),
                                      args = args,
                                      ext = ".pdf"
                                      )

  rmarkdown::output_format(knitr = knitr, pandoc = pandoc, keep_md = keep_md)
}
