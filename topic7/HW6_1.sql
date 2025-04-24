--CREATE INDEX MatchesCount ON Matches(matchid);
--CREATE INDEX PlayerIndex ON Player(playerid);
CREATE INDEX MatchIndex ON Matches(winnerID);
CREATE INDEX MatchPlayerOneIndex ON Matches(FK_playerOne);
CREATE INDEX MatchPlayerTwoIndex ON Matches(FK_playerTwo);
--CREATE INDEX RankingIndex ON Ranking(FK_playerid);