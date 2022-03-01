import sqlite3
from bokeh.io import output_file, show
from bokeh.plotting import figure
from bokeh.models import NumeralTickFormatter

db = sqlite3.connect("PythonDBProgram/project_test.db")
cur = db.cursor()


def initDB():
    try:
        f = open("createTables.sql", "r")
        commandstring = ""
        for line in f.readlines():
            commandstring += line
        cur.executescript(commandstring)
    except sqlite3.OperationalError:
        print("Database exists, skip initialization")


# Create some testing data:
def createData():

    # sports:
    sports = ["Football", "Hockey", "Tennis"]
    for sport in sports:
        cur.execute("INSERT OR IGNORE INTO Sport VALUES (?)", (sport,))
    # Coaches:
    coaches = [
        [1, "Hannu Jortikka", 100000, "TPS"],
        [2, "Markku Kanerva", 200000, "Finnish national team"],
        [3, "Roman Rotenberg", 300000, "SKA St.Petersburg"],
        [4, "Lionel Scaloni", 500000, "Argentinian national team"],
    ]
    for c in coaches:
        cur.execute(
            "INSERT OR IGNORE INTO Coach VALUES (?,?,?,?)", (c[0], c[1], c[2], c[3])
        )
    # Players:
    players = [
        [1, 100000, "Lauri Korpikoski", "Forward", "TPS", 1],
        [2, 200000, "Tim Sparv", "Middle field", "Finnish national team", 2],
        [3, 300000, "Leo Komarov", "Forward", "SKA St.Petersburg", 3],
        [4, 100000, "Paulus Arajuuri", "Defender", "Finnish national team", 2],
        [5, 500000, "Lionel Messi", "Forward", "Argentinian national team", 4],
    ]
    for c in players:
        cur.execute(
            "INSERT OR IGNORE INTO Player VALUES (?,?,?,?,?,?)",
            (c[0], c[1], c[2], c[3], c[4], c[5]),
        )
    # teams:
    teams = [
        ["TPS", 1000000, "Hockey", "SM-liiga"],
        ["Finnish national team", 200000, "Football", "FIFA World Cup"],
        ["SKA St.Petersburg", 3000000, "Hockey", "KHL"],
        ["Argentinian national team", 1000000, "Football", "FIFA World Cup"],
    ]
    for c in teams:
        cur.execute(
            "INSERT OR IGNORE INTO Team VALUES (?,?,?,?)", (c[0], c[1], c[2], c[3])
        )
    # Spectator:
    cur.execute(
        "INSERT OR IGNORE INTO Spectator VALUES (?,?,?)",
        ("Pertti Penkkiurheilija", 1, "Football"),
    )
    # Leagues:
    cur.execute("INSERT OR IGNORE INTO League VALUES (?)", ("SM-liiga",))
    cur.execute("INSERT OR IGNORE INTO League VALUES (?)", ("FIFA World Cup",))
    cur.execute("INSERT OR IGNORE INTO League VALUES (?)", ("KHL",))

    db.commit()


def main():
    initDB()
    createData()
    userInput = -1
    while userInput != "0":
        print("\nMenu options:")
        print("1: Print all sports")
        print("2: Print all teams")
        print("3: Print all leagues")
        print("4: Print coaches of your team")
        print("5: Print players of your team")
        print("6: Print all players of a league")
        print("7: Update player salary")
        print("8: Print player info")
        print("9: Visualize")
        print("0: Quit")
        userInput = input("What do you want to do? ")

        if userInput == "1":
            printSports()
        elif userInput == "2":
            printTeams()
        elif userInput == "3":
            printLeagues()
        elif userInput == "4":
            printCoaches()
        elif userInput == "5":
            printPlayers()
        elif userInput == "6":
            printLeaguePlayers()
        elif userInput == "7":
            updatePlayerSalary()
        elif userInput == "8":
            printPlayerInfo()
        elif userInput == "9":
            visualizeSalary()
        elif userInput == "0":
            print("Thank you, goodbye!")
        else:
            print("Not a valid input, try again")
    db.close()
    return


def printSports():
    cur.execute("SELECT * FROM Sport; ")
    sports = cur.fetchall()
    print(sports)
    return


def printTeams():
    cur.execute("SELECT TeamName FROM Team; ")
    teams = cur.fetchall()
    print(teams)


def printCoaches():
    team_name = input("Give your teams name: ")
    cur.execute("SELECT CoachName FROM Coach WHERE TeamName=(?);", (team_name,))
    coaches = cur.fetchall()
    print(coaches)
    return


def printPlayers():
    team_name = input("Give your teams name: ")
    cur.execute("SELECT PlayerName FROM Player WHERE TeamName=(?);", (team_name,))
    coaches = cur.fetchall()
    print(coaches)
    return


def printLeaguePlayers():
    l_name = input("Give the league name:")
    query = """SELECT PlayerName FROM Player
                JOIN Team ON Team.TeamName = Player.TeamName
                JOIN League ON League.LeagueName = Team.LeagueName
                WHERE League.LeagueName = (?);"""
    cur.execute(query, (l_name,))
    playerNames = cur.fetchall()
    print(playerNames)
    return


def printLeagues():
    cur.execute("SELECT * FROM League;")
    leagues = cur.fetchall()
    print(leagues)
    return


def updatePlayerSalary():
    p_name = input("Whose salary would you like to update:")
    newSalary = int(input("Give the new salary: "))
    query = """UPDATE Player SET Salary = (?)
                WHERE PlayerName = (?);"""
    cur.execute(query, (newSalary, p_name))
    db.commit()


def printPlayerInfo():
    p_name = input("Whose information would you like to print:")
    cur.execute(
        "SELECT PlayerName, Salary, Position, TeamName FROM Player WHERE PlayerName = (?);",
        (p_name,),
    )
    new_info = cur.fetchall()
    print(
        "Name: {}\nSalary: {}\nPosition: {}\nTeam: {}\n".format(
            new_info[0][0], new_info[0][1], new_info[0][2], new_info[0][3]
        )
    )


def visualizeSalary():

    players = []
    salaries = []
    output_file("chart.html")
    for row in cur.execute("SELECT PlayerName, Salary FROM Player;"):
        players.append(row[0])
        salaries.append((row[1]))
    p = figure(
        x_range=players,
        y_range=(0, max(salaries)),
        plot_width=600,
        plot_height=600,
        title="Player salaries",
    )
    p.vbar(x=players, top=salaries)
    p.x_range.range_padding = 0.05
    p.xaxis.major_label_orientation = 1
    p.yaxis.formatter = NumeralTickFormatter(format="00")
    show(p)


main()
