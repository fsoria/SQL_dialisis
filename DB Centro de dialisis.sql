-- ************************************
-- CREACION DE BASE DE DATOS
-- ************************************
CREATE DATABASE CentroDeDialisis;
USE CentroDeDialisis;

-- ************************************
-- CREACION DE TABLAS
-- ************************************
-- Tabla enfermeros (cada enfermero/a atiende a 4 pacientes por turno) --
CREATE TABLE Enfermero (
    ID_Enfermero INT AUTO_INCREMENT PRIMARY KEY,
    Nombre_y_Apellido VARCHAR(100) NOT NULL,
    Telefono VARCHAR(20),
    Email VARCHAR(100)
);

-- Agrego Matricula en la tabla de enfermeros --
ALTER TABLE Enfermero ADD COLUMN Matricula VARCHAR(10);

-- Tabla Paciente
CREATE TABLE Paciente (
    ID_Paciente INT AUTO_INCREMENT PRIMARY KEY,
    Nombre_y_Apellido VARCHAR(50) NOT NULL,
    Edad INT NOT NULL,
	ID_Enfermero INT NULL,
    FOREIGN KEY (ID_Enfermero) REFERENCES Enfermero(ID_Enfermero)
);

-- Agrego columna de obra social en la tabla paciente --
ALTER TABLE Paciente
ADD COLUMN Obra_Social VARCHAR(100);

-- Cambio del nombre de la columna Obra social por ID Obra social --
ALTER TABLE Paciente
CHANGE COLUMN Obra_Social ID_Obra_Social INT;



-- Tabla Medico
CREATE TABLE Medico (
    ID_Medico INT AUTO_INCREMENT PRIMARY KEY,
    Nombre_y_Apellido VARCHAR(50) NOT NULL,
    Edad INT NOT NULL,
    Matricula VARCHAR(20) UNIQUE NOT NULL
);

-- Tabla Tratamiento
CREATE TABLE Tratamiento (
    ID_Tratamiento INT AUTO_INCREMENT PRIMARY KEY,
    Tipo VARCHAR(50) NOT NULL,
    ID_Paciente INT NOT NULL,
    FOREIGN KEY (ID_Paciente) REFERENCES Paciente(ID_Paciente)
);

-- Tabla Turnos --
CREATE TABLE Turnos (
    ID_Turno INT AUTO_INCREMENT PRIMARY KEY,
    ID_Paciente INT NOT NULL,
	ID_Medico INT NOT NULL,
    Dias_Semana SET('Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado') NOT NULL,
    Horario TIME NOT NULL,
    Fecha_Turno DATE,
    FOREIGN KEY (ID_Paciente) REFERENCES Paciente(ID_Paciente),
    FOREIGN KEY (ID_Medico) REFERENCES Medico(ID_Medico),
    UNIQUE KEY (ID_Paciente, Horario)
);

-- Tabla de insumos medicos en stock --
CREATE TABLE Insumos (
    ID_Insumo INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Descripcion TEXT,
    Stock INT NOT NULL,
    Unidad ENUM('Unidades', 'Litros', 'Kg') NOT NULL
);

-- Tabla de insumos utilizados en la sesion de dialisis --
CREATE TABLE Insumo_Sala (
    ID_Insumo_Sala INT AUTO_INCREMENT PRIMARY KEY,
    ID_Turno INT NOT NULL,
    ID_Insumo INT NOT NULL,
    Cantidad INT NOT NULL,
    FOREIGN KEY (ID_Turno) REFERENCES Turnos(ID_Turno),
    FOREIGN KEY (ID_Insumo) REFERENCES Insumos(ID_Insumo)
);

-- Tabla de resultados de examenes de laboratorio --
CREATE TABLE Resultados_examenes (
    ID_Examen INT PRIMARY KEY AUTO_INCREMENT,
    ID_Paciente INT NOT NULL,
    examen ENUM('Hematocrito', 'Hemoglobina', 'Urea Pre', 'Urea Post', 'Calcio', 'Fosforo', 'Creatinina') NOT NULL,
    resultado DECIMAL(10, 2) NOT NULL,  
    fecha DATE NOT NULL,
    FOREIGN KEY (ID_Paciente) REFERENCES Paciente(ID_Paciente)
);

-- Tabla de inasistencias a la sesion de dialisis --
CREATE TABLE Inasistencias (
    ID_Inasistencia INT PRIMARY KEY AUTO_INCREMENT,
	ID_Paciente INT NOT NULL,
    fecha DATE NOT NULL,
    motivo VARCHAR(255),
	FOREIGN KEY (ID_Paciente) REFERENCES Paciente(ID_Paciente)
);

-- Tabla de medicacion que toma regularmente el paciente --
CREATE TABLE medicacion (
    ID_Medicacion INT PRIMARY KEY AUTO_INCREMENT,
    ID_Paciente INT NOT NULL,
    medicamento VARCHAR(255) NOT NULL,
    dosis VARCHAR(255) NOT NULL,
    frecuencia VARCHAR(255),
    fecha_inicio DATE,
    FOREIGN KEY (ID_Paciente) REFERENCES Paciente(ID_Paciente)
);

-- Tabla de obras sociales --
CREATE TABLE obras_sociales (
    ID_Obra_Social INT PRIMARY KEY AUTO_INCREMENT,
    razon_social VARCHAR(255) NOT NULL, 
    nombre_fantasia VARCHAR(255) NOT NULL,
    provincia VARCHAR(255),  
    telefono VARCHAR(20),  
    email VARCHAR(100) 
);


-- Tabla de Evoluciones Clínicas mensual --
CREATE TABLE evoluciones_clinicas (
    ID_Evolucion INT PRIMARY KEY AUTO_INCREMENT,
	ID_Paciente INT NOT NULL,
    ID_Medico INT NOT NULL,
    evolucion TEXT NOT NULL,
    fecha DATE NOT NULL,
    FOREIGN KEY (ID_Paciente) REFERENCES paciente(ID_Paciente),
    FOREIGN KEY (ID_Medico) REFERENCES Medico(ID_Medico)
);

-- Tabla de Proveedores de insumos medicos --
CREATE TABLE proveedores (
    ID_Proveedor INT PRIMARY KEY AUTO_INCREMENT,
    ID_Insumo INT NOT NULL,
    nombre_proveedor VARCHAR(255) NOT NULL,
    tipo_producto_servicio VARCHAR(255) NOT NULL,
    contacto VARCHAR(255),
    direccion VARCHAR(255),
    telefono VARCHAR(20),
    FOREIGN KEY (ID_Insumo) REFERENCES insumos(ID_Insumo)
);
























