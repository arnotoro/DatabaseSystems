CREATE TABLE Hashtag (
    HashtagID INT,
    Content VARCHAR(50),
    PRIMARY KEY (HashtagID)
);

CREATE TABLE User (
    UserID INT NOT NULL,
    Username VARCHAR(50),
    Verified VARCHAR(10),
    Followers INT,
    PRIMARY KEY (UserID)
);

CREATE TABLE Tweet (
    TweetID INT NOT NULL,
    UserID INT NOT NULL,
    Content VARCHAR(200),
    PRIMARY KEY (TweetID),
    FOREIGN KEY (UserID) REFERENCES User (UserID)
        ON DELETE CASCADE
);

CREATE TABLE Likes (
    LikeID INT NOT NULL,
    UserID INT NOT NULL,
    TweetID INT,
    CommentID INT,
    PRIMARY KEY (LikeID),
    FOREIGN KEY (UserID) REFERENCES User (UserID)
        ON DELETE CASCADE
    FOREIGN KEY (TweetID) REFERENCES Tweet (TweetID)
        ON DELETE CASCADE
    FOREIGN KEY (CommentID) REFERENCES Comments (CommentID)
        ON DELETE CASCADE
);

CREATE TABLE Comments (
    CommentID INT NOT NULL,
    UserID INT NOT NULL,
    Content varchar(200),
    TweetID INT,
    FK_CommentID INT,
    PRIMARY KEY (CommentID),
    FOREIGN KEY (TweetID) REFERENCES Tweet (TweetID)
        ON DELETE CASCADE
    FOREIGN KEY (FK_CommentID) REFERENCES Comments (CommentID)
        ON DELETE CASCADE
    FOREIGN KEY (UserID) REFERENCES User (UserID)
        ON DELETE CASCADE
);

CREATE TABLE HashtagsInContent (
    HashtagID INT NOT NULL,
    TweetID INT,
    CommentID INT,
    FOREIGN KEY (TweetID) REFERENCES Tweet (TweetID)
        ON DELETE CASCADE
    FOREIGN KEY (CommentID) REFERENCES Comments (CommentID)
        ON DELETE CASCADE
    FOREIGN KEY (HashtagID) REFERENCES Hashtag (HashtagID)
        ON DELETE CASCADE
);

INSERT INTO Hashtag (HashtagID, Content)
VALUES
(40001,'#win'),
(40002,'#friends'),
(40003,'#funny'),
(40004,'#giveaway'),
(40005,'#contest'),
(40006,'#thursdaythoughts'),
(40007,'#traveltuesday'),
(40008,'#science'),
(40009,'#fitness'),
(40010,'#goals');

INSERT INTO User (UserID, Username, Verified, Followers)
VALUES
(10001, 'MelonHusk', 'true', 22049),
(10002, 'DonaldDuck', 'true', 149195),
(10003, 'KamKirl', 'false', 207464),
(10004, 'JustForLaughs', 'true', 22019),
(10005, 'TheRock', 'false', 221749),
(10006, 'ReynoldsFan', 'false', 65449),
(10007, 'SkullPoopL', 'false', 6511789),
(10008, 'PingFinity', 'true', 5464198),
(10009, 'HugeAckman', 'false', 1981497),
(10010, 'SnakeShot', 'true', 47896);

INSERT INTO Tweet (TweetID, UserID, Content)
VALUES
(20001, 10002, 'Pretty sure that the world is just Duckburg'),
(20002, 10003, 'If you know what is good for you, you should do it.'),
(20003, 10004, 'Why the good die young and the bad go to hell?'),
(20004, 10005, 'Having snow in your shoe is as much fun as having warm beer.'),
(20005, 10007, 'Ice bucket challenge'),
(20006, 10008, 'Because science, right?'),
(20007, 10009, 'Did you know that the number of Nick Cage films correlate with drowning in pool?'),
(20008, 10001, 'Make sure you brush your hair before going to bed.'),
(20009, 10002, 'Bear, beer, beard, bird, turd. Bears are made of poop.'),
(20010, 10010, "Rock 'n roll all night long with your best friends!");

INSERT INTO Comments (CommentID, UserID, TweetID, FK_CommentID, Content)
VALUES
(30001, 10002, 20001, NULL, 'And Scrooge is the richest living being in the world.'),
(30002, 10003, 20002, NULL, "What if you don't know what is good for you? Do things to find out?"),
(30003, 10004, 20003, NULL, 'Because hell has to fill the torturer positions first.'),
(30004, 10006, 20004, NULL, 'Or as fun as making out with a pillow.'),
(30005, 10007, NULL, 30002, 'No no no, you ask from others what is good for them.'),
(30006, 10008, NULL, 30003, 'This sounds like the typical corporate ladder, where the first ones become executives and managers.'),
(30007, 10009, NULL, 30001, 'Does Mickey Mouse live in Duckburg or Mouseton?'),
(30008, 10008, NULL, 30002, "Or never do anything so you don't accidentally do anything bad."),
(30009, 10009, 20008, NULL, 'The new way to handle bedhair?'),
(30010, 10010, 20009, NULL, 'I think you dropped the last screw from your brain.');

INSERT INTO HashtagsInContent (HashtagID, TweetID, CommentID)
VALUES
(40001,20003,null),
(40002,20004,null),
(40003,20005,null),
(40004,20006,null),
(40005,null,30006),
(40006,null,30007),
(40007,null,30008),
(40008,null,30009),
(40009,null,30010),
(40010,20002,null),
(40003,20003,null),
(40004,null,30004),
(40005,20010,null),
(40006,20004,null),
(40008,null,30003),
(40009,null,30004),
(40010,null,30005);

INSERT INTO Likes (LikeID, UserID, TweetID, CommentID)
VALUES
(50001,10010,20003,null),
(50002,10008,20005,null),
(50003,10005,null,30005),
(50004,10010,null,30007),
(50005,10007,20010,null),
(50006,10001,null,30007),
(50007,10003,null,30003),
(50008,10005,20009,null),
(50009,10009,20010,null),
(50010,10010,20010,null);


CREATE VIEW Comments_of_comments AS
SELECT Username AS 'User', Content AS 'Comment', FK_CommentID AS 'Commented on' FROM User, Comments
WHERE Comments.UserID = User.UserID AND Comments.FK_CommentID NOT NULL
ORDER BY User.Username ASC;

CREATE TRIGGER hashtag_not_allowed BEFORE INSERT ON Hashtag
BEGIN
SELECT CASE
WHEN (NEW.Content) LIKE ('%mayonnaise%') THEN RAISE (ABORT, 'Mayonnaise detected!')
END;
END;

CREATE VIEW Tweets_and_tags AS
SELECT User.Username AS 'User', Tweet.Content AS 'Tweet',
CASE 
	WHEN (Hashtag.HashtagID = HashtagsInContent.HashtagID
	AND count(*) > 1) THEN
		group_concat(Hashtag.Content, '')
	WHEN (Hashtag.HashtagID = HashtagsInContent.HashtagID) THEN
		Hashtag.Content
	END 'Hashtag'
FROM HashtagsInContent
INNER JOIN User ON
	User.UserID = Tweet.UserID
INNER JOIN Tweet ON
	Tweet.TweetID = HashtagsInContent.TweetID
INNER JOIN Hashtag ON
	Hashtag.HashtagID = HashtagsInContent.HashtagID
GROUP BY User.Username;