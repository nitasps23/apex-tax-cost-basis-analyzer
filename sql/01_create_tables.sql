-- =============================================
-- Apex Tax & Cost Basis Analyzer
-- Step 1: Create tables
-- Run once on initial setup
-- =============================================

CREATE TABLE transactions (
    transaction_id VARCHAR(10) PRIMARY KEY,
    account_id VARCHAR(10),
    ticker VARCHAR(10),
    transaction_type VARCHAR(4),
    transaction_date DATE,
    quantity INTEGER,
    price_per_share DECIMAL(10,2),
    total_amount DECIMAL(12,2),
    cost_basis_method VARCHAR(10),
    status VARCHAR(10)
);

-- Create cost basis lots table
CREATE TABLE cost_basis_lots (
    lot_id VARCHAR(10) PRIMARY KEY,
    account_id VARCHAR(10),
    ticker VARCHAR(10),
    acquisition_date DATE,
    quantity INTEGER,
    cost_per_share DECIMAL(10,2),
    cost_basis_total DECIMAL(12,2),
    is_closed BOOLEAN
);

-- Create tax reporting table
CREATE TABLE tax_reporting (
    report_id VARCHAR(10) PRIMARY KEY,
    account_id VARCHAR(10),
    ticker VARCHAR(10),
    sale_date DATE,
    proceeds DECIMAL(12,2),
    cost_basis DECIMAL(12,2),
    gain_loss DECIMAL(12,2),
    holding_period VARCHAR(5),
    reported_to_irs BOOLEAN,
    status VARCHAR(20)
);

