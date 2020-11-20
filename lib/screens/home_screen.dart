import 'package:book_share/screens/buy.dart';
import 'package:book_share/screens/my_chats.dart';
import 'package:book_share/screens/profile_screen.dart';
import 'package:book_share/screens/sell.dart';
import 'package:book_share/services/auth.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthMethods authMethods = new AuthMethods();

  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    MyChats(),
    BuyBooks(),
    SellBooks(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: Color(0xFF12867E),
          leading: Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
            ),
            child: Icon(
              Icons.menu_book_sharp,
              size: 35.0,
            ),
          ),
          titleSpacing: 0.0,
          title: Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8.0),
            child: Text(
              'Book Share',
              style: TextStyle(
                fontSize: 22.0,
              ),
            ),
          ),
          actions: <Widget>[
            GestureDetector(
              onTap: () async {
                try {
                  await authMethods.signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                      (Route<dynamic> route) => false);
                } catch (e) {
                  print(e.toString());
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 2.0, right: 16.0),
                child: Icon(Icons.logout),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_sharp),
            label: 'Buy',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Sell',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF12867E),
        unselectedItemColor: Colors.black54,
        unselectedFontSize: 14.0,
        selectedFontSize: 14.0,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }
}
