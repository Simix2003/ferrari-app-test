// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:Ferrari_Scaglietti/pages/auth_page.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    _navigateToLoginPage(); // No need to pass context here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 36, 0),
      body: Center(
        child: Image.asset(
          'lib/images/loading.gif',
          width: 200,
          height: 200,
        ),
      ),
    );
  }

  Future<void> _navigateToLoginPage() async {
    await Future.delayed(const Duration(seconds: 5));
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const AuthPage()),
    );
  }
}
