drop table depositor cascade constraints;
drop table borrower cascade constraints;
drop table account cascade constraints;
drop table loan cascade constraints;
drop table customer cascade constraints;
drop table branch cascade constraints;

create table branch(
    branch_name varchar(15)	not null,
    branch_city varchar(15) not null,
    assets number not null,
    primary key(branch_name)
    );

create table customer(
    customer_name varchar(15)	not null,
    customer_street varchar(12)	not null,
    customer_city varchar(15)	not null,
    primary key(customer_name)
    );

create table account(
    account_number varchar(15) not null,
    branch_name	varchar(15)	not null,
    balance number not null,
    constraint account_pk primary key(account_number)
    );    


create table loan(
    loan_number varchar(15)	not null,
    branch_name varchar(15)	not null,
    amount number not null,
    primary key(loan_number)
    );

create table depositor(
    customer_name varchar(15) not null,
    account_number varchar(15) not null,
    primary key(customer_name, account_number),
    foreign key(account_number) references account(account_number),
    foreign key(customer_name) references customer(customer_name)
    );

create table borrower(
    customer_name varchar(15)	not null,
    loan_number varchar(15)	not null,
    primary key(customer_name, loan_number),
    foreign key(customer_name) references customer(customer_name),
    foreign key(loan_number) references loan(loan_number)
    );



    insert into customer values ('Jones',	'Main',		'Harrison');
insert into customer values ('Smith',	'Main',		'Rye');
insert into customer values ('Hayes',	'Main',		'Harrison');
insert into customer values ('Curry',	'North',	'Rye');
insert into customer values ('Lindsay',	'Park',		'Pittsfield');
insert into customer values ('Turner',	'Putnam',	'Stamford');
insert into customer values ('Williams','Nassau',	'Princeton');
insert into customer values ('Adams',	'Spring',	'Pittsfield');
insert into customer values ('Johnson',	'Alma',		'Palo Alto');
insert into customer values ('Glenn',	'Sand Hill',	'Woodside');
insert into customer values ('Brooks',	'Senator',	'Brooklyn');
insert into customer values ('Green',	'Walnut',	'Stamford');
insert into customer values ('Jackson',	'University',	'Salt Lake');
insert into customer values ('Majeris',	'First',	'Rye');
insert into customer values ('McBride',	'Safety',	'Rye');

insert into branch values ('Downtown',	'Brooklyn',	 900000);
insert into branch values ('Redwood',	'Palo Alto',	2100000);
insert into branch values ('Perryridge','Horseneck',	1700000);
insert into branch values ('Mianus',	'Horseneck',	 400200);
insert into branch values ('Round Hill','Horseneck',	8000000);
insert into branch values ('Pownal',	'Bennington',	 400000);
insert into branch values ('North Town','Rye',		3700000);
insert into branch values ('Brighton',	'Brooklyn',	7000000);
insert into branch values ('Central',	'Rye',		 400280);

insert into account values ('A-101', 'Downtown',	500);
insert into account values ('A-215', 'Mianus',	700);
insert into account values ('A-102', 'Perryridge',	400);
insert into account values ('A-305', 'Round Hill',	350);
insert into account values ('A-201', 'Perryridge',	900);
insert into account values ('A-222', 'Redwood',	700);
insert into account values ('A-217', 'Brighton',	750);
insert into account values ('A-333', 'Central',	850);
insert into account values ('A-444', 'North Town',	625);

insert into depositor values ('Johnson','A-101');
insert into depositor values ('Smith',	'A-215');
insert into depositor values ('Hayes',	'A-102');
insert into depositor values ('Hayes',	'A-101');
insert into depositor values ('Turner',	'A-305');
insert into depositor values ('Johnson','A-201');
insert into depositor values ('Jones',	'A-217');
insert into depositor values ('Lindsay','A-222');
insert into depositor values ('Majeris','A-333');
insert into depositor values ('Smith',	'A-444');

