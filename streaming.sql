CREATE TABLE Usuarios (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    contraseña VARCHAR(100) NOT NULL,
    pais VARCHAR(50),
    fecha_registro DATE NOT NULL
);

CREATE TABLE Suscripciones (
    id SERIAL PRIMARY KEY,
    tipo VARCHAR(50) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    usuario_id INTEGER NOT NULL REFERENCES Usuarios(id)
);

CREATE TABLE Categorias (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE Contenidos (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    tipo VARCHAR(50), -- película, serie, documental
    año INTEGER,
    duracion INTEGER, -- duración en minutos
    categoria_id INTEGER REFERENCES Categorias(id)
);

CREATE TABLE Reseñas (
    id SERIAL PRIMARY KEY,
    usuario_id INTEGER REFERENCES Usuarios(id),
    contenido_id INTEGER REFERENCES Contenidos(id),
    puntuacion INTEGER CHECK (puntuacion BETWEEN 1 AND 5),
    texto TEXT,
    fecha DATE DEFAULT CURRENT_DATE
);

CREATE TABLE Empleados (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    rol VARCHAR(50),
    fecha_ingreso DATE,
    email VARCHAR(100)
);

CREATE TABLE Plataformas (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    pais VARCHAR(50),
    disponibilidad BOOLEAN
);

CREATE TABLE Dispositivos (
    id SERIAL PRIMARY KEY,
    tipo_dispositivo VARCHAR(50), -- TV, móvil, PC, etc.
    sistema_operativo VARCHAR(50),
    usuario_id INTEGER REFERENCES Usuarios(id)
);

CREATE TABLE Favoritos (
    id SERIAL PRIMARY KEY,
    usuario_id INTEGER REFERENCES Usuarios(id),
    contenido_id INTEGER REFERENCES Contenidos(id),
    fecha_agregado DATE DEFAULT CURRENT_DATE
);

CREATE TABLE Historial (
    id SERIAL PRIMARY KEY,
    usuario_id INTEGER REFERENCES Usuarios(id),
    contenido_id INTEGER REFERENCES Contenidos(id),
    fecha_reproduccion DATE,
    minuto_final INTEGER
);
