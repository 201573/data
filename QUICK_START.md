# 快速开始指南 / Quick Start Guide

## 最简单的使用方法 / Easiest Way to Use

### 步骤 1: 运行Python数据准备脚本
```bash
python3 prepare_data.py
```

这将:
- 读取三个Excel文件 (T1, T2, T3)
- 按姓名对齐数据
- 计算所有变量
- 生成 `merged_data_python.csv`

### 步骤 2: 创建可视化
```bash
python3 create_visualizations.py
```

这将生成5个PNG图表:
1. `correlation_heatmap.png` - 相关矩阵热图
2. `time_series_plots.png` - 时间序列图
3. `childhood_trauma_dimensions.png` - 创伤维度对比
4. `scatter_matrix.png` - 散点图矩阵
5. `mediation_conceptual_model.png` - 中介模型概念图

### 步骤 3 (可选): 运行R完整分析
如果您需要详细的SEM分析结果:

```bash
# 首次使用需要安装R包
Rscript install_r_packages.R

# 运行完整分析
Rscript cross_lagged_analysis.R
```

R脚本将为每个童年期创伤维度生成:
- 交叉滞后模型结果
- 中介效应分析结果
- 路径图

---

## 查看结果 / View Results

### 数据文件
- `merged_data_python.csv` - 在Excel中打开查看合并后的数据
- `descriptive_statistics_python.csv` - 查看描述性统计
- `correlation_matrix_python.csv` - 查看相关系数

### 图表
直接打开PNG文件查看可视化结果

### R分析结果 (如果运行了R脚本)
- `*_summary.txt` - 文本格式的详细结果
- `*_diagram.png` - 路径图
- `analysis_summary_report.txt` - 综合报告

---

## 常见问题 / FAQ

**Q: Python脚本提示缺少包怎么办?**
A: 运行 `pip install pandas numpy openpyxl matplotlib seaborn`

**Q: R脚本运行时间很长?**
A: R包安装需要一些时间，这是正常的。分析本身通常在几分钟内完成。

**Q: 如何解释中介效应?**
A: 查看 `IMPLEMENTATION_SUMMARY.md` 中的"结果解释指南"部分

**Q: 数据中有缺失值怎么办?**
A: 脚本自动处理缺失值，只保留完整数据的参与者

---

## 技术支持 / Support

如有问题，请参考:
1. `README.md` - 完整文档
2. `IMPLEMENTATION_SUMMARY.md` - 详细结果和解释

---

**提示:** 建议先运行Python脚本快速查看结果，然后再决定是否需要运行R的详细SEM分析。
