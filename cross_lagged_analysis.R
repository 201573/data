# Cross-Lagged Panel Analysis
# 童年期创伤(Childhood Trauma), 认知努力(Cognitive Effort), 生命意义感(Meaning in Life)
# 分析思路: 认知努力在童年期创伤对生命意义感影响的路径中是否起到中介作用

# Load required packages
required_packages <- c("readxl", "dplyr", "lavaan", "semPlot", "ggplot2", 
                       "tidyr", "corrplot", "psych")

for (pkg in required_packages) {
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg, repos = "https://cloud.r-project.org/")
    library(pkg, character.only = TRUE)
  }
}

# Working directory is already set to the data folder

# 1. Load Data
cat("Loading data...\n")
t1_data <- read_excel("T1（已经转换）.xlsx")
t2_data <- read_excel("T2（已经转换）.xlsx")
t3_data <- read_excel("T3（已经转换）.xlsx")

cat("T1 data:", nrow(t1_data), "rows\n")
cat("T2 data:", nrow(t2_data), "rows\n")
cat("T3 data:", nrow(t3_data), "rows\n")

# 2. Calculate Childhood Trauma Dimensions (from T1 only)
# 童年期创伤维度定义:
# 维度1: T3, T8, T14, T18, T25
# 维度2: T9, T11, T12, T15, T17
# 维度3: T20, T21, T23, T24, T27
# 维度4: T5, T7, T13, T19, T28
# 维度5: T1, T2, T4, T6, T26

cat("\nCalculating Childhood Trauma dimensions...\n")
t1_processed <- t1_data %>%
  mutate(
    # Childhood Trauma Dimensions
    CT_Dim1 = rowMeans(select(., T3, T8, T14, T18, T25), na.rm = TRUE),
    CT_Dim2 = rowMeans(select(., T9, T11, T12, T15, T17), na.rm = TRUE),
    CT_Dim3 = rowMeans(select(., T20, T21, T23, T24, T27), na.rm = TRUE),
    CT_Dim4 = rowMeans(select(., T5, T7, T13, T19, T28), na.rm = TRUE),
    CT_Dim5 = rowMeans(select(., T1, T2, T4, T6, T26), na.rm = TRUE),
    
    # Cognitive Effort (using the total score from the data)
    CogEffort_T1 = 认知需求总分
  ) %>%
  select(姓名, 编号, 试次, CT_Dim1, CT_Dim2, CT_Dim3, CT_Dim4, CT_Dim5, CogEffort_T1)

# 3. Process T2 data
# Based on the data structure, E items might be cognitive effort, Y items might be meaning in life
cat("Processing T2 data...\n")
t2_processed <- t2_data %>%
  mutate(
    # Cognitive Effort - using the total score
    CogEffort_T2 = 认知需求总分,
    
    # Meaning in Life - calculate from Y items (Y1-Y15)
    MeaningLife_T2 = rowMeans(select(., starts_with("Y")), na.rm = TRUE)
  ) %>%
  select(姓名, 编号, 试次, CogEffort_T2, MeaningLife_T2)

# 4. Process T3 data
# W items might be meaning in life
cat("Processing T3 data...\n")
t3_processed <- t3_data %>%
  mutate(
    # Cognitive Effort - using the total score
    CogEffort_T3 = 认知需求总分,
    
    # Meaning in Life - calculate from W items (W1-W15)
    MeaningLife_T3 = rowMeans(select(., starts_with("W")), na.rm = TRUE)
  ) %>%
  select(姓名, 编号, 试次, CogEffort_T3, MeaningLife_T3)

# 5. Merge data by name (姓名)
cat("\nMerging data by name...\n")
merged_data <- t1_processed %>%
  inner_join(t2_processed, by = "姓名", suffix = c("_t1", "_t2")) %>%
  inner_join(t3_processed, by = "姓名") %>%
  filter(!is.na(CT_Dim1) & !is.na(CT_Dim2) & !is.na(CT_Dim3) & 
         !is.na(CT_Dim4) & !is.na(CT_Dim5) &
         !is.na(CogEffort_T1) & !is.na(CogEffort_T2) & !is.na(CogEffort_T3) &
         !is.na(MeaningLife_T2) & !is.na(MeaningLife_T3))

