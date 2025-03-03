-- ************************************
-- CREACION DE BASE DE DATOS
-- ************************************
CREATE DATABASE CentroDialisis;
USE CentroDialisis;


-- ************************************
-- CREACION DE TABLAS
-- ************************************
-- Tabla: Paciente --
CREATE TABLE Paciente (
    ID_Paciente INT AUTO_INCREMENT PRIMARY KEY,
    Nombre_y_Apellido VARCHAR(50) NOT NULL,
    Edad INT NOT NULL
);

-- Tabla: Medico --
CREATE TABLE Medico (
    ID_Medico INT AUTO_INCREMENT PRIMARY KEY,
    Nombre_y_Apellido VARCHAR(50) NOT NULL,
    Especializacion VARCHAR(50)
);

-- Tabla: Tratamiento --
CREATE TABLE Tratamiento (
    ID_Tratamiento INT AUTO_INCREMENT PRIMARY KEY,
    Tipo VARCHAR(50) NOT NULL,
    ID_Paciente INT NOT NULL,
    FOREIGN KEY (ID_Paciente) REFERENCES Paciente(ID_Paciente)
);

-- Tabla: Turnos --
CREATE TABLE Turnos (
    ID_Turno INT AUTO_INCREMENT PRIMARY KEY,
    Horario TIME NOT NULL,
    Dia DATE NOT NULL,
    ID_Paciente INT NOT NULL,
    ID_Medico INT NOT NULL,
    FOREIGN KEY (ID_Paciente) REFERENCES Paciente(ID_Paciente),
    FOREIGN KEY (ID_Medico) REFERENCES Medico(ID_Medico)
);


-- ************************************
-- CREACION DE VISTAS
-- ************************************
-- Vista de cada tratamiento segun el paciente --
CREATE VIEW Vista_Pacientes_Tratamientos AS
SELECT 
    P.ID_Paciente,
    P.Nombre_y_Apellido AS Paciente,
    T.Tipo AS Tratamiento
FROM Paciente P
INNER JOIN Tratamiento T ON P.ID_Paciente = T.ID_Paciente;

-- Vista de cada turno segun paciente  --
CREATE VIEW Vista_Turnos_Programados AS
SELECT 
    T.ID_Turno,
    T.Horario,
    T.Dia,
    P.Nombre_y_Apellido AS Paciente,
    M.Nombre_y_Apellido AS Medico
FROM Turnos T
INNER JOIN Paciente P ON T.ID_Paciente = P.ID_Paciente
INNER JOIN Medico M ON T.ID_Medico = M.ID_Medico;


-- ************************************
-- CREACION DE FUNCIONES
-- ************************************
-- Funcion medico encargado del turno --
DELIMITER //
CREATE FUNCTION Obtener_Medico_Encargado(turno_id INT) 
RETURNS VARCHAR(50)
READS SQL DATA
BEGIN
    DECLARE nombre_medico VARCHAR(50);
    -- Busca el nombre del médico asignado al turno
    SELECT M.Nombre_y_Apellido INTO nombre_medico
    FROM Turnos T
    INNER JOIN Medico M ON T.ID_Medico = M.ID_Medico
    WHERE T.ID_Turno = turno_id;
    -- Devuelve el nombre del médico
    RETURN nombre_medico;
END //
DELIMITER ;


-- Funcion para saber cuantos turnos de dialisis se realizo el paciente por mes --
DELIMITER //
CREATE FUNCTION Contar_Turnos_Dialisis_Por_Mes(paciente_id INT, mes INT, anio INT) 
RETURNS INT DETERMINISTIC
BEGIN
    DECLARE total_turnos INT;
    
    SELECT COUNT(*) INTO total_turnos
    FROM Turnos T
    WHERE T.ID_Paciente = paciente_id
    AND MONTH(T.Dia) = mes    
    AND YEAR(T.Dia) = anio;   
    RETURN total_turnos;
END //
DELIMITER ;


-- ************************************
-- CREACION DE STORED PROCEDURE
-- ************************************

