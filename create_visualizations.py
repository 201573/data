"""
Create visualizations for the cross-lagged analysis
使用Python创建交叉滞后分析的可视化图表
"""

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from matplotlib import rcParams

# Set up matplotlib for Chinese characters
rcParams['font.sans-serif'] = ['DejaVu Sans', 'Arial Unicode MS', 'SimHei']
rcParams['axes.unicode_minus'] = False

def create_correlation_heatmap(merged_data, output_file='correlation_heatmap.png'):
    """Create a correlation heatmap"""
    print("\nCreating correlation heatmap...")
    
    vars_for_corr = [
        'CT_Dim1', 'CT_Dim2', 'CT_Dim3', 'CT_Dim4', 'CT_Dim5',
        'CogEffort_T1', 'CogEffort_T2', 'CogEffort_T3',
        'MeaningLife_T2', 'MeaningLife_T3'
    ]
    
    # Calculate correlation matrix
    corr_matrix = merged_data[vars_for_corr].corr()
    
    # Create figure
    plt.figure(figsize=(12, 10))
    
    # Create heatmap
    sns.heatmap(corr_matrix, annot=True, fmt='.3f', cmap='coolwarm', 
                center=0, square=True, linewidths=1,
                cbar_kws={"shrink": 0.8})
    
    plt.title('Correlation Matrix of All Variables\nChildhood Trauma, Cognitive Effort, and Meaning in Life',
              fontsize=14, fontweight='bold', pad=20)
    plt.tight_layout()
    plt.savefig(output_file, dpi=300, bbox_inches='tight')
    plt.close()
    
    print(f"✓ Saved correlation heatmap to {output_file}")

def create_time_series_plots(merged_data):
    """Create time series plots for Cognitive Effort and Meaning in Life"""
    print("\nCreating time series plots...")
    
    fig, axes = plt.subplots(2, 1, figsize=(12, 10))
    
    # Plot 1: Cognitive Effort across time
    ax1 = axes[0]
    time_points = ['T1', 'T2', 'T3']
    cog_means = [
        merged_data['CogEffort_T1'].mean(),
        merged_data['CogEffort_T2'].mean(),
        merged_data['CogEffort_T3'].mean()
    ]
    cog_sems = [
        merged_data['CogEffort_T1'].sem(),
        merged_data['CogEffort_T2'].sem(),
        merged_data['CogEffort_T3'].sem()
    ]
    
    ax1.errorbar(time_points, cog_means, yerr=[1.96*s for s in cog_sems], 
                 marker='o', linewidth=2, markersize=10, capsize=5, capthick=2)
    ax1.set_ylabel('Cognitive Effort (Mean Score)', fontsize=12, fontweight='bold')
    ax1.set_title('Cognitive Effort Across Time Points', fontsize=14, fontweight='bold', pad=15)
    ax1.grid(True, alpha=0.3)
    
    # Plot 2: Meaning in Life across time
    ax2 = axes[1]
    time_points_ml = ['T2', 'T3']
    ml_means = [
        merged_data['MeaningLife_T2'].mean(),
        merged_data['MeaningLife_T3'].mean()
    ]
    ml_sems = [
        merged_data['MeaningLife_T2'].sem(),
        merged_data['MeaningLife_T3'].sem()
    ]
    
    ax2.errorbar(time_points_ml, ml_means, yerr=[1.96*s for s in ml_sems],
                 marker='s', linewidth=2, markersize=10, capsize=5, capthick=2, color='green')
    ax2.set_xlabel('Time Point', fontsize=12, fontweight='bold')
    ax2.set_ylabel('Meaning in Life (Mean Score)', fontsize=12, fontweight='bold')
    ax2.set_title('Meaning in Life Across Time Points', fontsize=14, fontweight='bold', pad=15)
    ax2.grid(True, alpha=0.3)
    
    plt.tight_layout()
    plt.savefig('time_series_plots.png', dpi=300, bbox_inches='tight')
    plt.close()
    
    print("✓ Saved time series plots to time_series_plots.png")

