-- ************************************
-- INSERCION DE DATOS 
-- ************************************

-- Enfermero
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/enfermero.csv'
INTO TABLE Enfermero
FIELDS TERMINATED BY ';' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(ID_Enfermero, Nombre_y_Apellido, Telefono, Email, Matricula);


-- Medico
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/medico.csv'
INTO TABLE Medico
FIELDS TERMINATED BY ';' ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(ID_Medico, Nombre_y_Apellido, Edad, Matricula);

-- Paciente
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/paciente.csv'
INTO TABLE Paciente
FIELDS TERMINATED BY ';' ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(ID_Paciente, Nombre_y_Apellido, Edad, ID_Enfermero, Obra_Social);

-- Tratamiento
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/tratamiento.csv'
INTO TABLE Tratamiento
FIELDS TERMINATED BY ';' ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(ID_Tratamiento, Tipo, ID_Paciente);

-- Obras Sociales
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Obras_Sociales.csv'
INTO TABLE obras_sociales
FIELDS TERMINATED BY ';' ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(ID_Obra_Social, razon_social, nombre_fantasia, provincia, telefono, email);


-- Insumos
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/insumos.csv'
INTO TABLE Insumos
FIELDS TERMINATED BY ';' ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(ID_Insumo, Nombre, Descripcion, Stock, Unidad);

-- Medicacion
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/medicacion.csv'
INTO TABLE medicacion
FIELDS TERMINATED BY ';' ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(ID_Medicacion, ID_Paciente, medicamento, dosis, frecuencia, fecha_inicio);

-- Inasistencias
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/inasistencias.csv'
INTO TABLE Inasistencias
FIELDS TERMINATED BY ';' ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(ID_Inasistencia, ID_Paciente, fecha, motivo);

-- Resultados Examenes
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Resultados_examenes.csv'
INTO TABLE Resultados_examenes
FIELDS TERMINATED BY ';' ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(ID_Examen, ID_Paciente, examen, resultado, fecha);

-- Evoluciones Clínicas
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Evoluciones_clinicas.csv'
INTO TABLE evoluciones_clinicas
FIELDS TERMINATED BY ';' ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(ID_Evolucion, ID_Paciente, ID_Medico, evolucion, fecha);

-- Proveedores
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/proveedores.csv'
INTO TABLE proveedores
FIELDS TERMINATED BY ';' ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(ID_Proveedor, ID_Insumo, nombre_proveedor, tipo_producto_servicio, contacto, direccion, telefono);

-- Asignar tratamientos --
CALL Asignar_Tratamientos_A_Todos();

-- Dividimos los 60 pacientes en dos grupos de 30 pacientes --

-- Grupo Martes, Jueves, Sábado: Turno 7:00 a 12:00 (primeros 10 pacientes) con Médico 1
INSERT INTO turnos (ID_Paciente, Dias_Semana, Horario, ID_Medico)
SELECT ID_Paciente, 'Martes,Jueves,Sábado', '07:00:00', 1
FROM Paciente
WHERE ID_Paciente BETWEEN 1 AND 10;

-- Grupo Martes, Jueves, Sábado: Turno 12:00 a 17:00 (pacientes 11-20) con Médico 2
INSERT INTO turnos (ID_Paciente, Dias_Semana, Horario, ID_Medico)
SELECT ID_Paciente, 'Martes,Jueves,Sábado', '12:00:00', 2
FROM Paciente
WHERE ID_Paciente BETWEEN 11 AND 20;

-- Grupo Martes, Jueves, Sábado: Turno 17:00 a 22:00 (pacientes 21-30) con Médico 3
INSERT INTO turnos (ID_Paciente, Dias_Semana, Horario, ID_Medico)
SELECT ID_Paciente, 'Martes,Jueves,Sábado', '17:00:00', 3
FROM Paciente
WHERE ID_Paciente BETWEEN 21 AND 30;

-- Grupo Lunes, Miércoles, Viernes: Turno 7:00 a 12:00 (pacientes 31-40) con Médico 4
INSERT INTO turnos (ID_Paciente, Dias_Semana, Horario, ID_Medico)
SELECT ID_Paciente, 'Lunes,Miércoles,Viernes', '07:00:00', 4
FROM Paciente
WHERE ID_Paciente BETWEEN 31 AND 40;

-- Grupo Lunes, Miércoles, Viernes: Turno 12:00 a 17:00 (pacientes 41-50) con Médico 5
INSERT INTO turnos (ID_Paciente, Dias_Semana, Horario, ID_Medico)
SELECT ID_Paciente, 'Lunes,Miércoles,Viernes', '12:00:00', 5
FROM Paciente
WHERE ID_Paciente BETWEEN 41 AND 50;

-- Grupo Lunes, Miércoles, Viernes: Turno 17:00 a 22:00 (pacientes 51-60) con Médico 6
INSERT INTO turnos (ID_Paciente, Dias_Semana, Horario, ID_Medico)
SELECT ID_Paciente, 'Lunes,Miércoles,Viernes', '17:00:00', 6
FROM Paciente
WHERE ID_Paciente BETWEEN 51 AND 60;





