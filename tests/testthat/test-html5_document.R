context("test-html5_document.R")

test_that("Is output format", {
  expect_true(inherits(html5_document(), "rmarkdown_output_format"))
})
