-- =============================================
-- Step 2: Verify data loaded correctly
-- Run after loading CSV files
-- =============================================

-- Summary row counts - all three in one view
SELECT 
    'transactions' AS table_name,
    COUNT(*) AS row_count
FROM transactions

UNION ALL

SELECT 
    'cost_basis_lots',
    COUNT(*)
FROM cost_basis_lots

UNION ALL

SELECT 
    'tax_reporting',
    COUNT(*)
FROM tax_reporting;

-- Quick preview of each table
SELECT * FROM transactions LIMIT 5;
SELECT * FROM cost_basis_lots LIMIT 5;
SELECT * FROM tax_reporting LIMIT 5;