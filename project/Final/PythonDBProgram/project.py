import sqlite3
from bokeh.io import output_file, show
from bokeh.plotting import figure

db = sqlite3.connect('PythonDBProgram/project.db')
cur = db.cursor()

def main():
    userInput = -1
    while(userInput != "0"):
        print("\nMenu options:")
        print("1: Print stations")
        print("2: Print information of specific station")
        print("3: Print departing trains of specific station")
        print("4: Print arriving trains of specific station")
        print("5: Print passengers departing from specific station")
        print("6: Update the next departing train's departure time")
        print("7: Insert new station")
        print("8: Graph all trains departing from all stations")
        print("0: Quit")
        userInput = input("What do you want to do? ")
        print(userInput)
        if userInput == "1":
            printStations()
        if userInput == "2":
            printInfoStation()
        if userInput == "3":
            printDeparture()
        if userInput == "4":
            printArrival()
        if userInput == "5":
            printNames()
        if userInput == "6":
            updateDeparture()
        if userInput == "7":
            insertStation()
        if userInput == "8":
            bokeh()
        if userInput == "0":
            print("Ending software...")
    db.close()        
    return

def printStations():
    print("Printing stations")
    cur.execute("SELECT stationLocation FROM Station;")
    result = cur.fetchall()
    for row in result:
        print(row)

    return

def printInfoStation():
    station = input("Which station? ")
    print("Printing station")
    cur.execute("SELECT stationLocation, stationPhone, numberOfRails FROM Station WHERE stationLocation = (?);", (station,))
    result = cur.fetchone()
    print("\nLocation: " + str(result[0]))
    print("Phone number: " + str(result[1]))
    print("Number of rails: " + str(result[2]))

    return

def printDeparture():
    count = 1
    station = input("Which station? ")
    print("Departing trains")
    cur.execute("SELECT departure, destination, departureTime, arrivalTime FROM Travel WHERE departure =(?) GROUP BY departureTime;", (station,))
    result = cur.fetchall()
    for i in result:
        print("\nTrain number: " + str(count))
        print("Departure location: " + str(i[0]))
        print("Destination: " + str(i[1]))
        print("Departure time: " + str(i[2]))
        print("Arrival time: "+ str(i[3]))
        count += 1

    return

def printArrival():
    count = 1
    station = input("Which station? ")
    print("Arriving trains")
    cur.execute("SELECT destination, departure, arrivalTime, departureTime FROM Travel WHERE destination =(?) GROUP BY arrivalTime;", (station,))
    result = cur.fetchall()
    for i in result:
        print("\nTrain number: " + str(count))
        print("Destination: " + str(i[0]))
        print("Departure: " + str(i[1]))
        print("Arrival time: " + str(i[2]))
        print("Departure time: "+ str(i[3]))
        count += 1

    return

def printNames():
    count = 1
    station = input("Which station? ")

    cur.execute("""SELECT (firstName || ' ' || lastName), departure, destination, departureTime, arrivalTime FROM Train 
    INNER JOIN Passenger ON Train.trainID = Passenger.FK_trainID 
    INNER JOIN Travel ON Travel.FK_trainID = Train.trainID AND departure = (?);""", (station, ))

    result = cur.fetchall()
    for i in result:
        print("\nPassenger number " + str(count))
        print("Passenger name: " + str(i[0]))
        print("Departure: " + str(i[1]))
        print("Destination: " + str(i[2]))
        print("Departure time: "+ str(i[3]))
        print("Arrival time: " +str(i[4]))
        count += 1
    return

def updateDeparture():
    station = input("Which station? ")
    date = input ("what is the new departure time? Format: YYYY-MM-DD HH-MM-SS ")
    
    cur.execute("""UPDATE Travel SET departureTime = (?)
    WHERE travelID = (SELECT travelID FROM Travel WHERE departure = (?) ORDER BY departureTime LIMIT 1); """, (date, station))
    cur.execute("""UPDATE Travel SET arrivalTime = NULL WHERE departureTime = (?) AND departure = (?);""", (date, station,))
    db.commit()
    return

def insertStation():
    station = input("What is the new stations location? ")
    phone = input("New stations phone number? ")
    rails = input("Number of rails? ")

    cur.execute("INSERT INTO Station (stationLocation, stationPhone, numberOfRails) VALUES (?,?,?);", (station, phone, rails))
    db.commit()
    return

def bokeh():
    count = []
    station = []
    output_file("trains.html")
    for row in cur.execute("SELECT departure, COUNT(*) FROM Travel GROUP BY departure;"):
        station.append((row[0]))
        count.append(str(row[1]))

    p = figure(x_range=station, height=500, width=800, title="Departing trains per station",
        toolbar_location = None, tools="")
    
    p.vbar(x=station, top=count, width=0.9)
    p.x_range.range_padding = 0.05
    show(p)
    return


if __name__ == "__main__":
    main()