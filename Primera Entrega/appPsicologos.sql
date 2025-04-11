CREATE TABLE Usuarios (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    contraseña VARCHAR(255) NOT NULL,
    pais VARCHAR(100) NOT NULL,
    rol ENUM('psicologo', 'paciente') NOT NULL
);

CREATE TABLE Psicologos (
    id_psicologo INT PRIMARY KEY AUTO_INCREMENT,
    usuario_id INT UNIQUE NOT NULL,
    especialidad VARCHAR(255) NOT NULL,
    contacto VARCHAR(255),
    educacion VARCHAR(255),
    profesion VARCHAR(255),
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE
);

CREATE TABLE Pacientes (
    id_paciente INT PRIMARY KEY AUTO_INCREMENT,
    usuario_id INT UNIQUE NOT NULL,
    genero VARCHAR(50),
    diagnostico TEXT,
    obra_social VARCHAR(255),
    valor_sesion DECIMAL(10,2),
    ingreso DATE,
    dni VARCHAR(20),
    cuil VARCHAR(20),
    telefono VARCHAR(50),
    fecha_nacimiento DATE,
    direccion VARCHAR(255),
    ciudad VARCHAR(100),
    provincia VARCHAR(100),
    pais VARCHAR(100),
    huso_horario VARCHAR(50),
    estado_civil VARCHAR(100),
    educacion VARCHAR(255),
    profesion VARCHAR(255),
    link_videollamada VARCHAR(255),
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE
);

CREATE TABLE Diagnosticos (
    id_diagnostico INT PRIMARY KEY AUTO_INCREMENT,
    paciente_id INT NOT NULL,
    contenido TEXT NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (paciente_id) REFERENCES Pacientes(id_paciente) ON DELETE CASCADE
);

CREATE TABLE Sesiones (
    id_sesion INT PRIMARY KEY AUTO_INCREMENT,
    paciente_id INT NOT NULL,
    psicologo_id INT NOT NULL,
    fecha DATETIME NOT NULL,
    costo DECIMAL(10,2) NOT NULL,
    estado_pago ENUM('pendiente', 'pagado') NOT NULL,
    FOREIGN KEY (paciente_id) REFERENCES Pacientes(id_paciente) ON DELETE CASCADE,
    FOREIGN KEY (psicologo_id) REFERENCES Psicologos(id_psicologo) ON DELETE CASCADE
);

CREATE TABLE Tests_Psicologicos (
    id_test INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    tipo_puntuacion ENUM('Escala Likert', 'Sí/No', 'Otro') NOT NULL,
    rango_min INT,
    rango_max INT
);

CREATE TABLE Evaluaciones (
    id_evaluacion INT PRIMARY KEY AUTO_INCREMENT,
    id_paciente INT NOT NULL,
    id_test INT NOT NULL,
    fecha_realizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    puntuacion_obtenida INT,
    interpretacion TEXT,
    FOREIGN KEY (id_paciente) REFERENCES Pacientes(id_paciente) ON DELETE CASCADE,
    FOREIGN KEY (id_test) REFERENCES Tests_Psicologicos(id_test) ON DELETE CASCADE
);

CREATE TABLE Historial_Evaluaciones (
    id_historial INT PRIMARY KEY AUTO_INCREMENT,
    id_evaluacion INT NOT NULL,
    pregunta TEXT,
    respuesta TEXT,
    FOREIGN KEY (id_evaluacion) REFERENCES Evaluaciones(id_evaluacion) ON DELETE CASCADE
);

CREATE TABLE Agenda (
    id_turno INT PRIMARY KEY AUTO_INCREMENT,
    psicologo_id INT NOT NULL,
    paciente_id INT NOT NULL,
    fecha DATETIME NOT NULL,
    estado ENUM('confirmado', 'cancelado', 'pendiente') NOT NULL,
    FOREIGN KEY (psicologo_id) REFERENCES Psicologos(id_psicologo) ON DELETE CASCADE,
    FOREIGN KEY (paciente_id) REFERENCES Pacientes(id_paciente) ON DELETE CASCADE
);

CREATE TABLE Medios_Pago (
    id_medio_pago INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(255) NOT NULL
);

CREATE TABLE Pagos (
    id_pago INT PRIMARY KEY AUTO_INCREMENT,
    sesion_id INT NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    metodo_pago_id INT NOT NULL,
    fecha DATETIME NOT NULL,
    FOREIGN KEY (sesion_id) REFERENCES Sesiones(id_sesion) ON DELETE CASCADE,
    FOREIGN KEY (metodo_pago_id) REFERENCES Medios_Pago(id_medio_pago) ON DELETE CASCADE
);

CREATE TABLE Obras_Sociales (
    id_obra_social INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(255) NOT NULL,
    contacto VARCHAR(255)
);

CREATE TABLE Consultorios (
    id_consultorio INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(255) NOT NULL,
    direccion VARCHAR(255) NOT NULL,
    telefono VARCHAR(20)
);

CREATE TABLE Evaluaciones (
    id_evaluacion INT PRIMARY KEY AUTO_INCREMENT,
    paciente_id INT NOT NULL,
    tipo_test ENUM('BAI', 'BDI-II', 'PSS', 'GAD-7', 'PHQ-9', 'OQ-45', 'LSAS') NOT NULL,
    resultado INT NOT NULL,
    fecha DATETIME NOT NULL,
    FOREIGN KEY (paciente_id) REFERENCES Pacientes(id_paciente) ON DELETE CASCADE
);

-- Relaciones Adicionales
ALTER TABLE Pacientes ADD COLUMN obra_social_id INT, ADD FOREIGN KEY (obra_social_id) REFERENCES Obras_Sociales(id_obra_social) ON DELETE SET NULL;
ALTER TABLE Sesiones ADD COLUMN consultorio_id INT, ADD FOREIGN KEY (consultorio_id) REFERENCES Consultorios(id_consultorio) ON DELETE SET NULL;
