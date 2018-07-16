# weasydoc

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental) [![Travis build status](https://travis-ci.org/RLesur/weasydoc.svg?branch=master)](https://travis-ci.org/RLesur/weasydoc) [![Coverage status](https://codecov.io/gh/RLesur/weasydoc/branch/master/graph/badge.svg)](https://codecov.io/github/RLesur/weasydoc?branch=master) [![CRAN status](https://www.r-pkg.org/badges/version/weasydoc)](https://cran.r-project.org/package=weasydoc)  

[![Binder](https://mybinder.org/badge.svg)](https://mybinder.org/v2/gh/RLesur/weasydoc-demo/master?urlpath=rstudio)  

[![](https://images.microbadger.com/badges/version/rlesur/weasydoc.svg)](https://microbadger.com/images/rlesur/weasydoc "Get your own version badge on microbadger.com") [![](https://images.microbadger.com/badges/image/rlesur/weasydoc.svg)](https://microbadger.com/images/rlesur/weasydoc "Get your own image badge on microbadger.com")

The goal of `weasydoc` is to convert `R Markdown` to `PDF` using [`WeasyPrint`](http://weasyprint.org/).

## Motivation

The usual way to convert `R Markdown` documents to `PDF` relies on `LaTeX`.  
The only caveat is that learning `LaTeX` layout is not obvious. 

Since [`pandoc`](https://pandoc.org/) version 2.0 supports `PDF` generation through `HTML+CSS`, formatting `PDF` document can now be achieved through `CSS`. I think this may be quite easier...

## Contribution

This package suits my needs. Feel free to send PR. 

## Example

``` r
devtools::install_github('RLesur/weasydoc')

rmarkdown::render('myfile.Rmd', weasydoc::wpdf_document_base(highlight = "pygments"))
```
