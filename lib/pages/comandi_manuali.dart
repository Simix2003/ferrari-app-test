// ignore_for_file: library_private_types_in_public_api, depend_on_referenced_packages, avoid_print

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class ShopPage extends StatefulWidget {
  const ShopPage({Key? key}) : super(key: key);

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  List<Light> lights = [
    Light(label: 'Luce Bagno', value: false, colorValue: false),
    Light(label: 'Luce Cucina', value: false, colorValue: false),
    Light(label: 'Luce Soggiorno', value: false, colorValue: false)
  ];

  Timer? _timer; // Declare the timer variable

  @override
  void initState() {
    super.initState();
    connectToPLC();
    fetchDataFromBackend();

    // Start the periodic timer and assign it to the _timer variable
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      fetchDataFromBackend();
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer?.cancel();
    super.dispose();
  }

  Future<void> fetchDataFromBackend() async {
    String apiUrl = 'http://192.168.1.190:5000/api/value_luce_bagno_sopra';

    try {
      var response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        bool lightsOn = (data['value'] as List<dynamic>)[0] as bool;
        bool colorValue = (data['value'] as List<dynamic>)[1] as bool;

        setState(() {
          for (var light in lights) {
            light.value = lightsOn;
            light.colorValue = colorValue;
          }
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> updateBoolValue(bool newValue) async {
    String apiUrl = 'http://192.168.1.190:5000/api/value_luce_bagno_sopra';

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({"value": newValue}),
      );
      if (response.statusCode == 200) {
        print('Boolean value updated successfully.');
      } else {
        print(
            'Failed to update boolean value. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: lights.map((light) {
              return buildButton(
                context,
                light.label,
                light.value,
                light.colorValue,
                () {
                  turnOnOffLights(light);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget buildButton(BuildContext context, String label, bool isOn,
      bool colorValue, VoidCallback onPressed) {
    String iconImage = isOn ? 'Images/Spark_Bulb.png' : 'Images/Light_Bulb.png';

    Widget icon = Image.asset(iconImage);

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 200,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[200],
          gradient: colorValue
              ? const LinearGradient(
                  colors: [Color(0xFFFA9261), Color(0xFFFF736F)],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                )
              : null,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            icon,
            Positioned(
              bottom: 0,
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void connectToPLC() async {
    print('CONNECTING');
    await fetchDataFromBackend();
  }

  void turnOnOffLights(Light light) async {
    await updateBoolValue(true);
    fetchDataFromBackend();
  }
}

class Light {
  final String label;
  bool value;
  bool colorValue;

  Light({required this.label, required this.value, required this.colorValue});
}
