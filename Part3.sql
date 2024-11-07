------------------------------------------------- Drop all the tables -------------------------------------------------

DROP TABLE [Contains]
 DROP TABLE Writes
 DROP TABLE Orders
 DROP TABLE Coupons
 DROP TABLE Categories
 DROP TABLE Customs
 DROP TABLE Products
 DROP TABLE CreditCards
 DROP TABLE Customers
 DROP TABLE CakeSize
 DROP TABLE CakeFlavor
 DROP TABLE CakeDesignIcing
 DROP TABLE CakeTopping
 DROP TABLE Colors






 ------------------------------------------------- Create tables -------------------------------------------------






 --DROP TABLE Customers
CREATE TABLE Customers (
    Email           VARCHAR(40)    PRIMARY KEY NOT NULL,
    NameFirst       VARCHAR(20)    NOT NULL,
    NameLast        VARCHAR(20)    NOT NULL,
    Phone           VARCHAR(20)    NOT NULL,
    CompanyName     VARCHAR(20)    NULL
);

--DROP TABLE CreditCards
CREATE TABLE CreditCards (
    CreditCardNumber    VARCHAR(20)    PRIMARY KEY NOT NULL,
    ExpirationDate      VARCHAR(5)     NOT NULL,
    CVV                 VARCHAR(3)     NOT NULL
);

--DROP TABLE Products
CREATE TABLE Products (
    DesignID        VARCHAR(20) PRIMARY KEY NOT NULL,
    Size            VARCHAR(20) NOT NULL,
    Topper          VARCHAR(20) NULL,
    Flavor          VARCHAR(50) NOT NULL,
    Card            VARCHAR(50) NULL,
    BasePrice       MONEY       NOT NULL,
    AdditionalPrice MONEY       NULL
);

--DROP TABLE Customs
CREATE TABLE Customs (
    DesignID    VARCHAR(20) PRIMARY KEY NOT NULL,
    CakeBase    VARCHAR(40) NOT NULL,
    CakeIcing   VARCHAR(50) NOT NULL,
    Topping1    VARCHAR(50) NULL,
    Topping2    VARCHAR(50) NULL,
    Topping3    VARCHAR(50) NULL,
    CONSTRAINT FK_Product_Custom FOREIGN KEY (DesignID) REFERENCES Products(DesignID)
);

--DROP TABLE Categories
CREATE TABLE Categories (
    DesignID    VARCHAR(20) PRIMARY KEY NOT NULL,
    CakeName    VARCHAR(20) NOT NULL,
    Color       VARCHAR(20) NULL,
    CONSTRAINT FK_Product_Category FOREIGN KEY (DesignID) REFERENCES Products(DesignID)
);

CREATE TABLE Coupons (
    CouponName      VARCHAR(20) PRIMARY KEY NOT NULL,
    DiscountPercent REAL        NOT NULL
);

--DROP TABLE Orders
CREATE TABLE Orders (
    OrderID             VARCHAR(20) PRIMARY KEY NOT NULL,
    NotesToOrders       VARCHAR(50) NULL,
    AddressCountry      VARCHAR(20) NOT NULL,
    AddressCity         VARCHAR(20) NOT NULL,
    AddressStreet       VARCHAR(40) NOT NULL,
    AddressHouseNumber  VARCHAR(20) NOT NULL,
    AddressApartment    VARCHAR(20) NULL,
    Customer            VARCHAR(40) NOT NULL,
    CreditCard          VARCHAR(20) NOT NULL,
    CouponName          VARCHAR(20) NULL,
    CONSTRAINT FK_Customer FOREIGN KEY (Customer) REFERENCES Customers(Email),
    CONSTRAINT FK_CreditCard FOREIGN KEY (CreditCard) REFERENCES CreditCards(CreditCardNumber),
    CONSTRAINT FK_Coupon FOREIGN KEY (CouponName) REFERENCES Coupons(CouponName)
);

