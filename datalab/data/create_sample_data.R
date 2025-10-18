# Script to create sample datasets for the datalab package
# This script should be in the 'data-raw' directory
# Run this *once* manually to create/update the .rda files in the 'data' folder.

set.seed(42)

# Agriculture dataset
agriculture_data <- data.frame(
  nitrogen_content = seq(10, 100, length.out = 50),
  crop_yield = seq(10, 100, length.out = 50) * 20 + stats::rnorm(50, 0, 100)
)

# Heart disease dataset
heart_data <- data.frame(
  age = sample(30:80, 200, replace = TRUE),
  sex = sample(c("Male", "Female"), 200, replace = TRUE, prob = c(0.55, 0.45)),
  chest_pain_type = sample(c("A", "B", "C", "D"), 200, replace = TRUE, prob = c(0.3, 0.25, 0.25, 0.2)),
  resting_bp = stats::rnorm(200, 130, 15),
  cholesterol = stats::rnorm(200, 240, 40)
)

# Save datasets to the 'data/' folder
# This requires the 'usethis' package to be installed
if (requireNamespace("usethis", quietly = TRUE)) {
  usethis::use_data(agriculture_data, overwrite = TRUE)
  usethis::use_data(heart_data, overwrite = TRUE)
} else {
  stop("Please install 'usethis' to save the data.")
}