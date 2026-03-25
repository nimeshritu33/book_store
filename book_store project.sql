-- create Database;
create database online_book_store;

-- Create table
Drop table if exists books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);
DROP TABLE IF EXISTS customers;
CREATE TABLE Customer (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
DROP TABLE IF EXISTS orders;
CREATE TABLE Orders(
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);
-- use database
use online_book_store;
-- show table in a database
SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- 1) retrive all books in the "fiction genre;
select * from books
where genre = "fiction";
-- 2)find books published after the year 1950;
select * from books
where published_year > 1950;
-- 3) list all customers from the canada;
select * from customers
where city = "canada";
-- 4) show order place in november 2023;
select * from orders
where order_date between "2023-11-01" and "2023-11-30";
-- 5)Retrive the total stock books availabe;
select sum(stock) as total_stock
 from books;
 -- 6) find the details of the most expensive books;
 select * from books
 order by price desc limit 1;
 -- 7)show all customers who order more than 1 quantity of a book;
 select *  from orders
 where quantity >1;
 -- 8) retrive all order where the total amount exceed $20;
 select * from orders
 where Total_Amount > 20;
 -- 9) list all genres available in the books store
 select distinct genre from books;
 -- 10) find the book with the lowest stock;
 select genre,stock from books
  order by stock asc;
 -- 11) calculated the total revenue genreated from all books;
 select sum(total_amount) from orders;
 
 -- Advanced  questions
 -- 1)retrive the total number of books sold for each genres;
 select genre,sum(quantity) 
 from books
 join orders
 on books.book_id = orders.book_id
 group by genre;
 -- 2) find the average price of the book in the "fantasy" genres
 select avg(price) from books
 where genre = "fantasy";
 -- 3)list customer who have placed at least 2 orders;
 select  o.customer_id,c.name,count(o.order_id) as order_count
 from orders o
 join customers c
 on o.Customer_ID = c.Customer_ID
group by o.customer_id,c.name
having count(order_id) >= 2;
 -- 4)find the most frequent ordered book
 select b.book_id,b.title,count(order_id) as order_count
 from orders o
 join books  b
 on o.Book_ID = b.Book_ID
 group by book_id,title
 order by order_count desc limit 1;
 -- 5) show the top 3 most expensive books of " fantasy " genre
 select * from books
 where genre = "fantasy"
 order  by price desc limit 3;
 -- 6) retrive the total quantity of book sold by each author;
 select b.author,sum(o.quantity)as total_book_Sold
 from orders o 
 join books b
 on o.Book_ID = b.book_id
group by b.author;
-- 7) List the cities where customers who spent over $30 are located:
SELECT DISTINCT c.city, total_amount
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
WHERE o.total_amount > 30;
-- 8) Find the customer who spent the most on orders:
SELECT c.customer_id, c.name, SUM(o.total_amount) AS Total_Spent
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY Total_spent Desc LIMIT 1;
-- 9) Calculate the stock remaining after fulfilling all orders:
SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS Order_quantity,  
	b.stock- COALESCE(SUM(o.quantity),0) AS Remaining_Quantity
FROM books b
LEFT JOIN orders o ON b.book_id=o.book_id
GROUP BY b.book_id ORDER BY b.book_id;