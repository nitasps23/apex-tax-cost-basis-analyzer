-- =============================================
-- Step 2: Verify data loaded correctly
-- Run after loading CSV files
-- =============================================

SELECT COUNT(*) AS transaction_count FROM transactions;
SELECT COUNT(*) AS lot_count FROM cost_basis_lots;
SELECT COUNT(*) AS report_count FROM tax_reporting;

-- Quick preview of each table
SELECT * FROM transactions LIMIT 5;
SELECT * FROM cost_basis_lots LIMIT 5;
SELECT * FROM tax_reporting LIMIT 5;