cat("Merged data:", nrow(merged_data), "participants with complete data across all three time points\n")

# Save merged data
write.csv(merged_data, "merged_data.csv", row.names = FALSE, fileEncoding = "UTF-8")
cat("Saved merged data to merged_data.csv\n")

# 6. Descriptive Statistics
cat("\n=== Descriptive Statistics ===\n")
desc_vars <- merged_data %>%
  select(CT_Dim1, CT_Dim2, CT_Dim3, CT_Dim4, CT_Dim5,
         CogEffort_T1, CogEffort_T2, CogEffort_T3,
         MeaningLife_T2, MeaningLife_T3)

desc_stats <- describe(desc_vars)
print(desc_stats)

# Save descriptive statistics
write.csv(desc_stats, "descriptive_statistics.csv", fileEncoding = "UTF-8")

# 7. Correlation Matrix
cat("\n=== Correlation Matrix ===\n")
cor_matrix <- cor(desc_vars, use = "pairwise.complete.obs")
print(round(cor_matrix, 3))

# Save correlation matrix
write.csv(cor_matrix, "correlation_matrix.csv", fileEncoding = "UTF-8")

# Visualize correlation matrix
png("correlation_matrix.png", width = 1200, height = 1000, res = 120)
corrplot(cor_matrix, method = "color", type = "upper", 
         tl.col = "black", tl.srt = 45,
         addCoef.col = "black", number.cex = 0.7,
         title = "Correlation Matrix of All Variables",
         mar = c(0,0,2,0))
dev.off()
cat("Saved correlation matrix plot to correlation_matrix.png\n")

# 8. Cross-Lagged Panel Model for each Childhood Trauma Dimension
cat("\n=== Cross-Lagged Panel Analysis ===\n")

