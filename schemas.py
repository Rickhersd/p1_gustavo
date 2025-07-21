from pydantic import BaseModel
from datetime import date

class FavoritoBase(BaseModel):
    usuario_id: int
    contenido_id: int
    fecha_agregado: date

class FavoritoCreate(FavoritoBase):
    pass

class FavoritoOut(FavoritoBase):
    id: int

    class Config:
        orm_mode = True
