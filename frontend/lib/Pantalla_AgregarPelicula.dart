import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:proyecto_pelis/widgets/navbar.dart';
import 'package:proyecto_pelis/widgets/appbar_default.dart';
import 'package:proyecto_pelis/modelos/pelicula_search_TMBD.dart';
import 'package:proyecto_pelis/modelos/post_pelicula_usuario.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:http/http.dart' as http;

import 'main.dart';

const List<String> lista = <String>[
  'Pelicula vista',
  'Pelicula que quiero ver'
];

class MovieInfoWindow extends StatefulWidget {
  final PeliculaTmdb movie;
  MovieInfoWindow({required this.movie});

  @override
  State<MovieInfoWindow> createState() => _MovieInfoWindowState();
}

class _MovieInfoWindowState extends State<MovieInfoWindow> {
  late PeliculaTmdb movieState;

  String dropdownValue_moviecondition = 'Pelicula vista';
  TextEditingController _dateController = TextEditingController();
  TextEditingController _comentarioController = TextEditingController();
  int _saveRating=3;

  @override
  void initState() {
    super.initState();
    movieState = widget.movie;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 35, 35, 35),
      drawer: const NavBar(),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBarDefault(title: 'Agregar Pelicula'),
      ),
      body: Builder(
        builder: (context) {
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
                            'Condicion: ',
                            style: GoogleFonts.asap(
                                fontSize: 15,
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          DropdownButton<String>(
                            dropdownColor: Color.fromARGB(255, 29, 46, 90),
                            value: dropdownValue_moviecondition,
                            icon: const Icon(Icons.arrow_downward),
                            iconSize: 24,
                            elevation: 20,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                            onChanged: (String? newValue2) {
                              setState(() {
                                dropdownValue_moviecondition = newValue2!;
                              });
                            },
                            items: lista
                                .map<DropdownMenuItem<String>>((String value2) {
                              return DropdownMenuItem<String>(
                                value: value2,
                                child: Text(value2),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      SizedBox(width: 25),
                      Visibility(
                        visible: dropdownValue_moviecondition == 'Pelicula vista',
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
                    visible: dropdownValue_moviecondition == 'Pelicula vista',
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
                        style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
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
                        widget.movie.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      Image.network(
                        'https://image.tmdb.org/t/p/w500${movieState.posterPath}',
                        height: 300,
                      ),
                      Text(
                        'Fecha de lanzamiento: ${movieState.releaseDate.year}-${movieState.releaseDate.month}-${movieState.releaseDate.day}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          movieState.overview,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
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
                  ElevatedButton.icon(
                    onPressed: () {
                      //cuando se presiona
                      _postPeliculaUsuario(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          dropdownValue_moviecondition == 'Pelicula que quiero ver'
                              ? Colors.green
                              : const Color.fromARGB(255, 255, 17, 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Agregar ${dropdownValue_moviecondition}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      ),
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

  Future<void> _postPeliculaUsuario(contexwindow) async {
    int? varcalificacion;
    String? varfechaVista;
    if (dropdownValue_moviecondition == 'Pelicula vista') {
      varcalificacion = _saveRating;
      varfechaVista = _dateController.text;
    } else {
      varcalificacion = null;
      varfechaVista = null;
    }

    var userPelicula = PostPeliculaUsuario(
      peliculaId: movieState.id,
      titulo: movieState.title,
      sinopsis: movieState.overview,
      fecha: movieState.releaseDate,
      link: movieState.posterPath,
      genero: movieState.genreIds,
      comentario: _comentarioController.text,
      estado: dropdownValue_moviecondition == 'Pelicula vista' ? true : false,
      calificacion:
          varcalificacion, //la calificacion es null si la pelicula no se ha visto
      fechaVista:
          varfechaVista, //la fecha de vista es null si la pelicula no se ha visto
    );

    var response =await http.post(
      Uri.parse('http://10.0.2.2:8000/usuario_pelicula/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':
            'Bearer ${Provider.of<TokenProvider>(context, listen: false).token}',
      },
      body: json.encode(userPelicula),
    );
    if(response.statusCode == 201){
      ScaffoldMessenger.of(contexwindow).showSnackBar(
        const SnackBar(
          content: Text('Pelicula agregada correctamente'),
        ),
      );
      Navigator.pop(contexwindow);
    }
    if(response.statusCode == 400){
      ScaffoldMessenger.of(contexwindow).showSnackBar(
        const SnackBar(
          content: Text('La pelicula ya ha sido agregada anteriormente'),
        ),
      );
      Navigator.pop(contexwindow);
    }
  }
}
