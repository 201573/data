"""
Data Preparation Script for Cross-Lagged Analysis
准备交叉滞后分析的数据
"""

import pandas as pd
import numpy as np
from pathlib import Path

def load_data():
    """Load all three time point data files"""
    print("Loading data files...")
    t1_data = pd.read_excel('T1（已经转换）.xlsx')
    t2_data = pd.read_excel('T2（已经转换）.xlsx')
    t3_data = pd.read_excel('T3（已经转换）.xlsx')
    
    print(f"T1 data: {len(t1_data)} rows")
    print(f"T2 data: {len(t2_data)} rows")
    print(f"T3 data: {len(t3_data)} rows")
    
    return t1_data, t2_data, t3_data

def calculate_childhood_trauma_dimensions(df):
    """
    Calculate 5 dimensions of childhood trauma from CTQ items
    
    维度1 (Dimension 1): T3, T8, T14, T18, T25
    维度2 (Dimension 2): T9, T11, T12, T15, T17
    维度3 (Dimension 3): T20, T21, T23, T24, T27
    维度4 (Dimension 4): T5, T7, T13, T19, T28
    维度5 (Dimension 5): T1, T2, T4, T6, T26
    """
    print("\nCalculating Childhood Trauma dimensions...")
    
    dimensions = {
        'CT_Dim1': ['T3', 'T8', 'T14', 'T18', 'T25'],
        'CT_Dim2': ['T9', 'T11', 'T12', 'T15', 'T17'],
        'CT_Dim3': ['T20', 'T21', 'T23', 'T24', 'T27'],
        'CT_Dim4': ['T5', 'T7', 'T13', 'T19', 'T28'],
        'CT_Dim5': ['T1', 'T2', 'T4', 'T6', 'T26']
    }
    
    result = df.copy()
    
    for dim_name, items in dimensions.items():
        # Calculate mean score for each dimension
        result[dim_name] = df[items].mean(axis=1)
        print(f"{dim_name}: Mean = {result[dim_name].mean():.2f}, SD = {result[dim_name].std():.2f}")
    
    return result

def process_t1_data(df):
    """Process T1 data - extract childhood trauma and cognitive effort"""
    print("\nProcessing T1 data...")
    
    # Calculate childhood trauma dimensions
    df = calculate_childhood_trauma_dimensions(df)
    
    # Extract relevant columns
    processed = df[[
        '姓名', '编号', '试次',
        'CT_Dim1', 'CT_Dim2', 'CT_Dim3', 'CT_Dim4', 'CT_Dim5',
        '认知需求总分'
    ]].copy()
    
    # Rename for clarity
    processed.rename(columns={'认知需求总分': 'CogEffort_T1'}, inplace=True)
    
    return processed

def process_t2_data(df):
    """Process T2 data - extract cognitive effort and meaning in life"""
    print("\nProcessing T2 data...")
    
    # Cognitive effort from total score
    cog_effort = df['认知需求总分']
    
    # Meaning in Life from Y items (Y1-Y15)
    y_cols = [col for col in df.columns if col.startswith('Y') and len(col) <= 3]
    meaning_life = df[y_cols].mean(axis=1)
    
    print(f"Cognitive Effort T2: Mean = {cog_effort.mean():.2f}, SD = {cog_effort.std():.2f}")
    print(f"Meaning in Life T2: Mean = {meaning_life.mean():.2f}, SD = {meaning_life.std():.2f}")
    
    # Create processed dataframe
    processed = pd.DataFrame({
        '姓名': df['姓名'],
        '编号': df['编号'],
        '试次': df['试次'],
        'CogEffort_T2': cog_effort,
        'MeaningLife_T2': meaning_life
    })
    
    return processed

def process_t3_data(df):
    """Process T3 data - extract cognitive effort and meaning in life"""
    print("\nProcessing T3 data...")
    
    # Cognitive effort from total score
    cog_effort = df['认知需求总分']
    
    # Meaning in Life from W items (W1-W15)
    w_cols = [col for col in df.columns if col.startswith('W') and len(col) <= 3]
    meaning_life = df[w_cols].mean(axis=1)
    
    print(f"Cognitive Effort T3: Mean = {cog_effort.mean():.2f}, SD = {cog_effort.std():.2f}")
    print(f"Meaning in Life T3: Mean = {meaning_life.mean():.2f}, SD = {meaning_life.std():.2f}")
    
    # Create processed dataframe
    processed = pd.DataFrame({
        '姓名': df['姓名'],
        '编号': df['编号'],
        '试次': df['试次'],
        'CogEffort_T3': cog_effort,
        'MeaningLife_T3': meaning_life
    })
    
    return processed

