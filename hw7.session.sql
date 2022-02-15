CREATE INDEX MatchIndex ON Matches(winnerID);
CREATE INDEX MatchPlayerOneIndex ON Matches(FK_playerOne);
CREATE INDEX MatchPlayerTwoIndex ON Matches(FK_playerTwo);
CREATE INDEX PlayerIndex ON Player(playerid);
CREATE INDEX RankingIndex ON Ranking(FK_playerid);
CREATE INDEX NameIndex ON Player(first_name, last_name);



CREATE VIEW MatchesWithNames AS 
SELECT P1.first_name || ' ' || P1.last_name AS PlayerOne,
P2.first_name || ' ' || P2.last_name AS PlayerTwo, resultSets, matchdate, P3.first_name || ' ' || P3.last_name AS Winner
FROM Matches 
INNER JOIN Player P1 ON Matches.FK_playerOne = P1.playerid
INNER JOIN Player P2 ON Matches.FK_playerTwo = P2.playerid
INNER JOIN Player P3 ON Matches.winnerID= P3.playerid;

SELECT PlayerOne, PlayerTwo, resultSets, Winner, rank AS 'Winner rank', points AS 'Winner points', record AS 'Winner record' FROM MatchesWithNames 
INNER JOIN Player P1 ON (P1.first_name || ' ' || P1.last_name) = Winner
INNER JOIN Ranking ON P1.playerid = Ranking.FK_playerid
LIMIT 3500;



