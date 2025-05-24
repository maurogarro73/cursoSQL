
-- ==========================
-- VISTAS
-- ==========================

-- Vista 1: Total de sesiones por psicólogo
CREATE VIEW vista_sesiones_por_psicologo AS
SELECT 
    p.id_psicologo,
    u.nombre AS nombre_psicologo,
    COUNT(s.id_sesion) AS cantidad_sesiones,
    SUM(s.costo) AS total_facturado
FROM Psicologos p
JOIN Usuarios u ON p.usuario_id = u.id_usuario
JOIN Sesiones s ON p.id_psicologo = s.psicologo_id
GROUP BY p.id_psicologo, u.nombre;

-- Vista 2: Estado de pagos por paciente
CREATE VIEW vista_pagos_por_estado AS
SELECT 
    pa.id_paciente,
    u.nombre AS nombre_paciente,
    s.estado_pago,
    COUNT(*) AS cantidad_sesiones,
    SUM(s.costo) AS monto_total
FROM Pacientes pa
JOIN Usuarios u ON pa.usuario_id = u.id_usuario
JOIN Sesiones s ON pa.id_paciente = s.paciente_id
GROUP BY pa.id_paciente, u.nombre, s.estado_pago;

-- Vista 3: Evaluaciones recientes (últimos 30 días)
CREATE VIEW vista_evaluaciones_recientes AS
SELECT 
    e.id_evaluacion,
    e.paciente_id,
    u.nombre AS nombre_paciente,
    e.tipo_test,
    e.resultado,
    e.fecha
FROM Evaluaciones e
JOIN Pacientes p ON e.paciente_id = p.id_paciente
JOIN Usuarios u ON p.usuario_id = u.id_usuario
WHERE e.fecha >= NOW() - INTERVAL 30 DAY;

-- ==========================
-- FUNCIONES
-- ==========================

-- Función: Total facturado por psicólogo
DELIMITER $$
CREATE FUNCTION f_total_facturado_por_psicologo(id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    SELECT SUM(costo) INTO total
    FROM Sesiones
    WHERE psicologo_id = id;
    RETURN IFNULL(total, 0.00);
END $$
DELIMITER ;

-- ==========================
-- STORED PROCEDURES
-- ==========================

-- Procedure: Registrar sesión con estado pendiente
DELIMITER $$
CREATE PROCEDURE sp_registrar_sesion(
    IN p_paciente_id INT,
    IN p_psicologo_id INT,
    IN p_fecha DATETIME,
    IN p_costo DECIMAL(10,2)
)
BEGIN
    INSERT INTO Sesiones(paciente_id, psicologo_id, fecha, costo, estado_pago)
    VALUES(p_paciente_id, p_psicologo_id, p_fecha, p_costo, 'pendiente');
END $$
DELIMITER ;

-- Procedure: Eliminar paciente y todo su historial
DELIMITER $$
CREATE PROCEDURE sp_eliminar_paciente(IN p_id INT)
BEGIN
    DELETE FROM Pacientes WHERE id_paciente = p_id;
END $$
DELIMITER ;

-- ==========================
-- TRIGGERS
-- ==========================

-- Trigger: Registrar pago automáticamente al marcar como pagado
DELIMITER $$
CREATE TRIGGER tr_auto_pago
AFTER UPDATE ON Sesiones
FOR EACH ROW
BEGIN
    IF NEW.estado_pago = 'pagado' AND OLD.estado_pago != 'pagado' THEN
        INSERT INTO Pagos(sesion_id, monto, metodo_pago_id, fecha)
        VALUES(NEW.id_sesion, NEW.costo, 1, NOW());
    END IF;
END $$
DELIMITER ;
