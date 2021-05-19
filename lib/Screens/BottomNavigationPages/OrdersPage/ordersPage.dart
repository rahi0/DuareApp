import 'dart:convert';

import 'package:duare/Api/api.dart';
import 'package:duare/Redux/action.dart';
import 'package:duare/Redux/state.dart';
import 'package:duare/RouteTransition/routeAnimation.dart';
import 'package:duare/Screens/BottomNavigationPages/OrdersPage/orderDetailsScreen.dart';
import 'package:duare/Screens/LoginScreen/loginScreen.dart';
import 'package:duare/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {


@override
  void initState() {
     _getOrderList();
    super.initState();
  }

////////////////// get Order list start ////////////////////
  _getOrderList() async {
    var res =
        await CallApi().getDataWithToken('ordermodule/getAllOrders');
    var body = json.decode(res.body);
    print(res.statusCode);
    // print('body - $body');
    // print('.....................');

    if (body['message'] == "You are not allowed to access this route... ") {
      _showMsg('Your login has expired!', 1);
      Navigator.pushReplacement(context, SlideLeftRoute(page: LoginScreen()));

    } ////////// checking if token is expired
    else if (res.statusCode == 200) {
      var body = json.decode(res.body); 
      print(body);
     store.dispatch(RecentOrderAction(body['recentOrders']));
     store.dispatch(PastOrderAction(body['pastOrders']));

    } else if (res.statusCode == 401) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else{
           _showMsg("Something went wrong", 1);
      }
       store.dispatch(OrderLoadingAction(false));
  }
  ////////////////// get Order list end ////////////////////

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        ////// this is the connector which mainly changes state/ui
        converter: (store) => store.state,
        builder: (context, items) { 
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        // leading: IconButton(
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        //   icon: Icon(
        //     Icons.arrow_back,
        //     color: Colors.black,
        //   ),
        // ),
        centerTitle: true,
        title: Text(
          'Orders',
          style: TextStyle(
            fontFamily: 'poppins',
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: store.state.orderLoadingState ?
      Center(
        child: SpinKitCircle(
                              color: Color(0xFF0487FF),
                              // size: 30,
                            ),
      ) :
      SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          margin: EdgeInsets.only(left: 18, right: 18, top: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Text(
                  'Recent Orders',
                  style: TextStyle(
                    fontFamily: 'poppins',
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),


              store.state.recentOrderState.length==0?
                            Center(
                              heightFactor: 2,
                              child: Text(
                                      'No order is available',
                                      style: TextStyle(
                                        fontFamily: 'poppins',
                                        color: Colors.grey,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                            ):
              Column(
                children: List.generate(
                  store.state.recentOrderState.length,
                  (index) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 20),
                      padding: EdgeInsets.only(
                          top: 16, bottom: 16, left: 20, right: 35),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          width: 0.5,
                          color: Color(0xFFD6D6D6),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 1.75,
                                child: Text(
                                  // 'Rice, oil, powder milk, oil, powder milk, oil, powder milk, oil, powder milk, oil, powder milk',
                                  store.state.recentOrderState[index]['productNames']==null? "":
                                  "${store.state.recentOrderState[index]['productNames']}",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: 'poppins',
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5, bottom: 3),
                                child: Text(
                                  // '20 Dec, 2019   3:00AM',
                                  //'${DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(store.state.recentOrderState[index]['created_at'])}',
                                  '${DateFormat('d MMM y   hh:mm a').format(DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(store.state.recentOrderState[index]['created_at']))}',
                                  style: TextStyle(
                                    fontFamily: 'poppins',
                                    color: Colors.black,
                                    fontSize: 12,
                                    // fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  'Order ${store.state.recentOrderState[index]['status']}',
                                  style: TextStyle(
                                    fontFamily: 'poppins',
                                    color: Color(0xFF00B658),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  SlideLeftRoute(page: OrderDetailsScreen(store.state.recentOrderState[index]['id'])));
                            },
                            child: Icon(
                              Icons.arrow_forward,
                              color: Color(0xFF979797),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20, top: 20),
                child: Text(
                  'Past Orders',
                  style: TextStyle(
                    fontFamily: 'poppins',
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              store.state.pastOrderState.length==0?
                            Center(
                              heightFactor: 2,
                              child: Text(
                                      'No order is available',
                                      style: TextStyle(
                                        fontFamily: 'poppins',
                                        color: Colors.grey,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                            ):
              Column(
                children: List.generate(
                  store.state.pastOrderState.length,
                  (index) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 20),
                      padding: EdgeInsets.only(
                          top: 16, bottom: 16, left: 20, right: 35),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          width: 0.5,
                          color: Color(0xFFD6D6D6),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 1.75,
                                child: Text(
                                  store.state.pastOrderState[index]['productNames']==null? "":
                                  "${store.state.pastOrderState[index]['productNames']}",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: 'poppins',
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5, bottom: 3),
                                child: Text(
                                  // '20 Dec, 2019   9:00AM',
                                  '${DateFormat('d MMM y   hh:mm a').format(DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(store.state.pastOrderState[index]['created_at']))}',
                                  style: TextStyle(
                                    fontFamily: 'poppins',
                                    color: Colors.black,
                                    fontSize: 12,
                                    // fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  // 'Delivered 21 Dec, 2019',
                                  "${store.state.pastOrderState[index]['status']} ${DateFormat('d MMM y hh:mm a').format(DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(store.state.pastOrderState[index]['updated_at']))}",
                                  style: TextStyle(
                                    fontFamily: 'poppins',
                                    color: store.state.pastOrderState[index]['status']== "Canceled"?
                                    Colors.red: Color(0xFF00B658),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  SlideLeftRoute(page: OrderDetailsScreen(store.state.pastOrderState[index]['id'])));
                            },
                            child: Icon(
                              Icons.arrow_forward,
                              color: Color(0xFF979797),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
    }
    );
  }


  //////////////// toast msg ui start ///////////////
  _showMsg(msg, numb) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor:
            numb == 1 ? Colors.red.withOpacity(0.9) : Colors.green[400],
        textColor: Colors.white,
        fontSize: 13.0);
  }
  //////////////// toast msg ui end ///////////////
}