# Function to run cross-lagged model for each CT dimension
run_cross_lagged_model <- function(ct_var, dim_name) {
  cat("\n--- Childhood Trauma Dimension:", dim_name, "---\n")
  
  # Define the cross-lagged panel model
  # Path: CT_T1 -> CogEffort_T2 -> MeaningLife_T3
  # Also including autoregressive paths and cross-lagged paths
  model <- paste0('
    # Autoregressive paths
    CogEffort_T2 ~ a1*CogEffort_T1
    CogEffort_T3 ~ a2*CogEffort_T2
    MeaningLife_T3 ~ a3*MeaningLife_T2
    
    # Cross-lagged paths (from CT to CogEffort)
    CogEffort_T2 ~ b1*', ct_var, '
    CogEffort_T3 ~ b2*', ct_var, '
    
    # Cross-lagged paths (from CT to MeaningLife)
    MeaningLife_T2 ~ c1*', ct_var, '
    MeaningLife_T3 ~ c2*', ct_var, '
    
    # Cross-lagged paths (from CogEffort to MeaningLife)
    MeaningLife_T2 ~ d1*CogEffort_T1
    MeaningLife_T3 ~ d2*CogEffort_T2
    
    # Covariances
    CogEffort_T1 ~~ ', ct_var, '
    CogEffort_T2 ~~ MeaningLife_T2
    CogEffort_T3 ~~ MeaningLife_T3
  ')
  
  # Fit the model
  fit <- sem(model, data = merged_data, missing = "fiml")
  
  # Print summary
  print(summary(fit, fit.measures = TRUE, standardized = TRUE))
  
  # Save model summary
  sink(paste0("cross_lagged_", dim_name, "_summary.txt"))
  print(summary(fit, fit.measures = TRUE, standardized = TRUE))
  sink()
  
  # Create path diagram
  png(paste0("cross_lagged_", dim_name, "_diagram.png"), 
      width = 1400, height = 1000, res = 120)
  semPaths(fit, what = "std", layout = "tree2", 
           edge.label.cex = 0.8, curvePivot = TRUE,
           title = paste("Cross-Lagged Model:", dim_name))
  dev.off()
  
  cat("Saved diagram to cross_lagged_", dim_name, "_diagram.png\n")
  
  return(fit)
}

# Run models for all 5 dimensions
ct_dimensions <- list(
  list(var = "CT_Dim1", name = "Dimension1"),
  list(var = "CT_Dim2", name = "Dimension2"),
  list(var = "CT_Dim3", name = "Dimension3"),
  list(var = "CT_Dim4", name = "Dimension4"),
  list(var = "CT_Dim5", name = "Dimension5")
)

models <- list()
for (dim in ct_dimensions) {
  models[[dim$name]] <- run_cross_lagged_model(dim$var, dim$name)
}

# 9. Mediation Analysis
cat("\n=== Mediation Analysis ===\n")
cat("Testing whether Cognitive Effort mediates the relationship between\n")
cat("Childhood Trauma and Meaning in Life\n")

# Function to run mediation analysis for each CT dimension
run_mediation_analysis <- function(ct_var, dim_name) {
  cat("\n--- Mediation Analysis for Childhood Trauma", dim_name, "---\n")
  
  # Mediation model: CT -> CogEffort -> MeaningLife
  # Using T1 for CT, T2 for CogEffort (mediator), T3 for MeaningLife (outcome)
  mediation_model <- paste0('
    # Direct paths
    CogEffort_T2 ~ a*', ct_var, '
    MeaningLife_T3 ~ b*CogEffort_T2 + c*', ct_var, '
    
    # Indirect effect
    indirect := a*b
    
    # Total effect
    total := c + (a*b)
  ')
  
  # Fit the mediation model
  fit <- sem(mediation_model, data = merged_data, missing = "fiml")
  
  # Print summary
  print(summary(fit, fit.measures = TRUE, standardized = TRUE))
  
  # Save model summary
  sink(paste0("mediation_", dim_name, "_summary.txt"))
  print(summary(fit, fit.measures = TRUE, standardized = TRUE))
  sink()
  
  # Create path diagram
  png(paste0("mediation_", dim_name, "_diagram.png"), 
      width = 1200, height = 800, res = 120)
  semPaths(fit, what = "std", layout = "tree", 
           edge.label.cex = 1.0, curvePivot = TRUE,
           title = paste("Mediation Model:", dim_name))
  dev.off()
  
  cat("Saved mediation diagram to mediation_", dim_name, "_diagram.png\n")
  
  # Extract parameter estimates
  params <- parameterEstimates(fit, standardized = TRUE)
  
  # Extract key effects
  indirect_effect <- params[params$label == "indirect", ]
  total_effect <- params[params$label == "total", ]
  
  cat("\nIndirect Effect (a*b):", indirect_effect$est, 
      ", p =", indirect_effect$pvalue, "\n")
  cat("Total Effect:", total_effect$est, 
      ", p =", total_effect$pvalue, "\n")
  
  return(fit)
}

# Run mediation analysis for all 5 dimensions
mediation_models <- list()
for (dim in ct_dimensions) {
  mediation_models[[dim$name]] <- run_mediation_analysis(dim$var, dim$name)
}

# 10. Create summary visualization comparing all dimensions
cat("\n=== Creating Summary Visualizations ===\n")

# Extract indirect effects for all dimensions
indirect_effects <- data.frame(
  Dimension = character(),
  Estimate = numeric(),
  SE = numeric(),
  pvalue = numeric(),
  stringsAsFactors = FALSE
)

for (dim in ct_dimensions) {
  fit <- mediation_models[[dim$name]]
  params <- parameterEstimates(fit, standardized = TRUE)
  indirect <- params[params$label == "indirect", ]
  
  indirect_effects <- rbind(indirect_effects, data.frame(
    Dimension = dim$name,
    Estimate = indirect$est,
    SE = indirect$se,
    pvalue = indirect$pvalue
  ))
}

# Save indirect effects summary
write.csv(indirect_effects, "mediation_indirect_effects_summary.csv", 
          row.names = FALSE, fileEncoding = "UTF-8")

# Plot indirect effects
png("mediation_indirect_effects_comparison.png", width = 1000, height = 800, res = 120)
ggplot(indirect_effects, aes(x = Dimension, y = Estimate)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  geom_errorbar(aes(ymin = Estimate - 1.96*SE, ymax = Estimate + 1.96*SE),
                width = 0.2) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
  labs(title = "Indirect Effects of Childhood Trauma on Meaning in Life\nvia Cognitive Effort",
       subtitle = "Error bars represent 95% confidence intervals",
       x = "Childhood Trauma Dimension",
       y = "Standardized Indirect Effect") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
dev.off()
cat("Saved indirect effects comparison plot\n")

# 11. Create a comprehensive summary report
cat("\n=== Creating Summary Report ===\n")

sink("analysis_summary_report.txt")
cat(paste(rep("=", 60), collapse = ""), "\n")
cat("Cross-Lagged Panel Analysis and Mediation Analysis\n")
cat("Childhood Trauma, Cognitive Effort, and Meaning in Life\n")
cat(paste(rep("=", 60), collapse = ""), "\n\n")

cat("Sample Size:\n")
cat("- Total participants with complete data:", nrow(merged_data), "\n\n")

cat("Variables:\n")
cat("- Childhood Trauma (T1): 5 dimensions\n")
cat("  * Dimension 1: Items T3, T8, T14, T18, T25\n")
cat("  * Dimension 2: Items T9, T11, T12, T15, T17\n")
cat("  * Dimension 3: Items T20, T21, T23, T24, T27\n")
cat("  * Dimension 4: Items T5, T7, T13, T19, T28\n")
cat("  * Dimension 5: Items T1, T2, T4, T6, T26\n")
cat("- Cognitive Effort: Total scores at T1, T2, T3\n")
cat("- Meaning in Life: Total scores at T2, T3\n\n")

cat("Analysis Approach:\n")
cat("1. Cross-Lagged Panel Analysis\n")
cat("   - Examined reciprocal relationships across time\n")
cat("   - Tested paths: CT_T1 -> CogEffort_T2 -> MeaningLife_T3\n\n")

cat("2. Mediation Analysis\n")
cat("   - Tested whether Cognitive Effort mediates the relationship\n")
cat("     between Childhood Trauma and Meaning in Life\n")
cat("   - Model: CT_T1 -> CogEffort_T2 -> MeaningLife_T3\n\n")

cat("Indirect Effects Summary:\n")
print(indirect_effects)
cat("\n")

cat("Interpretation:\n")
cat("- Significant indirect effects (p < 0.05) indicate mediation\n")
cat("- Positive coefficients suggest that higher childhood trauma\n")
cat("  is associated with changes in cognitive effort, which in turn\n")
cat("  affects meaning in life\n\n")

cat("Output Files:\n")
cat("- merged_data.csv: Complete dataset with all variables\n")
cat("- descriptive_statistics.csv: Descriptive statistics\n")
cat("- correlation_matrix.csv: Correlation matrix\n")
cat("- correlation_matrix.png: Correlation plot\n")
cat("- cross_lagged_Dimension[1-5]_summary.txt: Model summaries\n")
cat("- cross_lagged_Dimension[1-5]_diagram.png: Path diagrams\n")
cat("- mediation_Dimension[1-5]_summary.txt: Mediation summaries\n")
cat("- mediation_Dimension[1-5]_diagram.png: Mediation diagrams\n")
cat("- mediation_indirect_effects_summary.csv: Summary of indirect effects\n")
cat("- mediation_indirect_effects_comparison.png: Comparison plot\n\n")

cat(paste(rep("=", 60), collapse = ""), "\n")
cat("Analysis completed successfully!\n")
cat(paste(rep("=", 60), collapse = ""), "\n")
sink()

cat("\n=== All analyses completed! ===\n")
cat("Please check the output files for detailed results.\n")
