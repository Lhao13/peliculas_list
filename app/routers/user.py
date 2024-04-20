
from .. import models, schemas, utils, oauth2
from fastapi import FastAPI, Response, status, HTTPException, Depends, APIRouter
from sqlalchemy.orm import Session
from ..database import get_db

router = APIRouter(prefix="/users", tags=["users"])


@router.post("/", status_code=status.HTTP_201_CREATED, response_model=schemas.UserOut)
def crearUsuario(user: schemas.Users, db: Session = Depends(get_db)):

    hashed_password = utils.hash(user.password)
    user.password = hashed_password
    
    new_user=models.Users(**user.dict())    
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    return  new_user


@router.get("/", response_model=schemas.UserOut)
def getusurio( db: Session = Depends(get_db), current_user: int = Depends(oauth2.get_current_user)):

    usuario=db.query(models.Users).filter(models.Users.persona_id == current_user.persona_id).first()
    
    if usuario.persona_id != current_user.persona_id:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN,
                            detail=f"No tienes permiso para obtener este usuario")
    
    return  usuario



@router.delete("/", status_code=status.HTTP_204_NO_CONTENT)
def borrarusuario( db: Session = Depends(get_db), current_user: int = Depends(oauth2.get_current_user)):

    usuario_query = db.query(models.Users).filter(models.Users.persona_id == current_user.persona_id)
    usuario=usuario_query.first()
    
    if usuario ==  None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail=f"El usuario no existe")
        
    if usuario.persona_id != current_user.persona_id:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN,
                            detail=f"No tienes permiso para borrar este usuario")
    
    usuario_query.delete(synchronize_session=False)
    db.commit()
    
    return Response(status_code=status.HTTP_204_NO_CONTENT)


@router.put("/")
def updateusuario( user: schemas.UserOut, db: Session = Depends(get_db), current_user: int = Depends(oauth2.get_current_user)):
    
    usuario_query=db.query(models.Users).filter(models.Users.persona_id == current_user.persona_id)
    usuario=usuario_query.first()
    
    if usuario == None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail=f"El usuario no existe")
        
    if usuario.persona_id != current_user.persona_id:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN,
                            detail=f"No tienes permiso para cambiar este usuario")
        
    usuario_query.update(user.dict(), synchronize_session=False)
    db.commit()
    
    return  usuario_query.first()