#!/usr/bin/env Rscript

# Cross-Lagged Panel Analysis - Command Line Version
# This script can be run from the command line without RStudio

cat("Starting Cross-Lagged Panel Analysis...\n\n")

# Check and install required packages
cat("Checking required packages...\n")
required_packages <- c("readxl", "dplyr", "lavaan", "semPlot", "ggplot2", 
                       "tidyr", "corrplot", "psych")

for (pkg in required_packages) {
  if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
    cat(paste("Installing package:", pkg, "\n"))
    install.packages(pkg, repos = "https://cloud.r-project.org/", quiet = TRUE)
    library(pkg, character.only = TRUE)
  }
}

cat("All required packages loaded successfully!\n\n")

# Source the main analysis script
source("cross_lagged_analysis.R")
