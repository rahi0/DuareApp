import 'dart:convert';

import 'package:duare/Api/api.dart';
import 'package:duare/Redux/action.dart';
import 'package:duare/Screens/LoginScreen/loginScreen.dart';
import 'package:duare/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopOwnerOrderDetailsPage extends StatefulWidget {
  var orderId;

  ShopOwnerOrderDetailsPage(this.orderId);

  @override
  _ShopOwnerOrderDetailsPageState createState() =>
      _ShopOwnerOrderDetailsPageState();
}

class _ShopOwnerOrderDetailsPageState extends State<ShopOwnerOrderDetailsPage> {
  ////////////////// get Orders detail start ////////////////////
  _getOrderDetails() async {
    store.dispatch(SoOrderDetailLoadingAction(true));

    var res = await CallApi().getDataWithTokenandQuery(
        'shopownermodule/getAllSingleOrders/${widget.orderId}', '');
    var body = json.decode(res.body);
    print(res.statusCode);
    print('body - $body');
    print('.....................');

    if (res.statusCode == 200) {
      store.dispatch(SoOrderDetailAction(body));
    } else if (res.statusCode == 401) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else {
      _showMsg('Something went wrong!', 1);
    }

    store.dispatch(SoOrderDetailLoadingAction(false));
  }
  ////////////////// get Orders detail end ////////////////////

