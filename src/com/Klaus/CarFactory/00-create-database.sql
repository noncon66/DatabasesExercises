DROP DATABASE IF EXISTS CarFactory;
CREATE DATABASE CarFactory;
USE CarFactory;
DROP TABLE IF EXISTS Car;
CREATE TABLE Car (
id int auto_increment primary key,
brand varchar(30) NOT NULL,
type varchar(50) NOT NULL
);
DROP TABLE IF EXISTS Engine;
CREATE TABLE Engine (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    type VARCHAR(50) NOT NULL,
    power INT
);

DROP TABLE IF EXISTS Car_Engine;
CREATE TABLE Car_Engine (
CarId int,
EngineId int,
primary key (CarId,EngineId),
foreign key (CarId) references Car(Id),
foreign key (EngineId) references Engine(Id)
);

create INDEX Car_Engine_I1
on Car_Engine (CarId);

create INDEX Car_Engine_I2
on Car_Engine (EngineId);