def merge_data(t1_processed, t2_processed, t3_processed):
    """Merge data from three time points by name"""
    print("\nMerging data by participant name (姓名)...")
    
    # Merge T1 and T2
    merged = t1_processed.merge(
        t2_processed,
        on='姓名',
        how='inner',
        suffixes=('_t1', '_t2')
    )
    
    # Merge with T3
    merged = merged.merge(
        t3_processed,
        on='姓名',
        how='inner'
    )
    
    # Clean up column names
    # Keep only necessary columns
    cols_to_keep = [
        '姓名',
        'CT_Dim1', 'CT_Dim2', 'CT_Dim3', 'CT_Dim4', 'CT_Dim5',
        'CogEffort_T1', 'CogEffort_T2', 'CogEffort_T3',
        'MeaningLife_T2', 'MeaningLife_T3'
    ]
    
    merged = merged[cols_to_keep]
    
    # Remove rows with missing data
    initial_count = len(merged)
    merged = merged.dropna()
    final_count = len(merged)
    
    print(f"Initial merged sample: {initial_count}")
    print(f"After removing missing data: {final_count}")
    print(f"Removed {initial_count - final_count} cases with missing data")
    
    return merged

def generate_descriptive_statistics(merged_data):
    """Generate descriptive statistics for all variables"""
    print("\n" + "="*60)
    print("Descriptive Statistics")
    print("="*60)
    
    # Calculate descriptive statistics
    desc_stats = merged_data.describe().T
    desc_stats['missing'] = merged_data.isnull().sum()
    
    print(desc_stats)
    
    # Save to CSV
    desc_stats.to_csv('descriptive_statistics_python.csv', encoding='utf-8-sig')
    print("\nDescriptive statistics saved to: descriptive_statistics_python.csv")
    
    return desc_stats

def generate_correlation_matrix(merged_data):
    """Generate and save correlation matrix"""
    print("\n" + "="*60)
    print("Correlation Matrix")
    print("="*60)
    
    # Calculate correlation matrix
    vars_for_corr = [
        'CT_Dim1', 'CT_Dim2', 'CT_Dim3', 'CT_Dim4', 'CT_Dim5',
        'CogEffort_T1', 'CogEffort_T2', 'CogEffort_T3',
        'MeaningLife_T2', 'MeaningLife_T3'
    ]
    
    corr_matrix = merged_data[vars_for_corr].corr()
    
    print(corr_matrix.round(3))
    
    # Save to CSV
    corr_matrix.to_csv('correlation_matrix_python.csv', encoding='utf-8-sig')
    print("\nCorrelation matrix saved to: correlation_matrix_python.csv")
    
    return corr_matrix

def main():
    """Main execution function"""
    print("="*60)
    print("Data Preparation for Cross-Lagged Panel Analysis")
    print("交叉滞后分析数据准备")
    print("="*60)
    
    # Load data
    t1_data, t2_data, t3_data = load_data()
    
    # Process each time point
    t1_processed = process_t1_data(t1_data)
    t2_processed = process_t2_data(t2_data)
    t3_processed = process_t3_data(t3_data)
    
    # Merge data
    merged_data = merge_data(t1_processed, t2_processed, t3_processed)
    
    # Save merged data
    merged_data.to_csv('merged_data_python.csv', index=False, encoding='utf-8-sig')
    print(f"\nMerged data saved to: merged_data_python.csv")
    print(f"Total sample size: {len(merged_data)}")
    
    # Generate descriptive statistics
    desc_stats = generate_descriptive_statistics(merged_data)
    
    # Generate correlation matrix
    corr_matrix = generate_correlation_matrix(merged_data)
    
    print("\n" + "="*60)
    print("Data preparation completed successfully!")
    print("="*60)
    print("\nNext steps:")
    print("1. Review the merged_data_python.csv file")
    print("2. Check descriptive_statistics_python.csv")
    print("3. Examine correlation_matrix_python.csv")
    print("4. Run the R script (cross_lagged_analysis.R) for the full analysis")
    print("   or use the prepared data for other statistical analyses")

if __name__ == "__main__":
    main()
