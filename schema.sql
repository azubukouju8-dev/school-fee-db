   DROP TABLE IF EXISTS payments, discounts, invoice_items, invoices, fee_types, students CASCADE;

CREATE TABLE students (
    student_id     SERIAL PRIMARY KEY,
    admission_no   VARCHAR(20)  NOT NULL UNIQUE,
    first_name     VARCHAR(60)  NOT NULL,
    last_name      VARCHAR(60)  NOT NULL,
    class_level    VARCHAR(20)  NOT NULL,
    guardian_name  VARCHAR(120) NOT NULL,
    guardian_phone VARCHAR(20),
    enrolled_on    DATE         NOT NULL DEFAULT CURRENT_DATE,
    status         VARCHAR(10)  NOT NULL DEFAULT 'active'
                   CHECK (status IN ('active', 'graduated', 'withdrawn'))
);

CREATE TABLE fee_types (
    fee_type_id    SERIAL PRIMARY KEY,
    name           VARCHAR(60)   NOT NULL UNIQUE,
    description    TEXT,
    default_amount NUMERIC(12,2) NOT NULL CHECK (default_amount >= 0),
    is_recurring   BOOLEAN       NOT NULL DEFAULT TRUE
);

CREATE TABLE invoices (
    invoice_id    SERIAL PRIMARY KEY,
    student_id    INT         NOT NULL REFERENCES students(student_id) ON DELETE RESTRICT,
    academic_year VARCHAR(9)  NOT NULL,
    term          SMALLINT    NOT NULL CHECK (term BETWEEN 1 AND 3),
    issue_date    DATE        NOT NULL DEFAULT CURRENT_DATE,
    due_date      DATE        NOT NULL,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT due_after_issue CHECK (due_date >= issue_date),
    CONSTRAINT one_invoice_per_term UNIQUE (student_id, academic_year, term)
);

CREATE TABLE invoice_items (
    item_id     SERIAL PRIMARY KEY,
    invoice_id  INT           NOT NULL REFERENCES invoices(invoice_id) ON DELETE CASCADE,
    fee_type_id INT           NOT NULL REFERENCES fee_types(fee_type_id) ON DELETE RESTRICT,
    amount      NUMERIC(12,2) NOT NULL CHECK (amount > 0),
    CONSTRAINT one_fee_type_per_invoice UNIQUE (invoice_id, fee_type_id)
);

CREATE TABLE discounts (
    discount_id SERIAL PRIMARY KEY,
    invoice_id  INT           NOT NULL REFERENCES invoices(invoice_id) ON DELETE CASCADE,
    reason      VARCHAR(120)  NOT NULL,
    amount      NUMERIC(12,2) NOT NULL CHECK (amount > 0),
    approved_by VARCHAR(80),
    applied_on  DATE          NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE payments (
    payment_id  SERIAL PRIMARY KEY,
    invoice_id  INT           NOT NULL REFERENCES invoices(invoice_id) ON DELETE RESTRICT,
    amount      NUMERIC(12,2) NOT NULL CHECK (amount > 0),
    paid_on     DATE          NOT NULL DEFAULT CURRENT_DATE,
    method      VARCHAR(20)   NOT NULL
                CHECK (method IN ('cash', 'bank_transfer', 'card', 'pos', 'cheque')),
    reference   VARCHAR(60)   UNIQUE,
    received_by VARCHAR(80)
);

CREATE VIEW invoice_balances AS
SELECT
    i.invoice_id,
    i.student_id,
    i.academic_year,
    i.term,
    i.due_date,
    COALESCE(it.total, 0) AS invoice_total,
    COALESCE(d.total, 0)  AS total_discounts,
    COALESCE(p.total, 0)  AS total_paid,
    COALESCE(it.total, 0) - COALESCE(d.total, 0) - COALESCE(p.total, 0) AS balance
FROM invoices i
LEFT JOIN (SELECT invoice_id, SUM(amount) AS total FROM invoice_items GROUP BY invoice_id) it USING (invoice_id)
LEFT JOIN (SELECT invoice_id, SUM(amount) AS total FROM discounts     GROUP BY invoice_id) d  USING (invoice_id)
LEFT JOIN (SELECT invoice_id, SUM(amount) AS total FROM payments      GROUP BY invoice_id) p  USING (invoice_id);