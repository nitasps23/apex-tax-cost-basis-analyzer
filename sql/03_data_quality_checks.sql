-- =============================================
-- DATA QUALITY CHECK 1: Missing or null values
-- =============================================
SELECT
    'Missing price_per_share' AS issue_type,
    COUNT(*) AS issue_count
FROM transactions
WHERE price_per_share IS NULL

UNION ALL

SELECT
    'Zero quantity transactions',
    COUNT(*)
FROM transactions
WHERE quantity = 0

UNION ALL

SELECT
    'Missing cost basis on tax reports',
    COUNT(*)
FROM tax_reporting
WHERE cost_basis IS NULL;

-- =============================================
-- DATA QUALITY CHECK 2: Total amount validation
-- Does quantity x price = total_amount?
-- =============================================
SELECT
    transaction_id,
    account_id,
    ticker,
    quantity,
    price_per_share,
    total_amount,
    ROUND((quantity * price_per_share)::numeric, 2) AS expected_amount,
    ROUND((total_amount - (quantity * price_per_share))::numeric, 2) AS variance
FROM transactions
WHERE price_per_share IS NOT NULL
    AND quantity > 0
    AND ABS(total_amount - (quantity * price_per_share)) > 0.01
ORDER BY variance DESC;

-- =============================================
-- DATA QUALITY CHECK 3: Exception tracking
-- All ERROR and PENDING transactions
-- =============================================
SELECT
    status,
    COUNT(*) AS transaction_count,
    SUM(total_amount) AS total_dollar_value,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS pct_of_total
FROM transactions
GROUP BY status
ORDER BY transaction_count DESC;

-- =============================================
-- DATA QUALITY CHECK 4: Tax reporting discrepancies
-- =============================================
SELECT
    status,
    COUNT(*) AS report_count,
    ROUND(AVG(gain_loss)::numeric, 2) AS avg_gain_loss,
    SUM(CASE WHEN reported_to_irs = FALSE THEN 1 ELSE 0 END) AS not_yet_reported
FROM tax_reporting
GROUP BY status;

-- =============================================
-- DATA QUALITY CHECK 5: Gain/loss validation
-- Does proceeds - cost_basis = gain_loss?
-- =============================================
SELECT
    report_id,
    account_id,
    ticker,
    proceeds,
    cost_basis,
    gain_loss,
    ROUND((proceeds - cost_basis)::numeric, 2) AS expected_gain_loss,
    ROUND((gain_loss - (proceeds - cost_basis))::numeric, 2) AS variance
FROM tax_reporting
WHERE cost_basis IS NOT NULL
    AND ABS(gain_loss - (proceeds - cost_basis)) > 0.01;

-- =============================================
-- DATA QUALITY CHECK 6: FIFO cost basis trend
-- Monthly transaction volume and value by ticker
-- =============================================
SELECT
    DATE_TRUNC('month', transaction_date) AS month,
    ticker,
    transaction_type,
    COUNT(*) AS transaction_count,
    SUM(total_amount) AS total_value,
    AVG(price_per_share) AS avg_price
FROM transactions
WHERE status = 'PROCESSED'
    AND price_per_share IS NOT NULL
GROUP BY 1, 2, 3
ORDER BY 1, 2;