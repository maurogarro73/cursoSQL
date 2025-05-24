
-- Inserción de medios de pago
INSERT INTO Medios_Pago (id_medio_pago, nombre) VALUES (1, 'Efectivo');

-- Inserción de usuarios
INSERT INTO Usuarios (id_usuario, nombre, email, contraseña, pais, rol)
VALUES 
(1, 'Dra. Ana Freud', 'ana@psico.com', '123456', 'Argentina', 'psicologo'),
(2, 'Carlos López', 'carlos@paciente.com', '123456', 'Argentina', 'paciente');

-- Inserción de psicólogo y paciente
INSERT INTO Psicologos (id_psicologo, usuario_id, especialidad, contacto, educacion, profesion)
VALUES (1, 1, 'Cognitivo Conductual', '1122334455', 'UBA', 'Psicólogo');

INSERT INTO Pacientes (id_paciente, usuario_id, genero, valor_sesion, ingreso, dni, cuil, telefono, fecha_nacimiento, direccion, ciudad, provincia, pais, estado_civil, educacion, profesion, link_videollamada)
VALUES (1, 2, 'Masculino', 4000.00, CURDATE(), '12345678', '20-12345678-9', '1122334455', '1990-05-10', 'Calle Falsa 123', 'La Plata', 'Buenos Aires', 'Argentina', 'Soltero', 'Secundario', 'Empleado', 'https://meet.com/carlos');

-- Inserción de sesión
INSERT INTO Sesiones (id_sesion, paciente_id, psicologo_id, fecha, costo, estado_pago)
VALUES (1, 1, 1, NOW(), 4000.00, 'pendiente');

-- Inserción de evaluación
INSERT INTO Evaluaciones (id_evaluacion, paciente_id, tipo_test, resultado, fecha)
VALUES (1, 1, 'BAI', 28, NOW());
