context("test-pdf-engines-as-postprocessors.R")

test_that("A non HTML output format fails", {
  expect_error(
    rmarkdown::render("document.Rmd",
                      html2pdf(base_format = rmarkdown::pdf_document)
                      )
  )
})

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

test_that("Attach Rmd file correctly", {
  pdf_file <- rmarkdown::render("document.Rmd", html2pdf(attach_code = TRUE))
  knitr::knit_meta()
  expect_equal(pdftools::pdf_attachments(pdf_file)[[1]]$name, "document.Rmd")
  unlink(pdf_file)

  pdf_file <- rmarkdown::render("document.Rmd",
                                html2pdf(engine = "prince", attach_code = TRUE))
  knitr::knit_meta()
  expect_equal(pdftools::pdf_attachments(pdf_file)[[1]]$name, "document.Rmd")
  unlink(pdf_file)
})

test_that("Keep html option", {
  pdf_file <- rmarkdown::render("document.Rmd", html2pdf(keep_html = TRUE))
  knitr::knit_meta()
  expect_true(file.exists("document.html"))
  unlink(pdf_file)
  unlink("document.html")
})

test_that("Footnotes", {
  expect_error(rmarkdown::render("footnotes.Rmd", html2pdf(notes = "footnotes")))
  pdf_file <- rmarkdown::render("footnotes.Rmd",
                                html2pdf(notes = "footnotes",
                                         engine = "prince",
                                         keep_html = TRUE,
                                         base_format = rmarkdown::html_document_base)
                                )
  # Is there need to parse the html file?
  unlink("footnotes.html")
  unlink(pdf_file)
})
