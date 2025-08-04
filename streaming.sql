--- EL problema que veo en el diseño de esta db vendria a se la normalizacion.
--- Hay muchas entidades claves, como suscripciones, historial, favoritos, etc. Pero algunas tienen columnas que no deberian estar.
--- Tal vez abarcar menos aspectos de la db y normalizar mejor pocas tablas habria estado mejor.

-- Ejemplo, la tabla de suscripciones: este modulo deberia ser suscripciones y tipo_suscripciones.
-- Para no colocar el precio y el tipo en la tabla sucripciones. 

-- Si por ejemplo tuvieras las suscripciones Premium y Basic, y 20 millones de registros. Habria mucha redundancia en cuanto 
-- a los valores de la columnas. Lo ideal seria separar esos dos valores en una tabla aparte. 

CREATE TABLE Usuarios (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    contraseña VARCHAR(100) NOT NULL,  -- EVITAR CARACTERES COMO ñ o letras con tildes en el nombre de las columnas
    pais VARCHAR(50),  -- Se podria normalizar a una tabla paises
    fecha_registro DATE NOT NULL
);

CREATE TABLE Suscripciones (
    id SERIAL PRIMARY KEY,
    tipo VARCHAR(50) NOT NULL,  -- Se podria normalizar a una tabla tipo_suscripciones
    precio DECIMAL(10,2) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    usuario_id INTEGER NOT NULL REFERENCES Usuarios(id)
);

CREATE TABLE Categorias (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE NOT NULL
);

 -- A esta tabla lo que le falta es una columna url. Por lo general, peliculas, documentos, videos, etc. Archivos binarios grandes (Blob)
 -- se guardan en sistema de archivos. EN una DB, estos nunca se guardan por completo, solamente una url donde se puede encontrar.
 -- Y esta Url es la que se suele guardar en base de datos.

 -- Por ejemplo, imagina que tienes una pelicula guardada en tu servidor para tu app en la ruta de carpetas /movies/movie123.mp4
 -- En tu db deberias guardar la url de esta pelicula como /movies/movie123.mp4
 -- Entonces en el servidor, este tomara esa url, buscara en tu servidor donde esta guardada la pelicula y comenzara a transmitir.
 -- Si quieres conocer mas, escribeme al privado y te muestro ejemplos del flujo de esto. Tengo varios en el trabajo.
CREATE TABLE Contenidos (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    tipo VARCHAR(50), -- película, serie, documental
    año INTEGER,  -- EVITAR CARACTERES COMO ñ o letras con tildes en el nombre de las columnas
    duracion INTEGER, -- duración en minutos
    categoria_id INTEGER REFERENCES Categorias(id)
);

CREATE TABLE Reseñas (  -- EVITAR CARACTERES COMO ñ o letras con tildes en el nombre de las columnas
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
    rol VARCHAR(50),  -- Se podria normalizar a una tabla empleado_roles
    fecha_ingreso DATE,
    email VARCHAR(100)
);

CREATE TABLE Plataformas (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    pais VARCHAR(50), -- Se podria normalizar a una tabla paises
    disponibilidad BOOLEAN
);

CREATE TABLE Dispositivos (
    id SERIAL PRIMARY KEY,
    tipo_dispositivo VARCHAR(50), -- TV, móvil, PC, etc.  -- Se podria normalizar a una tabla tipo_dispositivos
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
