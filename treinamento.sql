-- Qual a proporção de pacientes do gênero Masculino e Feminino
SELECT gender as "Gênero", count(patient_id) as "Quantidade"
FROM patient
GROUP BY gender;

-- Região com maiores quantidade de pacientes 
SELECT 
    state_code AS "Codigo de área", 
    COUNT(patient_id) AS "Quantidade de pacientes"
FROM patient
GROUP BY state_code;

-- 10 médicos com maiores números de consultas e suas especialidades
SELECT d.name AS "Nome",  s.name AS "Especialidade", COUNT(a.appointment_id) AS "Total de consultas"
FROM appointment a
INNER JOIN doctor d ON a.doctor_id = d.doctor_id
INNER JOIN speciality s ON s.speciality_id = d.speciality_id
GROUP BY d.name, s.name
ORDER BY "Total de consultas" DESC
LIMIT 10;

-- Quantos médicos existem por especialidade
SELECT COUNT(d.doctor_id) as "Quantidade", s.name as "Especialidade" 
FROM doctor d 
INNER JOIN speciality s ON s.speciality_id = d.speciality_id
WHERE d.speciality_id IS NOT NULL
GROUP BY s.speciality_id;

-- 5 Medicamentos mais recomendados pelos médicos
SELECT 
	m.name AS "Medicamentos", 
	COUNT(p.medication_id) AS "Quantidade"
FROM medication m
INNER JOIN prescription p ON p.medication_id = m.medication_id
INNER JOIN appointment a ON a.appointment_id = p.appointment_id
GROUP BY m.name
ORDER BY COUNT(p.medication_id) DESC
LIMIT 5;

-- Quais as datas da primeira e última consulta
SELECT 
    min(appointment_date) as "Primeira consulta",
	max(appointment_date) as "Última consulta "
FROM appointment;

-- Total de consultas canceladas e completas
SELECT 
	notes as "Consultas", 
    COUNT(CASE WHEN status = "Cancelled" THEN 1 ELSE NULL END) as "Quantidade cancelada",
    COUNT(CASE WHEN status = "completed" THEN 1 ELSE NULL END) as "Quantidade completa"
FROM appointment
GROUP BY notes;

-- Qual especialidade com maior índice de cancelamento 
SELECT DISTINCT
    s.name as "Specialidade",
    d.name as "Nome",
    a.Consultas as "Consultas",
    a.`Quantidade cancelada` as "Quantidade cancelada",
    a.`Quantidade completa` as "Quantidade completa"
FROM speciality s
LEFT JOIN doctor d ON d.speciality_id = s.speciality_id
LEFT JOIN (
    SELECT 
        a.doctor_id,
        COUNT(a.notes) as "Consultas",
        COUNT(CASE WHEN a.status = 'Cancelled' THEN 1 ELSE NULL END) as "Quantidade cancelada",
        COUNT(CASE WHEN a.status = 'completed' THEN 1 ELSE NULL END) as "Quantidade completa"
    FROM appointment a
    GROUP BY a.doctor_id
) a ON a.doctor_id = d.doctor_id;

-- Qual diagnóstico mais comum
SELECT 
	a.notes as "Diagnóstico",
    COUNT(*) as "Quantidade"
FROM appointment a 
GROUP BY a.notes
ORDER BY COUNT(*) DESC;

-- Qual paciente tem o maior número de consultas
SELECT DISTINCT p.name AS "Paciente",
       c.total_consultas AS "Número de consultas",
       a.notes AS "Consultas",
       d.name AS "Nome do Médico"
FROM patient p
LEFT JOIN (
    SELECT p.name, COUNT(*) AS total_consultas
    FROM patient p
    INNER JOIN appointment a ON p.patient_id = a.patient_id
    GROUP BY p.name
) AS c ON p.name = c.name
INNER JOIN appointment a ON p.patient_id = a.patient_id
INNER JOIN doctor d ON d.doctor_id = a.doctor_id
ORDER BY total_consultas DESC
LIMIT 3;

-- Explorar correlações entre diagnósticos e tratamentos.
SELECT 
		a.notes AS "Diagnóstico",
		m.name AS "Medicação",
        m.description as "Prescrição",
		COUNT(*) AS "Frequência"
FROM prescription p
INNER JOIN appointment a ON a.appointment_id = p.appointment_id
INNER JOIN medication m ON m.medication_id = p.medication_id
GROUP BY a.notes, m.name, m.description
ORDER BY "Frequencia" DESC;
 
-- Analisar os dados demográficos e as tendências de saúde dos pacientes.
SELECT p.state_code,
       a.notes
FROM appointment a
INNER JOIN patient p ON p.patient_id = a.patient_id;

-- Dias da semana com maior número de agendamentos
SELECT 
    DAYNAME(a.appointment_date) AS "Dia da Semana",
    COUNT(*) AS "Quantidade"
FROM appointment a
GROUP BY DAYNAME(a.appointment_date)
ORDER BY COUNT(*) DESC;

-- Meses com maior número de agendamentos
SELECT 
    MONTHNAME(a.appointment_date) AS "Mês",
    COUNT(*) AS "Quantidade"
FROM appointment a
GROUP BY MONTHNAME(a.appointment_date)
ORDER BY COUNT(*) DESC;

-- Horas com maior número de agendamentos
SELECT 
    EXTRACT(HOUR FROM a.appointment_date) AS "HORA",
    COUNT(*) AS "Quantidade"
FROM appointment a
GROUP BY EXTRACT(HOUR FROM a.appointment_date)
ORDER BY COUNT(*) DESC;

-- Horário médio de agendamentos
SELECT 
    AVG(EXTRACT(HOUR FROM a.appointment_date)) AS "Horário médio das consultas"
FROM appointment a;











