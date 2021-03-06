use CarFactory;

-- 1. Liste aller Autos
SELECT * FROM Car;


-- 2. Liste aller Motoren
SELECT * FROM Engine;

-- 3. Liste aller Automarken
SELECT DISTINCT
    brand
FROM
    Car;

-- 4. Liste aller Ausführungen von Autos (Auto + Motor) (JOIN)
SELECT 
    CONCAT(Car.brand, ' ', Car.type) AS Car,
    Engine.name AS EngineName,
    Engine.type AS EngineType,
    Engine.power
FROM
    Car_Engine
        JOIN
    Car ON Car.id = Car_Engine.CarId
        JOIN
    Engine ON Engine.id = Car_Engine.EngineId;

-- 5. Liste aller Autos inklusive ihrer Ausführungen (auch wenn sie keinen Motor haben) (OUTER JOIN)
SELECT 
    CONCAT(Car.brand, ' ', Car.type) AS Car,
    Engine.name AS EngineName,
    Engine.type AS EngineType,
    Engine.power
FROM
    Car
        LEFT OUTER JOIN
    car_engine ON Car_Engine.CarId = Car.id
        LEFT OUTER JOIN
    Engine ON Car_Engine.EngineId = Engine.id
;

-- 6. Liste aller Motoren mit Autos, auch wenn sie kein Auto haben (OUTER JOIN)
SELECT 
    CONCAT(Car.brand, ' ', Car.type) AS Car,
    Engine.name AS EngineName,
    Engine.type AS EngineType,
    Engine.power
FROM
    Engine
        LEFT OUTER JOIN
    car_engine ON Car_Engine.EngineId = Engine.id
        LEFT OUTER JOIN
    car ON Car_Engine.EngineId = car.id
;

-- 6a. V2
SELECT 
    
    Engine.name AS EngineName,
    Engine.type AS EngineType,
    Engine.power,
    CONCAT(Car.brand, ' ', Car.type) AS Car
FROM
    Car
        RIGHT OUTER JOIN
    car_engine ON Car_Engine.CarId = Car.id
        RIGHT OUTER JOIN
    Engine ON Car_Engine.EngineId = Engine.id
;

-- 7. Liste aller Motoren und Autos, egal ob die ein Motorr oder ein Auto haben (FULL OUTER JOIN)



