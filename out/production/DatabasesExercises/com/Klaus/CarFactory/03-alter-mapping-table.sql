
USE CarFactory;


ALTER TABLE Car_Engine
ADD COLUMN assembly_days int;

UPDATE Car_Engine 
SET assembly_days = 3
WHERE EngineId IN (3,4,5);

UPDATE Car_Engine 
SET assembly_days = 1
WHERE EngineId IN (1);

UPDATE Car_Engine 
SET assembly_days = 4
WHERE EngineId IN (2,6);

ALTER TABLE Car_Engine
MODIFY assembly_days int NOT NULL;
 
SELECT * FROM Car_Engine;
 