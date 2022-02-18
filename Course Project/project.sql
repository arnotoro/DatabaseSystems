CREATE TABLE Train(
    trainID INT PRIMARY KEY,
    totalSeats INT
);

CREATE TABLE Passenger(
    passengerID INT PRIMARY KEY,
    firstName VARCHAR(30),
    lastName VARCHAR(30),
    homeAddress VARCHAR(50),
    phone VARCHAR(15),
    email VARCHAR(50),
    dateOfBirth DATE,
    FK_trainID INT,
    CONSTRAINT FK_train
    FOREIGN KEY (FK_trainID) REFERENCES Train(trainID)
);

CREATE TABLE Ticket (
    ticketID INT PRIMARY KEY,
    ticketPrice NUMERIC,
    issueDate DATE,
    seatNumber INT,
    FK_userID INT,
    CONSTRAINT FK_userAccount
    FOREIGN KEY (FK_userID) REFERENCES UserAccount(userID)
);

CREATE TABLE UserAccount (
    userID INT PRIMARY KEY,
    username VARCHAR(30),
    password VARCHAR(30),
    walletBalance NUMERIC,
    createdOn DATE,
    FK_passengerID INT,
    CONSTRAINT FK_passenger
    FOREIGN KEY (FK_passengerID) REFERENCES Passenger(passengerID)
);

CREATE TABLE TicketToTrain (
    trainID INT NOT NULL,
    ticketID INT NOT NULL,
    CONSTRAINT FK_TrainTicket
    FOREIGN KEY (trainID) REFERENCES Train(trainID)
    FOREIGN KEY (ticketID) REFERENCES Ticket(ticketID)
);

CREATE TABLE Station (
    stationID INT,
    stationName VARCHAR(30),
    stationLocation VARCHAR(30),
    stationPhone VARCHAR(15),
    numberOfRails INT
);

CREATE TABLE Travel (
    FK_trainID INT NOT NULL,
    FK_stationID INT NOT NULL,
    departure VARCHAR(30),
    destination VARCHAR(30),
    departureTime DATETIME,
    arrivalTime DATETIME,
    CONSTRAINT FK_TrainStation
    FOREIGN KEY (FK_trainID) REFERENCES Train(trainID)
    FOREIGN KEY (FK_stationID) REFERENCES Station(stationID)
);

CREATE TABLE Staff (
    employeeID INT NOT NULL,
    firstName VARCHAR(30),
    lastName VARCHAR(30),
    homeAddress VARCHAR(50),
    phone VARCHAR(15),
    email VARCHAR(50),
    dateOfBirth DATE,
    salary NUMERIC,
    FK_trainID INT,
    CONSTRAINT FK_TrainStaff
    FOREIGN KEY (FK_trainID) REFERENCES Train(trainID)
);
