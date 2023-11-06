// ignore_for_file: depend_on_referenced_packages, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:Ferrari_Scaglietti/pages/loading_page.dart';
import 'package:provider/provider.dart'; // Import the Provider package
import 'rectangle_colors_model.dart'; // Import the data model
import 'active_page.dart';

void main() async {
  runApp(
    MultiProvider(
      // Use MultiProvider to provide multiple providers
      providers: [
        ChangeNotifierProvider(create: (context) => RectangleColorsModel()),
        ChangeNotifierProvider(create: (_) => ActivePageProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Define a custom theme for your app
    final ThemeData theme = ThemeData(
      primaryColor:
          const Color.fromARGB(255, 252, 36, 0), // Red as accent color
      scaffoldBackgroundColor:
          const Color.fromARGB(255, 252, 36, 0), // Red background
      textTheme: const TextTheme(
        // Customize text colors
        bodyText2: TextStyle(color: Colors.black), // Customize text color
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: Colors.white, // Set the button background color to white
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(
          color: Colors.black, // Set the label text color to black
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(
                255, 252, 36, 0), // Set the focused border color to red
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(
                255, 252, 36, 0), // Set the enabled border color to red
          ),
        ),
      ),
      colorScheme: ColorScheme.fromSwatch()
          .copyWith(secondary: const Color.fromARGB(255, 252, 36, 0)),
    );

    return MaterialApp(
        theme: theme, // Apply the custom theme
        debugShowCheckedModeBanner: false,
        home: const LoadingPage()); // Show the LoadingPage initially
  }
}
