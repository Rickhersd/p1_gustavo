# StreamVibe - Proyecto de Base de Datos

**Contexto del proyecto**  
StreamVibe es una plataforma de streaming de películas y series que necesita reestructurar su arquitectura de datos para mejorar la experiencia del usuario. La base de datos permitirá manejar de forma eficiente el catálogo de contenido, interacciones como reseñas y favoritos, y la gestión de usuarios.

## 🔧 Entidades

Este proyecto incluye 10 entidades relacionadas: Usuarios, Suscripciones, Contenidos, Categorías, Reseñas, Empleados, Plataformas, Dispositivos, Favoritos, Historial.

## 📂 Backend (FastAPI)

El backend implementa un CRUD básico sobre la entidad `Favoritos`, con los siguientes endpoints:

- `POST /favoritos`  
- `GET /favoritos`  
- `GET /favoritos/{id}`  
- `DELETE /favoritos/{id}`  

Se utilizó SQLAlchemy para modelar las relaciones y Pydantic para los esquemas.

## 💾 Exportar la base de datos

Una vez que se haya creado la base en PostgreSQL con el archivo `esquema.sql`, puedes exportarla con:

```bash
pg_dump streamvibe_db > db/output.sql
