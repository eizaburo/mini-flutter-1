import 'package:flutter/material.dart';

import './home.dart';
import './contact.dart';

class BottomTab extends StatefulWidget {
  const BottomTab({super.key});

  @override
  State<BottomTab> createState() => BottomTabState();
}

class BottomTabState extends State<BottomTab> {
  int selectedIndex = 0;

  static const List<Widget> widgetOptions = <Widget>[Home(), Contact()];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: widgetOptions.elementAt(selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.mail), label: "Contact"),
        ],
        currentIndex: selectedIndex,
        onTap: onItemTapped,
      ),
    );
  }
}
