import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 188, 0, 0),
        elevation: 0,
        title: const Text(
          'A B O U T',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: const Center(
          child: Text('App progettata e Sviluppata da Simone Paparo')),
    );
  }
}
