
import 'dart:convert';

PostPeliculaUsuario postPeliculaUsuarioFromJson(String str) => PostPeliculaUsuario.fromJson(json.decode(str));

String postPeliculaUsuarioToJson(PostPeliculaUsuario data) => json.encode(data.toJson());

class PostPeliculaUsuario {
    int peliculaId;
    String titulo;
    String sinopsis;
    DateTime fecha;
    String? link;
    List<int> genero;
    String? comentario;
    int? calificacion;
    bool estado;
    String? fechaVista;

    PostPeliculaUsuario({
        required this.peliculaId,
        required this.titulo,
        required this.sinopsis,
        required this.fecha,
        this.link,
        required this.genero,
        this.comentario,
        this.calificacion,
        required this.estado,
        this.fechaVista,
    });

    factory PostPeliculaUsuario.fromJson(Map<String, dynamic> json) => PostPeliculaUsuario(
        peliculaId: json["pelicula_id"],
        titulo: json["titulo"],
        sinopsis: json["sinopsis"],
        fecha: DateTime.parse(json["fecha"]),
        link: json["link"],
        genero: List<int>.from(json["genero"].map((x) => x)),
        comentario: json["comentario"],
        calificacion: json["calificacion"],
        estado: json["estado"],
        fechaVista: json["fecha_vista"],
    );

    Map<String, dynamic> toJson() => {
        "pelicula_id": peliculaId,
        "titulo": titulo,
        "sinopsis": sinopsis,
        "fecha": "${fecha.year.toString().padLeft(4, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}",
        "link": link,
        "genero": List<dynamic>.from(genero.map((x) => x)),
        "comentario": comentario,
        "calificacion": calificacion,
        "estado": estado,
        "fecha_vista": fechaVista == ''
          ? null
          : fechaVista,
    };
}