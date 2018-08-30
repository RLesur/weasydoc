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

#' @importFrom utils URLencode
NULL

#' Generate a pdf from an html file
#'
#' This function is a helper to use [`WeasyPrint`](https://weasyprint.org/) or
#' [`Prince`](https://www.princexml.com/) in order to convert an `HTML` file to
#' `PDF`.
#'
#' The [presentational hints option](https://weasyprint.readthedocs.io/en/latest/api.html#cmdoption-p)
#' is always enabled for `Weasyprint`.
#' The [javascript option](https://www.princexml.com/doc-refs/#cl-javascript)
#' is always enabled for `Prince`.
#'
#' @param file An `HTML` file path.
#' @param engine A `PDF` engine.
#' @param engine_opts A character vector of command-line arguments to be passed to `engine`.
#' @param pdf_file Path to the `PDF` output file. By default, it is under the
#'     same directory as the `input` file and also has the same base name.
#' @return A character string of the path of the `PDF` output file (i.e., the
#'     value of the `pdf_file` argument).
#' @export
make_pdf <- function(file,
                     engine = c("weasyprint", "prince"),
                     engine_opts = NULL,
                     pdf_file = gsub("html?$", "pdf", file)) {
  if (!grepl("[.]html?$", file)) {
    stop("The input file '", file, "' does not have the .html or the .htm extension")
  }
  engine <- match.arg(engine)
  if (!is.null(engine_opts)) {
    if (!is.character(engine_opts)) {
      stop("The engine_opts argument must be a character vector")
    }
  }
  args <- c(default_args(engine),
            base_url_args(file, engine),
            engine_opts,
            shQuote(file),
            if (engine == "prince") "-o", shQuote(pdf_file)
            )
  result <- system2(command = engine, args = args)
  if (result != 0) {
    stop("Document conversion failed with error ", result, call. = FALSE)
  }
  pdf_file
}

default_args <- function(engine = c("weasyprint", "prince")) {
  switch(engine,
    weasyprint = c("--presentational-hints"),
    prince = c("--javascript")
  )
}

base_url_args <- function(file, engine = c("weasyprint", "prince")) {
  engine <- match.arg(engine)
  c(switch(engine, weasyprint = "--base-url", prince = "--baseurl"),
    shQuote(get_base_url(file))
   )
}

get_base_url <- function(file) {
  dir <- normalizePath(dirname(file), winslash = "/")
  url <- sprintf("file://localhost/%s/", dir)
  URLencode(url)
}
