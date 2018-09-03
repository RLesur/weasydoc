context("test-h5pdf_document.R")

test_that("Is output format", {
  expect_true(inherits(h5pdf_document(), "rmarkdown_output_format"))
})
