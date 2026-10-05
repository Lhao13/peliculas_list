import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:proyecto_pelis/Pantalla_Principal.dart';
import 'package:proyecto_pelis/Crear_usuario.dart';

import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TokenProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class TokenProvider with ChangeNotifier {
  late String _token;

  String get token => _token;

  void setToken(String value) {
    _token = value;
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var usercontroller = TextEditingController();
  var passwordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'My movie wacth list',
                    style: GoogleFonts.asap(
                        fontSize: 35,
                        color: const Color.fromARGB(243, 255, 255, 255),
                        fontWeight: FontWeight.bold),
                  ),
                  Image.asset(
                    'assets/imagenes/cinema-1294496_1280.png',
                    height: 200,
                  ),

                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Login',
                      style: GoogleFonts.asap(
                          fontSize: 25,
                          color: const Color.fromARGB(243, 255, 255, 255),
                          fontWeight: FontWeight.bold),
                    ),
                  ),

                  const SizedBox(height: 20), // Inserted space

                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Usuario:',
                      style: GoogleFonts.asap(
                          fontSize: 15,
                          color: const Color.fromARGB(255, 255, 17, 0),
                          fontWeight: FontWeight.bold),
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: usercontroller,
                      decoration: const InputDecoration(
                        hintText: 'Pon tu nombre de usuario aquí',
                        hintStyle: TextStyle(
                            color: Color.fromARGB(110, 255, 255, 255)),
                      ),
                      style:
                          const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Clave:',
                      style: GoogleFonts.asap(
                          fontSize: 15,
                          color: const Color.fromARGB(255, 255, 17, 0),
                          fontWeight: FontWeight.bold),
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      obscureText: true,
                      controller: passwordcontroller,
                      decoration: const InputDecoration(
                        hintText: 'Pon tu contraseña aquí',
                        hintStyle: TextStyle(
                            color: Color.fromARGB(110, 255, 255, 255)),
                      ),
                      style:
                          const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
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
                            255, 255, 17, 0), // Set button color here
                      ),
                      onPressed: () {
                        login(context);
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),

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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CrearUsuario()),
                        );
                      },
                      child: const Text(
                        'Crear una nueva cuenta',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> login(contexwindow) async {
    if (passwordcontroller.text.isNotEmpty && usercontroller.text.isNotEmpty) {
      var response = await http.post(Uri.parse('http://10.0.2.2:8000/login'),
          body: ({
            'username': usercontroller.text,
            'password': passwordcontroller.text
          }),
        );
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        var token = responseBody['access_token'];
        //token para acceder a los demas metodos
        Provider.of<TokenProvider>(context, listen: false).setToken(token);
        print(token);
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PantallaPrincipal()),
        );
      } else {
        ScaffoldMessenger.of(contexwindow).showSnackBar(
          const SnackBar(
            content: Text('Usuario o contraseña incorrectos'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(contexwindow).showSnackBar(
        const SnackBar(
          content: Text('Por favor, rellena todos los campos'),
        ),
      );
    }
  }
}
