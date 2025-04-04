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
    T.Dias_Semana,
    P.Nombre_y_Apellido AS Paciente,
    M.Nombre_y_Apellido AS Medico
FROM Turnos T
INNER JOIN Paciente P ON T.ID_Paciente = P.ID_Paciente
INNER JOIN Medico M ON T.ID_Medico = M.ID_Medico;

-- Vista de el/la enfermero/a asignado por paciente --
CREATE VIEW Vista_Pacientes_Enfermeros AS
SELECT 
    P.ID_Paciente,
    P.Nombre_y_Apellido AS Paciente,
    E.Nombre_y_Apellido AS Enfermero,
    E.Telefono,
    E.Email
FROM Paciente P
INNER JOIN Enfermero E ON P.ID_Enfermero = E.ID_Enfermero;

-- Vista de stock de insumos --
CREATE VIEW Vista_Insumos_Stock AS
SELECT 
    I.ID_Insumo,
    I.Nombre AS Insumo,
    I.Stock,
    I.Unidad
FROM Insumos I;

-- Vista de la obra social de cada paciente --
CREATE VIEW Vista_Pacientes_ObraSocial AS
SELECT p.ID_Paciente, p.Nombre_y_Apellido, p.Edad, p.Obra_Social
FROM Paciente p;

-- Vista de inansistencias de los pacientes --
CREATE VIEW Vista_Inasistencias AS
SELECT i.ID_Inasistencia, p.Nombre_y_Apellido AS Paciente, i.fecha, i.motivo
FROM Inasistencias i
JOIN Paciente p ON i.ID_Paciente = p.ID_Paciente;

-- Vista de los proveedores segun el insumo que venden --
CREATE VIEW Vista_Proveedores AS
SELECT pr.ID_Proveedor, pr.nombre_proveedor, pr.tipo_producto_servicio, 
       pr.contacto, i.Nombre AS Insumo
FROM Proveedores pr
JOIN Insumos i ON pr.ID_Insumo = i.ID_Insumo;


