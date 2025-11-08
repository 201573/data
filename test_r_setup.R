#!/usr/bin/env Rscript

# Test script to verify R setup and basic functionality

cat("Testing R installation and basic functionality...\n\n")

# Test 1: Check if we can load data
cat("Test 1: Loading data files...\n")
tryCatch({
  if (!require("readxl", quietly = TRUE)) {
    install.packages("readxl", repos = "https://cloud.r-project.org/", quiet = TRUE)
    library(readxl)
  }
  
  t1_data <- read_excel("T1（已经转换）.xlsx")
  cat("✓ T1 data loaded:", nrow(t1_data), "rows\n")
  
  t2_data <- read_excel("T2（已经转换）.xlsx")
  cat("✓ T2 data loaded:", nrow(t2_data), "rows\n")
  
  t3_data <- read_excel("T3（已经转换）.xlsx")
  cat("✓ T3 data loaded:", nrow(t3_data), "rows\n")
  
  cat("\nTest 1: PASSED ✓\n")
}, error = function(e) {
  cat("\nTest 1: FAILED ✗\n")
  cat("Error:", conditionMessage(e), "\n")
})

# Test 2: Check if we can use dplyr
cat("\nTest 2: Testing dplyr functionality...\n")
tryCatch({
  if (!require("dplyr", quietly = TRUE)) {
    install.packages("dplyr", repos = "https://cloud.r-project.org/", quiet = TRUE)
    library(dplyr)
  }
  
  t1_processed <- t1_data %>%
    select(姓名, 编号, T1, T2, T3) %>%
    head(5)
  
  cat("✓ dplyr operations work\n")
  cat("\nTest 2: PASSED ✓\n")
}, error = function(e) {
  cat("\nTest 2: FAILED ✗\n")
  cat("Error:", conditionMessage(e), "\n")
})

# Test 3: Check if merged_data_python.csv exists (from Python script)
cat("\nTest 3: Checking for pre-processed data...\n")
if (file.exists("merged_data_python.csv")) {
  cat("✓ merged_data_python.csv exists\n")
  
  # Try to load it
  merged_data <- read.csv("merged_data_python.csv", fileEncoding = "UTF-8")
  cat("✓ Successfully loaded merged data:", nrow(merged_data), "rows\n")
  cat("\nColumn names:\n")
  print(colnames(merged_data))
  
  cat("\nTest 3: PASSED ✓\n")
} else {
  cat("✗ merged_data_python.csv not found\n")
  cat("\nTest 3: FAILED ✗\n")
}

cat("\n", paste(rep("=", 50), collapse = ""), "\n", sep="")
cat("Basic R functionality verified!\n")
cat("The full analysis can be run using: Rscript cross_lagged_analysis.R\n")
cat(paste(rep("=", 50), collapse = ""), "\n")
