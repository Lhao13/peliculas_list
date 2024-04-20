from .. import models, schemas, utils, oauth2
from fastapi import FastAPI, Response, status, HTTPException, Depends, APIRouter
from sqlalchemy.orm import Session
from ..database import get_db

router = APIRouter(prefix="/genero", tags=["generos"])

@router.get("/{id}", response_model=schemas.genero)
def getGenero_id(id: int, db: Session = Depends(get_db),
                   current_user: int = Depends(oauth2.get_current_user)):
    genero_c=db.query(models.genero).filter(models.genero.genero_id == id).first()
    
    if genero_c == None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail=f"El genero {id} no existe")  
    return  genero_c
