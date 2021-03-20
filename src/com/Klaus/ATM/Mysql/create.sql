DROP DATABASE IF EXISTS atm;
CREATE DATABASE atm;
USE atm;

DROP TABLE IF EXISTS accounts;
CREATE TABLE accounts (
accountnumber INT PRIMARY KEY,
pinhash VARCHAR(256) NOT NULL);


INSERT INTO accounts (accountnumber, pinhash) VALUES 
(12345678, SHA2(1234,256)),
(87654321, SHA2(4321,256));

DROP TABLE IF EXISTS transactions;
CREATE TABLE transactions (
id INT auto_increment PRIMARY KEY,
executed TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
amount DOUBLE NOT NULL,
accountnumber INT NOT NULL,
FOREIGN KEY (accountnumber) REFERENCES accounts(accountnumber)
);

INSERT INTO transactions (amount, accountnumber) VALUES
(0, 12345678),
(0, 87654321)
;

SELECT * FROM accounts WHERE accountnumber = 12345678 AND pinhash = SHA2(1234,256);