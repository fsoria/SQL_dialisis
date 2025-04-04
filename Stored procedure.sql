-- ************************************
-- CREACION DE STORED PROCEDURE
-- ************************************

-- Stored procedure para realizar un cambio de tipo de tratamiento en el paciente (ej de Hemodialisis a Dialisis Peritoneal) --
DELIMITER //
CREATE PROCEDURE Cambiar_Tipo_Tratamiento(
    IN tratamiento_id INT,  
    IN nuevo_tipo VARCHAR(50)  
)
BEGIN
    UPDATE Tratamiento
    SET Tipo = nuevo_tipo
    WHERE ID_Tratamiento = tratamiento_id;  
END //
DELIMITER ;

-- Stored procedure para contar los turnos realizados por cada medico --
DELIMITER //
CREATE PROCEDURE Contar_Turnos_Por_Medico()
BEGIN
    SELECT M.ID_Medico, M.Nombre_y_Apellido, COUNT(T.ID_Turno) AS Total_Turnos
    FROM Medico M
    LEFT JOIN Turnos T ON M.ID_Medico = T.ID_Medico
    GROUP BY M.ID_Medico;
END //
DELIMITER ;

-- Stored procedure para asignar tratamientos a todos los pacientes--
DELIMITER //
CREATE PROCEDURE Asignar_Tratamientos_A_Todos()
BEGIN
    INSERT INTO Tratamiento (Tipo, ID_Paciente)
    SELECT 
        CASE WHEN MOD(ID_Paciente, 10) <= 5 THEN 'Hemodiálisis' 
             ELSE 'Diálisis Peritoneal' 
        END, 
        ID_Paciente
    FROM Paciente;
END //
DELIMITER ;


-- Stored procedure para asignar turnos fijos a todos los pacientes, quiere decir el turno trisemanal--
DELIMITER //
CREATE PROCEDURE Generar_Turnos_Fijos(IN semanas INT)
BEGIN
    DECLARE fecha_actual DATE DEFAULT CURDATE();
    DECLARE fecha_fin DATE DEFAULT DATE_ADD(fecha_actual, INTERVAL semanas WEEK);

    WHILE fecha_actual <= fecha_fin DO
        INSERT INTO Turnos (Dia, Horario, ID_Paciente, ID_Medico, Dias_Semana, Es_Fijo)
        SELECT fecha_actual, Horario, ID_Paciente, ID_Medico, DAYNAME(fecha_actual), TRUE
        FROM turnos
        JOIN Medico ON Medico.Especializacion = 'Nefrología';

        SET fecha_actual = DATE_ADD(fecha_actual, INTERVAL 1 DAY);
    END WHILE;
END //
DELIMITER ;

-- Stored procedure para insertar una inasistencia a un paciente --
DELIMITER //
CREATE PROCEDURE Registrar_Inasistencia(
    IN paciente_id INT,
    IN turno_id INT,
    IN motivo VARCHAR(255)
)
BEGIN
    INSERT INTO Inasistencias (ID_Paciente, ID_Turno, Fecha, Motivo)
    VALUES (paciente_id, turno_id, CURDATE(), motivo);
END //
DELIMITER ;


