from fastapi import APIRouter, Response, status, HTTPException, Depends
from sqlalchemy.orm import Session
from fastapi.security.oauth2 import OAuth2PasswordRequestForm

from .. import models, schemas, database, utils, oauth2

router = APIRouter( tags=["auth"])

@router.post("/login")
def login(user_credential: OAuth2PasswordRequestForm = Depends(), db: Session = Depends(database.get_db)):
    usuario = db.query(models.Users).filter(models.Users.username == user_credential.username).first()
    
    if not usuario:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN,
                            detail=f"credenciales incorrectas")
    
    if not utils.verify_password(user_credential.password, usuario.password):
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN,
                            detail=f"credenciales incorrectas")
    
    access_token = oauth2.create_access_token(data={"persona_id": usuario. persona_id})    
    
    return {"access_token": access_token, "token_type": "bearer"} 