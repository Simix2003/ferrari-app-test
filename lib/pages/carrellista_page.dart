// ignore_for_file: library_private_types_in_public_api, camel_case_types, unnecessary_null_comparison, non_constant_identifier_names, use_build_context_synchronously, avoid_print

import 'package:Ferrari_Scaglietti/pages/Op40Page.dart';
import 'package:Ferrari_Scaglietti/rectangle_colors_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'utils/api_utils.dart';
import 'dart:async';

class Carrellista_Page extends StatefulWidget {
  const Carrellista_Page({Key? key}) : super(key: key);

  @override
  _CarrellistaPageState createState() => _CarrellistaPageState();
}

class _CarrellistaPageState extends State<Carrellista_Page> {
  Timer? periodicTimer;

  @override
  void initState() {
    super.initState();
    periodicTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      await fetchDataAndUpdateColors();
    });
  }

  @override
  void dispose() {
    periodicTimer?.cancel();
    super.dispose();
  }

  Future<void> fetchDataAndUpdateColors() async {
    try {
      final fetchedData = await ApiUtils.fetchDataFromBackend(context);
      if (fetchedData != null && fetchedData.isNotEmpty) {
        final F171_spiderColor =
            getColorFromPezziValue(fetchedData['numPezziF171Spider'] ?? 0);
        final F171_coupeColor =
            getColorFromPezziValue(fetchedData['numPezziF171Coupe'] ?? 0);
        final F164_flColor =
            getColorFromPezziValue(fetchedData['numPezziF164FL'] ?? 0);

        final rectangleColorsModel =
            Provider.of<RectangleColorsModel>(context, listen: false);
        rectangleColorsModel.updateRectangleColors(
            F171_spiderColor, F171_coupeColor, F164_flColor);
        updateButtonColor(rectangleColorsModel);
      } else {
        print('Fetched data is null or empty');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void updateButtonColor(RectangleColorsModel rectangleColorsModel) {
    Color buttonColor;

    if (rectangleColorsModel.colorForF171Coupe == Colors.orange ||
        rectangleColorsModel.colorForF171Spider == Colors.orange ||
        rectangleColorsModel.colorForF164FL == Colors.orange) {
      buttonColor = Colors.orange;
    } else if (rectangleColorsModel.colorForF171Coupe == Colors.red ||
        rectangleColorsModel.colorForF171Spider == Colors.red ||
        rectangleColorsModel.colorForF164FL == Colors.red) {
      buttonColor = Colors.red;
    } else {
      buttonColor = Colors.green;
    }

    rectangleColorsModel.updateButtonColor(buttonColor);
  }

  Color getColorFromPezziValue(int numPezzi) {
    if (numPezzi <= 5 && numPezzi != 0) {
      return Colors.orange;
    } else if (numPezzi == 0) {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RectangleColorsModel>(
      builder: (context, rectangleColorsModel, _) {
        final buttonColor = rectangleColorsModel.buttonColor;
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
                left: 50,
                top: 250,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OP40Page(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                  ),
                  child: const Text('OP40 Button'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
