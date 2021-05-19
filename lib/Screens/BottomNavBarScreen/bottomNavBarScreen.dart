import 'dart:io';

import 'package:duare/Screens/BottomNavigationPages/AccountPage/accountPage.dart';
import 'package:duare/Screens/BottomNavigationPages/HomePage/homePage.dart';
import 'package:duare/Screens/BottomNavigationPages/OrdersPage/ordersPage.dart';
import 'package:duare/Screens/BottomNavigationPages/SearchPage/searchPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class BottomNavBarScreen extends StatefulWidget {

  // int c=0;
  // BottomNavBarScreen(this.c);
  var navIndex;
  BottomNavBarScreen(this.navIndex);

  @override
  _BottomNavBarScreenState createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {
  int _currentIndex = 0;
  bool loading = true;

  final List<Widget> _bottomNavPages = [
    HomePage(),
    SearchPage(),
    OrdersPage(),
    AccountPage(),
  ];

  @override
  void initState() {
    _currentIndex = widget.navIndex;
    if(!mounted) return;
    setState(() {
      loading = false;
    });
    super.initState();
  }

  

  //
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            //   title: new Text('Are you sure?'),
            content: new Text('Are you sure you want to exit this app?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text(
                  'No',
                  // style: TextStyle(color: appColor),
                ),
              ),
              new FlatButton(
                onPressed: () => exit(0),
                child: new Text(
                  'Yes',
                  // style: TextStyle(color: appColor),
                ),
              ),
            ],
          ),
        )) ??
        false;
  }
  //

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: loading ? Center(
                child: SpinKitCircle(
                  color: Color(0xFF0487FF),
                  // size: 30,
                 ),
              ) :
              Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: Container(
          height: 84,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.06),
                blurRadius: 10,
                spreadRadius: 0,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _currentIndex = 0;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FlutterIcons.home_fea,
                      color: _currentIndex == 0
                          ? Color(0xFF0487FF)
                          : Color(0xFF7C7C7C),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Home',
                      style: TextStyle(
                        fontFamily: 'poppins',
                        color: _currentIndex == 0
                            ? Color(0xFF0487FF)
                            : Color(0xFF7C7C7C),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _currentIndex = 1;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FlutterIcons.search_fea,
                      size: 26,
                      color: _currentIndex == 1
                          ? Color(0xFF0487FF)
                          : Color(0xFF7C7C7C),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Search',
                      style: TextStyle(
                        fontFamily: 'poppins',
                        color: _currentIndex == 1
                            ? Color(0xFF0487FF)
                            : Color(0xFF7C7C7C),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _currentIndex = 2;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FlutterIcons.file_text_fea,
                      color: _currentIndex == 2
                          ? Color(0xFF0487FF)
                          : Color(0xFF7C7C7C),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Orders',
                      style: TextStyle(
                        fontFamily: 'poppins',
                        color: _currentIndex == 2
                            ? Color(0xFF0487FF)
                            : Color(0xFF7C7C7C),
                        fontSize: 10,
                      ),
                    ),  
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {   
                    _currentIndex = 3;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FlutterIcons.user_fea,
                      color: _currentIndex == 3
                          ? Color(0xFF0487FF)
                          : Color(0xFF7C7C7C),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Account',
                      style: TextStyle(
                        fontFamily: 'poppins',
                        color: _currentIndex == 3
                            ? Color(0xFF0487FF)
                            : Color(0xFF7C7C7C),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: _bottomNavPages[_currentIndex],
      ),
    );
  }
}
