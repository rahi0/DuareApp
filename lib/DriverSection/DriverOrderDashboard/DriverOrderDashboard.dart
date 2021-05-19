import 'package:duare/DriverSection/DriverDrawer/DriverDrawer.dart';
import 'package:duare/DriverSection/DriverOrderDashboard/DriverOrderTabPages/DriverDeliveredOrdersTab.dart';
import 'package:duare/DriverSection/DriverOrderDashboard/DriverOrderTabPages/DriverNewOrdersTab.dart';
import 'package:duare/DriverSection/DriverOrderDashboard/DriverOrderTabPages/DriverPickupOrdersTab.dart';
import 'package:duare/DriverSection/DriverOrderDashboard/DriverOrderTabPages/DriverProcessingOrdersTab.dart';
import 'package:duare/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DriverOrderDashboard extends StatefulWidget {
  @override
  _DriverOrderDashboardState createState() => _DriverOrderDashboardState();
}

class _DriverOrderDashboardState extends State<DriverOrderDashboard> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: DriverDrawer(),
        appBar: AppBar(
          backgroundColor: appColor,
          title: Text(
            "Today's Orders",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              fontFamily: 'poppins',
            ),
          ),
          bottom: TabBar(
            isScrollable: true,
            labelColor: Colors.white,
            // unselectedLabelColor: Colors.grey,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(width: 2.5, color: Colors.white),
              insets: EdgeInsets.symmetric(horizontal: 10.0),
            ),
            labelStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              fontFamily: 'poppins',
            ),
            tabs: [
              Tab(
                text: "New Orders",
              ),
              Tab(
                text: "Processing",
              ),
              Tab(
                text: "Pickup",
              ),
              Tab(
                text: "Delivered",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            DriverNewOrdersTab(),
            DriverProcessingOrdersTab(),
            DriverPickupOrdersTab(),
            DriverDeliveredOrdersTab(),
          ],
        ),
      ),
      // ),
    );
  }
}
