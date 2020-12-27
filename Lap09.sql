CREATE DATABASE Lab09
GO
USE Lab09
USE AdventureWorks2014
CREATE VIEW ProductList
AS
SELECT ProductID, Name FROM AdventureWorks2014.Production.Product

SELECT * FROM ProductList

SELECT Name FROM ProductList

CREATE VIEW SalesOrderDetail
AS
SELECT pr.ProductID, pr.Name, od.UnitPrice, od.OrderQty,
od.UnitPrice*od.OrderQty as [Total Price]
FROM AdventureWorks2014.Sales.SalesOrderDetail od
JOIN AdventureWorks2014.Production.Product pr
ON od.ProductID=pr.ProductID

SELECT * FROM SalesOrderDetail

--Phần III: Bài tập tự làm
USE Lab09
GO
CREATE TABLE Customer
(
	CustomerID INT IDENTITY,
	CustomerName VARCHAR(50),
	[Address] VARCHAR(100),
	Phone VARCHAR(12),
	CONSTRAINT PK_CustomerID PRIMARY KEY (CustomerID)
)
CREATE TABLE Book
(
	BookCode INT NOT NULL,
	Category VARCHAR(50),
	Author VARCHAR(50),
	Publisher VARCHAR(50),
	Title VARCHAR(100),
	Price INT,
	InStore INT,
	CONSTRAINT PK_BookCode PRIMARY KEY (BookCode)
)
CREATE TABLE BookSold
(
	BookSoldID INT IDENTITY,
	CustomerID INT NOT NULL,
	BookCode INT NOT NULL,
	[Date] DATETIME,
	Price INT,
	Amount INT,
	CONSTRAINT PK_BookSoldID PRIMARY KEY (BookSoldID),
	CONSTRAINT FK_CustomerID FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID) ,
	CONSTRAINT FK_BookCode FOREIGN KEY (BookCode) REFERENCES Book(BookCode)
)
--Chèn ít nhất 5 bản ghi vào bảng Books, 5 bản ghi vào bảng Customer và 10 bản ghi vào bảng
--BookSold.
INSERT INTO Customer
VALUES('Nguyễn Văn Nam','Hà Nội',0987654311),
('Tran Van Thuyen','Nam Dinh',090912122),
('Bui Thi Xuyen','Ha Nam',089123423),
('Tran Thi Lan','Ha Noi',099921234)
SELECT * FROM Customer
INSERT INTO Book
VALUES(1,'Van Hoc','Ngo Tat To','NXB Thanh Nien','Lao Hac',1000,10),
(2,'Van Hoc','Nguyen Du','NXB Kim Dong','Truyen Kieu',1230,100),
(3,'Kinh Te','Dan Senor','NXB Thanh Nien','Quoc Gia Khoi Nghiep',999,5),
(4,'Khoa Hoc','Stephen Hawking','NXB Thanh Nien','Ban Thiet Ke Vi Dai',1599,50),
(5,'Van Hoc','To Hoai','NXB Kim Dong','De Men Phuu Luu Ky',23450,99)

INSERT INTO BookSold
VALUES(1,1,'2012-10-19',999,2),
(1,4,'2012-10-19',1000,3),
(2,1,'2014-11-09',1000,2),
(3,5,'2012-10-19',19999,5),
(4,2,'2015-10-19',1230,2)

--2. Tạo một khung nhìn chứa danh sách các cuốn sách (BookCode, Title, Price) kèm theo số lượng đã
--bán được của mỗi cuốn sách.
CREATE VIEW V_Book AS
SELECT b.BookCode, b.Title, B.Price, bs.Amount
FROM Book b 
JOIN BookSold AS bs ON b.BookCode = bs.BookCode;
SELECT * FROM V_Book

--3. Tạo một khung nhìn chứa danh sách các khách hàng (CustomerID, CustomerName, Address) kèm
--theo số lượng các cuốn sách mà khách hàng đó đã mua.
CREATE VIEW V_Customer AS
SELECT bs.CustomerID,c.CustomerName,c.[Address], bs.Amount 
FROM BookSold bs
JOIN Customer AS c ON bs.CustomerID = c.CustomerID

CREATE VIEW V_Customer_Amout AS
SELECT V_Customer.CustomerID,V_Customer.CustomerName,V_Customer.Address, SUM(Amount) AS 'So luong sach da ban'
FROM V_Customer
GROUP BY V_Customer.CustomerID,V_Customer.CustomerName,V_Customer.Address

SELECT * FROM V_Customer_Amout

-- 4.Tạo một khung nhìn chứa danh sách các khách hàng (CustomerID, CustomerName, Address) đã
--mua sách vào tháng trước, kèm theo tên các cuốn sách mà khách hàng đã mua.

--5. Tạo một khung nhìn chứa danh sách các khách hàng kèm theo tổng tiền mà mỗi khách hàng đã chi
--cho việc mua sách.
CREATE VIEW V_Customer_Price AS
SELECT c.CustomerID, c.CustomerName, SUM()
FROM Customer c JOIN BookSold AS bs ON c.CustomerID = bs.CustomerID

SELECT bs.CustomerID,bs.BookCode, SUM(bs.Amount * b.Price) AS 'Tong tien'
FROM Book b JOIN BookSold AS bs ON b.BookCode = bs.BookCode
GROUP BY  bs.CustomerID,bs.BookCode
SELECT * FROM Book