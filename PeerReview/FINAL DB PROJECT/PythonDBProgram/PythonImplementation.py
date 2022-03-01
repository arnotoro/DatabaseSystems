from ast import While
import sqlite3
import math
from bokeh.io import curdoc, show, output_file
from bokeh.plotting import figure

#Find every component of a product
def componentList(cur):
    cur.execute("""SELECT b.Title, b.Description, a.Title, a.Description, b.Quantity_for_assembly
                    FROM Product a
                    INNER JOIN
                    (SELECT * FROM Product WHERE FK_ProductID NOT NULL) AS b
                    ON b.FK_ProductID = a.ProductID
                    ORDER BY b.Title;""")
    print("\n")
    while True:
        line = cur.fetchone()
        if line == None:
            break
        print(f"""Main assembly: {line[0]}, {line[1]}
            Needs {line[4]}(pc. or meters)
            Component: {line[2]}, {line[3]}\n""")
    return
#Find supplier for every product(Double JOIN)
def productSupplier(cur):
    cur.execute("""SELECT Title, Description, Name, Location
     FROM Product AS p
     LEFT JOIN
     SupplyList AS sl
     ON p.ProductID = sl.FK_ProductID
     LEFT JOIN
     Supplier AS s
     ON sl.FK_SupplierID = s.SupplierID""")
    print("\n\tProducts and their manufactures\n")
    while True:
        line = cur.fetchone()
        if line == None:
            break
        print(f"""{line[0]}
                Supplier: {line[2]}, {line[3]}
                Description: {line[1]}\n""")
    return
#Find most bought product of customer and amount of purchases
def customerProfiles(cur):
    cur.execute("""SELECT Name,
SUM(s1.Price) AS amount,
(SELECT SUM(so.Quantity) FROM SaleOrder so
	JOIN Sale s2
	ON so.FK_SaleID = s2.SaleID
	WHERE s2.FK_CustomerID = s1.FK_CustomerID)
 AS volume FROM Customer c
                    INNER JOIN Sale s1
                    ON s1.FK_CustomerID = c.CustomerID
					
                    GROUP BY CustomerID
                    ORDER BY amount, volume DESC;""")
    
    
    items = cur.fetchall()
    name = []
    sales = []
    volume = []
    colors = ["#c9d9d3", "#718dbf"]
    legend = ["Sales($)", "Volume(pc.)"]
    for i in items:
        name.append(i[0])
        sales.append(i[1])
        volume.append(i[2])
    data = {'Companies' : name,
            'Sales($)'   : sales,
            'Volume(pc.)'   : volume}
    p = figure(x_range=name, title="Company profiles",
            tools="pan,wheel_zoom,box_zoom,reset",plot_width=1500, plot_height=700)

    p.vbar_stack(legend, x='Companies', width=0.5, color=colors, source=data,
                legend_label=legend)

    p.y_range.start = 0
    p.x_range.range_padding = 0.1
    p.legend.location = "top_left"
    p.legend.orientation = "vertical"
    output_file(filename="Customer Profiles.html")
    curdoc().theme = 'dark_minimal'
    p.axis.major_label_orientation = math.pi/4
    

    show(p)
        
#Inventory status
def inventoryStatus(cur):
    print("\n##########INVENTORY STATUS###########\n")
    cur.execute("""SELECT
                (SELECT Product.Title || ', '|| Product.Description From Product WHERE Product.ProductID = Inventory.FK_ProductID),
                Supply FROM Inventory
                """)
    while True:
        line = cur.fetchone()
        if line == None:
            break
        print(f"Item: {line[0]:30} Quantity: {line[1]}")
    print("\n#####################################\n")
    return
#Input sale information and update inventory
def inputSale(cur):
    print("\n\n\tInput sale\n")
    cur.execute("SELECT  CustomerID, name FROM Customer")
    while True:
        line = cur.fetchone()
        if line == None:
            break
        print(f"ID:{line[0]}, {line[1]}")
    customer = input("Customer id: ")
    employee = input("Your own EmployeeID: ")
    date = input("Sale date(dd-kk-yyyy): ")
    price =input("Sale price: ")
    print()
    product=[]
    qt=[]
    cur.execute("SELECT ProductID, Title, Description FROM Product")
    while True:
        line = cur.fetchone()
        if line == None:
            break
        print(f"ID:{line[0]}, {line[1]}, {line[2]}")
    print("Add products as many as you like, 0 as a product id ends input.")
    while True:
        product.append(input("Product ID: "))
        if(product[-1] == "0"):
            product.pop()
            break
        qt.append(input("Quantity: "))
    
    print(f"""You submitted following information:
        CustomerID: {customer}
        EmployeeID: {employee}
        Date: {date}
        Price: {price}
        Items(ID X amount): """)
    for i in range(len(product)):
            print(f"\t{qt[i]} X {product[i]}")
    
    if(input("Confirm(y/n): ")=="n"):
        print("Sale register Canceled.")
        return
    cur.execute("""INSERT INTO Sale (FK_CustomerID, Date, FK_EmployeeID, Price)
                    VALUES (?, ?, ?, ?)""", (customer, date, employee,price))
    for item in range(len(product)):
        cur.execute("""INSERT INTO SaleOrder (FK_ProductID, FK_SaleID, Quantity)
                        VALUES (?,(SELECT MAX(SaleID) FROM Sale), ?)""", (int(product[item]), int(qt[item])))
        cur.execute("""UPDATE Inventory
                    SET Supply = Supply - ?
                    WHERE FK_ProductID = ?""", (int(qt[item]), int(product[item])))
                    
    print("\n\tSale registered, remember to commit changes\n\n")
    return
