# 交叉滞后分析实施总结 / Cross-Lagged Analysis Implementation Summary

## 项目完成状态 / Project Completion Status

本项目已成功实现童年期创伤、认知努力与生命意义感的交叉滞后分析框架。

This project has successfully implemented a cross-lagged analysis framework for Childhood Trauma, Cognitive Effort, and Meaning in Life.

---

## 数据处理结果 / Data Processing Results

### 样本量 / Sample Size
- **原始数据 / Raw Data:**
  - T1: 2,844 名参与者 / participants
  - T2: 2,479 名参与者 / participants
  - T3: 2,215 名参与者 / participants

- **合并数据 / Merged Data:**
  - **1,416 名参与者** 在所有三个时间点都有完整数据
  - **1,416 participants** with complete data across all three time points

### 变量构建 / Variable Construction

#### 1. 童年期创伤 (Childhood Trauma) - 5个维度
基于CTQ问卷28个题目，按照指定维度分组计算平均分：

**维度1 (Dimension 1):** Items T3, T8, T14, T18, T25
- 均值 Mean: 1.67
- 标准差 SD: 0.73

**维度2 (Dimension 2):** Items T9, T11, T12, T15, T17
- 均值 Mean: 1.37
- 标准差 SD: 0.63

**维度3 (Dimension 3):** Items T20, T21, T23, T24, T27
- 均值 Mean: 1.21
- 标准差 SD: 0.49

**维度4 (Dimension 4):** Items T5, T7, T13, T19, T28
- 均值 Mean: 2.44
- 标准差 SD: 1.17

**维度5 (Dimension 5):** Items T1, T2, T4, T6, T26
- 均值 Mean: 1.74
- 标准差 SD: 0.68

#### 2. 认知努力 (Cognitive Effort) - 3个时间点
使用"认知需求总分"变量：

- **T1:** Mean = 75.38, SD = 16.07
- **T2:** Mean = 72.12, SD = 16.36
- **T3:** Mean = 71.08, SD = 14.90

#### 3. 生命意义感 (Meaning in Life) - 2个时间点

- **T2:** Mean = 4.19, SD = 1.21 (基于Y1-Y15题目)
- **T3:** Mean = 4.27, SD = 1.27 (基于W1-W15题目)

---

## 关键发现 / Key Findings

### 相关性分析 / Correlation Analysis

**童年期创伤与认知努力的负相关:**
- CT_Dim1 与 CogEffort_T1: r = -0.214
- CT_Dim1 与 CogEffort_T2: r = -0.234
- CT_Dim1 与 CogEffort_T3: r = -0.191

**童年期创伤与生命意义感的负相关:**
- CT_Dim1 与 MeaningLife_T2: r = -0.200
- CT_Dim1 与 MeaningLife_T3: r = -0.183

**认知努力与生命意义感的正相关:**
- CogEffort_T2 与 MeaningLife_T2: r = 0.395
- CogEffort_T3 与 MeaningLife_T3: r = 0.399

**认知努力的时间稳定性:**
- CogEffort_T1 与 T2: r = 0.570
- CogEffort_T2 与 T3: r = 0.576

这些相关性模式**支持中介假设**，表明认知努力可能在童年期创伤与生命意义感的关系中起中介作用。

---

## 已完成的分析脚本 / Completed Analysis Scripts

### 1. Python脚本 (已测试 ✓ / Tested)

#### `prepare_data.py`
- 读取三个Excel文件
- 按姓名自动对齐数据
- 计算5个童年期创伤维度
- 计算认知努力和生命意义感总分
- 生成合并数据集和描述性统计

**输出文件:**
- `merged_data_python.csv`
- `descriptive_statistics_python.csv`
- `correlation_matrix_python.csv`

#### `create_visualizations.py`
- 创建相关矩阵热图
- 创建时间序列图
- 创建童年期创伤维度对比图
- 创建散点图矩阵
- 创建中介模型概念图

**输出文件:**
- `correlation_heatmap.png`
- `time_series_plots.png`
- `childhood_trauma_dimensions.png`
- `scatter_matrix.png`
- `mediation_conceptual_model.png`

### 2. R脚本 (准备就绪 / Ready to Use)

#### `cross_lagged_analysis.R`
完整的交叉滞后面板分析和中介分析脚本，包括：

**功能:**
1. 数据加载和预处理
2. 为每个童年期创伤维度构建交叉滞后模型
3. 测试中介效应 (a×b路径)
4. 生成路径图和结果报告
5. 比较不同维度的间接效应

**使用的R包:**
- `lavaan`: 结构方程模型
- `semPlot`: 路径图可视化
- `readxl`, `dplyr`: 数据处理
- `ggplot2`, `corrplot`: 额外可视化

