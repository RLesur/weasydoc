context("test-pdf-engines-as-postprocessors.R")

test_that("Post process html_document", {
  pdf_file <- rmarkdown::render("document.Rmd", html2pdf())
  expect_true(file.exists(pdf_file))
  unlink(pdf_file)
})

test_that("Post process a bookdown", {
  pdf_file <- rmarkdown::render("document.Rmd", wpdf_document2())
  expect_true(file.exists(pdf_file))
  unlink(pdf_file)
})

