# School Fee Management Database

A PostgreSQL database for managing students, fee types, invoices, discounts, payments and outstanding balances. Built for module B3 (Databases, SQL and data modeling).

## Tables
| Table | Purpose |
|---|---|
| `students` | Student and guardian details |
| `fee_types` | Tuition, uniform, transport, exam |
| `invoices` | One invoice per student per term |
| `invoice_items` | Fee lines on each invoice |
| `discounts` | Discounts applied to an invoice |
| `payments` | Payments received against an invoice |
| `invoice_balances` (view) | Total, discounts, paid and balance per invoice |

## Files
- `schema.sql`: creates the tables and the view
- `seed.sql`: sample data (5 students, 5 invoices, 5 payments, 2 discounts)
- `queries.sql`: the 8 SQL queries
- `results/`: the saved output of each query as CSV
- `erd.md`: the entity relationship diagram
- `data_quality_note.md`: how data quality affects AI systems

## How to run
1. Create a database called `school_fees` in PostgreSQL.
2. Run `schema.sql`, then `seed.sql`.
3. Run the queries in `queries.sql`.

`seed.sql` begins with `TRUNCATE`, so running it again resets the data.

## Queries
| # | Question answered | Result file |
|---|---|---|
| Q1 | Unpaid fees | `results/q1_unpaid_fees.csv` |
| Q2 | Outstanding balances | `results/q2_outstanding_balances.csv` |
| Q3 | Overdue payments | `results/q3_overdue_payments.csv` |
| Q4 | Payment history for one student | `results/q4_payment_history.csv` |
| Q5 | Total collections | `results/q5_total_collections.csv` |
| Q6 | Collections by payment method | `results/q6_collections_by_method.csv` |
| Q7 | Outstanding balance by class | `results/q7_balance_by_class.csv` |
| Q8 | Revenue billed per fee type | `results/q8_revenue_by_fee_type.csv` |

## Key results (sample data)
- Total billed: 885,000. Discounts: 65,000. Collected: 555,000. Outstanding: 265,000.
- Three invoices are overdue and still owe money.

## Design decisions
- Balances are **calculated** in the `invoice_balances` view and not stored, so they cannot go out of date.
- Items, discounts and payments are summed in separate subqueries, which prevents rows multiplying and inflating totals.
- Constraints (foreign keys, CHECK, UNIQUE) protect data quality. See `data_quality_note.md`.