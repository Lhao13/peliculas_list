from pydantic import BaseModel
from typing import Optional
from datetime import date

class Users(BaseModel):
    nombres: str
    apellidos: str
    username: str
    password: str
    edad: Optional[int] = None
    fecha_nacimiento: Optional[date] = None
    genero: Optional[str] = None
    
class UserOut(BaseModel):
    nombres: str
    apellidos: str
    username: str
    edad: Optional[int] = None
    fecha_nacimiento: Optional[date] = None
    genero: Optional[str] = None
    class Config:
        orm_mode = True

#-------------------Peliculas-------------------

class Pelis(BaseModel):
    pelicula_id:int
    titulo: str
    sinopsis: Optional[str] = None
    fecha: date
    link: Optional[str] = None
    genero: list[int]
    class Config:
        orm_mode = True

class Pelis_con_estado(BaseModel):
    pelicula_id:int
    titulo: str
    sinopsis: Optional[str] = None
    fecha: date
    link: Optional[str] = None
    genero: list[int]
    
    comentario: Optional[str] = None
    calificacion: Optional[int] = None
    estado: bool
    fecha_vista: Optional[date] = None
    
#-------------------Usuario_Pelicula-------------------
      
class peli_user(BaseModel):
    comentario: Optional[str] = None
    calificacion: Optional[int] = None
    estado: bool
    fecha_vista: Optional[date] = None
    
    owner: Pelis
    class Config:
        orm_mode = True
    
class peli_user_update(BaseModel):
    comentario: Optional[str] = None
    calificacion: Optional[int] = None
    estado: Optional[bool]
    fecha_vista: Optional[date] = None

#-------------------Genero-------------------
 
class genero(BaseModel):
    nombre_genero: str
    
#-------------------Login-------------------

class UserLogin(BaseModel):
    username: str
    password: str
    
class Token(BaseModel):
    access_token: str
    token_type: str
    
class TokenData(BaseModel):
    persona_id: Optional[int] = None