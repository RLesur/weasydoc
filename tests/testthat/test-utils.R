context("test-utils.R")

test_that("Prince is installed", {
  expect_true(prince_available())
})

test_that("WeasyPrint is installed", {
  expect_true(weasyprint_available())
})

