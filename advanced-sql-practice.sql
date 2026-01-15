START TRANSACTION;

-- delete customers and orders tables if they exist
drop table if exists customers, orders;

-- create a table called customers with these identifiers
create table customers (
 id int primary key auto_increment,
 first_name varchar(50),
 last_name varchar(50)
);

-- create a table called orders with these identifiers
create table orders (
 id int primary key,
 customer_id int null,
 order_date date,
 total_amount decimal(10, 2),
 foreign key (customer_id) references customers(id)
);

-- add these values to the table customers
insert into customers (id, first_name, last_name) values
(1, 'John', 'Doe'),
(2, 'Jane', 'Smith'),
(3, 'Alice', 'Smith'),
(4, 'Bob', 'Brown');

-- add these values to the table orders
insert into orders (id, customer_id, order_date, total_amount) values
(1, 1, '2023-01-01', 100.00),
(2, 1, '2023-02-01', 150.00),
(3, 2, '2023-01-01', 200.00),
(4, 3, '2023-04-01', 250.00),
(5, 3, '2023-04-01', 300.00),
(6, NULL, '2023-04-01', 100.00);

-- show all data in tables customers and orders 
SELECT * FROM customers;
SELECT * FROM orders;

-- show total amount spent by each customer
SELECT customer_id, SUM(total_amount) AS total_spent
FROM orders
GROUP BY customer_id;

-- show total amount spent by each customer on each date
SELECT customer_id, order_date, SUM(total_amount) AS total_spent
FROM orders
GROUP BY customer_id, order_date;

-- show total amount spent by each customer but only if amount is over $200
SELECT customer_id, SUM(total_amount) AS total_spent
FROM orders
WHERE total_amount > 200
GROUP BY customer_id;

-- show customers who have spent more than $200
SELECT customer_id, SUM(total_amount) AS total_spent
FROM orders
GROUP BY customer_id
HAVING SUM(total_amount) > 200;

-- show data in table orders using first and last name (from table customers) instead of customer id
SELECT orders.id, customers.first_name, customers.last_name, orders.order_date, orders.total_amount
FROM orders
INNER JOIN customers ON orders.customer_id = customers.id;

-- show data in table orders, use first and last name instead of customer id 
-- include records even if they don't have a first and last name
SELECT orders.id, customers.first_name, customers.last_name, orders.order_date, orders.total_amount
FROM orders
LEFT JOIN customers ON orders.customer_id = customers.id;

-- show data in table orders where total amount is greater than or equal to 
-- the average total amount of orders
SELECT id, order_date, total_amount
FROM orders
WHERE total_amount >= (SELECT AVG(total_amount) FROM orders);

-- show orders where customer id is in the list of id values where customer name is Smith
SELECT id, order_date, total_amount, customer_id
FROM orders
WHERE customer_id IN (SELECT id FROM customers WHERE last_name = "Smith");

-- show all order dates from the table orders
SELECT order_date
FROM (SELECT id, order_date, total_amount FROM orders) AS order_summary;

COMMIT;