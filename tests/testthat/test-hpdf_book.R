context("test-hpdf_book.R")

test_that("Is an output format", {
  expect_true(inherits(hpdf_book(), "rmarkdown_output_format"))
})
