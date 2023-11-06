// ignore_for_file: depend_on_referenced_packages, non_constant_identifier_names, library_private_types_in_public_api, use_build_context_synchronously, avoid_print, file_names

import 'dart:async';
import 'dart:convert';
import 'package:Ferrari_Scaglietti/rectangle_colors_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'utils/api_utils.dart';

class OP40Page extends StatefulWidget {
  const OP40Page({Key? key}) : super(key: key);

  @override
  _OP40PageState createState() => _OP40PageState();
}

class _OP40PageState extends State<OP40Page> {
  int? numPezziF171Spider;
  int? numPezziF171Coupe;
  int? numPezziF164FL;
  int F171SpiderThreshold = 20;
  int F171CoupeThreshold = 10;
  int F164FLThreshold = 10;

  Color rectangleColorF171Spider = Colors.green;
  Color rectangleColorF171Coupe = Colors.green;
  Color rectangleColorF164FL = Colors.green;

  Timer? periodicTimer;

  @override
  void initState() {
    super.initState();
    periodicTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      fetchDataFromBackend();
    });
  }

  @override
  void dispose() {
    periodicTimer?.cancel();
    super.dispose();
  }

  void fetchDataFromBackend() async {
    try {
      final data = await ApiUtils.fetchDataFromBackend(context);

      if (data != null) {
        final newNumPezziF171Spider = data['numPezziF171Spider'];
        final newNumPezziF171Coupe = data['numPezziF171Coupe'];
        final newNumPezziF164FL = data['numPezziF164FL'];

        setState(() {
          numPezziF171Spider = newNumPezziF171Spider;
          numPezziF171Coupe = newNumPezziF171Coupe;
          numPezziF164FL = newNumPezziF164FL;
          updateRectangleColor();
        });

        Color F171SpiderColor = getColorFromPezziValue(numPezziF171Spider!, 1);
        Color F171CoupeColor = getColorFromPezziValue(numPezziF171Coupe!, 2);
        Color F164FLColor = getColorFromPezziValue(numPezziF164FL!, 3);
        Provider.of<RectangleColorsModel>(context, listen: false)
            .updateRectangleColors(
                F171SpiderColor, F171CoupeColor, F164FLColor);
      } else {
        // Handle the case where the fetched data is null
        print('Invalid data received from the backend.');
      }
    } catch (e) {
      print('Error fetching data from the backend: $e');
    }
  }

  void updateRectangleColor() {
    var rectangleColorsModel =
        Provider.of<RectangleColorsModel>(context, listen: false);
    rectangleColorsModel.updateRectangleColors(
        getColorFromPezziValue(numPezziF171Spider!, 1),
        getColorFromPezziValue(numPezziF171Coupe!, 2),
        getColorFromPezziValue(numPezziF164FL!, 3));
  }

  Color getColorFromPezziValue(int numPezzi, int indexSettings) {
    final rectangleColorsModel =
        Provider.of<RectangleColorsModel>(context, listen: false);
    final threshold = indexSettings == 1
        ? rectangleColorsModel.F171_SpiderThreshold
        : indexSettings == 2
            ? rectangleColorsModel.F171_CoupeThreshold
            : rectangleColorsModel.F164_FLThreshold;

    if (numPezzi <= threshold && numPezzi != 0) {
      return Colors.orange;
    } else if (numPezzi == 0) {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }

  Future<void> _openUpdatePopupF171Spider() async {
    int? updatedValue = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        int inputValue = 0;
        return AlertDialog(
          title: const Text('Pezzi F171 Spider Aggiunti'),
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
              },
              child: const Text('Aggiorna'),
            ),
          ],
        );
      },
    );

    if (updatedValue != null) {
      int newValue = updatedValue + (numPezziF171Spider ?? 0);
      updateNumPezzi_F171Spider(newValue);
    }
  }

  Future<void> _openUpdatePopupF171Coupe() async {
    int? updatedValue = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        int inputValue = 0;
        return AlertDialog(
          title: const Text("Pezzi F171 Coupe' Aggiunti"),
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
              },
              child: const Text('Aggiorna'),
            ),
          ],
        );
      },
    );

    if (updatedValue != null) {
      int newValue = updatedValue + (numPezziF171Coupe ?? 0);
      updateNumPezzi_F171Coupe(newValue);
    }
  }

  Future<void> _openUpdatePopupF164FL() async {
    int? updatedValue = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        int inputValue = 0;
        return AlertDialog(
          title: const Text("Pezzi F164 FL Aggiunti"),
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
              },
              child: const Text('Aggiorna'),
            ),
          ],
        );
      },
    );

    if (updatedValue != null) {
      int newValue = updatedValue + (numPezziF164FL ?? 0);
      updateNumPezzi_F164FL(newValue);
    }
  }

  Future<void> updateNumPezzi_F171Spider(int newValue) async {
    const apiUrl = 'http://192.168.1.197:5000/api/OP40_Value/Pezzi';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({"numPezziF171Spider": newValue}),
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

  Future<void> updateNumPezzi_F171Coupe(int newValue) async {
    const apiUrl = 'http://192.168.1.197:5000/api/OP40_Value/Pezzi';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({"numPezziF171Coupe": newValue}),
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

  Future<void> updateNumPezzi_F164FL(int newValue) async {
    const apiUrl = 'http://192.168.1.197:5000/api/OP40_Value/Pezzi';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({"numPezziF164FL": newValue}),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 252, 36, 0),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'lib/images/Layout_Fake.png',
              fit: BoxFit.cover,
            ),
          ),

          // RECTANGLE F171 SPIDER
          Positioned(
            left: 50,
            top: 100,
            child: GestureDetector(
              onTap: () {
                _openUpdatePopupF171Spider();
              },
              child: Container(
                width: 200,
                height: 100,
                color: getColorFromPezziValue(numPezziF171Spider ?? 0, 1),
                child: Center(
                  child: Text(
                    'F171 Spider: ${numPezziF171Spider ?? 0}',
                    style: const TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),

          // RECTANGLE F171 COUPE'
          Positioned(
            left: 300,
            top: 250,
            child: GestureDetector(
              onTap: () {
                _openUpdatePopupF171Coupe();
              },
              child: Container(
                width: 200,
                height: 100,
                color: getColorFromPezziValue(numPezziF171Coupe ?? 0, 2),
                child: Center(
                  child: Text(
                    "F171 Coupe': ${numPezziF171Coupe ?? 0}",
                    style: const TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),

          // RECTANGLE F164 FL
          Positioned(
            left: 550,
            top: 100,
            child: GestureDetector(
              onTap: () {
                _openUpdatePopupF164FL();
              },
              child: Container(
                width: 200,
                height: 100,
                color: getColorFromPezziValue(numPezziF164FL ?? 0, 3),
                child: Center(
                  child: Text(
                    "F164 FL': ${numPezziF164FL ?? 0}",
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
