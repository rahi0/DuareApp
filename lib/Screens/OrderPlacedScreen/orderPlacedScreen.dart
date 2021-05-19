import 'package:duare/Screens/BottomNavBarScreen/bottomNavBarScreen.dart';
import 'package:duare/Screens/BottomNavigationPages/OrdersPage/ordersPage.dart';
import 'package:flutter/material.dart';
import 'package:duare/RouteTransition/routeAnimation.dart';

class OrderPlacedScreen extends StatefulWidget {
  @override
  _OrderPlacedScreenState createState() => _OrderPlacedScreenState();
}

class _OrderPlacedScreenState extends State<OrderPlacedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Finish',
          style: TextStyle(
            fontFamily: 'poppins',
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 18, right: 18, top: 25),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    // height: 85,
                    // margin: EdgeInsets.only(right: 18),
                    child: Image.asset(
                      "assets/images/dotsBg.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: Color(0xFF00B658),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check,
                            // FlutterIcons.check_ent,
                            color: Colors.white,
                            size: 35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 50, bottom: 19),
              child: Text(
                'Order Placed',
                style: TextStyle(
                  fontFamily: 'poppins',
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 18, right: 18),
              child: Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'poppins',
                  color: Color(0xFF333436).withOpacity(0.5),
                  fontSize: 14,
                  // fontWeight: FontWeight.w500,
                ),
              ),
            ),

            //////////// Track Order button start ///////////
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    ScaleRoute(
                      page: BottomNavBarScreen(2),
                    ));
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 15, bottom: 15),
                margin: EdgeInsets.only(top: 50, bottom: 25),
                decoration: BoxDecoration(
                  color: Color(0xFF0487FF),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  'Track Order',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            //////////// Track Order button end /////////////
          ],
        ),
      ),
    );
  }
}