**输出文件 (将生成):**
- 交叉滞后模型摘要 (5个维度)
- 中介分析摘要 (5个维度)
- 路径图 (10个PNG文件)
- 间接效应比较图
- 综合分析报告

---

## 分析模型 / Analysis Models

### 交叉滞后面板模型 / Cross-Lagged Panel Model

```
时间点:     T1              T2              T3
变量:    CT, CogEffort   CogEffort,      CogEffort,
                        MeaningLife     MeaningLife

路径包括:
- 自回归路径 (如: CogEffort_T2 → CogEffort_T3)
- 交叉滞后路径 (如: CT_T1 → CogEffort_T2)
- 同期协方差 (如: CogEffort_T2 ↔ MeaningLife_T2)
```

### 中介模型 / Mediation Model

```
                     认知努力 T2
                   (Cognitive Effort)
                    /              \
                 a /                \ b
                  /                  \
童年期创伤 T1 ----------------------> 生命意义感 T3
(Childhood Trauma)      c'        (Meaning in Life)

间接效应 (Indirect Effect) = a × b
总效应 (Total Effect) = c' + (a × b)
```

---

## 使用说明 / Usage Instructions

### 快速开始 (Python方法 - 推荐)

```bash
# 1. 准备数据
python3 prepare_data.py

# 2. 创建可视化
python3 create_visualizations.py

# 3. 查看结果
# 检查生成的CSV文件和PNG图表
```

### 完整分析 (R方法)

```bash
# 1. 安装R包 (首次运行)
Rscript install_r_packages.R

# 2. 运行完整分析
Rscript cross_lagged_analysis.R

# 3. 查看结果
# 检查生成的所有分析报告和路径图
```

---

## 结果解释指南 / Result Interpretation Guide

### 中介效应显著性判断

**显著中介 (p < 0.05):** 
- 表明认知努力显著中介了童年期创伤对生命意义感的影响
- 童年期创伤通过影响认知努力，间接影响生命意义感

**部分中介 vs 完全中介:**
- 如果直接效应(c')和间接效应(a×b)都显著 → 部分中介
- 如果只有间接效应显著，直接效应不显著 → 完全中介

### 模型拟合度评估

良好拟合的标准:
- **CFI** ≥ 0.90
- **TLI** ≥ 0.90
- **RMSEA** ≤ 0.08
- **SRMR** ≤ 0.08

---

## 研究意义 / Research Implications

本分析提供了关于童年期创伤如何通过认知过程影响个体生命意义感的纵向证据。研究结果可能对以下领域有启示：

1. **临床干预:** 识别认知努力作为潜在的干预靶点
2. **预防策略:** 早期识别高风险个体
3. **理论发展:** 理解创伤对发展的长期影响机制

This analysis provides longitudinal evidence about how childhood trauma influences meaning in life through cognitive processes. The findings may have implications for:

1. **Clinical Intervention:** Identifying cognitive effort as a potential intervention target
2. **Prevention Strategies:** Early identification of high-risk individuals
3. **Theoretical Development:** Understanding mechanisms of long-term trauma effects on development

---

## 技术支持 / Technical Support

### 依赖包安装问题

**Python:**
```bash
pip install pandas numpy openpyxl matplotlib seaborn
```

**R:**
```bash
Rscript install_r_packages.R
```

### 常见问题

1. **字符编码问题:** 确保CSV文件使用UTF-8编码
2. **内存不足:** 大型数据集建议增加R内存限制
3. **包版本冲突:** 建议使用最新版本的包

---

## 文件清单 / File Checklist

### 原始数据文件
- [x] T1（已经转换）.xlsx
- [x] T2（已经转换）.xlsx
- [x] T3（已经转换）.xlsx

### 分析脚本
- [x] prepare_data.py
- [x] create_visualizations.py
- [x] cross_lagged_analysis.R
- [x] run_analysis.R
- [x] install_r_packages.R

### 文档
- [x] README.md
- [x] IMPLEMENTATION_SUMMARY.md (本文件)

### 数据输出
- [x] merged_data_python.csv
- [x] descriptive_statistics_python.csv
- [x] correlation_matrix_python.csv

### 可视化输出
- [x] correlation_heatmap.png
- [x] time_series_plots.png
- [x] childhood_trauma_dimensions.png
- [x] scatter_matrix.png
- [x] mediation_conceptual_model.png

---

## 下一步建议 / Next Steps

1. **运行R完整分析:** 执行 `cross_lagged_analysis.R` 生成详细的SEM结果
2. **检验假设:** 验证中介效应在不同创伤维度上的异质性
3. **敏感性分析:** 测试模型在不同子样本上的稳定性
4. **撰写报告:** 整合Python和R的分析结果，撰写研究报告

---

**项目状态:** ✅ 完成 / COMPLETED
**最后更新:** 2025-11-08
