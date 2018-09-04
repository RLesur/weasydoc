context("test-hpdf_document.R")

test_that("Is output format", {
  expect_true(inherits(hpdf_document(), "rmarkdown_output_format"))
})
