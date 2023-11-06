// ignore_for_file: avoid_print, depend_on_referenced_packages

import 'dart:convert';
import 'package:Ferrari_Scaglietti/active_page.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ApiUtils {
  static Future<Map<String, int>?> fetchDataFromBackend(
      BuildContext context) async {
    final activePageProvider =
        Provider.of<ActivePageProvider>(context, listen: false);

    if (!activePageProvider.isActivePage('Carrellista Page')) {
      // Return null if the page is not active
      return null;
    }

    const apiUrl = 'http://192.168.1.197:5000/api/OP40_Value/Pezzi';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final newNumPezziF171Spider = data['pezzi F171 SPIDER'] as int;
        final newNumPezziF171Coupe = data["pezzi F171 COUPE'"] as int;
        final newNumPezziF164FL = data["pezzi F164 FL"] as int;

        return {
          'numPezziF171Spider': newNumPezziF171Spider,
          'numPezziF171Coupe': newNumPezziF171Coupe,
          'numPezziF164FL': newNumPezziF164FL,
        };
      } else {
        print('Request failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null; // Return null for error
      }
    } catch (e) {
      print('Error: $e');
      return null; // Return null for error
    }
  }
}