--DROP TABLE Contains
CREATE TABLE [Contains] (
    DesignID   VARCHAR(20) NOT NULL,
    OrderID    VARCHAR(20) NOT NULL,
    Quantity   INT         NOT NULL,
    CONSTRAINT PK_Contains PRIMARY KEY (DesignID, OrderID),
    CONSTRAINT FK_Product_Contain FOREIGN KEY (DesignID) REFERENCES Products(DesignID),
    CONSTRAINT FK_Order FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

CREATE TABLE Writes (
    Cake       VARCHAR(20) NOT NULL,
    Customer   VARCHAR(40) NOT NULL,
    Review     VARCHAR(255) NOT NULL,
    CONSTRAINT PK_Writes PRIMARY KEY (Cake, Customer),
    CONSTRAINT FK_Write_Cake FOREIGN KEY (Cake) REFERENCES Categories(DesignID),
    CONSTRAINT FK_Write_Customer FOREIGN KEY (Customer) REFERENCES Customers(Email)
);

ALTER TABLE Customers ADD CONSTRAINT CK_Email CHECK (Email LIKE '%@%.%');
ALTER TABLE Products ADD CONSTRAINT CK_BasePrice CHECK (BasePrice > 0);
ALTER TABLE Products ADD CONSTRAINT CK_AdditionalPrice CHECK (AdditionalPrice > 0);
ALTER TABLE [Contains] ADD CONSTRAINT CK_Quantity CHECK (Quantity > 0);
ALTER TABLE Customs ADD CONSTRAINT CK_Base CHECK (CakeBase IN ('Vegan', 'Gluten Friendly', 'Low Sugar', 'Standard'));
ALTER TABLE CreditCards ADD CONSTRAINT CK_CVV CHECK (CVV LIKE '[0-9][0-9][0-9]');
ALTER TABLE CreditCards ADD CONSTRAINT CK_Date CHECK (ExpirationDate LIKE '[0][1-9]/[0-9][0-9]' OR ExpirationDate LIKE '[1][0-2]/[0-9][0-9]');
ALTER TABLE Coupons ADD CONSTRAINT CK_Discount CHECK (DiscountPercent >= 0 AND DiscountPercent <= 100);

CREATE TABLE CakeSize (
    Size VARCHAR(20) PRIMARY KEY NOT NULL
);
INSERT INTO CakeSize VALUES ('5 inch'), ('6 inch'), ('7 inch'), ('8 inch'), ('10 inch');
ALTER TABLE Products ADD CONSTRAINT FK_CakeSize FOREIGN KEY (Size) REFERENCES CakeSize(Size);

CREATE TABLE CakeFlavor (
    Flavor VARCHAR(50) PRIMARY KEY NOT NULL
);
INSERT INTO CakeFlavor VALUES ('The Classic'), ('Matcha Lover'), ('Oreo Madness'), ('Very Berry Raspberry'), ('Jamaican Dark chocolate'), ('Reeces'), ('Cookie Monster'), ('Zesty Lemon'), ('Mars Bar'), ('Mint Chocolate');
ALTER TABLE Products ADD CONSTRAINT FK_CakeFlavor FOREIGN KEY (Flavor) REFERENCES CakeFlavor(Flavor);

CREATE TABLE CakeDesignIcing (
    CakeIcing VARCHAR(50) PRIMARY KEY NOT NULL
);
INSERT INTO CakeDesignIcing VALUES ('matcha'), ('Oreo'), ('Blue with Gold leaf'), ('Chocolate'), ('Buttercream Flowers'), ('Blue Shades'), ('Pink & Purple'), ('Pink Shades'), ('Rainbow'), ('Vintage Stencil'), ('White With Gold Leaf'), ('White');
ALTER TABLE Customs ADD CONSTRAINT FK_CakeDesign FOREIGN KEY (CakeIcing) REFERENCES CakeDesignIcing(CakeIcing);

CREATE TABLE CakeTopping (
    Topping VARCHAR(50) PRIMARY KEY NOT NULL
);
INSERT INTO CakeTopping VALUES ('White Chocolate Shards'), ('White Chocolate Drip'), ('Dark Chocolate Drip'), ('Chocolate Assortment'), ('Dark Chocolate Shards'), ('Macarons'), ('Meringue Kisses'), ('Fresh Floral Decorations 3'), ('Fresh Floral Decorations 1'), ('Fresh Floral Decorations 2');
ALTER TABLE Customs ADD CONSTRAINT FK_Topping1 FOREIGN KEY (Topping1) REFERENCES CakeTopping(Topping);
ALTER TABLE Customs ADD CONSTRAINT FK_Topping2 FOREIGN KEY (Topping2) REFERENCES CakeTopping(Topping);
ALTER TABLE Customs ADD CONSTRAINT FK_Topping3 FOREIGN KEY (Topping3) REFERENCES CakeTopping(Topping);

CREATE TABLE Colors (
    Color VARCHAR(20) PRIMARY KEY NOT NULL
);
INSERT INTO Colors VALUES ('Blue & Cream'), ('Pink & Cream'), ('Purple & Cream'), ('Black & Cream'), ('Mauve & Purple'), ('White & Black'), ('Black & White'), ('Lavendar'), ('Rose Gold'), ('Hot Pink'), ('Black'), ('Blue & Pink'), ('Pink & Red'), ('Green & Pink'), ('Blue & Rose'), ('Green & Rose'), ('Grey & Mauve'), ('Yellow & Purple'), ('White'), ('Tan'), ('Peach'), ('Mauve');
ALTER TABLE Categories ADD CONSTRAINT FK_Color FOREIGN KEY (Color) REFERENCES Colors(Color);






------------------------------------------------- Queries for Part 3 -------------------------------------------------






SELECT DiscountPercent, 
TotalRevenue = ROUND(SUM(Quantity * (BasePrice + ISNULL(P.AdditionalPrice, 0)) * (1-DiscountPercent)),0)
FROM Coupons JOIN Orders AS O ON Coupons.CouponName = O.CouponName 
JOIN [Contains] ON O.OrderID = [Contains].OrderID
JOIN Products AS P ON P.DesignID = [Contains].DesignID
GROUP BY DiscountPercent
ORDER BY ROUND(SUM(Quantity * (BasePrice + ISNULL(P.AdditionalPrice, 0)) * (1-DiscountPercent)),0) DESC




SELECT Customers.Email, [Full Name] = NameFirst + ' ' + NameLast, [Number of orders] = COUNT(DISTINCT O.OrderID) 
FROM Customers JOIN Orders AS O ON Customers.Email = O.Customer 
JOIN [Contains] ON O.OrderID = [Contains].OrderID
JOIN Products AS P ON P.DesignID = [Contains].DesignID
GROUP BY Customers.Email, NameFirst, NameLast
HAVING COUNT(DISTINCT O.OrderID) > 3
ORDER BY COUNT(DISTINCT O.OrderID)




SELECT CakeName, TotalQuantity = SUM(Quantity), QuantityPrecent = SUM(Quantity) * 100.0 /
(
SELECT SUM(Quantity)
FROM Categories AS CA 
JOIN [Contains] AS CO ON CA.DesignID = CO.DesignID
)
FROM Categories AS CA 
JOIN [Contains] AS CO ON CA.DesignID = CO.DesignID
GROUP BY CakeName
ORDER BY QuantityPrecent DESC




SELECT W.Cake, [Total Reviews] = COUNT(W.Review)
FROM (
SELECT TOP 10 CA.DesignID, [Total Quantity] = COUNT(C.Quantity)
FROM Categories AS CA JOIN [Contains] AS C ON CA.DesignID = C.DesignID
GROUP BY CA.DesignID
ORDER BY COUNT(C.Quantity) DESC
) AS X
LEFT JOIN Writes AS W ON X.DesignID = W.Cake
GROUP BY W.Cake
ORDER BY COUNT(W.Review) DESC




ALTER TABLE Customers ADD [Level] VARCHAR(10)

UPDATE Customers SET [Level] = CASE
 WHEN (
        SELECT COUNT(*)
        FROM Orders O
        WHERE O.Customer = Customers.Email
    ) > 3 THEN 'VIP'
 WHEN (
        SELECT COUNT(*)
        FROM Orders O
        WHERE O.Customer = Customers.Email
    ) BETWEEN 2 AND 3 THEN 'Regular'
    ELSE 'New' END




SELECT DISTINCT Flavor
FROM Products

EXCEPT

SELECT Flavor
FROM Orders AS O JOIN [Contains] AS C ON O.OrderID = C.OrderID
JOIN Products AS P ON C.DesignID = P.DesignID
WHERE AddressCity = 'Melbourne' AND Size =
(
SELECT TOP 1 Size
FROM Orders AS O JOIN [Contains] AS C ON O.OrderID = C.OrderID
JOIN Products AS P ON C.DesignID = P.DesignID
GROUP BY Size
ORDER BY COUNT(*) DESC
)



ALTER TABLE Orders
ADD [Total Amount] MONEY

UPDATE Orders
SET [Total Amount] = (
    SELECT SUM(C.Quantity * (1 - ISNULL(COUP.DiscountPercent, 0) / 100) * (P.BasePrice + ISNULL(P.AdditionalPrice, 0)))
    FROM [Contains] AS C
    JOIN Products AS P ON C.DesignID = P.DesignID
    LEFT JOIN Coupons AS COUP ON Orders.CouponName = COUP.CouponName
    WHERE Orders.OrderID = C.OrderID
)
SELECT AddressCountry, [Total Amount],
[Order Rank] = RANK() OVER (PARTITION BY AddressCountry ORDER BY [Total Amount] DESC),
[Total AVG] = AVG([Total Amount]) OVER(),
[Country AVG] = AVG([Total Amount]) OVER(PARTITION BY AddressCountry),
[Country Num of Orders] = COUNT([Total Amount]) OVER(PARTITION BY AddressCountry),
[Total Num of Orders] = COUNT([Total Amount]) OVER()
FROM Orders
ORDER BY AddressCountry





ALTER TABLE Customers 
ADD [Total per Customer] MONEY

UPDATE Customers
SET [Total per Customer] =
	(
	SELECT SUM([Total Amount])
	FROM Orders
	WHERE Customers.Email = Orders.Customer
	)
SELECT Email, [Total Amount], 
[Num of Orders] = COUNT([Total Amount]) OVER(PARTITION BY Email),
[Total per Customer],
[Total AVG] = AVG([Total Amount]) OVER(),
[Customer AVG] = AVG([Total Amount]) OVER(PARTITION BY Email),
Quartile = NTILE(4) 
OVER (ORDER BY [Total per Customer])
FROM Customers AS C JOIN Orders AS O ON C.Email = O.Customer
ORDER BY Email




WITH
JoinTable AS (
    SELECT O.AddressCountry, O.AddressCity, CU.CakeBase, CO.Quantity, CU.DesignID, O.OrderID, 
	COUP.CouponName, COUP.DiscountPercent, P.BasePrice, P.AdditionalPrice
    FROM Customs AS CU
    JOIN Products AS P ON CU.DesignID = P.DesignID
    JOIN [Contains] AS CO ON CO.DesignID = P.DesignID
    JOIN Orders AS O ON O.OrderID = CO.OrderID
    JOIN Coupons AS COUP ON O.CouponName = COUP.CouponName
),
CountCities AS ( 
    SELECT CakeBase,
	[Number of Countries] = COUNT(DISTINCT AddressCountry),
	[Number of Cities] = COUNT(DISTINCT AddressCity)
    FROM JoinTable
    GROUP BY CakeBase
),
Price AS (
    SELECT CakeBase, [Total Quantity] = SUM(Quantity),
    [Revenue from Base] = SUM(Quantity * (1 - ISNULL(DiscountPercent, 0) / 100) * (BasePrice + ISNULL(AdditionalPrice, 0)))
    FROM JoinTable
    GROUP BY CakeBase
),
TotalRevenue AS (
    SELECT [Total Revenue] = SUM([Revenue from Base])
    FROM Price
),
CountAllCities AS (
    SELECT [Count all Cities] = COUNT(DISTINCT AddressCity)
    FROM Orders
)
SELECT CC.CakeBase,
P.[Total Quantity],
[Revenue from Base] = ROUND(P.[Revenue from Base],2), 
[Revenue Ratio] = ROUND((P.[Revenue from Base] * 100.0 / TR.[Total Revenue]),2),
[Revenue Quartile] = Ntile(4) OVER (ORDER BY P.[Revenue from Base] DESC),
CC.[Number of Countries], 
CC.[Number of Cities], 
[Cities Ratio] = CAST((CC.[Number of Cities] * 100.0 / CAC.[Count all Cities]) AS DECIMAL(10,2))
FROM CountCities AS CC
JOIN Price AS P ON CC.CakeBase = P.CakeBase
CROSS JOIN TotalRevenue AS TR
CROSS JOIN CountAllCities AS CAC
ORDER BY P.[Revenue from Base] DESC
