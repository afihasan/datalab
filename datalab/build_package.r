# ============================================================
# DATALAB PACKAGE BUILD SCRIPT
# Run this to build and check the package
# ============================================================
# Required packages for development
dev_packages <- c("devtools", "roxygen2", "testthat", "knitr", "rmarkdown", "usethis")

cat("Checking development packages...\n")
missing_dev <- dev_packages[!sapply(dev_packages, requireNamespace, quietly = TRUE)]

if (length(missing_dev) > 0) {
  cat("Installing missing development packages:", paste(missing_dev, collapse = ", "), "\n")
  install.packages(missing_dev)
}

# ADD THIS NEW SECTION:
# Check package dependencies (what datalab needs to run)
cat("Checking package dependencies...\n")
pkg_deps <- c("ggplot2", "dplyr", "rlang", "scales", "patchwork")
missing_deps <- pkg_deps[!sapply(pkg_deps, requireNamespace, quietly = TRUE)]

if (length(missing_deps) > 0) {
  cat("Installing missing package dependencies:", paste(missing_deps, collapse = ", "), "\n")
  install.packages(missing_deps)
}

library(devtools)

cat("\n=== Building datalab Package ===\n\n")

# Required packages for development
dev_packages <- c("devtools", "roxygen2", "testthat", "knitr", "rmarkdown", "usethis")

cat("Checking development packages...\n")
missing_dev <- dev_packages[!sapply(dev_packages, requireNamespace, quietly = TRUE)]

if (length(missing_dev) > 0) {
  cat("Installing missing development packages:", paste(missing_dev, collapse = ", "), "\n")
  install.packages(missing_dev)
}

library(devtools)

# Set working directory to package root (if not already there)
if (!file.exists("DESCRIPTION")) {
  stop("Please run this script from the package root directory (where DESCRIPTION is located)")
}

# Step 1: Generate documentation
cat("\n1. Generating documentation...\n")
document()

# Step 2: Run tests
cat("\n2. Running tests...\n")
test_results <- test()
if (any(as.data.frame(test_results)$failed > 0)) {
  warning("Some tests failed! Review output above.")
} else {
  cat("✓ All tests passed!\n")
}

# Step 3: Check package
cat("\n3. Running R CMD check...\n")
check_results <- check()

# Step 4: Build package
cat("\n4. Building package...\n")
build()

# Step 5: Build vignettes
cat("\n5. Building vignettes...\n")
build_vignettes()

cat("\n=== Build Complete ===\n")
cat("\nPackage file: datalab_0.1.0.tar.gz\n")
cat("To install locally: install.packages('datalab_0.1.0.tar.gz', repos = NULL, type = 'source')\n")
cat("To share: Send the .tar.gz file to participants\n\n")

# Create a workshop bundle
cat("Creating workshop bundle...\n")

workshop_files <- c(
  "workshop/participant_template.R",
  "workshop/exercise_answers.R",
  "workshop/facilitator_guide.md",
  "workshop/cheat_sheet.md",
  "workshop/precheck.R",
  "workshop/installation_guide.md",
  "README.md"
)

if (all(file.exists(workshop_files))) {
  zip("datalab_workshop_bundle.zip", files = workshop_files)
  cat("✓ Workshop bundle created: datalab_workshop_bundle.zip\n")
} else {
  cat("⚠ Some workshop files missing. Bundle not created.\n")
}

cat("\n=== Next Steps ===\n")
cat("1. Test installation in a fresh R session\n")
cat("2. Review check results for any warnings\n")
cat("3. Distribute datalab_0.1.0.tar.gz to participants\n")
cat("4. Send workshop bundle to facilitators\n\n")