import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../about_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  // method to log user out
  void logUserOut() {
    // Add your logout logic here if needed.

    // Close the app
    SystemNavigator.pop();
    Future.delayed(Duration.zero, () {
      // Restart the app
      exit(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 188, 0, 0),
      child: Column(
        children: [
          // Drawer header
          DrawerHeader(
            child: Center(
              child: CachedNetworkImage(
                imageUrl: 'https://i.imgur.com/2OlcWq5.png',
                placeholder: (context, url) => CircularProgressIndicator(),
                width: 185,
                height: 185,
              ),
            ),
          ),

          const SizedBox(height: 25),

          // ABOUT PAGE
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutPage(),
                  ),
                );
              },
              child: const ListTile(
                leading: Icon(Icons.info, color: Colors.white),
                title: Text(
                  "A B O U T",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),

          // LOGOUT BUTTON
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.white),
              onTap: () => logUserOut(),
              title: const Text(
                "L O G O U T",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