-- Stored procedure para realizar un cambio de tipo de tratamiento en el paciente (ej de Hemodialisis a Dialisis Peritoneal) --
DELIMITER //
CREATE PROCEDURE Cambiar_Tipo_Tratamiento(
    IN tratamiento_id INT,  -- ID del tratamiento a modificar
    IN nuevo_tipo VARCHAR(50)  -- Tipo de tratamiento nuevo
)
BEGIN
    UPDATE Tratamiento
    SET Tipo = nuevo_tipo
    WHERE ID_Tratamiento = tratamiento_id;  -- Actualiza solo el tratamiento específico
END //
DELIMITER ;


-- Stored procedure para contar los turnos realizados por cada medico --
DELIMITER //
CREATE PROCEDURE Contar_Turnos_Por_Medico()
BEGIN
    SELECT 
        M.ID_Medico,
        M.Nombre_y_Apellido AS Medico,
        COUNT(T.ID_Turno) AS Total_Turnos
    FROM Medico M
    LEFT JOIN Turnos T ON M.ID_Medico = T.ID_Medico
    GROUP BY M.ID_Medico, M.Nombre_y_Apellido;
END //
DELIMITER ;



-- ************************************
-- CREACION DE TRIGGER (PARA REVISION, CREO QUE DEBO CREAR UNA TABLA DE SILLONES)
-- ************************************

-- Trigger que realiza una validacion de disponibilidad de sillones para asignar un turno--
DELIMITER //
CREATE TRIGGER Turnos_verificacion_disponibilidad
BEFORE INSERT ON Turnos
FOR EACH ROW
BEGIN
    DECLARE turnos_disponibles INT;
    -- Verificar los turnos disponibles
    SET turnos_disponibles = Turnos_Disponibles(NEW.Dia, NEW.Horario);
    -- Si no hay sillones disponibles, cancelar la inserción
    IF turnos_disponibles <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No hay sillones disponibles en este horario.';
    END IF;
END //
DELIMITER ;



-- ************************************
-- INSERCION DE DATOS
-- ************************************

-- Insercion de pacientes--
INSERT INTO Paciente (Nombre_y_Apellido, Edad) VALUES
('Juan Pérez', 35), ('María Gómez', 40), ('Carlos López', 45), ('Ana Martínez', 50), ('Luis García', 55),
('Sofía Fernández', 60), ('Pedro Sánchez', 65), ('Laura Rodríguez', 30), ('Diego González', 33), ('Carmen Díaz', 37),
('Javier Ruiz', 42), ('Isabel Hernández', 47), ('Miguel Torres', 52), ('Elena Ramírez', 57), ('Francisco Flores', 62),
('Lucía Álvarez', 67), ('Daniel Romero', 70), ('Paula Moreno', 32), ('Alejandro Jiménez', 36), ('Sara Castro', 41),
('Raúl Ortega', 46), ('Marta Navarro', 51), ('Roberto Molina', 56), ('Patricia Delgado', 61), ('Jorge Vargas', 66),
('Natalia Cabrera', 31), ('Andrés Guerrero', 34), ('Clara Marín', 38), ('Rubén Peña', 43), ('Eva Rojas', 48);


-- Insercion de medicos --
INSERT INTO Medico (Nombre_y_Apellido, Especializacion) VALUES
('Dr. Carlos López', 'Clínico'), ('Dra. Ana Martínez', 'Clínico'), ('Dr. Luis García', 'Clínico'),
('Dra. Sofía Fernández', 'Nefrología'), ('Dr. Pedro Sánchez', 'Nefrología');

-- Insercion tratamientos --
DELIMITER //
CREATE PROCEDURE Asignar_Tratamientos_A_Todos()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE total_pacientes INT;
    
    -- Obtener el número total de pacientes
    SELECT COUNT(*) INTO total_pacientes FROM Paciente;
    
    -- Asignar tratamientos a todos los pacientes
    WHILE i <= total_pacientes DO
        IF i % 10 <= 5 THEN
            INSERT INTO Tratamiento (Tipo, ID_Paciente) VALUES ('Hemodiálisis', i);
        ELSE
            INSERT INTO Tratamiento (Tipo, ID_Paciente) VALUES ('Diálisis Peritoneal', i);
        END IF;
        SET i = i + 1;
    END WHILE;
