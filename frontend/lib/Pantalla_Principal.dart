import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_pelis/Pantalla_Listaquierover.dart';
import 'package:proyecto_pelis/widgets/navbar.dart';
import 'package:proyecto_pelis/Pantalla_buscarPelicula.dart';
import 'package:proyecto_pelis/Pantalla_ListaVista.dart';

import 'package:proyecto_pelis/modelos/pelicula_search_TMBD.dart';

import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

import 'main.dart';

const key = '0d6a4ec77ba0d8210b72b230f8f52fbb';
//key de la api de TMDB

class PantallaPrincipal extends StatefulWidget {
  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  late int codigopeli;
  List<PeliculaTmdb> movies = [];
  bool hasLoaded = true;

  final PublishSubject subject = PublishSubject<String>();

  @override
  void initState() {
    super.initState();
    _getUnaPeli(context);
  }

  Future<void> _getUnaPeli(contexwindow) async {
    var response = await http.get(
      Uri.parse('http://10.0.2.2:8000/usuario_pelicula?estado=true&limit=1'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':
            'Bearer ${Provider.of<TokenProvider>(context, listen: false).token}',
      },
    );
    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      if (responseBody.length == 0) {
        codigopeli = 299536;
        searchMovies(codigopeli);
      } else {
        codigopeli = responseBody[0]['owner']['pelicula_id'];
        print(codigopeli);
        searchMovies(codigopeli);
      }
    }
  }

  @override
  void dispose() {
    subject.close();
    super.dispose();
  }

  void searchMovies(query) {
    resetMovies();
    setState(() => hasLoaded = false);
    http
        .get(Uri.parse(
            'https://api.themoviedb.org/3/movie/$query/recommendations?api_key=$key&language=es&page=1'))
        .then((res) => (res.body))
        .then(json.decode)
        .then((map) => map["results"])
        .then((movies) => movies.forEach(addMovie))
        .catchError(onError)
        .then((e) {
      setState(() {
        hasLoaded = true;
      });
    });
  }

  void onError(dynamic d) {
    setState(() {
      hasLoaded = true;
    });
  }

  void addMovie(item) {
    setState(() {
      movies.add(PeliculaTmdb.fromJson(item));
    });
  }

  void resetMovies() {
    setState(() => movies.clear());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color.fromARGB(255, 35, 35, 35),
      drawer: NavBar(),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: Image.asset(
              'assets/imagenes/cinta.png',
              height: 40,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                height: 250,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Color.fromARGB(255, 72, 0, 0),
                      Color.fromARGB(255, 156, 16, 49),
                      Color.fromARGB(255, 3, 19, 61)
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                child: Text(
                  'My movie wacth list',
                  style: GoogleFonts.orbitron(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          //Texto de agregar una nueva pelicula

          CustomTextWidget(text: 'Agregar una nueva pelicula'),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              gradient: const LinearGradient(
                stops: [0.01, 0.99],
                colors: [
                  Color.fromRGBO(255, 0, 0, 1),
                  Color.fromRGBO(72, 0, 0, 1)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PantallaBusqueda()),
                );
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
                foregroundColor: Colors.transparent,
                backgroundColor: Colors.transparent,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/imagenes/cut.png',
                    height: 70,
                  ),
                  const Positioned(
                    bottom: 10,
                    child: Icon(
                      Icons.add_circle_rounded,
                      color: Colors.white,
                      size: 25,
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          CustomTextWidget(text: 'Lista de peliculas:'),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              gradient: const LinearGradient(
                stops: [0.01, 0.99],
                colors: [
                  Color.fromARGB(255, 255, 194, 64),
                  Color.fromARGB(255, 72, 49, 0)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Pelisvitas()),
                );
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
                foregroundColor: Colors.transparent,
                backgroundColor: Colors.transparent,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset('assets/imagenes/lista.png', height: 40),
                  const Text(
                    'vistas',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              gradient: const LinearGradient(
                stops: [0.01, 0.99],
                colors: [
                  Color.fromARGB(255, 69, 103, 194),
                  Color.fromARGB(255, 4, 16, 49)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PelisQuieroVer()),
                );
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
                foregroundColor: Colors.transparent,
                backgroundColor: Colors.transparent,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset('assets/imagenes/lista.png', height: 40),
                  const Text(
                    'quiero ver',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),

          CustomTextWidget(text: 'Recomendaciones'),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            child: const Divider(
              height: 20,
              thickness: 1,
              indent: 0,
              endIndent: 0,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          hasLoaded ? Container() : const CircularProgressIndicator(),
          Expanded(
            child: Container(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: movies.length,
                itemBuilder: (BuildContext context, int index) {
                  return new MovieView(movies[index]);
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MovieView extends StatefulWidget {
  MovieView(this.movie);
  final PeliculaTmdb movie;

  @override
  State<MovieView> createState() => _MovieViewState();
}

class _MovieViewState extends State<MovieView> {
  late PeliculaTmdb movieState;

  @override
  void initState() {
    super.initState();
    movieState = widget.movie;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.network(
          filterQuality: FilterQuality.high,
          height: 100,
          'https://image.tmdb.org/t/p/w500/${movieState.posterPath}',
        ),
      ),
    );
  }
}

class CustomTextWidget extends StatelessWidget {
  final String text;

  CustomTextWidget({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        text,
        style: GoogleFonts.asap(
          fontSize: 18,
          color: Color.fromARGB(255, 255, 255, 255),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
