// ignore_for_file: unused_import, library_private_types_in_public_api, prefer_const_constructors

import 'package:Ferrari_Scaglietti/main_page.dart';
import 'package:Ferrari_Scaglietti/pages/login_page.dart';
import 'package:Ferrari_Scaglietti/pages/sql_login.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController codeController = TextEditingController();
  final DatabaseService databaseService = DatabaseService();
  bool isLoading = false; // Track loading state

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 36, 0), // Red background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Big Title
            Padding(
              padding: const EdgeInsets.only(
                  top: 10.0), // Adjust the top padding as needed
              child: Text(
                'Buongiorno', // Replace with your desired title text
                style: TextStyle(
                  fontSize: 24, // Adjust the font size as needed
                  fontWeight: FontWeight.bold, // Add bold style if desired
                  color: Colors.black, // Customize the text color
                ),
              ),
            ),
            // Keypad for entering the 4-digit code
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: codeController,
                keyboardType: TextInputType.number,
                maxLength: 10,
                style: TextStyle(
                  color: Colors.black, // Set the input text color to black
                ),
                decoration: InputDecoration(
                  labelText: 'Scannerizzare Badge',
                  labelStyle: TextStyle(
                    color: Colors.black, // Set the label text color to black
                  ),
                  counterText: '',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 255, 255,
                          255), // Set the focused border color to red
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 255, 255,
                          255), // Set the enabled border color to red
                    ),
                  ),
                ),
              ),
            ),
            // Button to submit the code with loading animation
            ElevatedButton(
              onPressed: isLoading
                  ? null // Disable the button when loading
                  : () {
                      // Check if the entered code is correct
                      final enteredCode = codeController.text;
                      setState(() {
                        isLoading = true; // Set loading state to true
                      });

                      Future.delayed(Duration(milliseconds: 100), () {
                        // Simulate some background work for 100 milliseconds
                        databaseService
                            .verifyCode(enteredCode)
                            .then((isCorrect) {
                          if (isCorrect) {
                            // Navigate to MainPage if code is correct
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => MainPage(initialIndex: 0,)),
                            );
                          } else {
                            // Show an error message or retry option
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "Badge Inesistente! Contattare l'amministrazione."),
                              ),
                            );
                            setState(() {
                              isLoading = false; // Set loading state to false
                            });
                          }
                        });
                      });
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.white, // Set the button background color to white
              ),
              child: isLoading
                  ? CircularProgressIndicator(
                      // Show a loading indicator when loading
                      valueColor: AlwaysStoppedAnimation<Color>(
                        const Color.fromARGB(255, 252, 36, 0),
                      ),
                    )
                  : Text(
                      'Entra',
                      style: TextStyle(
                        color: Colors.black, // Set the text color to black
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
