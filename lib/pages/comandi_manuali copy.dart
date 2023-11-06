import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class ShopPage extends StatefulWidget {
  const ShopPage({Key? key}) : super(key: key);

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  bool lightsOn = false; // Represents the state of the lights
  bool colorValue = false; // Represents the color status of the button

  @override
  void initState() {
    super.initState();
    connectToPLC(); // Automatically connect to PLC and fetch its state on app launch
    fetchDataFromBackend();

    // Start a periodic timer to update the state every 10 seconds
    Timer.periodic(Duration(seconds: 10), (timer) {
      fetchDataFromBackend();
    });
  }

  Future<void> fetchDataFromBackend() async {
    String apiUrl = 'http://192.168.1.157:5000/api/bool_value';

    try {
      var response = await http.get(Uri.parse(apiUrl));
      print(
          response.body); // Print the API response to the console for debugging
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        bool lightsOn = (data['value'] as List<dynamic>)[0] as bool;
        bool colorValue = (data['value'] as List<dynamic>)[1] as bool;
        setState(() {
          this.lightsOn = lightsOn; // Update the lights state
          this.colorValue = colorValue; // Update the color status
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> updateBoolValue(bool newValue) async {
    String apiUrl = 'http://192.168.1.157:5000/api/bool_value';

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: GridView.builder(
          itemCount: 1, // Show only one grid item for the button
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1, // Display one button in a row
          ),
          itemBuilder: (context, index) => buildGridItem(context, index),
        ),
      ),
    );
  }

  Widget buildGridItem(BuildContext context, int index) {
    return buildButton(context, 'Luce Bagno Sopra', turnOnOffLights);
  }

  Widget buildButton(
      BuildContext context, String label, VoidCallback onPressed) {
    String iconImage =
        colorValue ? 'Images/Spark_Bulb.png' : 'Images/Light_Bulb.png';

    // Use the Image.asset widget to display the PNG image
    Widget icon = Image.asset(iconImage);

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 200,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[200], // Default grey color when light is off
          gradient: colorValue
              ? const LinearGradient(
                  colors: [Color(0xFFFA9261), Color(0xFFFF736F)],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                )
              : null, // No gradient if light is off
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            icon,
            Positioned(
              bottom: 0,
              child: Text(
                label,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void connectToPLC() async {
    print('CONNECTING');
    await fetchDataFromBackend(); // Automatically fetch the PLC state on app launch
  }

  void turnOnOffLights() async {
    // Implement the logic to toggle the lights here
    // For this example, we'll update the boolean value to its opposite in the backend
    await updateBoolValue(true); // Toggle the lights ON/OFF
    fetchDataFromBackend(); // Fetch the updated PLC state
  }
}
