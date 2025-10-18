library(testthat)
library(datalab)

# Setup test data
data <- data.frame(
  nitrogen_content = c(10, 20, 30, 40, 50),
  crop_yield = c(100, 150, 180, 200, 220),
  chest_pain_type = c("A", "B", "A", "C", "B"),
  sex = c("Male", "Male", "Female", "Female", "Male"),
  age = c(25, 35, 45, 55, 65)
)

test_that("linechart produces plot with default data", {
  expect_silent({
    p <- linechart(nitrogen_content, crop_yield)
  })
  expect_s3_class(p, "ggplot")
})

test_that("linechart works with explicit data argument", {
  custom_data <- data.frame(x = 1:5, y = 6:10)
  expect_silent({
    p <- linechart(x, y, data = custom_data)
  })
  expect_s3_class(p, "ggplot")
})

test_that("boxplot produces single boxplot", {
  expect_silent({
    p <- boxplot(age)
  })
  expect_s3_class(p, "ggplot")
})

test_that("boxplot works with grouping", {
  expect_silent({
    p <- boxplot(age, group = sex)
  })
  expect_s3_class(p, "ggplot")
})

test_that("piechart produces single pie chart", {
  expect_silent({
    p <- piechart(chest_pain_type)
  })
  expect_s3_class(p, "ggplot")
})

test_that("piechart produces multiple charts with filter", {
  expect_silent({
    p <- piechart(chest_pain_type, sex)
  })
  # Should return patchwork object
  expect_true(inherits(p, "patchwork") || inherits(p, "ggplot"))
})

test_that("descriptives returns data frame", {
  result <- descriptives(nitrogen_content, crop_yield)
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 2)
  expect_true("Mean" %in% names(result))
})

test_that("descriptives computes correct statistics", {
  result <- descriptives(nitrogen_content)
  expect_equal(result$Mean, 30)
  expect_equal(result$N, 5)
})

test_that("frequencies returns frequency table", {
  result <- frequencies(chest_pain_type)
  expect_s3_class(result, "data.frame")
  expect_true("Count" %in% names(result))
  expect_true("Percent" %in% names(result))
})

test_that("frequencies sorts correctly", {
  result_desc <- frequencies(chest_pain_type, sort = "desc")
  expect_true(result_desc$Count[1] >= result_desc$Count[nrow(result_desc)])
  
  result_asc <- frequencies(chest_pain_type, sort = "asc")
  expect_true(result_asc$Count[1] <= result_asc$Count[nrow(result_asc)])
})

test_that("error message for missing variable is clear", {
  expect_error(
    linechart(nonexistent_var, crop_yield),
    "Variable 'nonexistent_var' not found"
  )
})

test_that("error message for missing data frame is clear", {
  rm(data, envir = .GlobalEnv)
  expect_error(
    linechart(x, y),
    "No data frame found"
  )
  # Restore data
  data <- data.frame(
    nitrogen_content = c(10, 20, 30, 40, 50),
    crop_yield = c(100, 150, 180, 200, 220)
  )
})