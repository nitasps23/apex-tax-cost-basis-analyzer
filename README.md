# Tax & Cost Basis Data Quality Analyzer

> 🚧 **Work in progress** - built specifically to explore the 
> workflows of a Tax & Cost Basis operations team at a fintech 
> company. README and documentation being expanded.

---

## What This Project Does

Simulates the core data operations of a securities fintech 
platform - generating synthetic transaction data, running SQL 
data quality checks, analyzing cost basis and gain/loss 
reporting, and producing an AI-generated executive summary 
using the Claude API.

---

## Tech Stack

SQL · Python · PostgreSQL · Claude AI · Pandas · 
Plotly · Power BI · Jupyter Notebook

---

## Project Structure

```
apex-tax-cost-basis-analyzer/
├── data/ — CSV files
├── docs/ — SOP documentation
├── notebooks/ — synthetic data generator + analysis scripts + Claude AI reporting
├── reports/ — AI-generated management report + powerbi operational summary dashboard
├── sql/ — data quality validation queries
└── visualizations/ — Plotly HTML charts
```
---

## What's Covered

- Synthetic securities transaction data across 3 tables
  (transactions, cost basis lots, tax reporting)
- Six SQL data quality checks - null detection, calculation 
  validation, exception tracking, discrepancy analysis
- Python analysis with Plotly visualizations
- Claude AI API integration for automated management reporting
- Power BI dashboard for operational stakeholder reporting
- SOP document for monthly data quality review process

---

## Key Technical Notes

- PostgreSQL requires explicit `::numeric` casting for ROUND() 
  on financial calculations - critical for tax and cost basis 
  precision
- Date columns loaded via pandas need explicit dtype declaration 
  to avoid text/DATE type mismatches
- Synthetic data intentionally seeded with real-world quality 
  issues - null prices, zero quantities, status errors, 
  reporting discrepancies

---

## What I Would Improve With More Time

- Connect Power BI directly to PostgreSQL for live refresh
  (currently loads from CSV)
- Seed calculation variances into synthetic data so 
  gain/loss validation checks return exceptions
- Expand README with setup instructions and full findings

---

## BI Report

[View Power BI Dashboard →](https://app.powerbi.com/view?r=eyJrIjoiZGYwM2YwN2EtMTQ5Yi00MDM1LTlkOTMtYzI3ZDJlYzFjMzgwIiwidCI6IjQ1ZDU0MDVhLWIwOTUtNDIwZS1hM2NhLWYzMzk1YWViMzY1NCIsImMiOjF9)

---

## Author

**Nita Sokphoodsa**  
Data & BI Analyst
