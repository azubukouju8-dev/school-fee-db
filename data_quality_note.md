# AI Data-Quality Note

## Why this matters
An AI system built on this database (for example a chatbot that answers "how much does Tunde owe?" or a model that predicts late payers) can only be as correct as the data underneath it. Wrong data produces confident but wrong answers.

## Risks in a fee database
- **Duplicate or inconsistent student records** split one student's history across several rows, so balances and payment history come out wrong.
- **Payments linked to the wrong invoice** make a student look unpaid or overpaid. An AI assistant would then tell parents the wrong balance.
- **Missing or wrong due dates** distort overdue reports and any model that predicts late payment.
- **Free-text values** (for example "Cash", "cash", "CASH") split the same payment method into groups and skew reports.
- **Unrecorded discounts** make revenue look higher than it really is.

## How this schema reduces those risks
- **Foreign keys** make every invoice, item, discount and payment point to a real parent row, so orphan records cannot exist.
- `payments.method` has a **CHECK constraint** allowing only cash, bank_transfer, card, pos or cheque, so the labels stay consistent.
- `payments.reference` is **UNIQUE**, so the same transaction cannot be recorded twice.
- Amount columns have **CHECK (amount > 0)**, so zero or negative payments and discounts are rejected.
- `payments` uses **ON DELETE RESTRICT**, so an invoice with payments cannot be deleted by accident.
- The **`invoice_balances` view** is the single place where balances are calculated. Every report reads the same formula, so reports cannot disagree with each other.

## Known limitations
- Nothing stops a payment from exceeding the invoice total (overpayment), or a discount from exceeding it.
- Class level is free text, so "JSS 1" and "JSS1" would be treated as different values.
- Balances are calculated, not stored. This keeps them accurate, but very large data would need indexes or caching.

## Before feeding this data to an AI system
Run validation checks first: duplicates, orphan rows, negative or oversized amounts, and invoices whose payments exceed their total. Re-run them regularly, because bad data entered later can still reach the AI.