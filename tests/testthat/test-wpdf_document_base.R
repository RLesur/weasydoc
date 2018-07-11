context("test-wpdf_document_base.R")

test_that("Pandoc version is OK", {
  expect_true(rmarkdown::pandoc_available("2.1.3"))
})

test_that("Render with Prince", {
  rmarkdown::render("document.Rmd", wpdf_document_base(wpdf_engine = "prince"), "prince.pdf")
  knitr::knit_meta()
  expect_true(file.exists("prince.pdf"))

  expect_match(pdftools::pdf_text("prince.pdf"), "Created with Javascript")
})

test_that("Render with WeasyPrint", {
  rmarkdown::render("document.Rmd", wpdf_document_base(), "weasyprint.pdf")
  knitr::knit_meta()
  expect_true(file.exists("weasyprint.pdf"))
})

