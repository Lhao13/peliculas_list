
import 'dart:convert';

CrearUsuarioModelo crearUsuarioModeloFromJson(String str) => CrearUsuarioModelo.fromJson(json.decode(str));

String crearUsuarioModeloToJson(CrearUsuarioModelo data) => json.encode(data.toJson());

class CrearUsuarioModelo {
    String nombres;
    String apellidos;
    String username;
    String password;
    int? edad;
    String? fechaNacimiento;
    String? genero;

    CrearUsuarioModelo({
        required this.nombres,
        required this.apellidos,
        required this.username,
        required this.password,
        this.edad,
        this.fechaNacimiento,
        this.genero,
    });

    factory CrearUsuarioModelo.fromJson(Map<String, dynamic> json) => CrearUsuarioModelo(
        nombres: json["nombres"],
        apellidos: json["apellidos"],
        username: json["username"],
        password: json["password"],
        edad: json["edad"],
        fechaNacimiento: json["fecha_nacimiento"],
        genero: json["genero"],
    );

    Map<String, dynamic> toJson() => {
        "nombres": nombres,
        "apellidos": apellidos,
        "username": username,
        "password": password,
        "edad": edad,
        "fecha_nacimiento": fechaNacimiento ==''
          ? null  
          : fechaNacimiento,
        "genero": genero ==' ' 
          ? null  
          : genero,
    };
}
