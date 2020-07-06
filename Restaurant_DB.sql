-- Create the tables ((modified) tables taken from https://www.torsten-horn.de/techdocs/sql-commands.sql.htm - all credits go there)

CREATE DATABASE Mensa_test;
USE Mensa_test;

CREATE TABLE Customers
(
  id_customer INT           NOT NULL auto_increment,
  first_name  VARCHAR(100)  NOT NULL,
  department  VARCHAR(2),
  Plz         INT,
  Ort         VARCHAR(100),
  UNIQUE ( id_customer ),
  PRIMARY KEY ( id_customer )
);

INSERT INTO Customers (first_name, department,Plz,Ort)
VALUES  ('Andreas', 'RD', 52525, 'Heinsberg' ),
		('Arthur',  'PR', 52499, 'Baesweiler' ),
		('Gregor',  'PD', 52351, 'Dueren' ),
		('Michael', 'RD', 50859, 'Koeln' ),
		('Norbert', 'RD', 52134, 'Herzogenrath' ),
		('Roland',  'PR', 52134, 'Herzogenrath' ),
		('Stefan',  'PD', 52062, 'Aachen' ),
		('Torsten', 'PD', 52072, 'Aachen' ),
		('Werner',  'PR', 52076, 'Aachen' );

CREATE TABLE Dishes
(
  id_dish      INT           NOT NULL auto_increment,
  dish         VARCHAR(255)  NOT NULL,
  prize        FLOAT         NOT NULL,
  ingredients  VARCHAR(255),
  UNIQUE ( id_dish ),
  UNIQUE ( dish ),
  PRIMARY KEY ( id_dish )
);

INSERT INTO Dishes (dish,prize,ingredients) 
VALUES  ('Pizza Diabolo', 5.50, 'Teufelsohren' ),
		('Pizza Vulkano', 6.00, 'Teig, Käse, Vesuvtomaten' ),
		('Pizza Feuro', 6.50, 'Pepperoni' ),
		('Lasagno', 6, 'Nudeln, Hackfleisch' ),
		('Salat Eskimo', 4.50, 'Eiswürfel' );


CREATE TABLE Orders
(
  id_order     INT  NOT NULL auto_increment,
  id_customer  INT  NOT NULL,
  id_dish      INT  NOT NULL,
  UNIQUE ( id_order ),
  PRIMARY KEY ( id_order ),
  FOREIGN KEY (id_customer) REFERENCES Customers(id_customer) ON DELETE CASCADE,
  FOREIGN KEY (id_dish)     REFERENCES Dishes(id_dish)    ON DELETE CASCADE
);

INSERT INTO Orders (id_customer, id_dish)
VALUES  (3 , 5 ),
		(5 , 3 ),
		(1 , 3 ),
		(8 , 3 ),
		(6 , 1 ),
		(9 , 2 ),
		(7 , 3 ),
		(6 , 4 ),
        (7 , 1 ),
        (2 , 4 ),
        (2 , 2 ),
        (8 , 4 ),
        (3 , 1 ),
		(2 , 3 );

-- ------------------------------------------------------------------------------
-- Print a few interesting things
SELECT * FROM Customers;
SELECT dish,prize AS Euro FROM Dishes;
SELECT id_customer, MAX(id_dish) AS 'maximum dish id order' FROM Orders GROUP BY id_customer;

SELECT dish, ingredients,
	CASE 
		WHEN dish LIKE '%Pizza%' THEN 'Pizza' 
		ELSE 'Not Pizza'
	end as 'dish type'
	From Dishes;

-- A bit of relational analysis
SELECT first_name, department,
	IFNULL(Count(id_order),0) AS 'Visits', 
		CASE 
			WHEN Count(id_order)>=2 THEN 'Frequent client' 
            WHEN Count(id_order)<2 && Count(id_order)>0 THEN 'Normal client' 
            ELSE 'No visit' 
		end AS 'client status' 
	FROM Customers 
    LEFT JOIN Orders ON Customers.id_customer=Orders.id_customer 
    GROUP BY Customers.id_customer;
    
-- Average spent euros per department
SELECT department, 
	IFNULL(SUM(prize),0) AS 'Euros spent'
    FROM Customers
    INNER JOIN Orders ON Customers.id_customer = Orders.id_customer 
    INNER JOIN Dishes ON Orders.id_dish = Dishes.id_dish 
    GROUP BY Customers.department;


-- clear database again
DROP DATABASE Mensa_test;