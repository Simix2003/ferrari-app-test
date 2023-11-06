import 'package:flutter/material.dart';

class ActivePageProvider with ChangeNotifier {
  String _activePage = '';

  String get activePage => _activePage;

  void setActivePage(String pageName) {
    _activePage = pageName;
    notifyListeners();
  }

  bool isActivePage(String pageName) {
    return _activePage == pageName;
  }

  void setActivePageFromRoute(String route) {
    _activePage = route;
    notifyListeners();
  }
}
