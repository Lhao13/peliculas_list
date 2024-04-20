from fastapi.middleware.cors import CORSMiddleware
from fastapi import FastAPI

from . import models
from .database import engine
from .routers import user, peli, auth, usuario_pelicula, generos
from .config import settings

#models.Base.metadata.create_all(bind=engine)

app = FastAPI()

origins=["*"]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(user.router)
app.include_router(peli.router)
app.include_router(auth.router)
app.include_router(usuario_pelicula.router)
app.include_router(generos.router)


