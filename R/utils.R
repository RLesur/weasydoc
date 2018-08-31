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

#' @importFrom rmarkdown pandoc_available
NULL

is_installed <- function(pgm) {
  version <- tryCatch(system2(pgm, "--version", stdout = TRUE, stderr = TRUE),
                      error = function(e) "")

  !identical(nzchar(version), FALSE)
}

weasyprint_available <- function() {
  is_installed("weasyprint")
}

prince_available <- function() {
  is_installed("prince")
}

pandoc_notes_args <- function(notes = c("endnotes", "footnotes"),
                              engine = c("weasyprint", "prince")) {
  engine <- match.arg(engine)
  notes <- match.arg(notes)
  if (notes == "footnotes" && engine == "weasyprint") {
    stop("Notes as footnotes are not supported by WeasyPrint.\n",
         "Use endnotes or prince engine")
  }
  if (notes == "footnotes") {
    # test Pandoc version. Required for the footnotes lua filter.
    if (!is_pandoc_compatible()) {
      stop("Pandoc version 2.1.3 or greater is required.\n")
    }

    luafilter <- system.file("luafilters", "footnotes.lua", package = "weasydoc")
    css <- system.file("templates", "default", "footnotes.css", package = "weasydoc")
    return(c("--lua-filter",
             rmarkdown::pandoc_path_arg(luafilter),
             pandoc_css_arg(css)
    ))
  }
  NULL
}
