DROP TABLE IF EXISTS Train;
DROP TABLE IF EXISTS Passenger;
DROP TABLE IF EXISTS Ticket;
DROP TABLE IF EXISTS UserAccount;
DROP TABLE IF EXISTS TicketToTrain;
DROP TABLE IF EXISTS Station;
DROP TABLE IF EXISTS Travel;
DROP TABLE IF EXISTS Staff;

CREATE TABLE Train(
    trainID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    totalSeats INT
);

CREATE TABLE Passenger(
    passengerID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    firstName VARCHAR(30),
    lastName VARCHAR(30),
    city VARCHAR(50),
    phone VARCHAR(15),
    email VARCHAR(50),
    dateOfBirth DATE,
    FK_trainID INT,
    CONSTRAINT FK_trainPassenger FOREIGN KEY (FK_trainID) REFERENCES Train(trainID)
        ON UPDATE CASCADE
        ON DELETE SET NULL
);

CREATE TABLE Ticket (
    ticketID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    ticketPrice VARCHAR(20),
    issueTime DATETIME,
    seatNumber INT,
    FK_userID INT,
    CONSTRAINT FK_userAccount FOREIGN KEY (FK_userID) REFERENCES UserAccount(userID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE UserAccount (
    userID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    username VARCHAR(30),
    walletBalance VARCHAR(30),
    createdOn DATE,
    FK_passengerID INT,
    CONSTRAINT FK_passenger FOREIGN KEY (FK_passengerID) REFERENCES Passenger(passengerID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE TicketToTrain (
    trainID INT NOT NULL,
    ticketID INT NOT NULL,
    CONSTRAINT FK_Train FOREIGN KEY (trainID) REFERENCES Train(trainID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
    CONSTRAINT FK_Ticket FOREIGN KEY (ticketID) REFERENCES Ticket(ticketID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Station (
    stationID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    stationLocation VARCHAR(30),
    stationPhone VARCHAR(15) DEFAULT '',
    numberOfRails INT
);

CREATE TABLE Travel (
    travelID INTEGER PRIMARY KEY AUTOINCREMENT,
    FK_trainID INT NOT NULL,
    FK_stationID INT NOT NULL,
    departure VARCHAR(30),
    destination VARCHAR(30),
    departureTime DATETIME,
    arrivalTime DATETIME,
    CONSTRAINT FK_TrainTravel FOREIGN KEY (FK_trainID) REFERENCES Train(trainID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
    CONSTRAINT FK_TrainStation FOREIGN KEY (FK_stationID) REFERENCES Station(stationID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Staff (
    employeeID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    firstName VARCHAR(30),
    lastName VARCHAR(30),
    city VARCHAR(50),
    phone VARCHAR(15),
    email VARCHAR(50),
    dateOfBirth DATE,
    salary VARCHAR(20),
    FK_trainID INT,
    CONSTRAINT FK_TrainStaff FOREIGN KEY (FK_trainID) REFERENCES Train(trainID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE INDEX StationIndex ON Travel(departure, destination);

-- Train Table
INSERT INTO `Train` (`totalSeats`)
VALUES
  (121),
  (97),
  (106),
  (120),
  (143),
  (93),
  (168),
  (142),
  (175),
  (129);
INSERT INTO `Train` (`totalSeats`)
VALUES
  (194),
  (158),
  (107),
  (177),
  (129),
  (66),
  (180),
  (107),
  (83),
  (97);
INSERT INTO `Train` (`totalSeats`)
VALUES
  (69),
  (39),
  (197),
  (171),
  (69),
  (180),
  (138),
  (129),
  (170),
  (86);
INSERT INTO `Train` (`totalSeats`)
VALUES
  (54),
  (83),
  (199),
  (93),
  (127),
  (129),
  (123),
  (115),
  (38),
  (109);
INSERT INTO `Train` (`totalSeats`)
VALUES
  (63),
  (169),
  (189),
  (198),
  (61),
  (160),
  (66),
  (93),
  (74),
  (60);


-- Passenger table
INSERT INTO `Passenger` (`firstName`,`lastName`,`city`,`phone`,`dateOfBirth`,`FK_trainID`,`email`)
VALUES
  ("Fay","Duran","Dreieich","+358 844 4289","1991-5-10",14,"duran_fay@hotmail.de"),
  ("Carson","Kaufman","Mannheim","+358 446 7756","1967-8-24",5,"c_kaufman80@icloud.de"),
  ("Victoria","Medina","Bremerhaven","+358 511 7641","1969-2-19",39,"v-medina@hotmail.edu"),
  ("Cameron","Castro","Würzburg","+358 911 4427","1976-7-27",50,"c_castro6143@icloud.com"),
  ("Beck","Mcgowan","Garbsen","+358 566 6921","1970-3-6",3,"b_mcgowan3679@protonmail.com"),
  ("Lawrence","Osborne","Itzehoe","+358 423 4680","1968-8-28",17,"lawrence-osborne@yahoo.org"),
  ("Herrod","Melton","Hamburg","+358 784 5734","1981-2-8",6,"melton_herrod585@yahoo.net"),
  ("Regan","Rowe","Lübeck","+358 519 1136","1967-11-13",43,"regan_rowe@hotmail.de"),
  ("Zoe","Atkinson","Kleinmachnow","+358 348 6638","1971-10-1",38,"z_atkinson@yahoo.org"),
  ("Sarah","Olsen","Elmshorn","+358 443 6155","1977-5-15",17,"olsen_sarah@hotmail.de");
INSERT INTO `Passenger` (`firstName`,`lastName`,`city`,`phone`,`dateOfBirth`,`FK_trainID`,`email`)
VALUES
  ("Ella","Hoffman","Ludwigshafen","+358 707 6546","1986-7-1",45,"hoffman_ella@google.com"),
  ("Jamal","Jarvis","Hof","+358 913 1755","1995-1-16",18,"jamal-jarvis3626@icloud.net"),
  ("Dawn","Reilly","Bremerhaven","+358 527 0344","1971-5-31",10,"dreilly8564@protonmail.edu"),
  ("Jamal","Griffin","Dessau","+358 219 9721","1985-5-13",18,"j_griffin7736@hotmail.org"),
  ("Dolan","Black","Mönchengladbach","+358 107 4527","1973-8-10",20,"dblack@aol.edu"),
  ("Colorado","Walters","Chemnitz","+358 406 2442","1983-7-4",47,"colorado-walters@yahoo.edu"),
  ("Tad","Rowland","Hamburg","+358 775 8909","1995-5-4",25,"t-rowland@yahoo.net"),
  ("Justine","Mcdowell","Hamburg","+358 432 2563","1972-7-27",50,"mcdowelljustine@outlook.edu"),
  ("Steven","Hull","Plauen","+358 138 32115","1981-4-11",33,"s-hull@hotmail.org"),
  ("Scott","Gardner","Flensburg","+358 051 7188","1985-8-13",49,"gardner-scott1339@icloud.edu");


--Staff table
INSERT INTO `Staff` (`firstName`,`lastName`,`city`,`phone`,`dateOfBirth`,`FK_trainID`,`email`,`salary`)
VALUES
  ("Ayanna","Valdez","Freising","+358 128 2877","1987-11-25",7,"avaldez2992@icloud.net","2 186€"),
  ("Amanda","Pate","Wismar","+358 929 5719","1967-3-19",23,"pateamanda3920@google.edu","1 602€"),
  ("Kay","Ross","Sankt Ingbert","+358 643 8625","1980-5-7",49,"k_ross9323@icloud.org","2 816€"),
  ("Ryder","Spencer","Hamburg","+358 335 7516","1977-4-27",12,"r-spencer5316@outlook.de","2 643€"),
  ("Cadman","Rivers","Wernigerode","+358 695 7693","1997-1-18",30,"cadman-rivers@protonmail.net","2 581€"),
  ("Blaze","Spears","Ulm","+358 320 8688","1974-4-6",49,"spears.blaze330@aol.de","2 963€"),
  ("Aileen","Summers","Schwedt","+358 924 6825","1977-8-3",27,"a.summers@icloud.de","2 497€"),
  ("Illana","Nunez","Lebach","+358 424 0837","1987-2-20",5,"nunez-illana@outlook.com","2 534€"),
  ("Perry","Davis","Freiburg","+358 686 6615","1986-3-30",26,"d-perry1043@aol.edu","1 701€"),
  ("Phillip","Prince","Fürth","+358 331 5001","1982-3-19",12,"phillip.prince293@icloud.edu","1 901€");

INSERT INTO `Staff` (`firstName`,`lastName`,`city`,`phone`,`dateOfBirth`,`FK_trainID`,`email`,`salary`)
VALUES
  ("Palmer","Avery","Kassel","+358 668 8838","1972-3-23",20,"palmer.avery@icloud.org","2 828€"),
  ("Dillon","Johnston","Elmshorn","+358 116 6345","1970-3-9",23,"d-johnston@google.de","2 464€"),
  ("Venus","Spence","Berlin","+358 056 8468","1983-9-6",22,"spence-venus740@aol.com","2 755€"),
  ("Ifeoma","Rose","Villingen-Schwenningen","+358 911 4997","1970-3-25",15,"ifeoma-rose@protonmail.net","2 094€"),
  ("Kermit","Olson","Neumünster","+358 737 5444","1983-11-13",27,"kolson@hotmail.com","2 298€"),
  ("Sebastian","Harrington","Aschaffenburg","+358 927 1374" ,"1984-10-10",47,"sebastian.harrington@icloud.net","2 300€"),
  ("Tobias","Montgomery","Berlin","+358 226 5397","1996-5-9",19,"t_montgomery5214@hotmail.de","2 653€"),
  ("Reed","Bryant","Aschaffenburg","+358 171 7924" ,"1973-5-7",6,"r-bryant@icloud.net","2 260€"),
  ("Maris","Peck","Völklingen","+358 528 7544" ,"1995-3-20",27,"m-peck@hotmail.de","2 563€"),
  ("Ivory","Ramirez","Wadgassen","+358 385 4971" ,"1967-8-26",41,"i_ramirez2603@google.org","1 869€");


-- Ticket Table
INSERT INTO `Ticket` (`ticketPrice`,`issueTime`,`seatNumber`,`FK_userID`)
VALUES
  ("13€","2022-02-16 09:37:00",6,13),
  ("12€","2022-02-05 19:42:48",75,17),
  ("6€","2022-02-08 04:43:49",75,14),
  ("9€","2022-02-12 02:14:49",89,11),
  ("8€","2022-02-12 09:12:21",170,4),
  ("12€","2022-01-18 10:42:30",134,3),
  ("7€","2022-01-25 09:44:25",88,19),
  ("7€","2022-01-15 00:01:39",48,2),
  ("15€","2022-02-02 11:19:14",46,18),
  ("5€","2022-02-12 10:34:02",27,2);
INSERT INTO `Ticket` (`ticketPrice`,`issueTime`,`seatNumber`,`FK_userID`)
VALUES
  ("12€","2022-01-31 22:29:34",156,5),
  ("6€","2022-01-16 15:49:56",77,12),
  ("13€","2022-01-05 15:45:31",187,7),
  ("9€","2022-01-14 14:24:29",50,11),
  ("15€","2022-02-15 02:33:30",190,18),
  ("7€","2022-02-13 18:36:22",84,6),
  ("13€","2022-01-04 14:40:26",181,11),
  ("4€","2022-01-26 14:02:27",86,12),
  ("5€","2022-01-05 14:50:03",173,3),
  ("11€","2022-01-22 23:03:36",95,12);
INSERT INTO `Ticket` (`ticketPrice`,`issueTime`,`seatNumber`,`FK_userID`)
VALUES
  ("7€","2022-01-21 15:16:40",96,5),
  ("6€","2022-01-08 09:53:24",2,19),
  ("7€","2022-01-14 02:50:14",74,12),
  ("13€","2022-01-25 08:50:23",42,15),
  ("12€","2022-02-11 05:14:28",95,2),
  ("8€","2022-01-30 18:50:50",62,17),
  ("6€","2022-02-06 08:41:10",187,4),
  ("14€","2022-02-15 20:26:18",73,13),
  ("13€","2022-02-15 10:39:54",114,19),
  ("12€","2022-01-02 00:38:37",194,4);
INSERT INTO `Ticket` (`ticketPrice`,`issueTime`,`seatNumber`,`FK_userID`)
VALUES
  ("12€","2022-01-14 11:08:29",111,11),
  ("12€","2022-01-25 14:57:33",120,11),
  ("6€","2022-02-17 03:15:25",134,20),
  ("11€","2022-02-08 11:03:10",72,4),
  ("12€","2022-02-11 11:40:11",62,10),
  ("9€","2022-02-12 19:31:07",194,8),
  ("13€","2022-02-03 19:59:24",23,7),
  ("15€","2022-02-15 20:36:33",175,4),
  ("5€","2022-01-12 03:10:23",40,3),
  ("14€","2022-01-01 13:28:11",80,18);
INSERT INTO `Ticket` (`ticketPrice`,`issueTime`,`seatNumber`,`FK_userID`)
VALUES
  ("12€","2022-01-16 13:35:29",99,10),
  ("12€","2022-02-15 08:30:39",161,12),
  ("12€","2022-02-17 11:20:16",133,19),
  ("12€","2022-01-07 04:46:29",96,9),
  ("4€","2022-02-19 01:47:55",170,2),
  ("5€","2022-02-10 16:46:49",77,10),
  ("9€","2022-01-31 02:26:23",44,5),
  ("10€","2022-01-28 05:31:58",34,12),
  ("6€","2022-01-04 01:11:18",87,3),
  ("10€","2022-02-09 17:56:05",183,2);

  -- UserAccount Table
  INSERT INTO `UserAccount` (`username`,`createdOn`,`FK_passengerID`,`walletBalance`)
VALUES
  ("HCooperKarinaLogan","2020-12-24",17,"23€"),
  ("LVladimirKellySanchez","2021-06-18",3,"10€"),
  ("SAristotleMiriamKemp","2021-05-13",15,"23€"),
  ("PAdrianCourtneyBlanchard","2020-08-29",6,"83€"),
  ("NPakiMargaretSampson","2020-05-11",14,"19€"),
  ("BMaiaIdolaLancaster","2021-10-28",1,"9€"),
  ("DEmeryHadassahEllison","2021-06-23",9,"71€"),
  ("MAleaCassidyCummings","2020-05-08",15,"73€"),
  ("DUlyssesShafiraJones","2020-05-05",20,"56€"),
  ("JSimonElianaFrazier","2020-08-01",16,"88€");
INSERT INTO `UserAccount` (`username`,`createdOn`,`FK_passengerID`,`walletBalance`)
VALUES
  ("TCodyEricaRhodes","2020-06-05",3,"17€"),
  ("AWillaKarynCunningham","2020-11-05",19,"50€"),
  ("JGarthUrsulaBray","2021-02-11",10,"61€"),
  ("EMarshallMadalineWard","2020-02-29",9,"35€"),
  ("UNyssaFaySnider","2021-07-01",4,"29€"),
  ("NAldenSandraMccoy","2022-12-30",2,"59€"),
  ("RHanaeLareinaGray","2021-09-04",12,"98€"),
  ("WJoshuaPiperHarmon","2022-02-07",2,"84€"),
  ("MJonahRemediosTorres","2021-02-28",5,"40€"),
  ("SSierraCherylRodriguez","2020-04-26",4,"34€");


  -- TicketToTrain Table
  INSERT INTO `TicketToTrain` (`trainID`,`ticketID`)
VALUES
  (37,5),
  (47,14),
  (23,39),
  (45,31),
  (34,11),
  (48,27),
  (27,10),
  (19,13),
  (29,43),
  (13,49);
INSERT INTO `TicketToTrain` (`trainID`,`ticketID`)
VALUES
  (50,44),
  (31,5),
  (42,48),
  (2,46),
  (22,40),
  (15,1),
  (21,47),
  (23,23),
  (41,25),
  (39,43);
INSERT INTO `TicketToTrain` (`trainID`,`ticketID`)
VALUES
  (28,2),
  (47,45),
  (37,48),
  (4,3),
  (47,44),
  (20,47),
  (33,29),
  (21,30),
  (4,36),
  (11,32);
INSERT INTO `TicketToTrain` (`trainID`,`ticketID`)
VALUES
  (45,29),
  (26,4),
  (16,18),
  (11,44),
  (29,14),
  (31,19),
  (24,36),
  (25,33),
  (9,9),
  (8,7);
INSERT INTO `TicketToTrain` (`trainID`,`ticketID`)
VALUES
  (22,49),
  (38,8),
  (40,6),
  (26,46),
  (30,18),
  (22,1),
  (29,7),
  (37,12),
  (36,19),
  (10,45);

  --Station Table
  INSERT INTO `Station` (`stationLocation`,`stationPhone`,`numberOfRails`)
VALUES
  ("Helsinki","+358 10 185 0154",10),
  ("Lappeenranta","+358 10 748 1110",2),
  ("Tampere","+358 44 871 3145",4),
  ("Turku","+358 20 544 6922",9),
  ("Kerava","+358 10 666 6666",8),
  ("Korso","+358 40 553 2212",7),
  ("Imatra","+358 10 789 1453",7),
  ("Joensuu","+358 30 584 4841",7),
  ("Rovaniemi","+358 112 2310",4),
  ("Jyväskylä","+358 10 457 6214",9);

-- Travel Table

INSERT INTO `Travel` (`departure`,`destination`,`departureTime`,`arrivalTime`,`FK_trainID`,`FK_stationID`)
VALUES
  ("Tampere","Turku","15:56","18:12",18,1),
  ("Turku","Kerava","20:00","23:12",11,8),
  ("Korso","Imatra","8:07","11:28",12,9),
  ("Turku","Kerava","16:05","19:32",10,5),
  ("Kerava","Korso","14:44","17:54",25,1),
  ("Kerava","Korso","7:48","8:32",18,3),
  ("Imatra","Joensuu","4:38","5:45",11,3),
  ("Korso","Imatra","0:36","2:30",31,4),
  ("Tampere","Turku","17:58","21:23",19,8),
  ("Imatra","Joensuu","15:17","17:55",28,3);
INSERT INTO `Travel` (`departure`,`destination`,`departureTime`,`arrivalTime`,`FK_trainID`,`FK_stationID`)
VALUES
  ("Tampere","Turku","18:16","23:12",33,5),
  ("Helsinki","Tampere","12:10","14:23",32,7),
  ("Helsinki","Turku","12:00","15:32",39,9),
  ("Helsinki","Lappeenranta","13:42","17:22",44,3),
  ("Kerava","Helsinki","9:05","9:44",20,3),
  ("Helsinki","Rovaniemi","5:07","16:52",36,4),
  ("Kerava","Lappeenranta","12:10","14:20",23,9),
  ("Helsinki","Imatra","5:33","9:00",19,6),
  ("Imatra","Joensuu","19:00","23:59",34,5),
  ("Rovaniemi","Turku","18:55","23:11",13,9);
INSERT INTO `Travel` (`departure`,`destination`,`departureTime`,`arrivalTime`,`FK_trainID`,`FK_stationID`)
VALUES
  ("Turku","Lappeenrata","3:03","5:23",40,5),
  ("Korso","Helsinki","12:18","15:13",25,2),
  ("Tampere","Imatra","2:35","5:43",18,6),
  ("Lappeenranta","Tampere","13:23","17:33",38,7),
  ("Joensuu","Helsinki","23:50","4:58",20,6),
  ("Helsinki","Tampere","0:23","2:38",17,2),
  ("Helsinki","Kerava","13:01","13:56",28,5),
  ("Rovaniemi","Turku","4:52","6:07",21,6),
  ("Tampere","Rovaniemi","19:34","23:59",46,3),
  ("Korso","Helsinki","3:07","3:25",19,7);


UPDATE Travel SET departureTime = "2021-02-02 11:30:28", arrivalTime = "2021-02-03 13:51:59" WHERE travelID = 1;
UPDATE Travel SET departureTime = "2021-02-02 19:18:20", arrivalTime = "2021-02-03 01:50:42" WHERE travelID = 2;
UPDATE Travel SET departureTime = "2021-02-02 18:48:42", arrivalTime = "2021-02-03 12:52:29" WHERE travelID = 3;
UPDATE Travel SET departureTime = "2021-02-02 14:20:42", arrivalTime = "2021-02-03 12:46:21" WHERE travelID = 4;
UPDATE Travel SET departureTime = "2021-02-02 09:58:17", arrivalTime = "2021-02-03 06:53:49" WHERE travelID = 5;
UPDATE Travel SET departureTime = "2021-02-02 16:50:43", arrivalTime = "2021-02-03 01:35:04" WHERE travelID = 6;
UPDATE Travel SET departureTime = "2021-02-01 21:35:43", arrivalTime = "2021-02-03 07:06:26" WHERE travelID = 7;
UPDATE Travel SET departureTime = "2021-02-02 17:41:48", arrivalTime = "2021-02-03 05:59:56" WHERE travelID = 8;
UPDATE Travel SET departureTime = "2021-02-02 12:01:54", arrivalTime = "2021-02-02 23:53:06" WHERE travelID = 9;
UPDATE Travel SET departureTime = "2021-02-02 02:24:39", arrivalTime = "2021-02-03 18:56:24" WHERE travelID = 10;
UPDATE Travel SET departureTime = "2021-02-01 23:54:30", arrivalTime = "2021-02-03 12:29:16" WHERE travelID = 11;
UPDATE Travel SET departureTime = "2021-02-01 20:55:56", arrivalTime = "2021-02-02 19:58:29" WHERE travelID = 12;
UPDATE Travel SET departureTime = "2021-02-02 08:33:00", arrivalTime = "2021-02-03 12:59:01" WHERE travelID = 13;
UPDATE Travel SET departureTime = "2021-02-01 20:03:12", arrivalTime = "2021-02-03 04:52:57" WHERE travelID = 14;
UPDATE Travel SET departureTime = "2021-02-02 00:54:19", arrivalTime = "2021-02-03 06:36:45" WHERE travelID = 15;
UPDATE Travel SET departureTime = "2021-02-01 20:07:44", arrivalTime = "2021-02-03 04:50:31" WHERE travelID = 16;
UPDATE Travel SET departureTime = "2021-02-02 13:31:32", arrivalTime = "2021-02-03 10:09:24" WHERE travelID = 17;
UPDATE Travel SET departureTime = "2021-02-02 10:01:38", arrivalTime = "2021-02-03 05:01:02" WHERE travelID = 18;
UPDATE Travel SET departureTime = "2021-02-02 14:10:49", arrivalTime = "2021-02-03 00:02:47" WHERE travelID = 19;
UPDATE Travel SET departureTime = "2021-02-01 21:56:05", arrivalTime = "2021-02-02 19:25:28" WHERE travelID = 20;
UPDATE Travel SET departureTime = "2021-02-02 16:59:13", arrivalTime = "2021-02-03 18:54:59" WHERE travelID = 21;
UPDATE Travel SET departureTime = "2021-02-02 02:49:56", arrivalTime = "2021-02-03 01:45:58" WHERE travelID = 22;
UPDATE Travel SET departureTime = "2021-02-01 21:45:03", arrivalTime = "2021-02-03 18:23:22" WHERE travelID = 23;
UPDATE Travel SET departureTime = "2021-02-02 06:45:10", arrivalTime = "2021-02-03 03:11:23" WHERE travelID = 24;
UPDATE Travel SET departureTime = "2021-02-02 07:29:45", arrivalTime = "2021-02-03 01:47:52" WHERE travelID = 25;
UPDATE Travel SET departureTime = "2021-02-02 05:52:26", arrivalTime = "2021-02-03 19:14:03" WHERE travelID = 26;
UPDATE Travel SET departureTime = "2021-02-02 18:16:15", arrivalTime = "2021-02-02 23:27:02" WHERE travelID = 27;
UPDATE Travel SET departureTime = "2021-02-01 21:01:42", arrivalTime = "2021-02-02 19:23:30" WHERE travelID = 28;
UPDATE Travel SET departureTime = "2021-02-02 19:13:10", arrivalTime = "2021-02-02 21:08:40" WHERE travelID = 29;
UPDATE Travel SET departureTime = "2021-02-02 14:16:59", arrivalTime = "2021-02-03 00:14:32" WHERE travelID = 30;