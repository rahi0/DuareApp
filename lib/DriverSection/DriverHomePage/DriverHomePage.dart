import 'dart:convert';

import 'package:duare/Api/api.dart';
import 'package:duare/DriverSection/DriverDrawer/DriverDrawer.dart';
import 'package:duare/DriverSection/DriverOrderDashboard/DriverOrderDashboard.dart';
import 'package:duare/Redux/action.dart';
import 'package:duare/Redux/state.dart';
import 'package:duare/RouteTransition/routeAnimation.dart';
import 'package:duare/Screens/LoginScreen/loginScreen.dart';
import 'package:duare/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DriverHomepage extends StatefulWidget {
  @override
  _DriverHomepageState createState() => _DriverHomepageState();
}

class _DriverHomepageState extends State<DriverHomepage> {
  var dashbList = [
    {
      'title': 'Orders Received',
      'value': '0',
    },
    {
      'title': 'Orders Processing',
      'value': '0',
    },
    {
      'title': 'Orders Delivered',
      'value': '0',
    },
    {
      'title': 'Orders Pickup',
      'value': '0',
    },
  ];


  @override
  void initState() {
    _getDriverHome();
    super.initState();
  }

  
 Future<void> _pull() async {
   store.dispatch(DriverDashboardLoadingAction(true));
      _getDriverHome();   
  }


  ////////////////// get Driver Home start ////////////////////
  _getDriverHome() async {
    var res = await CallApi().getDataWithToken('drivermodule/getDashboard');
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
     store.dispatch(DriverDashboardAction(body));

    } else if (res.statusCode == 401) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }else{
           _showMsg("Something went wrong", 1);
      }           
       store.dispatch(DriverDashboardLoadingAction(false));
  }
  ////////////////// get Driver Home end ////////////////////   

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        ////// this is the connector which mainly changes state/ui
        converter: (store) => store.state,
        builder: (context, items) { 
    return Scaffold(
     backgroundColor: Color(0xFFF5F3F3),
     drawer: DriverDrawer(), 
     appBar: AppBar(
       backgroundColor: appColor,
       title: Text(
         'Dashboard',
         style: TextStyle(
           fontSize: 22,
           fontWeight: FontWeight.w500,
           color: Colors.white,
           fontFamily: 'poppins',
         ),
       ),
     ),
     body:  store.state.driverHomeLoadingState ?
      Center(
        child: SpinKitCircle(
          color: Color(0xFF0487FF),
           // size: 30,
        ),
      ) :
      Container(
       child: RefreshIndicator(
         onRefresh: _pull,
       child: SingleChildScrollView(
         physics: AlwaysScrollableScrollPhysics(),
         child: Container(
           margin: EdgeInsets.only(
             left: 10,
             right: 10,
             top: 20,
             bottom: 20,
           ),
           child: Center(
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Wrap(
                   alignment: WrapAlignment.center,
                   spacing: 20.0,
                   runSpacing: 20,
                   children: [
                     /////////////////////// Received order start //////////////////////
                     GestureDetector(
                         onTap: () { 
                           Navigator.push(context, ScaleRoute(page: DriverOrderDashboard()),);
                         },
                         child: dashbContainer(
                           'Orders Received',
                           store.state.driverHomeState==null? "0":
                           store.state.driverHomeState["Received"]==null? "0":
                           "${store.state.driverHomeState["Received"]}",
                         ),
                       ),
                     /////////////////////// Received order end //////////////////////
                     
                     /////////////////////// Processing order start //////////////////////
                     GestureDetector(
                         onTap: () { 
                           Navigator.push(context, ScaleRoute(page: DriverOrderDashboard()),);
                         },
                         child: dashbContainer(
                           'Orders Processing',
                           store.state.driverHomeState==null? "0":
                           store.state.driverHomeState["Processing"]==null? "0":
                           "${store.state.driverHomeState["Processing"]}",
                         ),
                       ),
                     /////////////////////// Processing order end //////////////////////
                     
                     /////////////////////// Delivered order start //////////////////////
                     GestureDetector(
                         onTap: () { 
                           Navigator.push(context, ScaleRoute(page: DriverOrderDashboard()),);
                         },
                         child: dashbContainer(
                           'Orders Delivered',
                           store.state.driverHomeState==null? "0":
                           store.state.driverHomeState["Delivered"]==null? "0":
                           "${store.state.driverHomeState["Delivered"]}",
                         ),
                       ),
                     /////////////////////// Delivered order end //////////////////////
                     
                     /////////////////////// Pickup order start //////////////////////
                     GestureDetector(
                         onTap: () { 
                           Navigator.push(context, ScaleRoute(page: DriverOrderDashboard()),);
                         },
                         child: dashbContainer(
                           'Orders Pickup',
                           store.state.driverHomeState==null? "0":
                           store.state.driverHomeState["Picked"]==null? "0":
                           "${store.state.driverHomeState["Picked"]}",
                         ),
                       ),
                     /////////////////////// Pickup order end //////////////////////
                   ],
                 ),
               ],
             ),
           ),
         ),
       ),
     ),
     ),
      );
  });
  }

  ////////////// buttonContainer ////////////////
  dashbContainer(var title, var value) {
    return Container(
      width: MediaQuery.of(context).size.width / 2.5,
      height: MediaQuery.of(context).size.width / 2.75,
      padding: EdgeInsets.only(
        left: 15, right: 15,
        //  top: 25, bottom: 25,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              // fontWeight: FontWeight.w500,
              color: Colors.black,
              fontFamily: 'poppins',
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontFamily: 'poppins',
            ),
          ),
        ],
      ),
    );
  }
  ////////////// buttonContainer ////////////////
  

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
