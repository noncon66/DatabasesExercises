use CarFactory;

-- 1. wie viel Tage dauert die Produktion der 3 "stärksten" (meisten Leistung) Autos? 
SELECT SUM(assembly_days) AS TotalDays 
FROM 
(SELECT 
    Car_Engine.assembly_days
FROM
    Car_Engine
        JOIN
    Car ON Car.id = Car_Engine.CarId
        JOIN
    Engine ON Engine.id = Car_Engine.EngineId
ORDER BY power DESC
LIMIT 3) 
AS days;

/*
SELECT 
    Car_Engine.assembly_days
FROM
    Car_Engine
        JOIN
    Car ON Car.id = Car_Engine.CarId
        JOIN
    Engine ON Engine.id = Car_Engine.EngineId
ORDER BY power DESC
LIMIT 3;
*/


-- 2. Liste mit dem stärksten Auto pro Marke



SELECT Car.brand, Car.type, Engine.name, Engine.type, Engine.power
FROM
    Car_Engine
        JOIN
    Car ON Car.id = Car_Engine.CarId
        JOIN
    Engine ON Engine.id = Car_Engine.EngineId
JOIN (SELECT 
		Car.brand AS Brand, 
		MAX(Engine.power) AS maxPower
	FROM
    Car_Engine
        JOIN
    Car ON Car.id = Car_Engine.CarId
        JOIN
    Engine ON Engine.id = Car_Engine.EngineId
GROUP BY Brand) MaxPowerList ON Car.Brand =  MaxPowerList.Brand
WHERE Engine.power = MaxPowerList.maxPower; 