insert into loan values ('L-17', 'Downtown',	1000);
insert into loan values ('L-23', 'Redwood',	2000);
insert into loan values ('L-15', 'Perryridge',	1500);
insert into loan values ('L-14', 'Downtown',	1500);
insert into loan values ('L-93', 'Mianus',	500);
insert into loan values ('L-11', 'Round Hill',	900);
insert into loan values ('L-16', 'Perryridge',	1300);
insert into loan values ('L-20', 'North Town',	7500);
insert into loan values ('L-21', 'Central',	570);

insert into borrower values ('Jones',	'L-17');
insert into borrower values ('Smith',	'L-23');
insert into borrower values ('Hayes',	'L-15');
insert into borrower values ('Jackson',	'L-14');
insert into borrower values ('Curry',	'L-93');
insert into borrower values ('Smith',	'L-11');
insert into borrower values ('Williams','L-17');
insert into borrower values ('Adams',	'L-16');
insert into borrower values ('McBride',	'L-20');
insert into borrower values ('Smith',	'L-21');

commit;

-- 1. Find all customer related information who have an account in a branch, located in the same city as they live.
-- Without subquery
SELECT DISTINCT c.customer_name, c.customer_street, c.customer_city
FROM customer c
JOIN depositor d ON c.customer_name = d.customer_name
JOIN account a ON d.account_number = a.account_number
JOIN branch b ON a.branch_name = b.branch_name
WHERE c.customer_city = b.branch_city;

-- With subquery
SELECT customer_name, customer_street, customer_city
FROM customer
WHERE customer_name IN (
    SELECT d.customer_name
    FROM depositor d
    JOIN account a ON d.account_number = a.account_number
    JOIN branch b ON a.branch_name = b.branch_name
    WHERE b.branch_city = (
        SELECT customer_city
        FROM customer
        WHERE customer_name = d.customer_name
    )
);

-- 2. Find all customer related information who have a loan in a branch, located in the same city as they live.
-- Without subquery
SELECT DISTINCT C.*
FROM Customer C
JOIN Borrower BO ON C.customer_name = BO.customer_name
JOIN Loan L ON BO.loan_number = L.loan_number
JOIN Branch B ON L.branch_name = B.branch_name
WHERE C.customer_city = B.branch_city;

-- With subquery
SELECT *
FROM Customer C
WHERE C.customer_name IN (
    SELECT BO.customer_name
    FROM Borrower BO
    JOIN Loan L ON BO.loan_number = L.loan_number
    JOIN Branch B ON L.branch_name = B.branch_name
    WHERE C.customer_city = B.branch_city
);

-- 3. For each branch city, find the average balance of all the accounts opened in a branch located in that branch city.
-- Exclude branch cities where the total balance is less than 1000.
-- Without HAVING clause
SELECT B.branch_city, AVG(A.balance) AS avg_balance
FROM Account A
JOIN Branch B ON A.branch_name = B.branch_name
WHERE B.branch_city NOT IN (
    SELECT B2.branch_city
    FROM Account A2
    JOIN Branch B2 ON A2.branch_name = B2.branch_name
    GROUP BY B2.branch_city
    HAVING SUM(A2.balance) < 1000
)
GROUP BY B.branch_city;


-- With HAVING clause
SELECT B.branch_city, AVG(A.balance) AS avg_balance
FROM Account A
JOIN Branch B ON A.branch_name = B.branch_name
GROUP BY B.branch_city
HAVING SUM(A.balance) >= 1000;


-- 4. For each branch city, find the average amount of all the loans opened in a branch located in that branch city.
-- Exclude branch cities where the average loan amount is less than 1500.
-- Without HAVING clause
SELECT B.branch_city, AVG(L.amount) AS avg_loan
FROM Loan L
JOIN Branch B ON L.branch_name = B.branch_name
WHERE B.branch_city NOT IN (
    SELECT B2.branch_city
    FROM Loan L2
    JOIN Branch B2 ON L2.branch_name = B2.branch_name
    GROUP BY B2.branch_city
    HAVING AVG(L2.amount) < 1500
)
GROUP BY B.branch_city;


