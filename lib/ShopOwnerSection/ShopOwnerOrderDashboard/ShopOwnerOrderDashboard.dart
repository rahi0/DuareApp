import 'package:duare/ShopOwnerSection/ShopOwnerDrawer/ShopOwnerDrawer.dart';
import 'package:duare/ShopOwnerSection/ShopOwnerOrderDashboard/ShopOwnerOrderTabPages/ShopOwnerDeliveredOrdersTab.dart';
import 'package:duare/ShopOwnerSection/ShopOwnerOrderDashboard/ShopOwnerOrderTabPages/ShopOwnerNewOrdersTab.dart';
import 'package:duare/ShopOwnerSection/ShopOwnerOrderDashboard/ShopOwnerOrderTabPages/ShopOwnerPickupOrdersTab.dart';
import 'package:duare/ShopOwnerSection/ShopOwnerOrderDashboard/ShopOwnerOrderTabPages/ShopOwnerProcessingOrdersTab.dart';
import 'package:duare/ShopOwnerSection/ShopOwnerOrderDashboard/ShopOwnerOrderTabPages/ShopOwnerCancelledOrdersTab.dart';
import 'package:duare/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShopOwnerOrderDashboard extends StatefulWidget {
  @override
  _ShopOwnerOrderDashboardState createState() =>
      _ShopOwnerOrderDashboardState();
}

class _ShopOwnerOrderDashboardState extends State<ShopOwnerOrderDashboard> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: ShopOwnerDrawer(),
        appBar: AppBar(
          backgroundColor: appColor,
          title: Text(
            'Order Dashboard',
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
              Tab(
                text: "Cancelled",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ShopOwnerNewOrdersTab(),
            ShopOwnerProcessingOrdersTab(),
            ShopOwnerPickupOrdersTab(),
            ShopOwnerDeliveredOrdersTab(),
            ShopOwnerCancelledOrdersTab(),
          ],
        ),
      ),
      // ),
    );
  }
}
