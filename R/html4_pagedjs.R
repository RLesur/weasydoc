#' HTML4 output format with CSS for Paged Media and paged.js
#'
#' This HTML format is developped only for bookdown.
#'
#' @inheritParams extd_html_document_base
#' @inheritParams rmarkdown::html_document
#' @export
html4_pagedjs <- function(toc = FALSE,
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

  pagedjs_preview_css <- system.file("templates", "default", "pagedpreview.css",
                                     package = "weasydoc")
  css <- c(pagedjs_preview_css, css)

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
