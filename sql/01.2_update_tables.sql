-- Fix the column 'transaction_date' type as a date permanently
-- Run this once and the column is properly typed going forward

ALTER TABLE transactions
ALTER COLUMN transaction_date TYPE DATE
USING transaction_date::DATE;