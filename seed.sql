TRUNCATE payments, discounts, invoice_items, invoices, fee_types, students RESTART IDENTITY CASCADE;

INSERT INTO students (admission_no, first_name, last_name, class_level, guardian_name, guardian_phone) VALUES
('ADM001', 'Chidi',  'Okafor', 'JSS1', 'Mr Okafor',  '08011111111'),
('ADM002', 'Amaka',  'Eze',    'JSS2', 'Mrs Eze',    '08022222222'),
('ADM003', 'Tunde',  'Bello',  'JSS3', 'Mr Bello',   '08033333333'),
('ADM004', 'Ngozi',  'Obi',    'SS1',  'Mrs Obi',    '08044444444'),
('ADM005', 'Ife',    'Adeyemi','SS2',  'Mr Adeyemi', '08055555555');

INSERT INTO fee_types (name, description, default_amount, is_recurring) VALUES
('Tuition',   'Termly tuition',       150000, TRUE),
('Uniform',   'School uniform set',    25000, FALSE),
('Transport', 'School bus per term',   40000, TRUE),
('Exam',      'Exam and materials',    15000, TRUE);

INSERT INTO invoices (student_id, academic_year, term, issue_date, due_date) VALUES
(1, '2026/2027', 1, '2026-09-01', '2026-09-30'),
(2, '2026/2027', 1, '2026-09-01', '2026-09-30'),
(3, '2026/2027', 1, '2026-09-01', '2026-09-30'),
(4, '2026/2027', 1, '2026-09-01', '2026-09-30'),
(5, '2026/2027', 2, '2026-10-01', '2026-12-15');

INSERT INTO invoice_items (invoice_id, fee_type_id, amount) VALUES
(1, 1, 150000), (1, 2, 25000), (1, 3, 40000),
(2, 1, 150000), (2, 4, 15000),
(3, 1, 150000), (3, 3, 40000),
(4, 1, 150000),
(5, 1, 150000), (5, 4, 15000);

INSERT INTO discounts (invoice_id, reason, amount, approved_by) VALUES
(1, 'Sibling discount', 15000, 'Bursar'),
(3, 'Scholarship',      50000, 'Principal');

INSERT INTO payments (invoice_id, amount, paid_on, method, reference, received_by) VALUES
(1, 200000, '2026-09-10', 'bank_transfer', 'TRX-1001', 'Bursar'),
(2,  80000, '2026-09-15', 'cash',          'RCP-2001', 'Cashier'),
(3,  70000, '2026-09-12', 'pos',           'POS-3001', 'Cashier'),
(3,  40000, '2026-10-05', 'bank_transfer', 'TRX-3002', 'Bursar'),
(5, 165000, '2026-10-08', 'card',          'CRD-5001', 'Bursar');