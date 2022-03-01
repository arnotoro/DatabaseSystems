SELECT * FROM Sport; 

SELECT TeamName FROM Team; 

SELECT CoachName FROM Coach WHERE TeamName=(?);

SELECT PlayerName FROM Player WHERE TeamName=(?);

SELECT PlayerName FROM Player
                JOIN Team ON Team.TeamName = Player.TeamName
                JOIN League ON League.LeagueName = Team.LeagueName
                WHERE League.LeagueName = (?);


SELECT * FROM League;


UPDATE Player SET Salary = (?)
                WHERE PlayerName = (?);


SELECT PlayerName, Salary, Position, TeamName FROM Player WHERE PlayerName = (?);


SELECT PlayerName, Salary FROM Player;