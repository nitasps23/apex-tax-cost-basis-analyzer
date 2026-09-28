-- =============================================
-- QUERY 1: Running transaction totals per account
-- Using window functions to track cumulative commission volume over time
-- =============================================

WITH daily_totals AS (
    SELECT
        account_id,
        ticker,
        transaction_date,
        transaction_type,
        total_amount,
        SUM(total_amount) OVER (
            PARTITION BY account_id, ticker
            ORDER BY transaction_date
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS running_total,
        COUNT(*) OVER (
            PARTITION BY account_id
            ORDER BY transaction_date
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS transaction_sequence
    FROM transactions
    WHERE status = 'PROCESSED'
        AND total_amount IS NOT NULL
)
SELECT *
FROM daily_totals
ORDER BY account_id, ticker, transaction_date;


-- =============================================
-- QUERY 2: Price deviation analysis
-- Flag transactions where price deviates significantly from the ticker average
-- =============================================

WITH ticker_stats AS (
    SELECT
        ticker,
        AVG(price_per_share) AS avg_price,
        STDDEV(price_per_share) AS stddev_price,
        COUNT(*) AS transaction_count
    FROM transactions
    WHERE price_per_share IS NOT NULL
        AND quantity > 0
    GROUP BY ticker
),
price_analysis AS (
    SELECT
        t.transaction_id,
        t.account_id,
        t.ticker,
        t.transaction_date,
        t.transaction_type,
        t.price_per_share,
        ts.avg_price,
        ts.stddev_price,
        ROUND(
            (t.price_per_share - ts.avg_price)::numeric / 
            NULLIF(ts.stddev_price, 0)::numeric,
            2
        ) AS z_score,
        CASE
            WHEN ABS((t.price_per_share - ts.avg_price) / 
                NULLIF(ts.stddev_price, 0)) > 2 
            THEN 'OUTLIER'
            ELSE 'NORMAL'
        END AS price_flag
    FROM transactions t
    JOIN ticker_stats ts ON t.ticker = ts.ticker
    WHERE t.price_per_share IS NOT NULL
        AND t.quantity > 0
)
SELECT *
FROM price_analysis
WHERE price_flag = 'OUTLIER'
ORDER BY ABS(z_score) DESC;


-- =============================================
-- QUERY 3: FIFO cost basis simulation
-- Matches buy lots to sales in chronological order
-- the foundation of cost basis calculation in securities
-- =============================================
WITH buy_lots AS (
    SELECT
        account_id,
        ticker,
        transaction_date AS acquisition_date,
        quantity,
        price_per_share AS cost_per_share,
        quantity * price_per_share AS lot_cost_basis,
        ROW_NUMBER() OVER (
            PARTITION BY account_id, ticker
            ORDER BY transaction_date
        ) AS lot_sequence
    FROM transactions
    WHERE transaction_type = 'BUY'
        AND status = 'PROCESSED'
        AND price_per_share IS NOT NULL
        AND quantity > 0
),
sell_events AS (
    SELECT
        account_id,
        ticker,
        transaction_date AS sale_date,
        quantity AS shares_sold,
        price_per_share AS sale_price,
        quantity * price_per_share AS sale_proceeds,
        ROW_NUMBER() OVER (
            PARTITION BY account_id, ticker
            ORDER BY transaction_date
        ) AS sale_sequence
    FROM transactions
    WHERE transaction_type = 'SELL'
        AND status = 'PROCESSED'
        AND price_per_share IS NOT NULL
        AND quantity > 0
)
SELECT
    s.account_id,
    s.ticker,
    b.acquisition_date,
    s.sale_date,
    b.cost_per_share AS fifo_cost_basis,
    s.sale_price,
    s.shares_sold,
    ROUND(
        (s.sale_price - b.cost_per_share)::numeric * 
        s.shares_sold::numeric,
        2
    ) AS estimated_gain_loss,
    CASE
        WHEN (s.sale_date - b.acquisition_date) > 365 
        THEN 'LONG_TERM'
        ELSE 'SHORT_TERM'
    END AS holding_period,
    CASE
        WHEN (s.sale_date - b.acquisition_date) > 365
        THEN 'Capital gains rate (0/15/20%)'
        ELSE 'Ordinary income rate (up to 37%)'
    END AS tax_treatment
FROM sell_events s
JOIN buy_lots b 
    ON s.account_id = b.account_id
    AND s.ticker = b.ticker
    AND b.lot_sequence = s.sale_sequence
ORDER BY s.account_id, s.ticker, s.sale_date;


-- =============================================
-- QUERY 4: Account-level exception summary
-- Rolls up all quality issues per account for prioritized remediation
-- =============================================
WITH exception_counts AS (
    SELECT
        t.account_id,
        COUNT(*) AS total_transactions,
        SUM(CASE WHEN t.status = 'ERROR' THEN 1 ELSE 0 END) 
            AS error_count,
        SUM(CASE WHEN t.status = 'PENDING' THEN 1 ELSE 0 END) 
            AS pending_count,
        SUM(CASE WHEN t.price_per_share IS NULL THEN 1 ELSE 0 END) 
            AS missing_price_count,
        SUM(CASE WHEN t.quantity = 0 THEN 1 ELSE 0 END) 
            AS zero_quantity_count,
        SUM(CASE WHEN t.total_amount IS NOT NULL 
            THEN t.total_amount ELSE 0 END) AS total_volume
    FROM transactions t
    GROUP BY t.account_id
),
tax_exceptions AS (
    SELECT
        account_id,
        SUM(CASE WHEN status = 'DISCREPANCY' THEN 1 ELSE 0 END) 
            AS discrepancy_count,
        SUM(CASE WHEN status = 'MISSING_BASIS' THEN 1 ELSE 0 END) 
            AS missing_basis_count,
        SUM(CASE WHEN reported_to_irs = FALSE THEN 1 ELSE 0 END) 
            AS unreported_count
    FROM tax_reporting
    GROUP BY account_id
)
SELECT
    ec.account_id,
    ec.total_transactions,
    ec.error_count,
    ec.pending_count,
    ec.missing_price_count,
    ec.zero_quantity_count,
    COALESCE(te.discrepancy_count, 0) AS discrepancy_count,
    COALESCE(te.missing_basis_count, 0) AS missing_basis_count,
    COALESCE(te.unreported_count, 0) AS unreported_count,
    ROUND(ec.total_volume::numeric, 2) AS total_volume,
    (ec.error_count + ec.pending_count + 
     ec.missing_price_count +
     COALESCE(te.discrepancy_count, 0) + 
     COALESCE(te.missing_basis_count, 0)) AS total_exception_score,
    CASE
        WHEN (ec.error_count + 
              COALESCE(te.missing_basis_count, 0)) > 3 
        THEN 'HIGH PRIORITY'
        WHEN (ec.pending_count + 
              COALESCE(te.discrepancy_count, 0)) > 3 
        THEN 'MEDIUM PRIORITY'
        ELSE 'LOW PRIORITY'
    END AS remediation_priority
FROM exception_counts ec
LEFT JOIN tax_exceptions te ON ec.account_id = te.account_id
ORDER BY total_exception_score DESC;

-- =============================================
-- QUERY 5: Month over month trend analysis
-- Tracks transaction volume, error rates, and average prices over time
-- =============================================
WITH monthly_metrics AS (
    SELECT
        DATE_TRUNC('month', 
            transaction_date::DATE) AS month,
        ticker,
        COUNT(*) AS total_transactions,
        SUM(CASE WHEN status = 'PROCESSED' 
            THEN 1 ELSE 0 END) AS processed_count,
        SUM(CASE WHEN status = 'ERROR' 
            THEN 1 ELSE 0 END) AS error_count,
        SUM(CASE WHEN status = 'PENDING' 
            THEN 1 ELSE 0 END) AS pending_count,
        ROUND(AVG(price_per_share)::numeric, 2) 
            AS avg_price,
        ROUND(SUM(total_amount)::numeric, 2) 
            AS total_volume
    FROM transactions
    WHERE price_per_share IS NOT NULL
    GROUP BY 1, 2
),
with_trends AS (
    SELECT
        *,
        ROUND(
            error_count::numeric / 
            NULLIF(total_transactions, 0)::numeric * 100,
            2
        ) AS error_rate_pct,
        LAG(total_volume) OVER (
            PARTITION BY ticker
            ORDER BY month
        ) AS prior_month_volume,
        ROUND(
            (total_volume - LAG(total_volume) OVER (
                PARTITION BY ticker ORDER BY month
            ))::numeric / NULLIF(
                LAG(total_volume) OVER (
                    PARTITION BY ticker ORDER BY month
                ), 0
            )::numeric * 100,
            2
        ) AS volume_change_pct
    FROM monthly_metrics
)
SELECT *
FROM with_trends
ORDER BY ticker, month;