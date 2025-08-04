from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from sqlalchemy import insert, Select
from app import models, schemas, database

models.Base.metadata.create_all(bind=database.engine)

app = FastAPI()


# Es Buen añadido haber agregado la funcion generadora para el manejo de los
# session siguiendo el patron de inyeccion de dependencias ⭐
def get_db():
    db = database.SessionLocal()
    try:
        yield db
    finally:
        db.close()


# El problema que veo con los endpoints es que usan la api vieja de SQLalchemy 1.4, en lugar de implementar la api
# 2.x. Usar add, refresh y query quedaran deprecated con los años. En cambio, deberia usar los objectos Select,
# Insert, Delete, Update importados directamente de Sqlalchemy.


# API 1.4. Version antigua
@app.post("/favoritos", response_model=schemas.FavoritoOut)
def crear_favorito(favorito: schemas.FavoritoCreate, db: Session = Depends(get_db)):
    nuevo = models.Favorito(**favorito.dict())

    db.add(nuevo)
    db.commit()
    db.refresh(nuevo)
    return nuevo


# API 2.x. Version actual
@app.post("/favoritos")
def crear_favorito(favorito: schemas.FavoritoCreate, db: Session = Depends(get_db)):
    stmt = insert(models.Favorito).values(**favorito.dict())

    db.execute(stmt)
    db.commit()

    return 'ok'


# API 1.4. Version antigua
@app.get("/favoritos", response_model=list[schemas.FavoritoOut])
def listar_favoritos(db: Session = Depends(get_db)):
    return db.query(models.Favorito).all()

# API 2.x. Version actual


@app.get("/favoritos", response_model=list[schemas.FavoritoOut])
def listar_favoritos(db: Session = Depends(get_db)):
    stmt = Select(models.Favorito).select_from(models.Favorito)
    result = db.execute(stmt)
    return result.all()


# API 1.4. Version antigua
@app.get("/favoritos/{id}", response_model=schemas.FavoritoOut)
def obtener_favorito(id: int, db: Session = Depends(get_db)):

    favorito = db.query(models.Favorito).filter(
        models.Favorito.id == id).first()
    if not favorito:
        raise HTTPException(status_code=404, detail="Favorito no encontrado")

    return favorito


# API 1.4. Version antigua
@app.delete("/favoritos/{id}")
def eliminar_favorito(id: int, db: Session = Depends(get_db)):

    favorito = db.query(models.Favorito).filter(
        models.Favorito.id == id).first()

    if not favorito:
        raise HTTPException(status_code=404, detail="Favorito no encontrado")

    db.delete(favorito)
    db.commit()
    return {"ok": True, "mensaje": "Favorito eliminado"}
