import 'dart:convert';

import 'package:duare/DriverSection/DriverHomePage/DriverHomePage.dart';
import 'package:duare/Redux/action.dart';
import 'package:duare/RouteTransition/routeAnimation.dart';
import 'package:duare/Screens/CategorySelectionScreen/categorySelectionScreen.dart';
import 'package:duare/Screens/GetStartedScreen/getStartedScreen.dart';
import 'package:duare/Screens/LoginScreen/loginScreen.dart';
import 'package:duare/Screens/OnBoardingScreen/onBoardingScreen.dart';
import 'package:duare/ShopOwnerSection/ShopOwnerHomepage/ShopOwnerHomepage.dart';
import 'package:duare/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;
  bool isLoading = true;
  bool firstOpen = true;

  /////////////////// Logo Animation Method Start /////////////////////
  anim() async {
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _offsetAnimation = Tween<Offset>(
      end: Offset.zero,
      begin: const Offset(0.0, -100),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.fastLinearToSlowEaseIn,
    ));
  }
  /////////////////// Logo Animation Method End /////////////////////

  /////////////////// Is the first time opended////
  startTime() async {
    await Future.delayed(new Duration(seconds: 3));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstTime = prefs.getBool('first_time');

    if (firstTime != null && !firstTime) {
      // Not first time
      _checkIfLoggedIn();
    } else {
      // First time
      prefs.setBool('first_time', false);
      setState(() {
        firstOpen = true;
      });

firstOpen ?
 Navigator.pushReplacement(context, FadeRoute(page: OnBoardingScreen())):
 Navigator.pushReplacement(context, FadeRoute(page: GetStartedScreen()));


     // FadeRoute(page: firstOpen ? OnBoardingScreen() : GetStartedScreen());
    }
  }
  /////////////////// Is the first time opended////

  ///////////////// checking if user logged in /////////////////
  bool _isLoggedIn = false;
  var userData;
  var userType;

  void _checkIfLoggedIn() async {
    // check if token is there
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');

    if (token != null) {
      setState(() {
        _isLoggedIn = true;
      });

      var user = localStorage.getString('userData');
      if (user != null) {
        setState(() {
          userData = json.decode(user);
          localStorage.setString('userData', json.encode(userData));
        });

        store.state.userInfoState = userData;
        store.dispatch(UserInfoAction(store.state.userInfoState));

        store.state.userInfoState["userType"] == "Driver" ?
      Navigator.pushReplacement(context, SlideLeftRoute(page: DriverHomepage())) :
      store.state.userInfoState["userType"] == "ShopOwner" ?
      Navigator.pushReplacement(context, SlideLeftRoute(page: ShopOwnerHomepage())) :
      Navigator.pushReplacement(context, SlideLeftRoute(page: CategorySelectionScreen()));
      } else {
        Navigator.pushReplacement(context, SlideLeftRoute(page: LoginScreen()));
      }
    } else {
      setState(() {
        _isLoggedIn = false;
      });

      Navigator.pushReplacement(context, SlideLeftRoute(page: LoginScreen()));
    }
  }
  ///////////////// checking if user logged in /////////////////

  @override
  void initState() {
    startTime();
    anim();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //////////////////// Duare Logo Start //////////////////////
              Center(
                child: Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 3.5),
                  child: SlideTransition(
                      position: _offsetAnimation,
                      child: Image.asset("assets/images/duare2 (1).png")),
                ),
              ),
              //////////////////// Duare Logo End //////////////////////

              Container(
                child: Image.asset("assets/images/img (6).png"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
