import 'dart:convert';

import 'package:duare/Api/api.dart';
import 'package:duare/Redux/action.dart';
import 'package:duare/Redux/state.dart';
import 'package:duare/RouteTransition/routeAnimation.dart';
import 'package:duare/Screens/LoginScreen/loginScreen.dart';
import 'package:duare/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MembershipPlanScreen extends StatefulWidget {
  @override
  _MembershipPlanScreenState createState() => _MembershipPlanScreenState();
}

class _MembershipPlanScreenState extends State<MembershipPlanScreen> {



@override
  void initState() {

     _getPlans(); 
    super.initState();
  }

  ///////////////// get Plans start /////////////////
  _getPlans() async {
    // store.dispatch(BannerLoadingAction(true));

    var res = await CallApi().getDataWithToken('usermodule/getPlans');
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
      //print(body);
      store.dispatch(GetPlansListAction(body['data']));

    } else if (res.statusCode == 401) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else{
           _showMsg("Something went wrong", 1);
      }
       store.dispatch(GetPlansListLoadingAction(false));
  }
  ///////////////// get Plans end /////////////////
  
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
          'Upgrade Plan',
          style: TextStyle(
            fontFamily: 'poppins',
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: store.state.getPlansLoadingState?
             Center(
               child: SpinKitCircle(
                                color: Color(0xFF0487FF),
                                // size: 30,
                              ),
             ):
           SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          margin: EdgeInsets.only(left: 16, right: 16, top: 45),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Text(
                  'Choose Your Plan',
                  style: TextStyle(
                    fontFamily: 'poppins',
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Column(
                children: List.generate(
                  store.state.getPlansListState.length,
                  (index) {
                    return Container(
                      // padding: EdgeInsets.only(left: 22, right: 22, top: 5),
                      margin: EdgeInsets.only(bottom: 40),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        // color: Color(0xFFF0EFEF),
                        border: Border.all(
                          color: Color(0xFFBDB9B9),
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(bottom: 5, top: 5),
                            decoration: BoxDecoration(
                              color: Color(0xFFE9F2FF),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                            ),
                            child: Text(
                              // 'Lite Plan',
                              '${store.state.getPlansListState[index]['name']}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'poppins',
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: 22, right: 22, top: 30, bottom: 30),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      // 'Tk750/',
                                      'Tk${store.state.getPlansListState[index]['price']}/',
                                      style: TextStyle(
                                        fontFamily: 'poppins',
                                        color: Color(0xFF00B658),
                                        fontSize: 22,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        // '3 months',
                                        '${store.state.getPlansListState[index]['duration']}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'poppins',
                                          color: Color(0xFF263238),
                                          fontSize: 14,
                                          // fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Container(
                                    margin:
                                        EdgeInsets.only(left: 10, right: 10),
                                    child: Text(
                                      // 'Free Home Delivery',
                                      '${store.state.getPlansListState[index]['description']}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'poppins',
                                        color: Color(0xFF263238),
                                        fontSize: 13,
                                        // fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  // width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.only(
                                      top: 5, bottom: 5, left: 25, right: 25),
                                  // margin: EdgeInsets.only(top: 40, bottom: 25),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF0487FF),
                                    borderRadius: BorderRadius.circular(5),
                                    // border: Border.all(
                                    //   width: 0.5,
                                    //   color: Color(0xFFDFDFDF),
                                    // ),
                                  ),
                                  child: Text(
                                    'Buy',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                      fontFamily: 'poppins',
                                    ),
                                  ),
                                ),
                              ],
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
