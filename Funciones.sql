-- ************************************
-- CREACION DE FUNCIONES
-- ************************************
-- Funcion medico encargado del turno --
DELIMITER //
CREATE FUNCTION Obtener_Medico_Encargado(turno_id INT) 
RETURNS VARCHAR(50)
READS SQL DATA
BEGIN
    RETURN (SELECT Nombre_y_Apellido 
            FROM Medico 
            WHERE ID_Medico = (SELECT ID_Medico 
                               FROM Turnos 
                               WHERE ID_Turno = turno_id));
END //
DELIMITER ;

-- Funcion para saber cuantos turnos de dialisis se realizo el paciente por mes --
DELIMITER //
CREATE FUNCTION Contar_Turnos_Dialisis_Por_Mes(paciente_id INT, mes INT, año INT) 
RETURNS INT
READS SQL DATA
BEGIN
    RETURN (SELECT COUNT(*) 
            FROM Turnos 
            WHERE ID_Paciente = paciente_id
            AND MONTH(Dias_Semana) = mes    
            AND YEAR(Dias_Semana) = año);
END //
DELIMITER ;


-- Funcion para conocer los pacientes que atendio cada enfemero/a --
DELIMITER //
CREATE FUNCTION Obtener_Nombres_Pacientes_Por_Enfermero(enfermero_id INT) 
RETURNS TEXT
READS SQL DATA
BEGIN
    RETURN (SELECT GROUP_CONCAT(Nombre_y_Apellido ORDER BY Nombre_y_Apellido ASC) 
            FROM Paciente 
            WHERE ID_Enfermero = enfermero_id);
END //
DELIMITER ;


-- Funcion para veririficar el stock de un insumo en particular --
DELIMITER //
CREATE FUNCTION Verificar_Stock_Insumo(insumo_id INT) 
RETURNS INT
READS SQL DATA
BEGIN
    RETURN (SELECT Stock FROM Insumos WHERE ID_Insumo = insumo_id);
END //
DELIMITER ;

-- Funcion para sumar la cantidad de inasistencias de un paciente --
DELIMITER //
CREATE FUNCTION Contar_Inasistencias_Por_Año(paciente_id INT, año INT) 
RETURNS INT
READS SQL DATA
BEGIN
    RETURN (SELECT COUNT(*) 
            FROM inasistencias 
            WHERE ID_Paciente = paciente_id 
            AND YEAR(fecha) = año);
END //
DELIMITER ;

-- Funcion para ver la ultima evolucion medica de un paciente --
DELIMITER //
CREATE FUNCTION Ultima_Evolucion_Paciente(paciente_id INT) 
RETURNS TEXT
READS SQL DATA
BEGIN
    RETURN (SELECT evolucion 
            FROM evoluciones_clinicas 
            WHERE ID_Paciente = paciente_id 
            ORDER BY fecha DESC 
            LIMIT 1);
END //
DELIMITER ;

