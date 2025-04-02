drop table depositor cascade constraints;
drop table borrower cascade constraints;
drop table account cascade constraints;
drop table loan cascade constraints;
drop table customer cascade constraints;
drop table branch cascade constraints;

create table account
   (account_number 	varchar(15)	not null,
    branch_name		varchar(15)	not null,
    balance 		number		not null,
    constraint account_pk primary key(account_number));

create table branch
   (branch_name 	varchar(15)	not null,
    branch_city 	varchar(15)	not null,
    assets 		number		not null,
    primary key(branch_name));

create table customer
   (customer_name 	varchar(15)	not null,
    customer_street 	varchar(12)	not null,
    customer_city 	varchar(15)	not null,
    primary key(customer_name));

create table loan
   (loan_number 	varchar(15)	not null,
    branch_name		varchar(15)	not null,
    amount 		number		not null,
    primary key(loan_number));

create table depositor
   (customer_name 	varchar(15)	not null,
    account_number 	varchar(15)	not null,
    primary key(customer_name, account_number),
    foreign key(account_number) references account(account_number),
    foreign key(customer_name) references customer(customer_name));

create table borrower
   (customer_name 	varchar(15)	not null,
    loan_number 	varchar(15)	not null,
    primary key(customer_name, loan_number),
    foreign key(customer_name) references customer(customer_name),
    foreign key(loan_number) references loan(loan_number));

/* populate relations */

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


SELECT branch_name,branch_city
FROM branch
WHERE assets > 1000000;

SELECT account_number,balance 
FROM account 
WHERE branch_name = 'Downtown' OR balance BETWEEN 600 AND 750;

SELECT account.account_number
FROM branch, account
WHERE branch.branch_city = 'Rye' 
AND branch.branch_name = account.branch_name;

SELECT loan.loan_number
FROM customer, loan, borrower
WHERE loan.loan_number = borrower.loan_number 
AND customer.customer_name = borrower.customer_name
AND loan.amount >= 1000 
AND customer.customer_city = 'Harrison';

SELECT *
FROM account
ORDER BY balance DESC;

SELECT *
FROM customer
ORDER BY customer_city ;
   
SELECT customer_name FROM customer
WHERE customer_name IN (
SELECT customer_name FROM depositor
INTERSECT
SELECT customer_name FROM borrower
);

SELECT * FROM customer
WHERE customer_name IN (
SELECT customer_name FROM depositor  
UNION
SELECT customer_name FROM borrower 
);

SELECT c.customer_name, c.customer_city
FROM customer c
JOIN borrower b ON c.customer_name = b.customer_name
MINUS
SELECT c.customer_name, c.customer_city
FROM customer c
JOIN depositor d ON c.customer_name = d.customer_name;

SELECT SUM(assets) AS total_assets
FROM branch;

SELECT branch_name, AVG(balance) AS average_balance
FROM account
GROUP BY branch_name;

SELECT b.branch_city, AVG(a.balance) AS average_balance_in_city
FROM account a
JOIN branch b ON a.branch_name = b.branch_name
GROUP BY b.branch_city;


SELECT branch_name, MIN(amount) AS lowest_loan_amount
FROM loan
GROUP BY branch_name;


SELECT branch_name, MIN(amount) AS lowest_loan_amount
FROM loan
GROUP BY branch_name;

SELECT branch_name, COUNT(loan_number) AS total_loans
FROM loan
GROUP BY branch_name;

SELECT c.customer_name, a.account_number
FROM customer c
JOIN depositor d ON c.customer_name = d.customer_name
JOIN account a ON d.account_number = a.account_number
WHERE a.balance = (SELECT MAX(balance) FROM account);






 

