#!/usr/bin/env Rscript

# Test and install R packages with proper library path

cat("Setting up R environment and testing packages...\n\n")

# Create user library directory if it doesn't exist
user_lib <- Sys.getenv("R_LIBS_USER")
if (user_lib == "") {
  user_lib <- path.expand("~/R/library")
}
dir.create(user_lib, recursive = TRUE, showWarnings = FALSE)
.libPaths(c(user_lib, .libPaths()))

cat("R library path:", .libPaths()[1], "\n\n")

# List of required packages
required_packages <- c("readxl", "dplyr", "lavaan", "semPlot", "ggplot2", 
                       "tidyr", "corrplot", "psych")

cat("Installing required packages (this may take a few minutes)...\n")

for (pkg in required_packages) {
  cat("\nChecking package:", pkg, "... ")
  if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
    cat("installing...")
    install.packages(pkg, repos = "https://cloud.r-project.org/", 
                     lib = user_lib, quiet = FALSE)
    if (require(pkg, character.only = TRUE, quietly = TRUE)) {
      cat("✓")
    } else {
      cat("✗ FAILED")
    }
  } else {
    cat("✓ already installed")
  }
}

cat("\n\n", paste(rep("=", 60), collapse = ""), "\n", sep="")
cat("Package installation completed!\n")
cat("You can now run the full analysis with:\n")
cat("  Rscript cross_lagged_analysis.R\n")
cat(paste(rep("=", 60), collapse = ""), "\n")
