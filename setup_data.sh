#!/bin/bash

# =============================================
# Tax & Cost Basis: Data Setup
# Run ONCE to generate and load data
# Usage: bash setup_data.sh
# =============================================

set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "================================================"
echo "Data Setup Pipeline"
echo "Project: $PROJECT_DIR"
echo "Started: $(date)"
echo "================================================"

cd "$PROJECT_DIR"

# Step 1 — Generate synthetic data
echo ""
echo "Step 1: Generating synthetic data..."
jupyter nbconvert \
    --to notebook \
    --execute notebooks/01_generate_data.ipynb \
    --output 01_generate_data.ipynb \
    --ExecutePreprocessor.timeout=120
echo "✓ Data generated — CSV files saved to data/"

# Step 2 — Load into PostgreSQL
echo ""
echo "Step 2: Loading data into PostgreSQL..."
jupyter nbconvert \
    --to notebook \
    --execute notebooks/02_load_data.ipynb \
    --output 02_load_data.ipynb \
    --ExecutePreprocessor.timeout=120
echo "✓ Data loaded into apex_tax_db"

# Step 3: Fix column data types
echo ""
echo "Step 3: Updating column data types..."
psql -U postgres -d apex_tax_db \
    -f sql/01.2_update_tables.sql
echo "✓ Column types updated — dates properly typed"

# Step 4 — Verify data loaded correctly
echo ""
echo "Step 4: Verifying data..."
psql -U postgres -d apex_tax_db \
    -f sql/02_verify_data.sql \
    | tee reports/data_verification.txt
echo "✓ Data verification saved to reports/data_verification.txt"


echo ""
echo "================================================"
echo "Setup complete: $(date)"
echo "CSV files → data/"
echo "Tables loaded → apex_tax_db"
echo "Date types    → fixed"
echo "Run bash run_pipeline.sh for analysis"
echo "================================================"