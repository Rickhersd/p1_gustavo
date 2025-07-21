from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from app import models, schemas, database

models.Base.metadata.create_all(bind=database.engine)

app = FastAPI()

def get_db():
    db = database.SessionLocal()
    try:
        yield db
    finally:
        db.close()

@app.post("/favoritos", response_model=schemas.FavoritoOut)
def crear_favorito(favorito: schemas.FavoritoCreate, db: Session = Depends(get_db)):
    nuevo = models.Favorito(**favorito.dict())
    db.add(nuevo)
    db.commit()
    db.refresh(nuevo)
    return nuevo

@app.get("/favoritos", response_model=list[schemas.FavoritoOut])
def listar_favoritos(db: Session = Depends(get_db)):
    return db.query(models.Favorito).all()

@app.get("/favoritos/{id}", response_model=schemas.FavoritoOut)
def obtener_favorito(id: int, db: Session = Depends(get_db)):
    favorito = db.query(models.Favorito).filter(models.Favorito.id == id).first()
    if not favorito:
        raise HTTPException(status_code=404, detail="Favorito no encontrado")
    return favorito

@app.delete("/favoritos/{id}")
def eliminar_favorito(id: int, db: Session = Depends(get_db)):
    favorito = db.query(models.Favorito).filter(models.Favorito.id == id).first()
    if not favorito:
        raise HTTPException(status_code=404, detail="Favorito no encontrado")
    db.delete(favorito)
    db.commit()
    return {"ok": True, "mensaje": "Favorito eliminado"}
