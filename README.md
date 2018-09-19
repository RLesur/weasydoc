# weasydoc

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental) [![Travis build status](https://travis-ci.org/RLesur/weasydoc.svg?branch=master)](https://travis-ci.org/RLesur/weasydoc) [![Coverage status](https://codecov.io/gh/RLesur/weasydoc/branch/master/graph/badge.svg)](https://codecov.io/github/RLesur/weasydoc?branch=master) [![CRAN status](https://www.r-pkg.org/badges/version/weasydoc)](https://cran.r-project.org/package=weasydoc)  

_Work In Progress. Do Not Use in Production Yet!_ 

The goal of `weasydoc` is to convert `R Markdown` to `PDF` using [`WeasyPrint`](https://weasyprint.org/) or [`Prince`](https://www.princexml.com/) with **CSS for Paged Media**. 

## Motivation

The usual way to convert `R Markdown` documents to `PDF` relies on `LaTeX`.  
In order to customize the rendered document, you have to pass the painful `LaTeX` learning curve.  

Since [`pandoc`](https://pandoc.org/) version 2 supports `PDF` generation through `HTML+CSS`, formatting `PDF` document can now be achieved through `CSS`. For those who already know `HTML` and `CSS`, learning _CSS for Paged Media_ is quite easy.

### What is CSS for Paged Media?

In industry, printed document are commonly designed with publishing softwares like [Microsoft Publisher](https://products.office.com/publisher), [Adobe InDesign®](https://www.adobe.com/InDesign) or [Scribus](https://www.scribus.net/).

_CSS for Paged Media_ can mainly be understood as an alternative for these publishing softwares: it allows conversion from HTML to PDF using CSS rules.  

#### The CSS for Paged Media Standard

The _CSS for Paged Media_ standard is a subset of the [W3C CSS specifications](https://www.w3.org/Style/CSS/specs.en.html):

- [CSS Paged Media Module Level 3](https://www.w3.org/TR/css3-page/)
- [CSS Generated Content for Paged Media Module](https://www.w3.org/TR/css3-gcpm/)
- [CSS Page Floats](https://www.w3.org/TR/css-page-floats-3/)
- [CSS Fragmentation Module Level 3](https://www.w3.org/TR/css-break-3/)
- ...

#### CSS for Paged Media Converters

Some important features of _CSS for Paged Media_ are not implemented by the top browsers in use. So, you cannot rely on browsers (or headless browsers) to generate a `PDF` file from `HTML` using _CSS for Paged Media_: you have to install a converter that implements the _CSS for Paged Media_ standard.  
The great [print-css.rocks](https://print-css.rocks/) website by Andreas Jung ([@zopyx](https://github.com/zopyx)) offers a [comprehensive list of converters](https://print-css.rocks/tools.html) using _CSS for Paged Media_.

**Note:** a very promising project of the Paged Media initiative named [Paged.js](https://gitlab.pagedmedia.org/tools/pagedjs) proposes a polyfill for Paged Media. I think this could be a game changer.

## Installation

_If you do not want to modify your system, you can use the `rlesur/weasydoc` docker image or even easier the `MyBinder` environment (see below)._

### weasydoc installation

The `weasydoc` package is still in development. You can install the development version from GitHub with:

``` r
devtools::install_github('RLesur/weasydoc')
```

### System requirements

#### Pandoc version

You need [`pandoc`](https://pandoc.org/) version 2.1.3 or above (but version 2.2.1 or above is recommended).  
If you use the [`RStudio` preview release](https://www.rstudio.com/products/rstudio/download/preview/), you do not need to upgrade `pandoc`. Otherwise, [see the installation instruction for `pandoc`](https://pandoc.org/installing.html).

#### HTML to PDF converter

You need to install a `HTML` to `PDF` converter that supports _CSS for Paged Media_.

For now, `weasydoc` supports `WeasyPrint` and `Prince`:

- [`WeasyPrint`](https://weasyprint.org/) is an open source software. [See the installation instruction for `WeasyPrint`](https://weasyprint.readthedocs.io/en/latest/install.html) (be careful, WeasyPrint installation is cumbersome on Windows).  
- [`Prince`](https://www.princexml.com/) is a commercial software. However, you can use Prince for non-commercial purposes: a notice is included in the PDF and you have to mention the www.princexml.com web address when distributing the PDF files ([see the end user licence agreement](https://www.princexml.com/license/)). [See the installation instruction for `Prince`](https://www.princexml.com/doc-install/).

**Ensure that the location of `WeasyPrint` and/or `Prince` is in the `PATH` environment variable.**

## Docker image

[![](https://images.microbadger.com/badges/version/rlesur/weasydoc.svg)](https://microbadger.com/images/rlesur/weasydoc "Get your own version badge on microbadger.com") [![](https://images.microbadger.com/badges/image/rlesur/weasydoc.svg)](https://microbadger.com/images/rlesur/weasydoc "Get your own image badge on microbadger.com")

**Do not use this image in production.**

If you are not familiar with the [docker](https://www.docker.com/) images of the [Rocker project](https://www.rocker-project.org/), please read this great tutorial of [rOpenSci](https://ropensci.org/) Labs: https://ropenscilabs.github.io/r-docker-tutorial/

Since the use of `weasydoc` involves tier-softwares installation (`pandoc`, `WeasyPrint`/`Prince`), a docker image built on top of [`rocker/verse:3.5.0`](https://hub.docker.com/r/rocker/verse/) is provided: [`rlesur/weasydoc`](https://hub.docker.com/r/rlesur/weasydoc/). 

You can launch a container using:

```bash
docker run --rm -dp 8787:8787 rlesur/weasydoc
```

Be aware that using this image, you agree with the terms of the Prince end user license: https://www.princexml.com/license/

## MyBinder environment

The quickest way to test `weasydoc` is to click on the following badge:

[![Binder](https://mybinder.org/badge.svg)](https://mybinder.org/v2/gh/RLesur/weasydoc-demo/master?urlpath=rstudio)  

Using this environment, you agree with the terms of the Prince end user license: https://www.princexml.com/license/

## Usage

Here is a simple example:

```r
file.copy(system.file("rmarkdown/templates/hpdf_document/skeleton/skeleton.Rmd", 
                      package = "weasydoc"), 
          "myfile.Rmd")
rmarkdown::render("myfile.Rmd", weasydoc::hpdf_document())
```

This package also supports `bookdown` output format. You can use 
`weasydoc::hpdf_book()` to generate a PDF using `bookdown`.

## How can I learn CSS for Paged Media?

There are a lot of great ressources on the web to learn _CSS for Paged Media_:

- [A Guide To The State Of Print Stylesheets In 2018](https://www.smashingmagazine.com/2018/05/print-stylesheets-in-2018/) by Rachel Andrew
- [Print CSS Rocks: https://print-css.rocks/](https://print-css.rocks/) by Andreas Jung ([@zopyx](https://github.com/zopyx))
- [Introduction to CSS for Paged Media](http://www.xmlprague.cz/wp-content/uploads/www.xmlprague.cz/2018/02/CSS-Print.pdf) by Tony Graham ([@tgraham-antenna](https://github.com/tgraham-antenna)), Antenna House - XML Prague 2018 Conference.
- [Prince User Guide](https://www.princexml.com/doc-prince/)

**O'Reilly Media tutorials on Youtube:**

- [Part 1: Introduction to HTML and CSS](https://www.youtube.com/watch?v=OZeoiotzPFg)
- [Part 2: Basic Layout and Text Formatting](https://www.youtube.com/watch?v=yyqvXhu-HOc)
- [Part 3: Paged Media Basics](https://www.youtube.com/watch?v=P-bDFt2wZDA)
- [Part 4: Generated Content - Counters & Strings](https://www.youtube.com/watch?v=mTgxZmOpJls)

I also recommend this article [Streamlining CSS Print Design with Sass](https://medium.com/@sandersk/streamlining-css-print-design-with-sass-debaa2a204c3) by Sanders Kleinfeld ([@sandersk](https://github.com/sandersk)) and the **Paged Media initiative** blog [www.pagedmedia.org](https://www.pagedmedia.org/).

## Contribution

This package is still in active development. Some breaking changes may appear. Feel free to send a PR. 

## Credits

The name `weasydoc` is a tribute to the [WeasyPrint](https://github.com/Kozea/WeasyPrint) project: I like open source and really appreciate the effort of the community to develop an open source software using _CSS for Paged Media_.

Thanks Christophe Dervieux ([@cderv](https://github.com/cderv)) for making me discover [MyBinder](https://mybinder.org/)! 

The most important source of inspiration comes from the [rmarkdown](https://github.com/rstudio/rmarkdown) and [bookdown](https://github.com/rstudio/bookdown) packages created by Yihui Xie ([@yihui](https://github.com/yihui)). Many thanks!
