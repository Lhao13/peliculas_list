import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_pelis/Pantalla_Listaquierover.dart';

import 'package:proyecto_pelis/widgets/navbar.dart';
import 'package:proyecto_pelis/widgets/appbar_default.dart';
import 'package:proyecto_pelis/modelos/get_pelicula_usuario.dart';
import 'package:proyecto_pelis/modelos/put_pelicula_usuario.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:http/http.dart' as http;

import 'package:proyecto_pelis/main.dart';

const List<String> lista = <String>[
  'Pelicula vista',
  'Pelicula que quiero ver'
];

class InfoPeliculaChange extends StatefulWidget {
  final GetPeliculaUsuario movie;
  InfoPeliculaChange({required this.movie});

  @override
  State<InfoPeliculaChange> createState() => _InfoPeliculaChangeState();
}

class _InfoPeliculaChangeState extends State<InfoPeliculaChange> {
  late GetPeliculaUsuario movieState;

  TextEditingController _dateController = TextEditingController();
  TextEditingController _comentarioController = TextEditingController();
  int _saveRating = 3;

  @override
  void initState() {
    super.initState();
    movieState = widget.movie;
    _comentarioController.text =
        widget.movie.comentario == null ? '' : widget.movie.comentario!;
    _dateController.text = widget.movie.fechaVista == null
        ? ''
        : '${widget.movie.fechaVista!.year}-${widget.movie.fechaVista!.month}-${widget.movie.fechaVista!.day}';
  }

  bool _swicthValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 35, 35, 35),
      drawer: const NavBar(),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBarDefault(title: 'Informacion pelicula quiero ver'),
      ),
      body: Builder(builder: (context) {
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
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: ListView(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 10),
                        Text(
                          'Cambiar a pelicula vista: ',
                          style: GoogleFonts.asap(
                              fontSize: 15,
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Switch(
                          value: _swicthValue,
                          onChanged: (bool value) {
                            setState(() {
                              _swicthValue = value;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(width: 25),
                    Visibility(
                      visible: _swicthValue == true,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 10),
                          Text(
                            'Calificacion: ',
                            style: GoogleFonts.asap(
                                fontSize: 15,
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),
                          Container(
                            color: Colors.white,
                            alignment: Alignment.center,
                            child: RatingBar.builder(
                              initialRating: 3,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: false,
                              itemCount: 5,
                              itemSize: 30.0,
                              tapOnlyMode: true,
                              itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 1.0),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                _saveRating = rating.toInt();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Visibility(
                  visible: _swicthValue == true,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: _dateController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                        labelText: 'Fecha de visualizacion',
                        labelStyle: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        filled: true,
                        fillColor: Color.fromARGB(255, 0, 0, 0),
                        prefixIcon: Icon(Icons.calendar_today,
                            color: Colors.white, size: 20),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 255, 255, 255))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 255, 255, 255))),
                      ),
                      style:
                          TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                      readOnly: true,
                      onTap: () {
                        _selectDate();
                      },
                    ),
                  ),
                ),
                const Divider(
                  height: 20,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                Column(
                  children: <Widget>[
                    Text(
                      movieState.owner.titulo,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    Image.network(
                      'https://image.tmdb.org/t/p/w500${movieState.owner.link}',
                      height: 300,
                    ),
                    Text(
                      'Fecha de lanzamiento: ${movieState.owner.fecha.year}-${movieState.owner.fecha.month}-${movieState.owner.fecha.day}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        movieState.owner.sinopsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: _swicthValue == true,
                  child: Container(
                    margin: const EdgeInsets.all(10.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Container(
                      height: 150, // Establece un tamaño definido
                      child: TextField(
                        controller: _comentarioController,
                        maxLines: null, // Permite un número ilimitado de líneas
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Agrega un comentario',
                          hintStyle:
                              TextStyle(color: Colors.white.withOpacity(0.6)),
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: _swicthValue == true,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _updatePelicula(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 55, 216, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                    icon: const Icon(
                      Icons.refresh,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Actualizar pelicula',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                ElevatedButton.icon(
                  onPressed: () {
                    _deletePelicula(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 17, 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Borrar pelicula',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
        context: context, firstDate: DateTime(1950), lastDate: DateTime(2023));

    if (_picked != null) {
      setState(
        () {
          _dateController.text = _picked.toString().split(" ")[0];
        },
      );
    }
  }

  Future<void> _deletePelicula(contexwindow) async {
    var response = await http.delete(
      Uri.parse(
          'http://10.0.2.2:8000/usuario_pelicula/${movieState.owner.peliculaId}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':
            'Bearer ${Provider.of<TokenProvider>(context, listen: false).token}',
      },
    );
    if (response.statusCode == 204) {
      ScaffoldMessenger.of(contexwindow).showSnackBar(
        const SnackBar(
          content: Text('Pelicula eliminada de la lista de vistas'),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PelisQuieroVer(),
        ),
      );
    }
    if (response.statusCode == 401) {
      ScaffoldMessenger.of(contexwindow).showSnackBar(
        const SnackBar(
          content: Text('No tienes permisos para eliminar la pelicula'),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PelisQuieroVer(),
        ),
      );
    }
    if (response.statusCode == 404) {
      ScaffoldMessenger.of(contexwindow).showSnackBar(
        const SnackBar(
          content: Text('La pelicula no se encuentra en la lista de vistas'),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PelisQuieroVer(),
        ),
      );
    }
  }

  Future<void> _updatePelicula(contexwindow) async {
    
    var userPelicula = PutPeliculaUsuario(
      comentario: _comentarioController.text,
      calificacion: _saveRating,
      estado: true,
      fechaVista: _dateController.text,
    );

    var response = await http.put(
      Uri.parse(
          'http://10.0.2.2:8000/usuario_pelicula/${movieState.owner.peliculaId}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':
            'Bearer ${Provider.of<TokenProvider>(context, listen: false).token}',
      },
      body: json.encode(userPelicula),
    );
    if(response.statusCode == 200){
      ScaffoldMessenger.of(contexwindow).showSnackBar(
        const SnackBar(
          content: Text('Pelicula actualizada'),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PelisQuieroVer(),
        ),
      );
    }
    if(response.statusCode == 404){
      ScaffoldMessenger.of(contexwindow).showSnackBar(
        const SnackBar(
          content: Text('La pelicula no se encuentra en la lista de vistas'),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PelisQuieroVer(),
        ),
      );
    }
  }
}
