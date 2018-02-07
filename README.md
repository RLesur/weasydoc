# weasydoc

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
