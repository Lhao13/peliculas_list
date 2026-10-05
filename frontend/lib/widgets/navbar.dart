import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.home, color: Colors.white),
            title: const Text('Menu Principal',
                style: TextStyle(color: Colors.white)),
            onTap: () {
            },
          ),

          ListTile(
            leading: const Icon(Icons.movie, color: Colors.white),
            title: const Text('Lista de peliculas vistas',
                style: TextStyle(color: Colors.white)),
            onTap: () {
            },
          ),

          ListTile(
            leading: const Icon(Icons.subscriptions_sharp, color: Colors.white),
            title: const Text('peliculas que quieres ver',
                style: TextStyle(color: Colors.white)),
            onTap: () {
            },
          ),

          ListTile(
            leading: const Icon(Icons.star, color: Colors.white),
            title: const Text('Recomendaciones',
                style: TextStyle(color: Colors.white)),
            onTap: () {
            },
          ),
          
            const SizedBox(height: 30),

          ListTile(
            leading: const Icon(Icons.settings, color: Colors.white),
            title: const Text('settings',
                style: TextStyle(color: Colors.white)),
            onTap: () {
            },
          ),
        ],
      ),
    );
  }
}