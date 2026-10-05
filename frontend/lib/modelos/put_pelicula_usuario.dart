// To parse this JSON data, do
//
//     final putPeliculaUsuario = putPeliculaUsuarioFromJson(jsonString);

import 'dart:convert';

PutPeliculaUsuario putPeliculaUsuarioFromJson(String str) => PutPeliculaUsuario.fromJson(json.decode(str));

String putPeliculaUsuarioToJson(PutPeliculaUsuario data) => json.encode(data.toJson());

class PutPeliculaUsuario {
    String? comentario;
    int calificacion;
    bool estado;
    String? fechaVista;

    PutPeliculaUsuario({
        this.comentario,
        required this.calificacion,
        required this.estado,
        this.fechaVista,
    });

    factory PutPeliculaUsuario.fromJson(Map<String, dynamic> json) => PutPeliculaUsuario(
        comentario: json["comentario"],
        calificacion: json["calificacion"],
        estado: json["estado"],
        fechaVista: json["fecha_vista"],
    );

    Map<String, dynamic> toJson() => {
        "comentario": comentario,
        "calificacion": calificacion,
        "estado": estado,
        "fecha_vista": fechaVista == '' ? null : fechaVista,
    };
}