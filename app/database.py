from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from .config import settings

SQLALCHEMY_DATABASE_URL = f"postgresql://{settings.database_username}:{settings.database_password}@{settings.database_hostname}:{settings.database_port}/{settings.database_name}"

engine = create_engine(SQLALCHEMY_DATABASE_URL)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
        
'''    
while True:
    try:
        conn= psycopg2.connect(host="localhost",database="postgres", 
                            user="postgres", password="Dante2024", 
                            cursor_factory=RealDictCursor)
        cursor = conn.cursor()
        print("Conectado a la base de datos") 
        break
    except Exception as e:
        print("conexión fallida")
        print("Error:", e)
        time.sleep(2)
'''