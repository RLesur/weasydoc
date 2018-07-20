context("test-wpdf_document_base.R")

test_that("Render with WeasyPrint-Default options", {
  rmarkdown::render("document.Rmd", wpdf_document_base(), "weasyprint.pdf")
  knitr::knit_meta()
  expect_true(file.exists("weasyprint.pdf"))
})

test_that("Render with Prince-Default options", {
  rmarkdown::render("document.Rmd", wpdf_document_base(wpdf_engine = "prince"), "prince.pdf")
  knitr::knit_meta()
  expect_true(file.exists("prince.pdf"))

  expect_match(pdftools::pdf_text("prince.pdf"), "Created with Javascript")
})

test_that("Attach Rmd file correctly", {
  rmarkdown::render("document.Rmd", wpdf_document_base(attach_code = TRUE), "weasyprint.pdf")
  knitr::knit_meta()
  rmarkdown::render("document.Rmd", wpdf_document_base(wpdf_engine = "prince", attach_code = TRUE), "prince.pdf")
  knitr::knit_meta()

  testthat::expect_equal(pdftools::pdf_attachments("weasyprint.pdf")[[1]]$name, "document.Rmd")
  testthat::expect_equal(pdftools::pdf_attachments("prince.pdf")[[1]]$name, "document.Rmd")
})