-- With HAVING clause
SELECT B.branch_city, AVG(L.amount) AS avg_loan
FROM Loan L
JOIN Branch B ON L.branch_name = B.branch_name
GROUP BY B.branch_city
HAVING AVG(L.amount) >= 1500;


-- 5. Find the customer name, customer street, customer city of the account which has the highest balance among all the accounts.
-- Without using ALL keyword:

SELECT c.customer_name, c.customer_street, c.customer_city
FROM customer c
JOIN depositor d ON c.customer_name = d.customer_name
JOIN account a ON d.account_number = a.account_number
WHERE a.balance = (SELECT MAX(balance) FROM account);
-- Using ALL keyword:

SELECT c.customer_name, c.customer_street, c.customer_city
FROM customer c
JOIN depositor d ON c.customer_name = d.customer_name
JOIN account a ON d.account_number = a.account_number
WHERE a.balance >= ALL (SELECT balance FROM account);


-- 6. Find the customer name, customer street, customer city of the loan which has the lowest amount among all the loans.
SELECT C.customer_name, C.customer_street, C.customer_city
FROM Customer C
JOIN Borrower BO ON C.customer_name = BO.customer_name
JOIN Loan L ON BO.loan_number = L.loan_number
WHERE L.amount = (SELECT MIN(amount) FROM Loan);

-- 7. Find the distinct branches (name and city) that have opened both accounts and loans.
SELECT DISTINCT B.branch_name, B.branch_city
FROM Branch B
WHERE EXISTS (
    SELECT 1 FROM Account A WHERE A.branch_name = B.branch_name
)
AND EXISTS (
    SELECT 1 FROM Loan L WHERE L.branch_name = B.branch_name
);

-- Using IN
SELECT branch_name, branch_city
FROM branch
WHERE branch_name IN (SELECT branch_name FROM account)
 AND branch_name IN (SELECT branch_name FROM loan);


-- 8. Find the distinct customers (name and city) who do not have loans but have accounts.
-- Using NOT IN keyword:

SELECT DISTINCT c.customer_name, c.customer_city
FROM customer c
WHERE c.customer_name IN (
    SELECT customer_name FROM depositor
) AND c.customer_name NOT IN (
    SELECT customer_name FROM borrower
);
-- Using NOT EXISTS keyword:

SELECT DISTINCT c.customer_name, c.customer_city
FROM customer c
WHERE EXISTS (
    SELECT 1 FROM depositor d WHERE d.customer_name = c.customer_name
) AND NOT EXISTS (
    SELECT 1 FROM borrower b WHERE b.customer_name = c.customer_name
);

-- 9. Find those branch names which have total account balance greater than the average of total balance among all the branches.
-- With clause
WITH Avg_Balance AS (
    SELECT AVG(balance) AS overall_avg_balance
    FROM Account
)
SELECT DISTINCT B.branch_name
FROM Account A
JOIN Branch B ON A.branch_name = B.branch_name
WHERE A.balance > (SELECT overall_avg_balance FROM Avg_Balance);


-- Without clause
SELECT DISTINCT B.branch_name
FROM Account A
JOIN Branch B ON A.branch_name = B.branch_name
WHERE A.balance > (
    SELECT AVG(balance)
    FROM Account
);


-- 10. Find those branch names which have total loan amount less than the average of total loan amount among all the branches.
-- With clause
WITH Avg_Loan AS (
    SELECT AVG(amount) AS overall_avg_loan
    FROM Loan
)
SELECT DISTINCT B.branch_name
FROM Loan L
JOIN Branch B ON L.branch_name = B.branch_name
GROUP BY B.branch_name
HAVING SUM(L.amount) < (SELECT overall_avg_loan FROM Avg_Loan);


-- Without clause
SELECT DISTINCT B.branch_name
FROM Loan L
JOIN Branch B ON L.branch_name = B.branch_name
GROUP BY B.branch_name
HAVING SUM(L.amount) < (
    SELECT AVG(amount)
    FROM Loan
);