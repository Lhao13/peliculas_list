# My Movie Watch List

**Fecha de creación:** 2024/11

Aplicación para organizar películas vistas y recomendaciones personales de películas por ver. La información de cada título se obtiene de [TMDB](https://www.themoviedb.org/), y las listas y datos de cada usuario se guardan mediante una API propia.

## ¿Cómo funciona?

1. El usuario crea una cuenta e inicia sesión. La API valida sus credenciales y entrega un token para las operaciones protegidas.
2. Desde la pantalla principal puede ver recomendaciones y buscar películas por título.
3. Al seleccionar una película, puede agregarla a **Vistas** o **Quiero ver**. Para las vistas puede guardar una calificación, la fecha en que la vio y un comentario.
4. En sus listas puede buscar títulos y consultar sus detalles. También puede actualizar los datos, pasar una película de **Quiero ver** a **Vistas** o eliminarla de su lista.

Cada usuario consulta y administra sus propias listas. La aplicación se enfoca actualmente en películas; las series no están incluidas.

## Componentes principales

- **Frontend:** aplicación multiplataforma hecha con Flutter y Dart.
- **Backend:** API REST creada con FastAPI; gestiona usuarios, autenticación y listas de películas.
- **Base de datos:** PostgreSQL, accedida desde el backend con SQLAlchemy.
- **Catálogo:** API de TMDB, usada para buscar películas, mostrar sus datos y obtener recomendaciones.
