#' Convert a RMarkdown file to pdf using Weasyprint
#'
#' Format for converting from R Markdown to a PDF using Weasyprint.
#'
#' @inheritParams rmarkdown::html_document
#' @return R Markdown output format to pass to `rmarkdown::render`.
#' @importFrom rmarkdown output_format knitr_options pandoc_options html_document from_rmarkdown
#' @export
pdf_document <- function(number_sections = FALSE,
                           fig_width = 7,
                           fig_height = 5,
                           fig_retina = 2,
                           fig_caption = TRUE,
                           dev = "png",
                           df_print = "default",
                           smart = TRUE,
                           highlight = "default",
                           template = "default",
                           extra_dependencies = NULL,
                           css = NULL,
                           includes = NULL,
                           keep_md = FALSE,
                           lib_dir = NULL,
                           md_extensions = NULL,
                           pandoc_args = NULL,
                           ...) {

  md_extensions <- c(md_extensions, if (smart) "+smart")

  rmarkdown::output_format(
    knitr = NULL,
    pandoc = rmarkdown::pandoc_options(
      to = "html",
      from = rmarkdown::from_rmarkdown(fig_caption, md_extensions),
      args = c("--pdf-engine=weasyprint"),
      ext = ".pdf"
    ),
    clean_supporting = TRUE,
    base_format = rmarkdown::html_document(
      number_sections = number_sections,
      section_divs = TRUE,
      fig_width = fig_width,
      fig_height = fig_height,
      fig_retina = fig_retina,
      dev = dev,
      df_print = df_print,
      # voir pour code_folding
      code_download = FALSE,
      self_contained = TRUE,
      theme = NULL,
      highlight = highlight,
      mathjax = NULL,
      template = template,
      extra_dependencies = extra_dependencies,
      css = css,
      includes = includes,
      keep_md = keep_md,
      lib_dir = lib_dir,
      pandoc_args = pandoc_args,
      ...
    )
  )
}
