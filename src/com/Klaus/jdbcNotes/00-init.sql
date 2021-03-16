DROP DATABASE IF EXISTS Notes;
CREATE DATABASE Notes;
USE Notes;

DROP TABLE IF EXISTS Users;
CREATE TABLE Users (
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(500) NOT NULL);

INSERT INTO Users (name)
VALUES ("Hans"),
("Karl"), ("Otto");

SELECT * FROM Users;

DROP TABLE IF EXISTS Notes;
CREATE TABLE Notes (
	id INT AUTO_INCREMENT PRIMARY KEY,
    text VARCHAR(500) NOT NULL,
    created TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    user int,
    FOREIGN KEY (user) REFERENCES Users(id)
);

INSERT INTO Notes (text, user)
VALUES ("my first comment", 1);

INSERT INTO Notes (text, user)
VALUES ("wow it works!", 3);

SELECT *
FROM Notes
ORDER BY created DESC;
