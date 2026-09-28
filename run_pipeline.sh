#!/bin/bash

# =============================================
# Tax & Cost Basis: Analysis Pipeline
# Run repeatedly after setup_data.sh
# Usage: bash run_pipeline.sh
# =============================================

set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "================================================"
echo "Tax & Cost Basis Analysis Pipeline"
echo "Project: $PROJECT_DIR"
echo "Started: $(date)"
echo "================================================"

cd "$PROJECT_DIR"

# Create output folders if they don't exist
mkdir -p reports
mkdir -p visualizations

# Step 1 - Run data quality checks
echo ""
echo "Step 1: Running SQL data quality checks..."
psql -U postgres -d apex_tax_db \
    -f sql/03_data_quality_checks.sql \
    -o reports/quality_check_results.txt
echo "✓ Quality checks → reports/quality_check_results.txt"

# Step 2 - Run advanced SQL analysis
echo ""
echo "Step 2: Running advanced SQL analysis..."
psql -U postgres -d apex_tax_db \
    -f sql/04_advanced_analysis.sql \
    -o reports/advanced_analysis_results.txt
echo "✓ Advanced analysis → reports/advanced_analysis_results.txt"

# Step 3 - Run Python analysis + visualizations
echo ""
echo "Step 3: Running analysis and building charts..."
jupyter nbconvert \
    --to notebook \
    --execute notebooks/03_analysis.ipynb \
    --output 03_analysis.ipynb \
    --ExecutePreprocessor.timeout=180
echo "✓ Analysis complete → visualizations/"

# Step 4 - Generate Claude AI management report
echo ""
echo "Step 4: Generating Claude AI management report..."
jupyter nbconvert \
    --to notebook \
    --execute notebooks/04_ai_analysis.ipynb \
    --output 04_ai_analysis.ipynb \
    --ExecutePreprocessor.timeout=120
echo "✓ Management report → reports/management_report.md"

# Step 5 — Run deep AI analysis
echo ""
echo "Step 5: Running deep AI analysis..."
jupyter nbconvert \
    --to notebook \
    --execute notebooks/05_ai_deep_analysis.ipynb \
    --output 05_ai_deep_analysis.ipynb \
    --ExecutePreprocessor.timeout=120
echo "✓ Deep analysis → reports/management_report_detailed.md"

echo ""
echo "================================================"
echo "Pipeline complete: $(date)"
echo ""
echo "Outputs:"
echo "  SQL results  → reports/quality_check_results.txt"
echo "  SQL advanced → reports/advanced_analysis_results.txt"
echo "  Charts       → visualizations/"
echo "  AI report    → reports/management_report.md"
echo "  Deep report  → reports/management_report_detailed.md"
echo "================================================"