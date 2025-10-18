# ============================================================
# DATALAB WORKSHOP PRE-CHECK SCRIPT
# Run this before the workshop to verify your setup
# ============================================================

cat("\n=== DATALAB WORKSHOP PRE-CHECK ===\n\n")

# Track issues
issues <- c()
warnings <- c()

# 1. Check R version
cat("Checking R version... ")
r_version <- as.numeric(paste0(R.version$major, ".", R.version$minor))
if (r_version >= 3.6) {
  cat("✓ OK (", R.version.string, ")\n", sep = "")
} else {
  cat("✗ FAIL\n")
  issues <- c(issues, "R version is too old. Please update to R 3.6.0 or newer.")
}

# 2. Check required packages
cat("\nChecking required packages...\n")

required_packages <- c("ggplot2", "dplyr", "rlang", "scales", "patchwork")

for (pkg in required_packages) {
  cat("  ", pkg, "... ", sep = "")
  if (requireNamespace(pkg, quietly = TRUE)) {
    cat("✓ Installed\n")
  } else {
    cat("✗ Missing\n")
    issues <- c(issues, paste0("Package '", pkg, "' is not installed."))
  }
}

# 3. Try to load datalab package
cat("\nChecking datalab package... ")
if (requireNamespace("datalab", quietly = TRUE)) {
  cat("✓ Installed\n")
  
  # Try to load it
  cat("  Loading package... ")
  tryCatch({
    library(datalab, warn.conflicts = FALSE)
    cat("✓ OK\n")
    
    # Check if sample data exists
    cat("  Checking sample datasets... ")
    tryCatch({
      data(heart_data, envir = environment())
      data(agriculture_data, envir = environment())
      cat("✓ OK\n")
    }, error = function(e) {
      cat("✗ FAIL\n")
      warnings <- c(warnings, "Sample datasets not found. Package may need reinstallation.")
    })
    
  }, error = function(e) {
    cat("✗ FAIL\n")
    issues <- c(issues, paste("Cannot load datalab package:", e$message))
  })
} else {
  cat("✗ Not installed\n")
  issues <- c(issues, "Package 'datalab' is not installed.")
}

# 4. Test basic plotting
cat("\nTesting plotting capability... ")
tryCatch({
  test_data <- data.frame(x = 1:5, y = 1:5)
  p <- ggplot2::ggplot(test_data, ggplot2::aes(x = x, y = y)) + 
    ggplot2::geom_point()
  cat("✓ OK\n")
}, error = function(e) {
  cat("✗ FAIL\n")
  issues <- c(issues, paste("Plotting test failed:", e$message))
})

# 5. Check RStudio (optional but recommended)
cat("\nChecking RStudio... ")
if (Sys.getenv("RSTUDIO") == "1") {
  cat("✓ Running in RStudio\n")
} else {
  cat("⚠ Not running in RStudio\n")
  warnings <- c(warnings, "RStudio is recommended but not required for the workshop.")
}

# Summary
cat("\n=== SUMMARY ===\n\n")

if (length(issues) == 0 && length(warnings) == 0) {
  cat("✓ ALL CHECKS PASSED! You're ready for the workshop.\n\n")
  cat("Next steps:\n")
  cat("  1. Keep this R session open\n")
  cat("  2. Join the workshop at the scheduled time\n")
  cat("  3. Have fun exploring data!\n\n")
} else {
  if (length(issues) > 0) {
    cat("✗ ISSUES FOUND:\n\n")
    for (i in seq_along(issues)) {
      cat("  ", i, ". ", issues[i], "\n", sep = "")
    }
    cat("\n")
  }
  
  if (length(warnings) > 0) {
    cat("⚠ WARNINGS:\n\n")
    for (i in seq_along(warnings)) {
      cat("  ", i, ". ", warnings[i], "\n", sep = "")
    }
    cat("\n")
  }
  
  # Provide solutions
  if (length(issues) > 0) {
    cat("SOLUTIONS:\n\n")
    
    # Missing packages
    missing_pkgs <- required_packages[!sapply(required_packages, function(p) requireNamespace(p, quietly = TRUE))]
    if (length(missing_pkgs) > 0) {
      cat("To install missing packages, run:\n")
      cat('  install.packages(c("', paste(missing_pkgs, collapse = '", "'), '"))\n\n', sep = "")
    }
    
    # Missing datalab
    if (!requireNamespace("datalab", quietly = TRUE)) {
      cat("To install datalab package, you have two options:\n\n")
      cat("Option 1 - Install from local file:\n")
      cat('  install.packages("path/to/datalab_0.1.0.tar.gz", repos = NULL, type = "source")\n\n')
      cat("Option 2 - Install with devtools (if you have the source):\n")
      cat('  devtools::install("path/to/datalab")\n\n')
    }
    
    cat("After making fixes, run this script again to verify.\n\n")
  }
}

cat("Questions? Contact your workshop facilitator.\n")
cat("==========================================\n\n")