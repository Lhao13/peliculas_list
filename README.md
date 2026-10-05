# My Movie Watch List

**Fecha de creación:** 2024/11

Aplicación para llevar un registro personal de películas vistas y guardar películas que se quieren ver más adelante. Permite consultar títulos y sus datos desde [TMDB](https://www.themoviedb.org/) y guardar listas separadas por usuario.

## Funcionalidades

- **Cuenta e inicio de sesión:** permite crear una cuenta e iniciar sesión con nombre de usuario y contraseña. Los nombres de usuario son únicos; el backend guarda las contraseñas como hashes, no en texto plano.
- **Búsqueda:** busca películas en TMDB por título y muestra la información disponible, como el póster, la sinopsis y la fecha de estreno.
- **Listas personales:** clasifica las películas como **Vistas** o **Quiero ver**. No se puede agregar dos veces la misma película a la lista de un usuario.
- **Registro de películas vistas:** permite guardar una calificación de 1 a 5 estrellas, la fecha en que se vio la película y un comentario.
- **Gestión de listas:** permite filtrar las listas por título, abrir el detalle de una película, editar sus datos, eliminarla o cambiar una película de **Quiero ver** a **Vistas**.
- **Recomendaciones:** la pantalla principal solicita sugerencias de películas a TMDB usando como referencia una película de la lista de vistas. Si la lista está vacía, usa un título predeterminado como punto de partida.

La aplicación está enfocada en películas; las series y el registro de tiempo de visualización no forman parte de la versión actual. Los datos de cuenta y listas se almacenan en el backend y la base de datos, no solo en el dispositivo.

## Flujo de la aplicación

1. El usuario crea una cuenta o inicia sesión desde la aplicación Flutter.
2. El backend valida el inicio de sesión y devuelve un token de acceso. La app adjunta ese token a las solicitudes que requieren autenticación.
3. La app consulta TMDB directamente para buscar películas y obtener sus recomendaciones.
4. Cuando el usuario agrega una película, la app envía al backend su identificador y los datos necesarios, junto con el estado elegido y, si corresponde, su calificación, fecha vista y comentario.
5. El backend relaciona la película con la cuenta autenticada y guarda los cambios en PostgreSQL. Al abrir una lista, la app solicita únicamente las películas del usuario y del estado seleccionado.

## Arquitectura

| Parte | Tecnología | Responsabilidad |
|---|---|---|
| Aplicación | Flutter / Dart | Interfaz, navegación, búsquedas y solicitudes a los servicios |
| API | FastAPI / Python | Registro, autenticación y operaciones de lectura y escritura |
| Persistencia | PostgreSQL / SQLAlchemy | Cuentas, catálogo de películas y relación de cada usuario con sus películas |
| Migraciones | Alembic | Creación y actualización del esquema de la base de datos |
| Catálogo externo | TMDB API | Búsqueda, imágenes y recomendaciones de películas |

En la base de datos, la relación usuario-película almacena el estado (vista o por ver), la calificación, la fecha vista y el comentario. Los datos generales de una película se comparten como catálogo; cada usuario mantiene su propio estado y sus propios detalles personales.

## Requisitos

- Python y `pip`.
- PostgreSQL.
- Flutter SDK y las herramientas para la plataforma donde se ejecutará la app.
- Una clave de API de TMDB.

## Ejecución local

### 1. Configurar el backend

Desde la carpeta raíz del repositorio, instala las dependencias:

```bash
pip install -r requirements.txt
```

Crea un archivo `.env` en la raíz con los datos de conexión de PostgreSQL y la configuración del token:

```dotenv
database_hostname=localhost
database_port=5432
database_name=nombre_de_la_base
database_username=usuario_de_postgres
database_password=contraseña_de_postgres
secret_key=una_clave_secreta_larga
algorithm=HS256
access_token_expire_minutes=90
```

Crea previamente la base de datos indicada y aplica las migraciones:

```bash
alembic upgrade head
```

Inicia la API desde la raíz del repositorio:

```bash
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

La documentación interactiva de FastAPI queda disponible en `http://localhost:8000/docs`.

### 2. Configurar y ejecutar Flutter

En otra terminal, instala las dependencias e inicia la aplicación:

```bash
cd frontend
flutter pub get
flutter run
```

La app apunta actualmente al backend en `http://10.0.2.2:8000`, dirección que permite al emulador Android acceder al `localhost` de la computadora. Si se ejecuta en un dispositivo físico u otra plataforma, hay que cambiar esa dirección en las solicitudes HTTP del frontend por la dirección del backend accesible desde ese dispositivo.

La clave de TMDB está definida en los archivos de las pantallas de búsqueda y recomendaciones (`frontend/lib/Pantalla_buscarPelicula.dart` y `frontend/lib/Pantalla_Principal.dart`). Para usar otra clave, actualiza ambos valores antes de ejecutar la app. No publiques claves privadas en repositorios compartidos.

## Rutas principales de la API

| Método | Ruta | Uso | Autenticación |
|---|---|---|---|
| `POST` | `/users/` | Crear una cuenta | No |
| `POST` | `/login` | Iniciar sesión y obtener un token | No |
| `GET` | `/usuario_pelicula/` | Consultar películas del usuario; admite filtros por estado, título y límite | Sí |
| `POST` | `/usuario_pelicula/` | Agregar una película a la lista del usuario | Sí |
| `PUT` | `/usuario_pelicula/{id}` | Actualizar estado y datos personales de una película | Sí |
| `DELETE` | `/usuario_pelicula/{id}` | Quitar una película de la lista | Sí |
| `GET` | `/users/` | Consultar la cuenta autenticada | Sí |
| `PUT` / `DELETE` | `/users/` | Actualizar o eliminar la cuenta autenticada | Sí |

Las rutas protegidas esperan el token de acceso emitido por `/login` en la cabecera de autorización con esquema Bearer. Las rutas `/pelicula/` y `/genero/{id}` también están disponibles en el backend y requieren autenticación.

## Estructura del repositorio

```text
app/                   API FastAPI, modelos, configuración y rutas
alembic/               Migraciones de la base de datos
frontend/lib/          Pantallas, modelos y widgets Flutter
frontend/assets/       Imágenes usadas por la app
frontend/test/         Pruebas Flutter
requirements.txt       Dependencias Python del backend
frontend/pubspec.yaml  Dependencias y configuración Flutter
```
