#' @importFrom rmarkdown output_format knitr_options pandoc_options html_document from_rmarkdown
NULL

#' Convert a RMarkdown file to pdf using Weasyprint
#'
#' Format for converting from R Markdown to a PDF using Weasyprint.
#'
#' @inheritParams rmarkdown::html_document
#' @param pdf_engine `HTML` to `PDF` engine for producing `PDF` output. Options
#'   are `"wkhtmltopdf"`, `"weasyprint"` and `"prince"`. Default is
#'   [`weasyprint`](http://weasyprint.org/).
#' @return R Markdown output format to pass to `rmarkdown::render`.
#' @export
pdf_document <- function(toc = FALSE,
                         toc_depth = 3,
                         number_sections = FALSE,
                         section_divs = TRUE,
                         fig_width = 7,
                         fig_height = 5,
                         fig_retina = 2,
                         fig_caption = TRUE,
                         dev = 'png',
                         df_print = "default",
                         code_download = FALSE,
                         smart = TRUE,
                         theme = "default",
                         highlight = "default",
                         mathjax = "default",
                         template = "default",
                         extra_dependencies = NULL,
                         css = NULL,
                         includes = NULL,
                         keep_md = FALSE,
                         lib_dir = NULL,
                         md_extensions = NULL,
                         pandoc_args = NULL,
                         pdf_engine = "weasyprint",
                         ...) {
  base_format <- rmarkdown::html_document(
    toc = toc,
    toc_depth = toc_depth,
    number_sections = number_sections,
    section_divs = section_divs,
    fig_width = fig_width,
    fig_height = fig_height,
    fig_retina = fig_retina,
    fig_caption = fig_caption,
    dev = dev,
    df_print = df_print,
    code_folding = "none",
    code_download = FALSE,
    smart = smart,
    self_contained = TRUE,
    theme = theme,
    highlight = highlight,
    mathjax = mathjax,
    template = template,
    extra_dependencies = extra_dependencies,
    css = css,
    includes = includes,
    keep_md = keep_md,
    lib_dir = lib_dir,
    md_extensions = md_extensions,
    pandoc_args = pandoc_args,
    ...
  )

  # HTML to PDF engine
  wpdf_engine <- match.arg(pdf_engine, c("wkhtmltopdf", "weasyprint", "prince"))

  # TODO code download
  post_processor <- function(metadata, input_file, output_file, clean, verbose) {
    output <- paste0(tools::file_path_sans_ext(output_file), ".pdf")
    options <- c(base_format$pandoc$args, rmarkdown::pandoc_latex_engine_args(pdf_engine))
    wd <- dirname(tools::file_path_as_absolute(input_file))
    rmarkdown::pandoc_convert(
      input = input_file,
      to = "html5",
      from = base_format$pandoc$from,
      output = output,
      options = options,
      verbose = verbose,
      wd = wd
    )
    output
  }

  rmarkdown::output_format(
    knitr = NULL,
    pandoc = NULL,
    keep_md = keep_md,
    clean_supporting = TRUE,
    df_print = df_print,
    post_processor = post_processor,
    base_format = base_format
  )
}
