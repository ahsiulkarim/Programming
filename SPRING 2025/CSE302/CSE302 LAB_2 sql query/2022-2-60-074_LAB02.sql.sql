CREATE TABLE account (
 account_no CHAR(5) PRIMARY KEY,
 balance NUMBER CHECK (balance >= 0) NOT NULL
);

CREATE TABLE customer (
customer_no CHAR(5) PRIMARY KEY,
customer_name VARCHAR2(20) NOT NULL,
customer_city VARCHAR2(10)
);

CREATE TABLE depositor (
account_no CHAR(5),
customer_no CHAR(5),
PRIMARY KEY (account_no, customer_no)
);

DESC account;

DESC customer;

DESC depositor;

ALTER TABLE customer
ADD date_of_birth DATE;

ALTER TABLE customer
DROP COLUMN date_of_birth;

ALTER TABLE depositor
RENAME COLUMN account_no TO a_no;

ALTER TABLE depositor
RENAME COLUMN customer_no TO c_no;

ALTER TABLE depositor
ADD CONSTRAINT depositor_fk1 FOREIGN KEY (a_no) REFERENCES account (account_no);

ALTER TABLE depositor
ADD CONSTRAINT depositor_fk2 FOREIGN KEY (c_no) REFERENCES customer (customer_no);

-- Insert records into the account table
INSERT INTO account (account_no, balance) VALUES ('A-001', 12000);
INSERT INTO account (account_no, balance) VALUES ('A-002', 6000);
INSERT INTO account (account_no, balance) VALUES ('A-003', 2500);

-- Insert records into the customer table
INSERT INTO customer (customer_no, customer_name, customer_city) VALUES ('C-101', 'Alice', 'Dhaka');
INSERT INTO customer (customer_no, customer_name, customer_city) VALUES ('C-102', 'Annie', 'Dhaka');
INSERT INTO customer (customer_no, customer_name, customer_city) VALUES ('C-103', 'Bob', 'Chittagong');
INSERT INTO customer (customer_no, customer_name, customer_city) VALUES ('C-104', 'Charlie', 'Khulna');

-- Insert records into the depositor table (Corrected a_no values)
INSERT INTO depositor (a_no, c_no) VALUES ('A-001', 'C-101');
INSERT INTO depositor (a_no, c_no) VALUES ('A-003', 'C-102');
INSERT INTO depositor (a_no, c_no) VALUES ('A-003', 'C-104');
INSERT INTO depositor (a_no, c_no) VALUES ('A-002', 'C-103');

-- 1.
SELECT customer_name, customer_city FROM customer;
-- 2.
SELECT DISTINCT customer_city FROM customer;
-- 3.
SELECT account_no FROM account WHERE balance > 7000;
-- 4.
SELECT customer_no, customer_name FROM customer WHERE customer_city = 'Khulna';
-- 5.
SELECT customer_no, customer_name FROM customer WHERE customer_city != 'Dhaka';
-- 6.
SELECT customer.customer_name, customer.customer_city
FROM customer, depositor, account
WHERE customer.customer_no = depositor.c_no
AND depositor.a_no = account.account_no
AND account.balance > 7000;
-- 7.
SELECT customer.customer_name, customer.customer_city
FROM customer, depositor, account
WHERE customer.customer_no = depositor.c_no
AND depositor.a_no = account.account_no
AND account.balance > 7000
AND customer.customer_city <> 'Khulna';
-- 8.
SELECT account.account_no, account.balance
FROM account, depositor
WHERE account.account_no = depositor.a_no
AND depositor.c_no = 'C-102';
-- 9.
SELECT account.account_no, account.balance
FROM account, depositor, customer
WHERE account.account_no = depositor.a_no
AND depositor.c_no = customer.customer_no
AND (customer.customer_city = 'Dhaka' OR customer.customer_city = 'Khulna');
-- 10.
SELECT customer_no, customer_name
FROM customer
WHERE customer_no NOT IN (SELECT c_no FROM depositor);