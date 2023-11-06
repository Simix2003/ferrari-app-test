// ignore_for_file: unused_local_variable, depend_on_referenced_packages, camel_case_types, library_private_types_in_public_api, non_constant_identifier_names, no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_notifications/awesome_notifications.dart';

class Carrellista_Page extends StatefulWidget {
  const Carrellista_Page({Key? key}) : super(key: key);

  @override
  _CarrellistaPageState createState() => _CarrellistaPageState();
}

class _CarrellistaPageState extends State<Carrellista_Page> {
  int num_pezzi = 0;

  @override
  void initState() {
    super.initState();
    fetchDataFromBackend_Carrellista(); // Initial fetch
    Timer.periodic(const Duration(seconds: 1), (timer) {
      fetchDataFromBackend_Carrellista();
    });
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  createNotification() {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 10,
            channelKey: 'basic',
            title: 'Allerta Mancanza Pezzi',
            body: 'I pezzi nella stazione OP40 sono terminati'));
  }

  Future<void> fetchDataFromBackend_Carrellista() async {
    String apiUrl = 'http://192.168.1.157:5000/api/Carrellista_Value';

    try {
      var response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        int newNumPezzi = (data['pezzi'] as int);

        // Only update if the value has changed
        if (newNumPezzi != num_pezzi) {
          setState(() {
            num_pezzi = newNumPezzi;
            if (num_pezzi == 0) {
              createNotification();
              print('AOOOOOO');
            }
          });
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> Update_Pezzi_Value(int newValue) async {
    String apiUrl = 'http://192.168.1.157:5000/api/Carrellista_Value';

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({"pezzi": newValue}),
      );
      if (response.statusCode == 200) {
        print('Int value updated successfully.');
      } else {
        print(
            'Failed to update Int value. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _openUpdatePopup() async {
    int updatedValue = await showDialog(
      context: context,
      builder: (BuildContext context) {
        int inputValue = 0;
        return AlertDialog(
          title: const Text('Aggiungi Pezzi'),
          content: TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              inputValue = int.tryParse(value) ?? 0;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(inputValue);
                Update_Pezzi_Value(inputValue);
              },
              child: const Text('Aggiorna'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Color rectangleColor = Colors.green; // Default color
    if (num_pezzi < 5) {
      rectangleColor = Colors.orange;
    }
    if (num_pezzi == 0) {
      rectangleColor = Colors.red;
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'lib/images/Layout_Fake.png', // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            left: 50, // Change these coordinates as needed
            top: 100, // Change these coordinates as needed
            child: GestureDetector(
              onTap: () {
                _openUpdatePopup();
              },
              child: Container(
                width: 200,
                height: 100,
                color: rectangleColor, // Apply the color here
                child: Center(
                  child: Text(
                    'Num Pezzi: $num_pezzi',
                    key: ValueKey<int>(num_pezzi),
                    style: const TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
