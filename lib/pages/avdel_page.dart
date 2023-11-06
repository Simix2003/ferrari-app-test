// ignore_for_file: unused_local_variable, library_private_types_in_public_api, depend_on_referenced_packages, non_constant_identifier_names, avoid_print

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class AvdelPage extends StatefulWidget {
  const AvdelPage({Key? key}) : super(key: key);

  @override
  _AvdelPageState createState() => _AvdelPageState();
}

class _AvdelPageState extends State<AvdelPage>
    with AutomaticKeepAliveClientMixin<AvdelPage> {
  bool lightsOn = false;
  bool colorValue = false;
  int countdown = 5;
  Timer? countdownTimer;
  Timer? periodicTimer;
  StreamController<int> countdownStreamController = StreamController<int>();
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    connectToPLC();

    periodicTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      await fetchDataFromBackend_Avdel();
    });
  }

  @override
  void dispose() {
    periodicTimer?.cancel();
    super.dispose();
  }

  Future<void> fetchDataFromBackend_Avdel() async {
    const apiUrl = 'http://192.168.1.197:5000/api/Avdel_Bool';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final bool lightsOn = data['value'] as bool;
        final bool colorValue = data['color_status'] as bool;
        // Handle other updates as needed
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> updateBoolValue(bool newValue) async {
    String apiUrl = 'http://192.168.1.197:5000/api/Avdel_Bool';

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

  void connectToPLC() async {
    print('CONNECTING');
    await fetchDataFromBackend_Avdel();
  }

  void startCountdown() {
    countdown = 5;
    countdownStreamController.add(countdown);
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown > 0) {
        countdown--;
        countdownStreamController.add(countdown);
      } else {
        countdownTimer?.cancel();
        countdownTimer = null;
        countdownStreamController.add(-1); // Signal to hide the countdown
      }
    });
  }

  void StartAvdel_P1() async {
    if (colorValue == false) {
      startCountdown();
      await Future.delayed(Duration(seconds: countdown), () async {
        await updateBoolValue(true);
        fetchDataFromBackend_Avdel();
        await Future.delayed(const Duration(seconds: 3));
        fetchDataFromBackend_Avdel();
      });
    } else {
      await updateBoolValue(true);
      fetchDataFromBackend_Avdel();
      await Future.delayed(const Duration(seconds: 3));
      fetchDataFromBackend_Avdel();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 36, 0),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: GridView.builder(
          itemCount: 1,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
          ),
          itemBuilder: (context, index) => buildGridItem(context, index),
        ),
      ),
    );
  }

  Widget buildGridItem(BuildContext context, int index) {
    return buildButton(context, 'Start Avdel P1', StartAvdel_P1);
  }

  Widget buildButton(
      BuildContext context, String label, VoidCallback onPressed) {
    String iconImage = colorValue
        ? 'lib/images/Closed_Pinza.png'
        : 'lib/images/Opened_Pinza.png';

    Widget icon = Image.asset(iconImage);

    return Column(
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(), backgroundColor: colorValue ? Colors.green : Colors.grey[200],
          ),
          child: Container(
            width: 100,
            height: 100,
            padding: const EdgeInsets.all(10),
            child: icon,
          ),
        ),
        const SizedBox(height: 10), // Add spacing between button and text
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10), // Add spacing between text and countdown
        StreamBuilder<int>(
          stream: countdownStreamController.stream,
          builder: (context, snapshot) {
            int currentCountdown = snapshot.data ?? countdown;
            if (currentCountdown > 0) {
              return Text(
                '$currentCountdown',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              );
            } else {
              return const SizedBox(); // Hide the countdown when <= 0
            }
          },
        ),
      ],
    );
  }
}