#update inventory
def updateInventory(cur):
    cur.execute("SELECT FK_ProductID, (SELECT Title || ', '|| Description From Product WHERE Product.ProductID = Inventory.FK_ProductID), Supply FROM Inventory ORDER BY FK_ProductID")
    while True:
        line = cur.fetchone()
        if line == None:
            break
        print(f"ID: {line[0]}, {line[1]:50}  {line[2]}pc.")
    id = input("Give Product id, 0 to not update anything: ")
    if(id == "0"):
        return
    supply = input("What is new supply in inventory: ")
    cur.execute("""UPDATE Inventory
                SET Supply = ? WHERE FK_ProductID = ?""", (supply, id))
    return
def createTables(cur):
    try:
        with open('CreateTables.sql', 'r') as sql_file:
            cur.executescript(sql_file.read())
            print("Tables created, filling them...")
        try:
            with open('FillTables.sql', 'r') as sql_file:
                    cur.executescript(sql_file.read())
            print("Tables created and filled")
        except FileNotFoundError as e:
            print("File not found error: ", e)
        except sqlite3.OperationalError as i:
            print("Script failed,db might have been already created.\nMSG:", i)

    except FileNotFoundError as e:
        print("File not found error: ", e)
    except sqlite3.OperationalError as i:
        print("Script failed,db might have been already created.\nMSG:", i)
    
    
    return

def getSales(cur):
    cur.execute("""SELECT MAX(SaleID) FROM Sale""")
    rows = sum(cur.fetchone())
    for sales in range(1, rows+1):
      try:
        cur.execute("""SELECT (SELECT Name FROM Customer WHERE s.FK_CustomerID = Customer.CustomerID),
                              (SELECT Full_name FROM Employee WHERE s.FK_EmployeeID = Employee.EmployeeID),
                               s.Date
                               FROM Sale s;""")
        line1 = cur.fetchone()
        print(f"""Sale: {sales}
            Customer: {line1[0]}
            Saleperson: {line1[1]}
            Date: {line1[2]}\n""")

        cur.execute("""SELECT 
			(SELECT Title || ', ' || Description FROM Product  WHERE so.FK_ProductID = Product.ProductID),
			so.Quantity
            FROM Sale as s
            INNER JOIN SaleOrder as so
            ON s.SaleID = so.FK_SaleID
            JOIN Product as p
            ON so.FK_ProductID = p.ProductID
            WHERE SaleID = ?
            ORDER BY OrderID;
            """, (sales,))
        while True:
            line2 = cur.fetchone()
            if line2 == None:
                 break
            print(f"""\t\tItem: {line2[0]}
                    Quantity: {line2[1]}""")
        print("\n")
      except sqlite3.OperationalError as e:
          print("Sale info not found,"+ e)
      except TypeError as t:
           print("Sale info not found,"+ t)

#Main
def main():
    db = sqlite3.connect('PythonDBProgram/ERP1.sqlite3')
    cur = db.cursor()
    
    while 1:
        print("""ERP DATABASE
              Select correct query
              1. Component list of a product
              2. Product and supplier list
              3. Customer profile
              4. Input sale information
              5. Update inventory
              6. Inventory status
              7. List all sales
              0. Exit database""")
        selection = input("Give corresponding number: ")
        if selection == "0":
            if(input("Do you want to commit all changes? y/n: ") == "y"):
                db.commit()
                print("Changes committed")
            print("Closing database.")
            db.close()
            break
        elif selection == "1":
            componentList(cur)
        elif selection == "2":
            productSupplier(cur)
        elif selection == "3":
            customerProfiles(cur)
        elif selection == "4":
            inputSale(cur)
        elif selection == "5":
            updateInventory(cur)
        elif selection == "6":
            inventoryStatus(cur)
        elif selection == "sql":
            createTables(cur)
        elif selection == "7":
            getSales(cur)
        else:
            print("Give number betweed 0-7")
    return    

main()