END //
DELIMITER ;

-- Ejecutar el stored procedure
CALL Asignar_Tratamientos_A_Todos();


-- Insertar turnos --
DELIMITER //

CREATE PROCEDURE Insertar_Turnos()
BEGIN
    DECLARE fecha_actual DATE;
    DECLARE paciente INT;
    DECLARE medico INT;
    DECLARE horario TIME;
    DECLARE horario_index INT;
    
    SET fecha_actual = '2024-03-01';

    turnos_loop: LOOP
        -- Si la fecha supera el límite, salir del loop
        IF fecha_actual > '2024-05-31' THEN
            LEAVE turnos_loop;
        END IF;

        -- Verificar si el día es Lunes, Miércoles o Viernes
        IF DAYOFWEEK(fecha_actual) IN (2, 4, 6) THEN
            SET paciente = 1;  -- Pacientes 1-15 en Lunes, Miércoles y Viernes
        -- Verificar si el día es Martes, Jueves o Sábado
        ELSEIF DAYOFWEEK(fecha_actual) IN (3, 5, 7) THEN
            SET paciente = 16; -- Pacientes 16-30 en Martes, Jueves y Sábados
        ELSE
            -- Avanzar al siguiente día y continuar
            SET fecha_actual = DATE_ADD(fecha_actual, INTERVAL 1 DAY);
            ITERATE turnos_loop;
        END IF;

        -- Insertar turnos en los tres horarios
        SET horario_index = 0;
        horarios_loop: LOOP
            IF horario_index >= 3 THEN
                LEAVE horarios_loop;
            END IF;

            CASE horario_index
                WHEN 0 THEN SET horario = '07:00:00';
                WHEN 1 THEN SET horario = '12:00:00';
                WHEN 2 THEN SET horario = '17:00:00';
            END CASE;
            -- Insertar turnos para 15 pacientes por cada tipo de día
            pacientes_loop: LOOP
                IF paciente > 30 THEN
                    LEAVE pacientes_loop;
                END IF;
                SET medico = (paciente MOD 5) + 1; -- Asignar médicos rotativamente
                INSERT INTO Turnos (Horario, Dia, ID_Paciente, ID_Medico)
                VALUES (horario, fecha_actual, paciente, medico);
                SET paciente = paciente + 1;

                -- Si llegó a 16, significa que cambiamos de grupo de días
                IF paciente = 16 THEN
                    LEAVE pacientes_loop;
                END IF;
            END LOOP pacientes_loop;
            -- Siguiente horario
            SET horario_index = horario_index + 1;
        END LOOP horarios_loop;
        -- Avanzar al siguiente día
        SET fecha_actual = DATE_ADD(fecha_actual, INTERVAL 1 DAY);
    END LOOP turnos_loop;
END //

DELIMITER ;

-- Ejecutar el procedimiento para insertar los turnos
CALL Insertar_Turnos();

-- ****************************************************
-- COMPROBACION DE VISTAS, FUNCIONES Y STORED PROCEDURE
-- ****************************************************

SELECT * FROM Vista_Pacientes_Tratamientos;

SELECT * FROM Vista_Turnos_Programados;

SELECT Obtener_Medico_Encargado(2) AS Medico_Encargado;

SELECT Contar_Turnos_Dialisis_Por_Mes(15, 10, 2023) AS Turnos_Dialisis_Octubre_2023;

CALL Cambiar_Tipo_Tratamiento(1, 'Hemodiálisis');

SELECT * FROM Tratamiento WHERE ID_Paciente = 1;

CALL Contar_Turnos_Por_Medico();


-- Trigger para revision --
INSERT INTO Turnos (Horario, Dia, ID_Paciente, ID_Medico)
VALUES ('07:00:00', '2023-10-09', 1, 1);

-- Supongamos que ya hay 10 turnos en el mismo horario y día
INSERT INTO Turnos (Horario, Dia, ID_Paciente, ID_Medico)
VALUES ('07:00:00', '2023-10-09', 2, 2);










