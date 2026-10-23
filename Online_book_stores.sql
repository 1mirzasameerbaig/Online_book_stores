

DROP TABLE IF EXISTS Books;
CREATE TABLE Books(
	Book_ID	SERIAL	PRIMARY KEY,
	Title	VARCHAR(100),	
	Author	VARCHAR(100),	
	Genre	VARCHAR(100),	
	Published_Year	INT,	
	Price	NUMERIC(10,2),	
	Stock	INT
);

SELECT * FROM Books

COPY Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock)
FROM 'C:/Users/KING/Documents/SQL/SQL Practice/30 Day - SQL Practice Files/Books.csv'
CSV HEADER;

DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers(
	Customer_ID	SERIAL	PRIMARY KEY,
	Name	VARCHAR(100),
	Email	VARCHAR(100),
	Phone	VARCHAR(100),
	City	VARCHAR(100),
	Country	VARCHAR(100)
);

SELECT * FROM Customers

COPY CUSTOMERS(Customer_ID, Name, Email, Phone, City, Country)
FROM 'C:/Users/KING/Documents/SQL/SQL Practice/30 Day - SQL Practice Files/Customers.csv'
CSV HEADER;

DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders(
	Order_ID SERIAL	PRIMARY KEY,
	Customer_ID	INT	REFERENCES Customers(Customer_ID),
	Book_ID	INT	REFERENCES Books(Book_ID),
	Order_Date DATE,
	Quantity INT,
	Total_Amount NUMERIC(10,2)
);

SELECT * FROM Orders

COPY Orders(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount)
FROM 'C:\Users\KING\Documents\SQL\SQL Practice\30 Day - SQL Practice Files\Orders.csv'
CSV HEADER;


--Basic Queries
--1) Retrieve all books in the "Fiction" genre
SELECT * FROM Books WHERE Genre = 'Fiction';

--2) Find books published after the year 1950
SELECT * FROM Books WHERE published_year > 1950;

--3) List all customers from the Canada
SELECT * FROM Customers WHERE country = 'Canada';

--4) Show orders placed in November 2023
SELECT * FROM ORDERS WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

--5) Retrieve the total stock of books available
SELECT SUM(stock) AS Total_Stock FROM Books;

--6) Find the details of the most expensive book
SELECT MAX(price) AS Most_expensive_book;
SELECT * FROM Books ORDER BY price DESC LIMIT 1;

--7) Show all customers who ordered more than 1 quantity of a book
SELECT * FROM Orders WHERE quantity > 1;

--8) Retrieve all orders where the total amount exceeds $20
SELECT * FROM Orders WHERE total_amount > 20;

--9) List all genres available in the Books table
SELECT DISTINCT genre FROM Books;

--10) Find the book with the lowest stock
SELECT * FROM Books ORDER BY stock ASC;

--11) Calculate the total revenue generated from all orders
SELECT SUM(total_amount) AS total_revenue FROM Orders;


--Advance Queries

--1) Retrieve the total number of books sold for each genre
SELECT b.Genre, o.Quantity
FROM Orders o
JOIN Books b ON o.book_id = b.book_id;

SELECT b.Genre, SUM(o.Quantity) AS 	Total_Books_Sold
FROM Orders o
JOIN Books b ON o.book_id = b.book_id
GROUP BY b.Genre;
/*
The main difference is that the first query shows the quantity sold for each order, 
while the second query calculates the total quantity sold for each genre.
*/

--2) Find the average price of books in the "Fantasy" genre
SELECT genre, price FROM Books WHERE Genre = 'Fantasy';

SELECT AVG(price) AS avg_price_Fantasy FROM Books WHERE Genre = 'Fantasy';

--3) List customers who have placed at least 2 orders
SELECT Customer_id, count(order_id) AS order_count
FROM  Orders
GROUP BY customer_id
HAVING COUNT(Order_id) >= 2;

SELECT o.Customer_id, c.name, count(o.order_id) AS order_count
FROM  Orders o
JOIN Customers c ON o.customer_id = c.customer_id
GROUP BY o.customer_id, c.name
HAVING COUNT(Order_id) >= 2;

SELECT o.Customer_id, c.name, count(o.order_id) AS order_count
FROM  Orders o
JOIN Customers c ON o.customer_id = c.customer_id
GROUP BY o.customer_id, c.name
HAVING COUNT(Order_id) >= 2
ORDER BY c.name ASC;

SELECT o.Customer_id, c.name, count(o.order_id) AS order_count
FROM  Orders o
JOIN Customers c ON o.customer_id = c.customer_id
GROUP BY o.customer_id, c.name
HAVING COUNT(Order_id) >= 2
ORDER BY order_count ASC;

--4) Find the most frequently ordered book
SELECT Book_id, COUNT(Order_id) AS Order_Count
FROM orders
GROUP BY Book_id;

