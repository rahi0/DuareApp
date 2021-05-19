import 'dart:convert';

import 'package:duare/Api/api.dart';
import 'package:duare/Redux/action.dart';
import 'package:duare/RouteTransition/routeAnimation.dart';
import 'package:duare/Screens/LoginScreen/loginScreen.dart';
import 'package:duare/ShopOwnerSection/ShopOwnerAddSubCategory/ShopOwnerAddSubCategory.dart';
import 'package:duare/ShopOwnerSection/ShopOwnerDrawer/ShopOwnerDrawer.dart';
import 'package:duare/ShopOwnerSection/ShopOwnerOrderDashboard/ShopOwnerOrderDashboard.dart';
import 'package:duare/ShopOwnerSection/ShopOwnerProductsListPage/ShopOwnerProductsListPage.dart';
import 'package:duare/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ShopOwnerHomepage extends StatefulWidget {
  @override
  _ShopOwnerHomepageState createState() => _ShopOwnerHomepageState();
}

class _ShopOwnerHomepageState extends State<ShopOwnerHomepage> {
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
      'title': 'Total Products',
      'value': '0',
    },
    {
      'title': 'Available Products',
      'value': '0',
    },
    {
      'title': 'This Month\'s Income',
      'value': '0',
    },
    {
      'title': 'This Year\'s Income',
      'value': '0',
    },
  ];

  _getShopCategory() async {
    var res =
        await CallApi().getDataWithToken('shopownermodule/getShopCategory');
    var body = json.decode(res.body);
    print(res.statusCode);
    print('body - $body');
    print('.....................');

    if (body['message'] == "You are not allowed to access this route... ") {
      _showMsg('Your login has expired!', 1);
      Navigator.pushReplacement(context, SlideLeftRoute(page: LoginScreen()));
    } ////////// checking if token is expired
    else if (res.statusCode == 200) {
      var shopCategoryData = json.decode(res.body);
      store.state.soShopCategoryState = shopCategoryData['data'][0]['category'];
      store.dispatch(SoShopCategoryAction(store.state.soShopCategoryState));
      print(store.state.soShopCategoryState);
    }
  }

  _getDashboard() async {
    var res = await CallApi().getDataWithToken('shopownermodule/getDashboard');
    var body = json.decode(res.body);
    print(res.statusCode);
    print('body - $body');
    print('.....................');

    if (body['message'] == "You are not allowed to access this route... ") {
      _showMsg('Your login has expired!', 1);
      Navigator.pushReplacement(context, SlideLeftRoute(page: LoginScreen()));
    } ////////// checking if token is expired
    else if (res.statusCode == 200) {
      setState(() {
        dashbList[0]['value'] = '${body['recieveOrders']}';
        dashbList[1]['value'] = '${body['processingOrders']}';
        dashbList[2]['value'] = '${body['deliveredOrders']}';
        dashbList[3]['value'] = '${body['totalProducts']}';
        dashbList[4]['value'] = '${body['availableProducts']}';
        dashbList[5]['value'] = '${body['monthlyIncome']}';
        dashbList[6]['value'] = '${body['yearlyIncome']}';
      });
    }

    store.dispatch(SoDashboardLoadingAction(false));
  }

  @override
  void initState() {
    _getShopCategory();
    _getDashboard();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F3F3),
      drawer: ShopOwnerDrawer(),
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
      body: Container(
        // child: RefreshIndicator(
        //   onRefresh: null,
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
              child: store.state.soDashboardLoadingState
                  ?
                  //////////////////// progress inidcator start //////////////////////
                  Center(
                      child: Container(
                        child: SpinKitCircle(
                          color: Color(0xFF0487FF),
                        ),
                      ),
                    )
                  ////////////////////// progress inidcator end //////////////////////
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 20.0,
                          runSpacing: 20,
                          children: List.generate(
                            dashbList.length,
                            (index) {
                              return GestureDetector(
                                onTap: () {
                                  // if (dashbList[index]['title'] == 'Total Products' ||
                                  //     dashbList[index]['title'] ==
                                  //         'Available Products')
                                  // Navigator.push(
                                  //   context,
                                  //   ScaleRoute(page: ShopOwnerProductsListPage()),
                                  // );
                                  // else
                                  if (dashbList[index]['title'] ==
                                          'This Month\'s Income' ||
                                      dashbList[index]['title'] ==
                                          'This Year\'s Income') {
                                  } else
                                    Navigator.push(
                                      context,
                                      ScaleRoute(
                                          page: ShopOwnerOrderDashboard()),
                                    );
                                },
                                child: dashbContainer(
                                  dashbList[index]['title'],
                                  dashbList[index]['value'],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
      // ),
    );
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
