-- Create database
CREATE DATABASE IF NOT EXISTS myapp;

-- Select database
USE myapp;

-- Create employees table
CREATE TABLE IF NOT EXISTS employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    department VARCHAR(100),
    salary DECIMAL(10,2),
    joining_date DATE
);

-- Insert sample records
INSERT INTO employees
    (name, email, department, salary, joining_date)
VALUES
    ('Ashok', 'ashok@example.com', 'DevOps', 75000.00, '2024-01-15'),
    ('Rahul', 'rahul@example.com', 'AWS', 70000.00, '2023-06-10'),
    ('Priya', 'priya@example.com', 'Development', 65000.00, '2024-03-20'),
    ('Suresh', 'suresh@example.com', 'Testing', 60000.00, '2022-11-05'),
    ('Anita', 'anita@example.com', 'DevOps', 72000.00, '2023-09-12');

-- Verify records
SELECT * FROM employees;