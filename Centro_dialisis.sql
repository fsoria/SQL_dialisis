-- Creación de la base de datos
CREATE DATABASE CentroDialisis;
USE CentroDialisis;

-- Tabla: Paciente
CREATE TABLE Paciente (
    ID_Paciente INT AUTO_INCREMENT PRIMARY KEY,
    Nombre_y_Apellido VARCHAR(50) NOT NULL,
    Edad INT NOT NULL
);

-- Tabla: Medico
CREATE TABLE Medico (
    ID_Medico INT AUTO_INCREMENT PRIMARY KEY,
    Nombre_y_Apellido VARCHAR(50) NOT NULL,
    Especializacion VARCHAR(50)
);

-- Tabla: Tratamiento
CREATE TABLE Tratamiento (
    ID_Tratamiento INT AUTO_INCREMENT PRIMARY KEY,
    Tipo VARCHAR(50) NOT NULL,
    ID_Paciente INT NOT NULL,
    FOREIGN KEY (ID_Paciente) REFERENCES Paciente(ID_Paciente)
);

-- Tabla: Turnos
CREATE TABLE Turnos (
    ID_Turno INT AUTO_INCREMENT PRIMARY KEY,
    Horario TIME NOT NULL,
    Dia DATE NOT NULL,
    ID_Paciente INT NOT NULL,
    ID_Medico INT NOT NULL,
    FOREIGN KEY (ID_Paciente) REFERENCES Paciente(ID_Paciente),
    FOREIGN KEY (ID_Medico) REFERENCES Medico(ID_Medico)
);
