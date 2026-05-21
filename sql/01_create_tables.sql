-- ============================================================
-- Bootcamp School Database - DDL v3
-- Cambios respecto a v2:
--   · Sin cambios de esquema; v3 es la versión canónica alineada
--     con generate_inserts.ipynb (grupos con modalidad, sin
--     modalidad_id en profesor_grupo)
-- ============================================================

CREATE TABLE campus (
    campus_id SERIAL PRIMARY KEY,
    campus    VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE vertical (
    vertical_id SERIAL PRIMARY KEY,
    vertical    VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE promocion (
    promocion_id SERIAL PRIMARY KEY,
    nombre       VARCHAR(100) NOT NULL,
    anio         INT          NOT NULL,
    UNIQUE (nombre, anio)
);

CREATE TABLE modalidad (
    modalidad_id SERIAL PRIMARY KEY,
    modalidad    VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE rol (
    rol_id SERIAL PRIMARY KEY,
    rol    VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE proyecto_tipo (
    proyecto_tipo_id SERIAL PRIMARY KEY,
    proyecto         VARCHAR(100) NOT NULL,
    vertical_id      INT          NOT NULL REFERENCES vertical(vertical_id),
    UNIQUE (proyecto, vertical_id)
);

-- grupo: cohorte concreta = campus + vertical + promoción + modalidad
CREATE TABLE grupo (
    grupo_id     SERIAL PRIMARY KEY,
    campus_id    INT  NOT NULL REFERENCES campus(campus_id),
    vertical_id  INT  NOT NULL REFERENCES vertical(vertical_id),
    promocion_id INT  NOT NULL REFERENCES promocion(promocion_id),
    modalidad_id INT  NOT NULL REFERENCES modalidad(modalidad_id),
    fecha_inicio DATE NOT NULL,
    UNIQUE (campus_id, vertical_id, promocion_id, modalidad_id)
);

CREATE TABLE estudiante (
    estudiante_id SERIAL PRIMARY KEY,
    nombre        VARCHAR(200) NOT NULL,
    email         VARCHAR(200) NOT NULL UNIQUE,
    grupo_id      INT          NOT NULL REFERENCES grupo(grupo_id)
);

CREATE TABLE calificacion (
    calificacion_id  SERIAL PRIMARY KEY,
    estudiante_id    INT         NOT NULL REFERENCES estudiante(estudiante_id),
    proyecto_tipo_id INT         NOT NULL REFERENCES proyecto_tipo(proyecto_tipo_id),
    resultado        VARCHAR(20) NOT NULL CHECK (resultado IN ('Apto', 'No Apto')),
    UNIQUE (estudiante_id, proyecto_tipo_id)
);

CREATE TABLE profesor (
    profesor_id SERIAL PRIMARY KEY,
    nombre      VARCHAR(200) NOT NULL,
    rol_id      INT          NOT NULL REFERENCES rol(rol_id)
);

-- profesor_grupo: qué profesor imparte en qué grupo
CREATE TABLE profesor_grupo (
    profesor_grupo_id SERIAL PRIMARY KEY,
    profesor_id       INT NOT NULL REFERENCES profesor(profesor_id),
    grupo_id          INT NOT NULL REFERENCES grupo(grupo_id),
    UNIQUE (profesor_id, grupo_id)
);
