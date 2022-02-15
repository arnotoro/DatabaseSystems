CREATE TABLE musicrecords (
	band VARCHAR (50),
	band_member  VARCHAR (50),
	member_instrument  VARCHAR (50),
	track  VARCHAR (50),
	track_duration  VARCHAR (50),
	album  VARCHAR (50),
	releaseYear INTEGER
);


CREATE VIEW View_1 AS
SELECT band, band_member, member_instrument FROM musicrecords
WHERE NOT NULL;