// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Ferrari_Scaglietti/rectangle_colors_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController F171_SpiderController = TextEditingController();
  final TextEditingController F171_CoupeController = TextEditingController();
  final TextEditingController F164_FLController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadSavedValues();
  }

  void loadSavedValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int F171_SpiderThreshold = prefs.getInt('F171_SpiderThreshold') ?? 0;
    int F171_CoupeThreshold = prefs.getInt('F171_CoupeThreshold') ?? 0;
    int F164_FLThreshold = prefs.getInt('F164_FLThreshold') ?? 0;
    F171_SpiderController.text = F171_SpiderThreshold.toString();
    F171_CoupeController.text = F171_CoupeThreshold.toString();
    F164_FLController.text = F164_FLThreshold.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primarySwatch: Colors.red,
      ),
      child: Scaffold(
        body: Column(
          children: [
            TextField(
              controller: F171_SpiderController,
              decoration:
                  const InputDecoration(labelText: 'F171 Spider Pre Allarme'),
            ),
            TextField(
              controller: F171_CoupeController,
              decoration:
                  const InputDecoration(labelText: 'F171 Coupe Pre Allarme'),
            ),
            TextField(
              controller: F164_FLController,
              decoration:
                  const InputDecoration(labelText: 'F164 FL Pre Allarme'),
            ),
            ElevatedButton(
              onPressed: () async {
                final int newF171_SpiderThreshold =
                    int.parse(F171_SpiderController.text);
                final int newF171_CoupeThreshold =
                    int.parse(F171_CoupeController.text);
                final int newF164_FLThreshold =
                    int.parse(F164_FLController.text);

                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setInt('F171_SpiderThreshold', newF171_SpiderThreshold);
                prefs.setInt('F171_CoupeThreshold', newF171_CoupeThreshold);
                prefs.setInt('F164_FLThreshold', newF164_FLThreshold);

                Provider.of<RectangleColorsModel>(context, listen: false)
                    .updatePreAlarmThresholds(newF171_SpiderThreshold,
                        newF171_CoupeThreshold, newF164_FLThreshold);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
