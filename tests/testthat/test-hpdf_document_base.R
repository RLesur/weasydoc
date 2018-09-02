context("test-hpdf_document_base.R")

test_that("Render with WeasyPrint-Default options", {
  pdf_file <- rmarkdown::render("document.Rmd", hpdf_document_base(), "weasyprint.html")
  knitr::knit_meta()
  expect_true(file.exists("weasyprint.pdf"))
  expect_false(file.exists("weasyprint.html"))
  unlink(pdf_file)
})

test_that("Render with Prince-Default options", {
  pdf_file <- rmarkdown::render("document.Rmd", hpdf_document_base(engine = "prince"), "prince.html")
  knitr::knit_meta()
  expect_true(file.exists("prince.pdf"))
  expect_false(file.exists("prince.html"))
  expect_match(pdftools::pdf_text("prince.pdf"), "Created with Javascript")
  unlink(pdf_file)
})

test_that("Attach Rmd file correctly", {
  rmarkdown::render("document.Rmd", hpdf_document_base(attach_code = TRUE), "weasyprint.html")
  knitr::knit_meta()
  rmarkdown::render("document.Rmd", hpdf_document_base(engine = "prince", attach_code = TRUE), "prince.html")
  knitr::knit_meta()

  testthat::expect_equal(pdftools::pdf_attachments("weasyprint.pdf")[[1]]$name, "document.Rmd")
  testthat::expect_equal(pdftools::pdf_attachments("prince.pdf")[[1]]$name, "document.Rmd")
  unlink("weasyprint.pdf")
  unlink("prince.pdf")
})

test_that("Keep html option", {
  rmarkdown::render("document.Rmd", hpdf_document_base(keep_html = TRUE), "weasyprint.html")
  knitr::knit_meta()
  expect_true(file.exists("weasyprint.html"))
  unlink("weasyprint.pdf")
  unlink("weasyprint.html")

  rmarkdown::render("document.Rmd", hpdf_document_base(wpdf_engine = "prince", keep_html = TRUE), "prince.html")
  knitr::knit_meta()
  expect_true(file.exists("prince.html"))
  unlink("prince.pdf")
  unlink("prince.html")
})

test_that("Include CSS works", {
  rmarkdown::render("document.Rmd", hpdf_document_base(keep_html = TRUE, css = "css_file.css"), "include_css.html")
  knitr::knit_meta()
  expect_true(any(grepl("html {color: red;}", readLines("include_css.html"), fixed = TRUE)))

  unlink("include_css.pdf")
  unlink("include_css.html")
})
