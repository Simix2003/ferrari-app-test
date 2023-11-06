// ignore: unused_import
// ignore_for_file: no_logic_in_create_state, use_key_in_widget_constructors, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:Ferrari_Scaglietti/pages/avdel_page.dart';
import 'package:Ferrari_Scaglietti/pages/carrellista_page.dart';
import 'pages/components/my_bottom_nav_bar.dart';
import 'pages/components/my_drawer.dart';
import 'pages/setting_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.initialIndex});

  final int initialIndex;

  @override
  State<MainPage> createState() => _MainPageState(initialIndex: 0);
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex;

  _MainPageState({required int initialIndex}) : _selectedIndex = initialIndex;

  // This method will update our selected index
  // when the user taps on the bottom nav bar
  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // pages to display
  final List<Widget> _pages = [
    const AvdelPage(),
    const Carrellista_Page(),
    SettingsPage(),
  ];

  // A function to create the page associated with the selected index
  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return const AvdelPage();
      case 1:
        return const Carrellista_Page();
      case 2:
        return SettingsPage();
      default:
        return Container(); // Return an empty container for an unknown index
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 252, 36, 0),
      ),
      drawer: const MyDrawer(),
      body: _buildPage(_selectedIndex), // Create the page dynamically
      bottomNavigationBar: MyBottomNavBar(
        onTabChange: (index) {
          if (_selectedIndex != index) {
            // If the selected index changes, dispose of the previous page
            final previousPage = _pages[_selectedIndex];
            if (previousPage is StatefulWidget) {
              final previousState = previousPage.createState();
              previousState.dispose();
            }

            // Update the selected index
            navigateBottomBar(index);
          }
        },
      ),
    );
  }
}
