CREATE TABLE "Customer" (
	"CustomerID"	INTEGER NOT NULL,
	"Phone_number"	INTEGER,
	"Location"	TEXT,
	"Name"	TEXT,
	PRIMARY KEY("CustomerID")
);

CREATE TABLE "Employee" (
	"EmployeeID"	INTEGER NOT NULL UNIQUE,
	"Title"	TEXT,
	"Phone_number"	INTEGER,
	"Full_name"	TEXT,
	PRIMARY KEY("EmployeeID")
);

CREATE TABLE "Inventory" (
	"FK_ProductID"	INTEGER NOT NULL UNIQUE,
	"Supply"	INTEGER NOT NULL,
	"Min_supply"	INTEGER DEFAULT 5,
	FOREIGN KEY("FK_ProductID") REFERENCES "Product"("ProductID") ON DELETE CASCADE
);

CREATE TABLE "Product" (
	"ProductID"	INTEGER NOT NULL,
	"Description"	TEXT,
	"Title"	TEXT,
	"FK_ProductID"	INTEGER,
	"Quantity_for_assembly"	REAL,
	PRIMARY KEY("ProductID"),
	FOREIGN KEY("FK_ProductID") REFERENCES "Product"("ProductID") ON DELETE CASCADE
);

CREATE TABLE "Sale" (
	"SaleID"	INTEGER NOT NULL,
	"FK_CustomerID"	INTEGER NOT NULL,
	"Date"	TEXT,
	"FK_EmployeeID"	INTEGER NOT NULL,
	"Price"	INTEGER,
	FOREIGN KEY("FK_EmployeeID") REFERENCES "Employee"("EmployeeID"),
	FOREIGN KEY("FK_CustomerID") REFERENCES "Customer"("CustomerID"),
	PRIMARY KEY("SaleID")
);

CREATE TABLE "Supplier" (
	"SupplierID"	INTEGER,
	"Name"	TEXT,
	"Location"	TEXT,
	"Phone_number"	INTEGER,
	PRIMARY KEY("SupplierID")
);

CREATE TABLE "SupplyList" (
	"FK_ProductID"	INTEGER NOT NULL UNIQUE,
	"FK_SupplierID"	INTEGER NOT NULL DEFAULT 1,
	FOREIGN KEY("FK_SupplierID") REFERENCES "Supplier"("SupplierID"),
	FOREIGN KEY("FK_ProductID") REFERENCES "Product"("ProductID") ON DELETE CASCADE
);
CREATE TABLE "SaleOrder" (
	"OrderID"	INTEGER,
	"FK_ProductID"	INTEGER,
	"FK_SaleID"	INTEGER,
	"Quantity"	INTEGER,
	PRIMARY KEY("OrderID"),
	FOREIGN KEY("FK_ProductID") REFERENCES "Product"("ProductID"),
	FOREIGN KEY("FK_SaleID") REFERENCES "Sale"("SaleID")
);
