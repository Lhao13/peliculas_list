
import 'dart:convert';

GetPeliculaUsuario getPeliculaUsuarioFromJson(String str) => GetPeliculaUsuario.fromJson(json.decode(str));

String getPeliculaUsuarioToJson(GetPeliculaUsuario data) => json.encode(data.toJson());

class GetPeliculaUsuario {
    String? comentario;
    int? calificacion;
    bool estado;
    DateTime? fechaVista;
    Owner owner;

    GetPeliculaUsuario({
        this.comentario,
        this.calificacion,
        required this.estado,
        this.fechaVista,
        required this.owner,
    });

    factory GetPeliculaUsuario.fromJson(Map<String, dynamic> json) => GetPeliculaUsuario(
        comentario: json["comentario"],
        calificacion: json["calificacion"],
        estado: json["estado"],
        fechaVista: json["fecha_vista"] != null ? DateTime.parse(json["fecha_vista"]) : null,
        owner: Owner.fromJson(json["owner"]),
    );

    Map <String, dynamic> toJson() => {
        "comentario": comentario,
        "calificacion": calificacion,
        "estado": estado,
        "fecha_vista": "${fechaVista?.year.toString().padLeft(4, '0')}-${fechaVista?.month.toString().padLeft(2, '0')}-${fechaVista?.day.toString().padLeft(2, '0')}",
        "owner": owner.toJson(),
    };
}

class Owner {
    int peliculaId;
    String titulo;
    String sinopsis;
    DateTime fecha;
    String? link;
    List<int> genero;

    Owner({
        required this.peliculaId,
        required this.titulo,
        required this.sinopsis,
        required this.fecha,
        this.link,
        required this.genero,
    });

    factory Owner.fromJson(Map<String, dynamic> json) => Owner(
        peliculaId: json["pelicula_id"],
        titulo: json["titulo"],
        sinopsis: json["sinopsis"],
        fecha: DateTime.parse(json["fecha"]),
        link: json["link"],
        genero: List<int>.from(json["genero"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "pelicula_id": peliculaId,
        "titulo": titulo,
        "sinopsis": sinopsis,
        "fecha": "${fecha.year.toString().padLeft(4, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}",
        "link": link,
        "genero": List<dynamic>.from(genero.map((x) => x)),
    };
}
