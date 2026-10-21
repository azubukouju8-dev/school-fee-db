SELECT * FROM invoice_balances ORDER BY invoice_id;
-- Q1: Unpaid fees (invoices with no payment at all)
SELECT s.admission_no, s.first_name, s.last_name, b.invoice_id, b.balance
FROM invoice_balances b
JOIN students s ON s.student_id = b.student_id
WHERE b.total_paid = 0;

-- Q2: Outstanding balances (anything still owed)
SELECT s.first_name, s.last_name, b.invoice_id, b.balance
FROM invoice_balances b
JOIN students s ON s.student_id = b.student_id
WHERE b.balance > 0
ORDER BY b.balance DESC;

-- Q3: Overdue payments (past due date and still owing)
SELECT s.first_name, s.last_name, b.invoice_id, b.due_date,
       CURRENT_DATE - b.due_date AS days_overdue, b.balance
FROM invoice_balances b
JOIN students s ON s.student_id = b.student_id
WHERE b.due_date < CURRENT_DATE AND b.balance > 0
ORDER BY days_overdue DESC;

-- Q4: Payment history for one student (ADM003, Tunde)
SELECT s.first_name, p.paid_on, p.amount, p.method, p.reference
FROM payments p
JOIN invoices i ON i.invoice_id = p.invoice_id
JOIN students s ON s.student_id = i.student_id
WHERE s.admission_no = 'ADM003'
ORDER BY p.paid_on;

-- Q5: Total collections
SELECT SUM(amount) AS total_collected, COUNT(*) AS payment_count
FROM payments;

-- Q6: Collections by payment method
SELECT method, COUNT(*) AS payments, SUM(amount) AS total
FROM payments
GROUP BY method
ORDER BY total DESC;

-- Q7: Outstanding balance by class level
SELECT s.class_level, SUM(b.balance) AS outstanding
FROM invoice_balances b
JOIN students s ON s.student_id = b.student_id
WHERE b.balance > 0
GROUP BY s.class_level
ORDER BY outstanding DESC;

-- Q8: Revenue billed per fee type
SELECT f.name, COUNT(*) AS times_billed, SUM(ii.amount) AS total_billed
FROM invoice_items ii
JOIN fee_types f ON f.fee_type_id = ii.fee_type_id
GROUP BY f.name
ORDER BY total_billed DESC;