import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seller/constants/vars.dart';

import 'home_screen.dart';
import 'my_profile_screen.dart';
import 'notification_screen.dart';
import 'order_screen.dart';

class NavigatorScreen extends StatefulWidget {
  static const routeName = '/navigator';
  @override
  _NavigatorScreenStates createState() => _NavigatorScreenStates();
}

class _NavigatorScreenStates extends State<NavigatorScreen> {
  int _selectedIndex = 0;
  final List<Widget> _children = [
    HomeScreen(),
    OrderScreen(),
    NotificationScreen(),
    MyProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        body: _children[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text(homePageMM),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              title: Text(orderPageMM),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              title: Text(notificationPageMM),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              title: Text(accountPageMM),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).primaryColor,
          selectedFontSize: 12,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
