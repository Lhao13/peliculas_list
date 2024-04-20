from .. import models, schemas, oauth2
from fastapi import FastAPI, Response, status, HTTPException, Depends, APIRouter
from sqlalchemy.orm import Session
from ..database import get_db

router = APIRouter(prefix="/pelicula", tags=["pelicula"])

@router.post("/", status_code=status.HTTP_201_CREATED)
def crearPelicula(peli: schemas.Pelis, db: Session = Depends(get_db), current_user: int = Depends(oauth2.get_current_user)):
    new_peli=models.Pelis(**peli.dict())
    db.add(new_peli)
    db.commit()
    db.refresh(new_peli)
    return  new_peli

@router.get("/", response_model=list[schemas.Pelis])
def getPeliculas(db: Session = Depends(get_db),
                 current_user: int = Depends(oauth2.get_current_user)):
    peliculas=db.query(models.Pelis).all()
    return peliculas

@router.get("/{id}", response_model=schemas.Pelis)
def getPelicula_id(id: int, db: Session = Depends(get_db),
                   current_user: int = Depends(oauth2.get_current_user)):
    pelicula=db.query(models.Pelis).filter(models.Pelis.pelicula_id == id).first()
    
    if not pelicula:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail=f"La pelicula {id} no existe")  
    return  pelicula

