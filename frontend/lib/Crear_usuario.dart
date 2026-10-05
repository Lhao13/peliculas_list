import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

import 'package:proyecto_pelis/modelos/usuario.dart';

const List<String> list = <String>[' ', 'F', 'M'];
List<String> ages = List<String>.generate(99, (i) => (i + 1).toString());

class CrearUsuario extends StatefulWidget {
  const CrearUsuario({super.key});

  @override
  State<CrearUsuario> createState() => _CrearUsuarioState();
}

class _CrearUsuarioState extends State<CrearUsuario> {
  var nombreController = TextEditingController();
  var apellidoController = TextEditingController();
  var usuarioController = TextEditingController();
  var claveController = TextEditingController();
  var claveValidatorController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  String dropdownValue = ' ';
  String dropdownValue_edad = '1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.01, 0.99],
                colors: [
                  Color.fromARGB(239, 6, 6, 6),
                  Color.fromARGB(237, 59, 59, 59)
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 50),
                Text(
                  'My movie wacth list',
                  style: GoogleFonts.asap(
                      fontSize: 35,
                      color: const Color.fromARGB(243, 255, 255, 255),
                      fontWeight: FontWeight.bold),
                ),
                //insertar nombre
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: nombreController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                      labelStyle: TextStyle(
                        color: Color.fromARGB(255, 69, 103, 194),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                    style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                ),
                //insertar apellido
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: apellidoController,
                    decoration: const InputDecoration(
                      labelText: 'Apellido',
                      labelStyle: TextStyle(
                        color: Color.fromARGB(255, 69, 103, 194),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                    style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                ),
                //insertar usuario
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: usuarioController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre de Usuario',
                      labelStyle: TextStyle(
                        color: Color.fromARGB(255, 69, 103, 194),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                    style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                ),

                //poner bold
                //insertar clave

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: claveController,
                    decoration: const InputDecoration(
                      labelText: 'Clave',
                      labelStyle: TextStyle(
                        color: Color.fromARGB(255, 69, 103, 194),
                        fontSize: 20, 
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                    style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                ),

                //poner bold
                //insertar clave para validar

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: claveValidatorController,
                    decoration: const InputDecoration(
                      labelText: 'Valida tu Clave',
                      labelStyle: TextStyle(
                        color: Color.fromARGB(255, 69, 103, 194),
                        fontSize: 20, 
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                    style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                ),

                //parte de abajo

                const SizedBox(height: 35),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: _dateController,
                    decoration: const InputDecoration(
                      labelText: 'Fecha de nacimiento',
                      labelStyle: TextStyle(
                        color: Color.fromARGB(255, 69, 103, 194),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      filled: false,
                      prefixIcon:
                          Icon(Icons.calendar_today, color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 255, 255, 255))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 255, 255, 255))),
                    ),
                    style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                    readOnly: true,
                    onTap: () {
                      _selectDate();
                    },
                  ),
                ),

                const SizedBox(height: 20),

                //fila de genero y sexo

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  width: double.infinity,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Genero:',
                        style: GoogleFonts.asap(
                            fontSize: 20,
                            color: const Color.fromARGB(255, 69, 103, 194),
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 20),
                      //Genero_dropdown
                      DropdownButton<String>(
                        dropdownColor: Color.fromARGB(255, 29, 46, 90),
                        value: dropdownValue,
                        icon: const Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 20,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },
                        items:
                            list.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),

                      SizedBox(width: 40),
                      Text(
                        'Edad:',
                        style: GoogleFonts.asap(
                          fontSize: 20,
                          color: const Color.fromARGB(255, 69, 103, 194),
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(width: 20),
                      //edad dropdown
                      DropdownButton<String>(
                        dropdownColor: Color.fromARGB(255, 29, 46, 90),
                        value: dropdownValue_edad,
                        icon: const Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 20,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (String? newValue2) {
                          setState(() {
                            dropdownValue_edad = newValue2!;
                          });
                        },
                        items:
                            ages.map<DropdownMenuItem<String>>((String value2) {
                          return DropdownMenuItem<String>(
                            value: value2,
                            child: Text(value2),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      backgroundColor: const Color.fromARGB(
                          255, 69, 103, 194), // Set button color here
                    ),
                    onPressed: () async{
                      _publicarUsuario(context);
                    },
                    child: const Text(
                      'Crear cuenta',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
        context: context, firstDate: DateTime(1920), lastDate: DateTime(2023));

    if (_picked != null) {
      setState(
        () {
          _dateController.text = _picked.toString().split(" ")[0];

        },
      );
    }
  }

  Future<void> _publicarUsuario(contexwindow) async {
    var userM = CrearUsuarioModelo(
      nombres: nombreController.text,
      apellidos: apellidoController.text,
      username: usuarioController.text,
      password: claveController.text,
      edad: int.parse(dropdownValue_edad),
      fechaNacimiento: _dateController.text,
      genero: dropdownValue,
    );
    print(userM.toJson());

    if (nombreController.text.isNotEmpty &&
        apellidoController.text.isNotEmpty &&
        usuarioController.text.isNotEmpty &&
        claveController.text.isNotEmpty && 
        claveValidatorController.text.isNotEmpty ) {

      if (claveController.text == claveValidatorController.text) {

        var response = await http.post(Uri.parse('http://10.0.2.2:8000/users/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(userM),
        );
        if(response.statusCode == 201){
          ScaffoldMessenger.of(contexwindow).showSnackBar(
            const SnackBar(
              content: Text('Usuario creado exitosamente'),
            ),
          );
          Navigator.pop(contexwindow);
        }
        if(response.statusCode == 400){
          ScaffoldMessenger.of(contexwindow).showSnackBar(
            const SnackBar(
              content: Text('EL nombre de usuario ya existe'),
            ),
          );
        }

      }else{
        ScaffoldMessenger.of(contexwindow).showSnackBar(
          const SnackBar(
            content: Text('Las claves no coinciden'),
          ),
        );
      } 
    } else {
      ScaffoldMessenger.of(contexwindow).showSnackBar(
        const SnackBar(
          content: Text('Por favor, rellena todos los campos obligatorios'),

        ),
      );
    }
  }
}
