context("test-make_pdf.R")

test_that("Direct PDF generation with WeasyPrint", {
  pdf_file <- make_pdf("test folder/html_file.html")
  expect_true(file.exists(pdf_file))
  unlink(pdf_file)
})

test_that("Direct PDF generation with Prince", {
  pdf_file <- make_pdf("test folder/html_file.html", engine = "prince")
  expect_true(file.exists(pdf_file))
  unlink(pdf_file)
})


