from sqlalchemy import Column, Integer, String, Date, Boolean, ForeignKey
from sqlalchemy.orm import relationship
from .database import Base

class Usuario(Base):
    __tablename__ = "usuarios"
    id = Column(Integer, primary_key=True, index=True)
    nombre = Column(String(100), nullable=False)
    email = Column(String(100), nullable=False, unique=True)
    contraseña = Column(String(100), nullable=False)
    pais = Column(String(50))
    fecha_registro = Column(Date)

    favoritos = relationship("Favorito", back_populates="usuario")


class Contenido(Base):
    __tablename__ = "contenidos"
    id = Column(Integer, primary_key=True, index=True)
    titulo = Column(String(150), nullable=False)
    tipo = Column(String(50))
    año = Column(Integer)
    duracion = Column(Integer)
    categoria_id = Column(Integer, ForeignKey("categorias.id"))

    favoritos = relationship("Favorito", back_populates="contenido")


class Favorito(Base):
    __tablename__ = "favoritos"
    id = Column(Integer, primary_key=True, index=True)
    usuario_id = Column(Integer, ForeignKey("usuarios.id"), nullable=False)
    contenido_id = Column(Integer, ForeignKey("contenidos.id"), nullable=False)
    fecha_agregado = Column(Date)

    usuario = relationship("Usuario", back_populates="favoritos")
    contenido = relationship("Contenido", back_populates="favoritos")
