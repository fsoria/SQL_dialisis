-- ************************************
-- CREACION DE TRIGGER
-- ************************************

-- Trigger para evitar que se eliminen turnos pasados que ya forman parte de la historia clinica del paciente --
DELIMITER //
CREATE TRIGGER Evitar_Eliminar_Turno_Realizado
BEFORE DELETE ON Turnos
FOR EACH ROW
BEGIN
    IF OLD.Fecha_Turno < CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se pueden eliminar turnos pasados.';
    END IF;
END //
DELIMITER ;

-- Trigger para modificar el stock de insumos cuando se utilizan en la sesion de dialisis --
DELIMITER //
CREATE TRIGGER Actualizar_Stock_Insumo
AFTER INSERT ON Insumo_Sala
FOR EACH ROW
BEGIN
    UPDATE Insumos
    SET Stock = Stock - NEW.Cantidad
    WHERE ID_Insumo = NEW.ID_Insumo;
END //
DELIMITER ;