  @override
  void initState() {
    _getOrderDetails();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor,
        title: Text(
          'Order Details',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontFamily: 'poppins',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 20, bottom: 20, left: 15, right: 15),
          child: store.state.soOrderDetailLoadingState
              ?
              ////////////////////// progress inidcator start //////////////////////
              Center(
                  child: Container(
                    child: SpinKitCircle(
                      color: Color(0xFF0487FF),
                    ),
                  ),
                )
              ////////////////////// progress inidcator end //////////////////////
              : Column(
                  children: [
                    /////////////////// Order Information start /////////////////////
                    buildDetailsContainer(
                      'Order Information',
                      'Order ID: ',
                      '${store.state.soOrderDetailState['id']}',
                      'Order Date: ',
                      '${store.state.soOrderDetailState['orderDate']}',
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 15),
                      child: Divider(),
                    ),
                    /////////////////// Order Information end /////////////////////

                    /////////////////// Delivery Man Information start /////////////////////
                    store.state.soOrderDetailState['driver'] == null
                        ? Container()
                        : buildDetailsContainer(
                            'Delivery Man Information',
                            'Name: ',
                            '${store.state.soOrderDetailState['driver']['name']}',
                            //  'Bijoya',
                            'Phone: ',
                            store.state.soOrderDetailState['driver']['phone'] ==
                                    null
                                ? ""
                                : '${store.state.soOrderDetailState['driver']['phone']}',
                            // '01689076543',
                          ),
                    Container(
                      margin: EdgeInsets.only(bottom: 15),
                      child: Divider(),
                    ),
                    /////////////////// Delivery Man Information end /////////////////////

                    /////////////////// Product Information start /////////////////////
                    buildDetailsContainer(
                      'Product Information',
                      'Payment Method: ',
                      // 'Cash on delivery',
                      store.state.soOrderDetailState['paymentType'] == null
                          ? ""
                          : '${store.state.soOrderDetailState['paymentType']}',
                      'Total Bill: ',
                      '৳${store.state.soOrderDetailState['total']}',
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 15),
                      child: Divider(),
                    ),
                    /////////////////// Product Information end /////////////////////

                    /////////////////// Shipping Information start /////////////////////
                    buildDetailsContainer(
                      'Shipping Information',
                      'Name: ',
                      // 'Bijoya',
                      '${store.state.soOrderDetailState['user']['name']}',
                      'Phone: ',
                      // '01689076543',
                      '${store.state.soOrderDetailState['user']['phone']}',
                    ),
                    Row(
                      children: [
                        Text(
                          'Address: ',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontFamily: 'poppins',
                          ),
                        ),
                        Text(
                          store.state.soOrderDetailState['user']['address'] ==
                                  null
                              ? ''
                              : '${store.state.soOrderDetailState['user']['address']}',
                          // 'MoloviBazar, Sylhet, Bangladesh',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontFamily: 'poppins',
                          ),
                        ),
                      ],
                    ),
                    /////
                      Row(
                      children: [
                        Text(
                          'Address: ',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontFamily: 'poppins',
                          ),
                        ),
                        Text(
                          store.state.soOrderDetailState['user']['address'] ==
                                  null
                              ? ''
                              : '${store.state.soOrderDetailState['user']['address']}',
                          // 'MoloviBazar, Sylhet, Bangladesh',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontFamily: 'poppins',
                          ),
                        ),
                      ],
                    ),
                    /////
                    Container(
                      margin: EdgeInsets.only(bottom: 15),
                      child: Divider(),
                    ),
                    /////////////////// Shipping Information end /////////////////////

                    /////////////////// Ordered Products List start /////////////////////
                    Column(
                      children: List.generate(
                        store.state.soOrderDetailState['items'].length,
                        (index) {
                          return Container(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 10),
                                      child: Image.asset(
                                        "assets/images/img (5).png",
                                        // fit: BoxFit.contain,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          // 'Dano Milk Powder',
                                          '${store.state.soOrderDetailState['items'][index]['product']['name']}',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'poppins',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          'Variation: ${store.state.soOrderDetailState['items'][index]['variation']['name']}',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'poppins',
                                          ),
                                        ),
                                        Text(
                                          'Company: ${store.state.soOrderDetailState['items'][index]['product']['brand']['name']}',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'poppins',
                                          ),
                                        ),
                                        Text(
                                          'Quantity: ${store.state.soOrderDetailState['items'][index]['quantity']}',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'poppins',
                                          ),
                                        ),
                                        Text(
                                          'Purchase Price: ৳${store.state.soOrderDetailState['items'][index]['variation']['purchase_price']}',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'poppins',
                                          ),
                                        ),
                                        Text(
                                          'Sale Price: ৳${store.state.soOrderDetailState['items'][index]['variation']['price']}',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'poppins',
                                          ),
                                        ),
                                        Text(
                                          'Total Price: ৳${store.state.soOrderDetailState['items'][index]['total']}',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'poppins',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 5),
                                  child: Divider(),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    /////////////////// Ordered Products List end /////////////////////

                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ////////////////////// Reject Button Start //////////////////////
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: MediaQuery.of(context).size.width / 3,
                              padding: EdgeInsets.only(top: 15, bottom: 15),
                              margin: EdgeInsets.only(top: 10, bottom: 20),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                'Reject',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          ////////////////////// Reject Button End //////////////////////

                          ////////////////////// Accept Button Start //////////////////////
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: MediaQuery.of(context).size.width / 3,
                              padding: EdgeInsets.only(top: 15, bottom: 15),
                              margin: EdgeInsets.only(top: 10, bottom: 20),
                              decoration: BoxDecoration(
                                color: Color(0xFF00B658),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                'Accept',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          ////////////////////// Accept Button End //////////////////////
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

////////////////////////////////////////////////////////////////////
  Container buildDetailsContainer(
      var heading, var title1, var value1, var title2, var value2) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Text(
              heading,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontFamily: 'poppins',
              ),
            ),
          ),
          Row(
            children: [
              Text(
                title1,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontFamily: 'poppins',
                ),
              ),
              Text(
                value1,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontFamily: 'poppins',
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                title2,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontFamily: 'poppins',
                ),
              ),
              GestureDetector(
                onTap: () {
                  title2 == 'Phone: ' ? launch("tel:$value2") : null;
                },
                child: Row(
                  children: [
                    title2 == 'Phone: '
                        ? Icon(
                            Icons.call,
                            color: Colors.green,
                          )
                        : Container(),
                    Text(
                      value2,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontFamily: 'poppins',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
////////////////////////////////////////////////////////////////////

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
