from .. import models, schemas, oauth2
from fastapi import FastAPI, Response, status, HTTPException, Depends, APIRouter
from typing import Optional
from sqlalchemy.orm import Session
from ..database import get_db
from sqlalchemy import or_


router = APIRouter(prefix="/usuario_pelicula", tags=["usuario_pelicula"])

@router.post("/", status_code=status.HTTP_201_CREATED)
def crearPeliculaUsuario(peli: schemas.Pelis_con_estado, db: Session = Depends(get_db), current_user: int = Depends(oauth2.get_current_user)):

    new_peli=models.Pelis(pelicula_id=peli.pelicula_id, 
                          titulo=peli.titulo, 
                          sinopsis=peli.sinopsis, 
                          fecha=peli.fecha, 
                          link=peli.link, 
                          genero=peli.genero)
    
    new_peliusuario=models.peli_user(persona_id_2 = current_user.persona_id ,
                                     pelicula_id_2=new_peli.pelicula_id,
                                     comentario=peli.comentario, calificacion=peli.calificacion, 
                                     estado=peli.estado, 
                                     fecha_vista=peli.fecha_vista)
    db.add(new_peliusuario)
    
    #si la pelicula no existe en la tabla de peliculas se agrega
    if db.query(models.Pelis).filter(models.Pelis.pelicula_id == new_peli.pelicula_id).first() == None:
        db.add(new_peli)
    
    #si la pelicula ya esta en la lista de peliculas del usuario    
    pregunta=db.query(models.peli_user).filter(models.peli_user.persona_id_2 == current_user.persona_id).filter(models.peli_user.pelicula_id_2 == new_peli.pelicula_id).first()
    if pregunta!=None:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST,
                            detail=f"La pelicula ya esta en tu lista")
    db.commit()
    return  "Pelicula añadida a tu lista de peliculas"


@router.get("/", response_model=list[schemas.peli_user])
def getPeliculas(db: Session = Depends(get_db),current_user: int = Depends(oauth2.get_current_user),
                 limit: int = 20, search: Optional[str] ="", estado: Optional[bool]= True):
    
    peliculas_query=db.query(models.peli_user)\
        .join(models.Pelis, models.peli_user.pelicula_id_2 == models.Pelis.pelicula_id)\
        .filter(models.peli_user.persona_id_2 == current_user.persona_id)\
        .filter(models.Pelis.titulo.contains(search))\
        .filter(models.peli_user.estado == estado)\
        .limit(limit)
        
    peliculas=peliculas_query.all()
    return peliculas

@router.put("/{id}")
def updatePeliculaUsuario(id: int, peli: schemas.peli_user_update, db: Session = Depends(get_db), current_user: int = Depends(oauth2.get_current_user)):
    
    pelicula_query=db.query(models.peli_user).filter(models.peli_user.persona_id_2 == current_user.persona_id).filter(models.peli_user.pelicula_id_2==id)
    pelicula=pelicula_query.first()
    
    if pelicula == None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail=f"No tienes esa pelicula agregada {id} no existe")  
  
    pelicula_query.update(peli.dict(), synchronize_session=False)
    db.commit()
    return  pelicula_query.first()


@router.delete("/{id}", status_code=status.HTTP_204_NO_CONTENT)
def borrarPeliculaUsuario(id: int, db: Session = Depends(get_db), current_user: int = Depends(oauth2.get_current_user)):
    pelicula_query=db.query(models.peli_user).filter(models.peli_user.persona_id_2 == current_user.persona_id).filter(models.peli_user.pelicula_id_2==id)
    pelicula=pelicula_query.first()
    
    if pelicula == None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail=f"No tienes esa pelicula agregada {id} no existe")  
    
    pelicula_query.delete(synchronize_session=False)
    db.commit()
    return Response(status_code=status.HTTP_204_NO_CONTENT)
