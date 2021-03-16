SET SQL_SAFE_UPDATES=0;

use CarFactory;

delete from Car;
delete from Engine;
delete from Car_Engine;

insert into car (id, brand, type)
values 
(1, "VW", "Golf"),
(2, "VW", "Passat"),
(3, "Tesla", "X"),
(4, "Ferarri", "F40"),
(5, "Trabant", "601"),
(6, "Fiat", "500"),
(7, "Opel", "Concept HR");

insert into Engine (id, name, type, power)
values 
(1, "Brushless V1", "Elektro", 180),
(2, "TDI 5.0", "Diesel", 115),
(3, "V2", "Benzin 2-Takt", 45),
(4, "Sport V12", "Benzin", 420),
(5, "TFSI", "Benzin", 140),
(6, "CDI 1.8", "Diesel", 100),
(7, "Hamsterrad", "Hamster", null);

insert into Car_Engine (CarId, EngineId)
values
(1,2),
(1,5),
(2,2),
(2,5),
(3,1),
(4,4),
(5,3),
(6,5),
(6,6);