def create_childhood_trauma_dimensions_plot(merged_data):
    """Create a bar plot comparing childhood trauma dimensions"""
    print("\nCreating childhood trauma dimensions comparison...")
    
    ct_dims = ['CT_Dim1', 'CT_Dim2', 'CT_Dim3', 'CT_Dim4', 'CT_Dim5']
    ct_labels = ['Dimension 1', 'Dimension 2', 'Dimension 3', 'Dimension 4', 'Dimension 5']
    
    means = [merged_data[dim].mean() for dim in ct_dims]
    sems = [merged_data[dim].sem() for dim in ct_dims]
    
    plt.figure(figsize=(12, 6))
    
    colors = sns.color_palette("husl", 5)
    bars = plt.bar(ct_labels, means, yerr=[1.96*s for s in sems], 
                   capsize=5, color=colors, alpha=0.8, edgecolor='black', linewidth=1.5)
    
    plt.ylabel('Mean Score', fontsize=12, fontweight='bold')
    plt.xlabel('Childhood Trauma Dimension', fontsize=12, fontweight='bold')
    plt.title('Childhood Trauma Dimensions Comparison\n(Error bars represent 95% confidence intervals)',
              fontsize=14, fontweight='bold', pad=20)
    plt.grid(True, axis='y', alpha=0.3)
    plt.xticks(rotation=45, ha='right')
    
    # Add value labels on bars
    for bar, mean in zip(bars, means):
        height = bar.get_height()
        plt.text(bar.get_x() + bar.get_width()/2., height,
                f'{mean:.2f}',
                ha='center', va='bottom', fontweight='bold')
    
    plt.tight_layout()
    plt.savefig('childhood_trauma_dimensions.png', dpi=300, bbox_inches='tight')
    plt.close()
    
    print("✓ Saved childhood trauma dimensions plot to childhood_trauma_dimensions.png")

def create_scatter_matrices(merged_data):
    """Create scatter plot matrices for key relationships"""
    print("\nCreating scatter plot matrix...")
    
    # Select key variables for scatter matrix
    key_vars = [
        'CT_Dim1', 'CT_Dim4',  # Two example trauma dimensions
        'CogEffort_T1', 'CogEffort_T2', 'CogEffort_T3',
        'MeaningLife_T2', 'MeaningLife_T3'
    ]
    
    # Create scatter matrix
    fig = plt.figure(figsize=(16, 16))
    
    # Use pandas scatter_matrix
    pd.plotting.scatter_matrix(merged_data[key_vars], alpha=0.3, figsize=(16, 16),
                              diagonal='hist', hist_kwds={'bins': 30, 'edgecolor': 'black'})
    
    plt.suptitle('Scatter Plot Matrix of Key Variables', fontsize=16, fontweight='bold', y=0.995)
    plt.tight_layout()
    plt.savefig('scatter_matrix.png', dpi=300, bbox_inches='tight')
    plt.close()
    
    print("✓ Saved scatter matrix to scatter_matrix.png")

