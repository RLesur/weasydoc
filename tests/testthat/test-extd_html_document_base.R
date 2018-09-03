context("test-extd_html_document_base.R")

test_that("Is output format", {
  expect_true(inherits(extd_html_document_base(), "rmarkdown_output_format"))
})
