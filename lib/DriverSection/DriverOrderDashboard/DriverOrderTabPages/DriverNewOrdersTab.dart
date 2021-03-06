import 'dart:convert';

import 'package:duare/Api/api.dart';
import 'package:duare/DriverSection/DriverOrderDetailsPage/DriverOrderDetailsPage.dart';
import 'package:duare/Redux/action.dart';
import 'package:duare/Redux/state.dart';
import 'package:duare/RouteTransition/routeAnimation.dart';
import 'package:duare/Screens/LoginScreen/loginScreen.dart';
import 'package:duare/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class DriverNewOrdersTab extends StatefulWidget {
  @override
  _DriverNewOrdersTabState createState() => _DriverNewOrdersTabState();
}

class _DriverNewOrdersTabState extends State<DriverNewOrdersTab> {

 @override
  void initState() {
    _getDriverNewOrder();
    super.initState();
  }

  
 Future<void> _pull() async {
   store.dispatch(DriverNewOrderLoadingAction(true));
      _getDriverNewOrder();   
  }


  ////////////////// get Driver New Order start ////////////////////
  _getDriverNewOrder() async {
    var res = await CallApi().getDataWithToken('drivermodule/allNewDriversOrders');
    var body = json.decode(res.body);
    print(res.statusCode);
    print('body - $body');
    print('.....................');

    if (body['message'] == "You are not allowed to access this route... ") {
      _showMsg('Your login has expired!', 1);
      Navigator.pushReplacement(context, SlideLeftRoute(page: LoginScreen()));

    } ////////// checking if token is expired
    else if (res.statusCode == 200) {
      var body = json.decode(res.body); 
      print(body);
     store.dispatch(DriverNewOrderAction(body['data']));

    } else if (res.statusCode == 401) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }else{
           _showMsg("Something went wrong", 1);
      }           
       store.dispatch(DriverNewOrderLoadingAction(false));
  }
  ////////////////// get Driver New Order end ////////////////////  



  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        ////// this is the connector which mainly changes state/ui
        converter: (store) => store.state,
        builder: (context, items) { 
    return RefreshIndicator(
     onRefresh: _pull,
     child: store.state.driverNewOrderLoadingState ?
      //////////////////// progress inidcator start //////////////////////
                Center(
              child: SpinKitCircle(
                color: Color(0xFF0487FF),
              ),
            ) :
      //////////////////// progress inidcator End //////////////////////
     SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
        child: 

            ////////////////////// no orders text container start //////////////////////
            store.state.driverNewOrderState.length <= 0 ?
                Container(
                  height: MediaQuery.of(context).size.height/1.4,
                  child: Center(
                    child: Text(
                  'No New Orders',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontFamily: 'poppins',
                  ),
                ),
                  ),
                ) :
            ////////////////////// no orders text container end //////////////////////

            ////////////////////// orders list start //////////////////////
            Column(
          children: List.generate(
            store.state.driverNewOrderState.length,
            (index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(context, ScaleRoute(page: DriverOrderDetailsPage(store.state.driverNewOrderState[index]['id'], "NewOrder")));
                },
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildItemContainer('Invoice Number', '${store.state.driverNewOrderState[index]['id']}'),
                      buildItemContainer('Time',
                          '${DateFormat.yMd().add_jm().format(DateTime.parse(store.state.driverNewOrderState[index]['created_at']))}'),
                      buildItemContainer('Price', '???${store.state.driverNewOrderState[index]['total']}'),
                      buildItemContainer('Payment Type', '${store.state.driverNewOrderState[index]['paymentType']}'),
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Divider(),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        ////////////////////// orders list end //////////////////////
      ),
      ),
    );
  });
  }

  ///////////////////////////////////////////////////////
  Container buildItemContainer(var title, var value) {
    return Container(
      padding: EdgeInsets.only(bottom: 5),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Text(
              '$title: ',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontFamily: 'poppins',
              ),
            ),
          ),
          Container(
            child: Text(
              value,
              style: TextStyle(
                fontWeight:
                    title == 'Price' ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
  ///////////////////////////////////////////////////////
  
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
