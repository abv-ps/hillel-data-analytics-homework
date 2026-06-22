CREATE TABLE IF NOT EXISTS students (
	full_name VARCHAR(100) NOT NULL,
	email VARCHAR(100) NOT NULL,
	signup_date DATE NOT NULL,
	last_login TIMESTAMP,
	is_active BOOL,
	gpa DECIMAL(3,2),
	enrolled_classes TEXT[],
	scholarships TEXT[]
);

INSERT INTO students (
full_name,
email,
signup_date,
last_login,
is_active,
gpa,
enrolled_classes,
scholarships
)
VALUES
('George Novak', 'george.n@example.com', '2025-07-01', '2025-06-29 15:00:00', TRUE, 2.65, '{BIO101}', '{Athletic Scholarship}'),
('Alice Johnson', 'alice.j@example.com', '2024-09-01', '2025-06-28 14:30:00', TRUE, 3.85, '{CS101,MATH202,ENG150}', '{Merit Scholarship}'),
('Fatima Ali', 'fatima.a@example.com', '2025-02-10', '2025-06-27 11:22:00', TRUE, 3.75, '{ECON101,BUS200}', '{Leadership Award,Women in Business}'),
('Evan Lee', 'evan.l@example.com', '2025-01-20', '2025-06-25 08:00:00', TRUE, 3.0, '{MATH101,CS101}', '{}'),
('Carlos Nguyen', 'carlos.n@example.com', '2024-10-15', '2025-06-20 19:45:00', TRUE, 3.45, '{CS101,STAT200,PHYS105}', '{STEM Grant}'),
('Bob Smith', 'bob.smith@example.com', '2024-09-03', '2025-06-30 09:10:00', FALSE, 2.95, '{HIST110,PHIL101}', '{}'),
('Diana Petros', 'diana.p@example.com', '2024-11-01', NULL, FALSE, 4.0, '{ART101,DES202}', '{Dean''s List}');

SELECT LOWER(full_name)
FROM students
WHERE is_active = TRUE;

SELECT email, ROUND(gpa, 1)
FROM students
WHERE gpa > 3.5;

SELECT full_name, TO_CHAR(signup_date, 'DD.MM.YYYY') 
FROM students
WHERE signup_date > '2025-01-01';

SELECT full_name, ARRAY_LENGTH(scholarships, 1)
FROM students
WHERE ARRAY_LENGTH(scholarships, 1) > 0;

SELECT full_name, ARRAY_LENGTH(enrolled_classes, 1)
FROM students
WHERE 'CS101' = ANY(enrolled_classes);
