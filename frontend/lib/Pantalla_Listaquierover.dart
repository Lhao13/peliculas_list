import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_pelis/widgets/appbar_default.dart';
import 'package:proyecto_pelis/widgets/navbar.dart';
import 'package:proyecto_pelis/main.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto_pelis/modelos/get_pelicula_usuario.dart';
import 'package:rxdart/rxdart.dart';
import 'package:proyecto_pelis/Pantallas_especiales/infopeliculaChange.dart';


class PelisQuieroVer extends StatefulWidget {
  const PelisQuieroVer({super.key});

  @override
  State<PelisQuieroVer> createState() => _PelisQuieroVerState();
}

class _PelisQuieroVerState extends State<PelisQuieroVer> {
  List<GetPeliculaUsuario> movies = [];
  bool hasLoaded = true;
  TextEditingController _controller = TextEditingController();

  final PublishSubject subject = PublishSubject<String>();

  @override
  void dispose() {
    _controller.clear();
    subject.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    searchMoviesUser(' ', 40);
    subject.stream
        .debounceTime(const Duration(milliseconds: 500))
        .listen((dynamic data) {
      final size = 20; // Replace 10 with the desired value for size
      data == '' ? searchMoviesUser(' ', size) : searchMoviesUser(data, size);
    });
  }

  void searchMoviesUser(query, size) {
    resetMoviesUser();
    if (query.isEmpty) {
      setState(() {
        hasLoaded = true;
      });
      return;
    }
    setState(() => hasLoaded = false);
    http
        .get(
          Uri.parse(
              'http://10.0.2.2:8000/usuario_pelicula?estado=false&search=$query&size=$size'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization':
                'Bearer ${Provider.of<TokenProvider>(context, listen: false).token}',
          },
        )
        .then((res) => (res.body))
        .then(json.decode)
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
      movies.add(GetPeliculaUsuario.fromJson(item));
    });
    print('${movies.map((e) => e.owner.titulo)}');
  }

  void resetMoviesUser() {
    setState(() => movies.clear());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.01, 0.99],
            colors: [
              Color.fromARGB(255, 3, 14, 46),
              Color.fromARGB(237, 64, 98, 192)
            ],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          drawer: const NavBar(),
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: AppBarDefault(title: 'Peliculas que quiero ver'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                TextField(
                  controller: _controller,
                  style: TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Buscar pelicula',
                    labelStyle: TextStyle(color: Colors.white),
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                  ),
                  onChanged: (String string) => (subject.add(string)),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      childAspectRatio: 0.6,
                    ),
                    itemCount: movies.length,
                    itemBuilder: (BuildContext context, int index) {
                      return buildCard(movies[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class buildCard extends StatefulWidget {
  buildCard(this.movie);
  final GetPeliculaUsuario movie;

  @override
  State<buildCard> createState() => _buildCardState();
}

class _buildCardState extends State<buildCard> {
  late GetPeliculaUsuario movieState;

  @override
  void initState() {
    super.initState();
    movieState = widget.movie;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: GestureDetector(
        child: Card(
          color: const Color.fromARGB(255, 0, 0, 0),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  'https://image.tmdb.org/t/p/w500/${movieState.owner.link}',
                  filterQuality: FilterQuality.high,
                  height: 250,
                ),
              ),
              const SizedBox(width: 5),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  movieState.owner.titulo,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  softWrap: true,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => InfoPeliculaChange(movie: movieState),
            ),
          );
        },
      ),
    );
  }
}