SELECT Book_id, COUNT(Order_id) AS Order_Count
FROM orders
GROUP BY Book_id
ORDER BY Order_Count DESC;

SELECT Book_id, COUNT(Order_id) AS Order_Count
FROM orders
GROUP BY Book_id
ORDER BY Order_Count DESC LIMIT 1;

SELECT o.Book_id, b.title, COUNT(o.Order_id) AS Order_Count
FROM orders o
JOIN books b ON o.book_id = b.book_id
GROUP BY o.Book_id, b.title
ORDER BY Order_Count DESC;

SELECT o.Book_id, b.title, COUNT(o.Order_id) AS Order_Count
FROM orders o
JOIN books b ON o.book_id = b.book_id
GROUP BY o.Book_id, b.title
ORDER BY Order_Count DESC LIMIT 1;

--5) Show the top 3 most expensive books of 'Fantasy' Genre 
SELECT * FROM BOOKS
WHERE GENRE = 'FANTASY'
ORDER BY PRICE DESC LIMIT 3;
-- doesn't matter you the headings in caps or small but the "value" name should be as it is.

SELECT * FROM BOOKS
WHERE GENRE = 'Fantasy'
ORDER BY PRICE DESC LIMIT 3;

--6) Retrieve the total quantity of books sold by each author
SELECT o.book_id, b.author, SUM(o.Quantity) AS total_books_sold
FROM Orders o
JOIN Books b ON o.book_id = b.book_id
GROUP BY o.book_id, b.author
ORDER BY total_books_sold DESC;
--try check the reason the difference 

SELECT b.author, SUM(o.Quantity) AS total_books_sold
FROM orders o
JOIN Books b ON o.book_id = b.book_id
GROUP BY b.author
ORDER BY total_books_sold DESC;

--7) List the cities where customers who spent over $30 are located
SELECT DISTINCT C.CUSTOMER_ID, C.NAME, C.CITY, O.TOTAL_AMOUNT
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
WHERE o.total_amount >= 300;

SELECT DISTINCT C.CITY, TOTAL_AMOUNT
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
WHERE o.total_amount >= 300;

--8) Find the customer who spent the most on orders
SELECT c.*, SUM(o.total_amount) AS Total_spent
FROM Orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY Total_spent DESC;

SELECT c.*, SUM(o.total_amount) AS total_spent, STRING_AGG(DISTINCT b.title, ', ') AS books_purchased
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
JOIN book_id b ON o.order_id = b.order_id
JOIN books b ON b.book_id = oi.book_id
GROUP BY c.customer_id
ORDER BY total_spent DESC;


SELECT c.customer_id, c.name, SUM(o.total_amount) AS Total_spent
FROM Orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY Total_spent DESC;



SELECT o.order_id, c.*, b.title, b.author, b.genre,	b.price, o.quantity, o.order_date, o.total_amount 
	AS amount_spent
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Books b ON o.book_id = b.book_id
ORDER BY o.order_id;


SELECT c.*, STRING_AGG(b.title, ', ' ORDER BY b.title) AS books_purchased,
    SUM(o.quantity) AS total_books_purchased, SUM(o.total_amount) AS total_amount_spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Books b ON o.book_id = b.book_id
GROUP BY c.customer_id
ORDER BY total_amount_spent DESC;


SELECT c.*, COALESCE(bk.books_purchased, '') AS books_purchased,
    COALESCE(t.total_books_purchased, 0) AS total_books_purchased, 
	COALESCE(t.total_amount_spent, 0) AS total_amount_spent
FROM Customers c
LEFT JOIN (
    SELECT o.customer_id, STRING_AGG(DISTINCT b.title, ', ' ORDER BY b.title) AS books_purchased
    FROM Orders o
    JOIN Books b ON o.book_id = b.book_id
    GROUP BY o.customer_id 
) bk ON c.customer_id = bk.customer_id
LEFT JOIN (
    SELECT customer_id, SUM(quantity) AS total_books_purchased, SUM(total_amount) AS total_amount_spent
    FROM Orders
    GROUP BY customer_id
) t ON c.customer_id = t.customer_id
ORDER BY total_amount_spent DESC;

--9) Calculate the stock remaining after fulfilling all orders
SELECT b.book_id, b.title, b.stock
FROM books b
LEFT JOIN Orders o ON b.book_id = o.book_id
GROUP BY b.book_id;


SELECT b.book_id, b.title, b.stock, COALESCE(SUM(quantity),0) AS Order_quantity
FROM books b
LEFT JOIN Orders o ON b.book_id = o.book_id
GROUP BY b.book_id;

SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS Order_quantity,
		b.stock - COALESCE(SUM(o.quantity),0) AS Remaining_quantity
FROM books b
LEFT JOIN Orders o ON b.book_id = o.book_id
GROUP BY b.book_id
ORDER BY b.book_id;