def create_mediation_diagram(output_file='mediation_conceptual_model.png'):
    """Create a conceptual mediation model diagram"""
    print("\nCreating conceptual mediation model diagram...")
    
    fig, ax = plt.subplots(figsize=(14, 8))
    ax.set_xlim(0, 10)
    ax.set_ylim(0, 10)
    ax.axis('off')
    
    # Box parameters
    box_width = 2.5
    box_height = 1.5
    
    # Define box positions
    ct_pos = (1, 5)  # Childhood Trauma
    ce_pos = (5, 7.5)  # Cognitive Effort
    ml_pos = (9, 5)  # Meaning in Life
    
    # Draw boxes
    boxes = {
        'CT': plt.Rectangle((ct_pos[0] - box_width/2, ct_pos[1] - box_height/2),
                           box_width, box_height, fill=True, facecolor='lightcoral',
                           edgecolor='black', linewidth=2),
        'CE': plt.Rectangle((ce_pos[0] - box_width/2, ce_pos[1] - box_height/2),
                           box_width, box_height, fill=True, facecolor='lightyellow',
                           edgecolor='black', linewidth=2),
        'ML': plt.Rectangle((ml_pos[0] - box_width/2, ml_pos[1] - box_height/2),
                           box_width, box_height, fill=True, facecolor='lightgreen',
                           edgecolor='black', linewidth=2)
    }
    
    for box in boxes.values():
        ax.add_patch(box)
    
    # Add text labels
    ax.text(ct_pos[0], ct_pos[1], 'Childhood\nTrauma\n(T1)', 
            ha='center', va='center', fontsize=12, fontweight='bold')
    ax.text(ce_pos[0], ce_pos[1], 'Cognitive\nEffort\n(T2)', 
            ha='center', va='center', fontsize=12, fontweight='bold')
    ax.text(ml_pos[0], ml_pos[1], 'Meaning\nin Life\n(T3)', 
            ha='center', va='center', fontsize=12, fontweight='bold')
    
    # Draw arrows
    # CT -> CE (path a)
    ax.annotate('', xy=(ce_pos[0] - box_width/2, ce_pos[1] - box_height/4),
                xytext=(ct_pos[0] + box_width/2, ct_pos[1] + box_height/4),
                arrowprops=dict(arrowstyle='->', lw=3, color='blue'))
    ax.text(3, 6.8, 'path a', ha='center', va='center', fontsize=11, 
            color='blue', fontweight='bold')
    
    # CE -> ML (path b)
    ax.annotate('', xy=(ml_pos[0] - box_width/2, ml_pos[1] + box_height/4),
                xytext=(ce_pos[0] + box_width/2, ce_pos[1] - box_height/4),
                arrowprops=dict(arrowstyle='->', lw=3, color='blue'))
    ax.text(7, 6.8, 'path b', ha='center', va='center', fontsize=11,
            color='blue', fontweight='bold')
    
    # CT -> ML (path c')
    ax.annotate('', xy=(ml_pos[0] - box_width/2, ml_pos[1]),
                xytext=(ct_pos[0] + box_width/2, ct_pos[1]),
                arrowprops=dict(arrowstyle='->', lw=2, color='red', linestyle='--'))
    ax.text(5, 4.3, "path c' (direct effect)", ha='center', va='center', 
            fontsize=11, color='red', fontweight='bold')
    
    # Add title
    ax.text(5, 9.5, 'Mediation Model: Cognitive Effort as Mediator',
            ha='center', va='top', fontsize=16, fontweight='bold')
    
    # Add explanation
    ax.text(5, 0.8, 'Indirect effect (mediation) = a × b',
            ha='center', va='center', fontsize=12, style='italic',
            bbox=dict(boxstyle='round,pad=0.5', facecolor='wheat', alpha=0.5))
    
    plt.savefig(output_file, dpi=300, bbox_inches='tight')
    plt.close()
    
    print(f"✓ Saved conceptual mediation model to {output_file}")

def main():
    """Main execution function"""
    print("="*60)
    print("Creating Visualizations for Cross-Lagged Analysis")
    print("="*60)
    
    # Load merged data
    print("\nLoading merged data...")
    merged_data = pd.read_csv('merged_data_python.csv')
    print(f"✓ Loaded {len(merged_data)} participants")
    
    # Create all visualizations
    create_correlation_heatmap(merged_data)
    create_time_series_plots(merged_data)
    create_childhood_trauma_dimensions_plot(merged_data)
    create_scatter_matrices(merged_data)
    create_mediation_diagram()
    
    print("\n" + "="*60)
    print("All visualizations created successfully!")
    print("="*60)
    print("\nGenerated files:")
    print("  - correlation_heatmap.png")
    print("  - time_series_plots.png")
    print("  - childhood_trauma_dimensions.png")
    print("  - scatter_matrix.png")
    print("  - mediation_conceptual_model.png")

if __name__ == "__main__":
    main()
