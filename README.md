# 交叉滞后分析 / Cross-Lagged Panel Analysis

## 项目概述 / Project Overview

本项目实现了童年期创伤(Childhood Trauma)、认知努力(Cognitive Effort)和生命意义感(Meaning in Life)的交叉滞后分析和中介效应分析。

This project implements cross-lagged panel analysis and mediation analysis for Childhood Trauma, Cognitive Effort, and Meaning in Life.

## 研究问题 / Research Question

**研究假设**: 认知努力在童年期创伤对生命意义感影响的路径中是否起到中介作用？

**Research Hypothesis**: Does cognitive effort mediate the relationship between childhood trauma and meaning in life?

## 数据文件 / Data Files

- `T1（已经转换）.xlsx` - 第一时间点数据 (Time 1 data)
- `T2（已经转换）.xlsx` - 第二时间点数据 (Time 2 data)
- `T3（已经转换）.xlsx` - 第三时间点数据 (Time 3 data)

## 变量说明 / Variables

### 童年期创伤 (Childhood Trauma) - T1
童年期创伤分为5个维度，基于CTQ问卷的28个题目：

- **维度1 (Dimension 1)**: 题目 T3, T8, T14, T18, T25
- **维度2 (Dimension 2)**: 题目 T9, T11, T12, T15, T17
- **维度3 (Dimension 3)**: 题目 T20, T21, T23, T24, T27
- **维度4 (Dimension 4)**: 题目 T5, T7, T13, T19, T28
- **维度5 (Dimension 5)**: 题目 T1, T2, T4, T6, T26

### 认知努力 (Cognitive Effort) - T1, T2, T3
使用"认知需求总分"变量

### 生命意义感 (Meaning in Life) - T2, T3
- T2: 基于Y系列题目计算总分
- T3: 基于W系列题目计算总分

## 运行分析 / Running the Analysis

### 前提条件 / Prerequisites

#### Python (推荐使用 / Recommended)
- Python 3.7 or higher
- 所需Python包 / Required Python packages:
  - pandas
  - numpy
  - openpyxl
  - matplotlib
  - seaborn

安装方法 / Installation:
```bash
pip install pandas numpy openpyxl matplotlib seaborn
```

#### R (可选，用于完整的SEM分析 / Optional, for full SEM analysis)
- R (version 4.0 or higher)
- 所需R包 / Required R packages:
  - readxl
  - dplyr
  - lavaan
  - semPlot
  - ggplot2
  - tidyr
  - corrplot
  - psych

### 运行方法 / How to Run

#### 方法1: Python数据准备和可视化 (推荐/Recommended)
```bash
# Step 1: 准备数据 / Prepare data
python3 prepare_data.py

# Step 2: 创建可视化 / Create visualizations
python3 create_visualizations.py
```

这将生成以下文件 / This will generate:
- `merged_data_python.csv` - 合并后的数据 / Merged dataset
- `descriptive_statistics_python.csv` - 描述性统计 / Descriptive statistics
- `correlation_matrix_python.csv` - 相关矩阵 / Correlation matrix
- 多个PNG可视化图表 / Multiple PNG visualization files

#### 方法2: 使用RStudio进行完整分析
1. 打开 `cross_lagged_analysis.R` 文件
2. 选择全部代码并运行

#### 方法3: 命令行运行R分析
```bash
# 首先安装R包 / First install R packages
Rscript install_r_packages.R

# 然后运行分析 / Then run the analysis
Rscript run_analysis.R
```

或者直接运行主脚本:
```bash
Rscript cross_lagged_analysis.R
```

## 项目文件 / Project Files

### 核心脚本 / Core Scripts
- `prepare_data.py` - Python数据准备脚本 (推荐先运行)
- `create_visualizations.py` - Python可视化脚本
- `cross_lagged_analysis.R` - R完整分析脚本 (包含交叉滞后和中介分析)
- `run_analysis.R` - R分析启动脚本
- `install_r_packages.R` - R包安装脚本

### 数据和结果 / Data and Results
- `merged_data_python.csv` - 处理后的合并数据
- `descriptive_statistics_python.csv` - 描述性统计结果
- `correlation_matrix_python.csv` - 相关矩阵
- 各类PNG图表文件 - 可视化结果

## 分析方法 / Analysis Methods

### 1. 数据对齐 / Data Alignment
- 根据姓名(Name)自动匹配三个时间点的数据
- 仅保留在所有三个时间点都有完整数据的参与者

### 2. 交叉滞后面板分析 / Cross-Lagged Panel Analysis
对每个童年期创伤维度分别进行分析，模型包括：
- 自回归路径 (Autoregressive paths)
- 交叉滞后路径 (Cross-lagged paths)
- 协方差 (Covariances)

### 3. 中介效应分析 / Mediation Analysis
检验认知努力是否中介童年期创伤对生命意义感的影响：
- **自变量**: 童年期创伤 (T1)
- **中介变量**: 认知努力 (T2)
- **因变量**: 生命意义感 (T3)

## 输出文件 / Output Files

### 数据文件 / Data Files
- `merged_data.csv` - 合并后的完整数据集
- `descriptive_statistics.csv` - 描述性统计
- `correlation_matrix.csv` - 相关系数矩阵

### 分析结果 / Analysis Results
- `cross_lagged_Dimension[1-5]_summary.txt` - 各维度交叉滞后模型结果
- `mediation_Dimension[1-5]_summary.txt` - 各维度中介效应模型结果
- `mediation_indirect_effects_summary.csv` - 间接效应汇总

### 可视化图表 / Visualizations
- `correlation_matrix.png` - 相关矩阵热图
- `cross_lagged_Dimension[1-5]_diagram.png` - 交叉滞后路径图
- `mediation_Dimension[1-5]_diagram.png` - 中介效应路径图
- `mediation_indirect_effects_comparison.png` - 各维度间接效应对比图

### 综合报告 / Summary Report
- `analysis_summary_report.txt` - 分析总结报告

## 结果解释 / Interpreting Results

### 拟合指数 / Fit Indices
- **CFI** (Comparative Fit Index) > 0.90 表示良好拟合
- **TLI** (Tucker-Lewis Index) > 0.90 表示良好拟合
- **RMSEA** (Root Mean Square Error of Approximation) < 0.08 表示良好拟合
- **SRMR** (Standardized Root Mean Square Residual) < 0.08 表示良好拟合

### 间接效应 / Indirect Effects
- **显著性**: p < 0.05 表示中介效应显著
- **方向**: 
  - 正值表示正向中介
  - 负值表示负向中介
- **效应量**: 标准化系数的绝对值越大，效应越强

## 注意事项 / Notes

1. 分析假设所有变量均为连续变量
2. 使用FIML (Full Information Maximum Likelihood) 处理缺失数据
3. T1时间点仅使用童年期创伤数据，符合研究设计
4. 所有路径系数均为标准化系数，便于比较不同变量间的效应大小

## 引用 / Citation

如果使用本分析代码，请引用：
- Rosseel, Y. (2012). lavaan: An R Package for Structural Equation Modeling. Journal of Statistical Software, 48(2), 1-36.

## 联系方式 / Contact

如有问题，请通过GitHub Issues反馈。
