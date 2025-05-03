-- =============================================
-- SIMPLE BANKING DATABASE SCHEMA (PostgreSQL)
-- =============================================

-- ==========================
-- TABLE: customers
-- ==========================
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,            -- Auto-incremented integer
    name VARCHAR(100),                         -- Customer name
    email VARCHAR(100) UNIQUE,                 -- Unique email address
    phone VARCHAR(10)                          -- Phone number
);

-- ==========================
-- TABLE: accounts
-- ==========================
CREATE TABLE accounts (
    account_id SERIAL PRIMARY KEY,             -- Auto-incremented integer
    customer_id INT REFERENCES customers(customer_id),  -- FK to customers
    balance DECIMAL(12, 2) DEFAULT 0.00        -- Account balance
);

-- ==========================
-- INSERT SAMPLE DATA
-- ==========================

-- Add a customer
INSERT INTO customers (name, email, phone)
VALUES ('Haydar Abbass Moussa', 'ham026@usal.edu.lb', '8888888');

-- Add an account for customer_id = 1
INSERT INTO accounts (customer_id, balance)
VALUES (1, 1000.00);

-- ==========================
-- READ / SELECT QUERIES
-- ==========================

-- View all customers
SELECT * FROM customers;

-- View account balances with customer names
SELECT 
    a.account_id,
    c.name,
    a.balance
FROM accounts a
JOIN customers c ON a.customer_id = c.customer_id;

-- ==========================
-- UPDATE QUERIES
-- ==========================

-- Update customer name
UPDATE customers
SET name = 'Yussef Abbass Moussa'
WHERE customer_id = 1;

-- Deposit money into account_id = 1
UPDATE accounts
SET balance = balance + 500
WHERE account_id = 1;

-- ==========================
-- DELETE QUERIES
-- ==========================

-- Delete account with ID 1
DELETE FROM accounts
WHERE account_id = 1;

-- Delete customer with ID 1
DELETE FROM customers
WHERE customer_id = 1;

-- ==========================
-- STORED FUNCTION: insert_balance
-- ==========================

-- Add amount to an account
CREATE OR REPLACE FUNCTION insert_balance(
    p_account_id INT,
    p_amount DECIMAL(12,2)
)
RETURNS VOID AS $$
BEGIN
    UPDATE accounts
    SET balance = balance + p_amount
    WHERE account_id = p_account_id;
END;
$$ LANGUAGE plpgsql;

-- Call function to deposit 1000 into account_id = 4
SELECT insert_balance(1, 1000.00);
