
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_pelis/Pantalla_ListaVista.dart';
import 'package:proyecto_pelis/main.dart';

import 'package:proyecto_pelis/widgets/navbar.dart';
import 'package:proyecto_pelis/widgets/appbar_default.dart';
import 'package:proyecto_pelis/modelos/get_pelicula_usuario.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:http/http.dart' as http;

const List<String> lista = <String>[
  'Pelicula vista',
  'Pelicula que quiero ver'
];

class InfoPelicula extends StatefulWidget {
  final GetPeliculaUsuario movie;
  InfoPelicula({required this.movie});

  @override
  State<InfoPelicula> createState() => _InfoPeliculaState();
}

class _InfoPeliculaState extends State<InfoPelicula> {
  late GetPeliculaUsuario movieState;

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
        child: AppBarDefault(title: 'Informacion pelicula vista'),
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
                          'Condicion: ',
                          style: GoogleFonts.asap(
                              fontSize: 15,
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Vista',
                          style: GoogleFonts.asap(
                              fontSize: 15,
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(width: 25),
                    Column(
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
                            initialRating: movieState.calificacion!.toDouble(),
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            ignoreGestures: true,
                            itemCount: 5,
                            itemSize: 30.0,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 1.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Fecha de visualizacion:',
                  style: GoogleFonts.asap(
                      fontSize: 15,
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Container(
                  width: 20,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextField(
                    readOnly: true,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText:movieState.fechaVista == null?
                          'Sin fecha':
                          '${movieState.fechaVista?.year}-${movieState.fechaVista?.month}-${movieState.fechaVista?.day}',
                      hintStyle: TextStyle(color: Colors.white),
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
                      readOnly: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: movieState.comentario == ''
                            ? 'Sin comentario'
                            : movieState.comentario,
                        hintStyle:
                            TextStyle(color: Colors.white.withOpacity(0.6)),
                      ),
                    ),
                  ),
                ),
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
                  label: const Text(
                    'Quitar de la lista',
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
          builder: (context) => Pelisvitas(),
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
          builder: (context) => Pelisvitas(),
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
          builder: (context) => Pelisvitas(),
        ),
      );
    }
  }
}
