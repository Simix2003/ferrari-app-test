// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class RectangleColorsModel extends ChangeNotifier {
  Color colorForF171Spider = Colors.green;
  Color colorForF171Coupe = Colors.green;
  Color colorForF164FL = Colors.green;

  Color buttonColor = Colors.blue; // Add a property to store button color
  int F171_SpiderThreshold = 20; // Default value
  int F171_CoupeThreshold = 10; // Default value
  int F164_FLThreshold = 10; // Default value

  void updateRectangleColors(
      Color F171_spiderColor, Color F171_coupeColor, Color F164_flColor) {
    colorForF171Spider = F171_spiderColor;
    colorForF171Coupe = F171_coupeColor;
    colorForF164FL = F164_flColor;
    notifyListeners(); // Notify listeners of changes
  }

  void updateButtonColor(Color newButtonColor) {
    buttonColor = newButtonColor;
    notifyListeners(); // Notify listeners of changes
  }

  void updatePreAlarmThresholds(int newF171_SpiderThreshold,
      int newF171_CoupeThreshold, int newF164_FLThreshold) {
    F171_SpiderThreshold = newF171_SpiderThreshold;
    F171_CoupeThreshold = newF171_CoupeThreshold;
    F164_FLThreshold = newF164_FLThreshold;

    notifyListeners();
  }

  void updateData(bool lightsOn, bool colorValue) {}
}
