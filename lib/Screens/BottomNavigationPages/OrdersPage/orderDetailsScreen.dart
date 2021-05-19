import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:duare/Api/api.dart';
import 'package:duare/Redux/action.dart';
import 'package:duare/Redux/state.dart';
import 'package:duare/RouteTransition/routeAnimation.dart';
import 'package:duare/Screens/CartPage/cartPage.dart';
import 'package:duare/Screens/LoginScreen/loginScreen.dart';
import 'package:duare/Screens/OrderPlacedScreen/orderPlacedScreen.dart';
import 'package:duare/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class OrderDetailsScreen extends StatefulWidget {
  final orderID;
  OrderDetailsScreen(this.orderID);
  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  bool isImageError = false;
  bool _isReOrderPressed = false;
  bool _isCancelOrderPressed = false;

  @override
  void initState() {
     _getOrderDetails();
    super.initState();
  }

////////////////// get Order list start ////////////////////
  _getOrderDetails() async {
    store.dispatch(OrderDetailsLoadingAction(true));
    var res =
        await CallApi().getDataWithToken('ordermodule/getAllSingleOrders/${widget.orderID}');
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
     store.dispatch(OrderDetailsAction(body));

    } else if (res.statusCode == 401) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else{
           _showMsg("Something went wrong!", 1);
      }
       store.dispatch(OrderDetailsLoadingAction(false));
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
          'Order',
          style: TextStyle(
            fontFamily: 'poppins',
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: store.state.orerDetailsLoadingState ?
      Center(
        child: SpinKitCircle(
                              color: Color(0xFF0487FF),
                              // size: 30,
                            ),
      ) :
      SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          //color: Colors.red,
          margin: EdgeInsets.only(left: 18, right: 18, top: 45),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /////////////////////////////////////////////// test ////////////////////////////////////////////////
              Container(
                margin: EdgeInsets.only(bottom: 35),
                height: 150,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    ////////////////////// order delivery address start //////////////////////////
                    Positioned(
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: Container(
                        height: 90,
                        padding: EdgeInsets.only(
                            left: 40, right: 40, top: 30, bottom: 10),
                        decoration: BoxDecoration(
                          color: Color(0xFf00B658),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.06),
                              spreadRadius: 0,
                              blurRadius: 23,
                              offset:
                                  Offset(0, 8), // changes position of shadow
                            ),
                          ],
                        ),
                        child: RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Address:  ',
                                style: TextStyle(
                                  fontFamily: 'poppins',
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text:
                                    // 'Dhaka-Sylhet highway, MM Enterprise, Moulvibazar',
                                    store.state.orerDetailsState['address']['apartment_number']==null ? 
                                    store.state.orerDetailsState['address']['address']==null ? "" :
                                    '${store.state.orerDetailsState['address']['address']}' :
                                  '${store.state.orerDetailsState['address']['apartment_number']}, ${store.state.orerDetailsState['address']['address']}',
                                style: TextStyle(
                                  fontFamily: 'poppins',
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    ////////////////////// order delivery address end //////////////////////////

                    ////////////////////// order status start //////////////////////////
                    Container(
                      height: 80,
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 0, bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.06),
                            spreadRadius: 0,
                            blurRadius: 23,
                            offset: Offset(2, -5), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 17),
                            child: Image.asset(
                              "assets/images/delivery 1.png",
                              fit: BoxFit.contain,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(top: 8),
                              child: Text(
                                store.state.orerDetailsState['status'] == "Pending" ?
                                "Oreder is in pending" :
                                store.state.orerDetailsState['status'] == "Processing" ?
                                'Placed : Arriving in ${store.state.orerDetailsState['delivery_time']}' :
                                store.state.orerDetailsState['status'] =="Picked" ?
                                'Placed : Arriving in ${store.state.orerDetailsState['delivery_time']}' :
                                 store.state.orerDetailsState['status'] == "Delivered" ?
                                'Order Delivered at ${DateFormat('d MMM y   hh:mm a').format(DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(store.state.orerDetailsState['updated_at']))}' :
                                "Order Canceled",
                                style: TextStyle(
                                  fontFamily: 'poppins',
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ), ////////////////////// order status end //////////////////////////
              /////////////////////////////////////////////// test ////////////////////////////////////////////////

              // ////////////////////// order status start //////////////////////////
              // Container(
              //   padding:
              //       EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 10),
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(12),
              //     boxShadow: [
              //       BoxShadow(
              //         color: Color.fromRGBO(0, 0, 0, 0.06),
              //         spreadRadius: 0,
              //         blurRadius: 23,
              //         offset: Offset(2, -5), // changes position of shadow
              //       ),
              //     ],
              //   ),
              //   child: Row(
              //     children: [
              //       Container(
              //         margin: EdgeInsets.only(right: 17),
              //         child: Image.asset(
              //           "assets/images/delivery 1.png",
              //           fit: BoxFit.contain,
              //         ),
              //       ),
              //       Expanded(
              //         child: Container(
              //           padding: EdgeInsets.only(top: 8),
              //           child: Text(
              //             'Placed : Arriving in 15 mins',
              //             style: TextStyle(
              //               fontFamily: 'poppins',
              //               color: Colors.black,
              //               fontSize: 16,
              //               fontWeight: FontWeight.w500,
              //             ),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              // ////////////////////// order status end //////////////////////////

              // ////////////////////// order delivery address start //////////////////////////
              // Container(
              //   width: MediaQuery.of(context).size.width,
              //   padding:
              //       EdgeInsets.only(left: 25, right: 25, top: 5, bottom: 10),
              //   decoration: BoxDecoration(
              //     color: Color(0xFf00B658),
              //     borderRadius: BorderRadius.only(
              //       bottomLeft: Radius.circular(12),
              //       bottomRight: Radius.circular(12),
              //     ),
              //     boxShadow: [
              //       BoxShadow(
              //         color: Color.fromRGBO(0, 0, 0, 0.06),
              //         spreadRadius: 0,
              //         blurRadius: 23,
              //         offset: Offset(0, 8), // changes position of shadow
              //       ),
              //     ],
              //   ),
              //   child: RichText(
              //     text: TextSpan(
              //       children: [
              //         TextSpan(
              //           text: 'Address:  ',
              //           style: TextStyle(
              //             fontFamily: 'poppins',
              //             color: Colors.white,
              //             fontSize: 16,
              //             fontWeight: FontWeight.w500,
              //           ),
              //         ),
              //         TextSpan(
              //           text: 'Dhaka-Sylhet highway, M Enterprise, Moulvibazar',
              //           style: TextStyle(
              //             fontFamily: 'poppins',
              //             color: Colors.white,
              //             // fontSize: 12,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // ////////////////////// order delivery address end //////////////////////////

              ////////////////////// order delivery man start //////////////////////////
             if (store.state.orerDetailsState['status'] == "Delivered" || store.state.orerDetailsState['status'] =="Picked" )
              Container(
                //color: Colors.red,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only( bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/8, right: 20),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.transparent,
                        backgroundImage: store.state.orerDetailsState['driver']['image'] == null ?
                        AssetImage(
                          "assets/images/manAvatar.png",
                        ) :
                        CachedNetworkImageProvider(
                          "${store.state.orerDetailsState['driver']['image']}"
                        ),
                        onBackgroundImageError: (_, __) {
                            setState(() {
                              this.isImageError = true;
                            });
                          },
                          child: (this.isImageError) ? Center(child: new Icon(Icons.error)): Container()
                        // CachedNetworkImage(
                        //   imageUrl: "http://duareadmin.duare.net/img/photo.jpg",
                        //   // fit: BoxFit.cover,
                        //   placeholder:(context, url) => Center(
                        //   child: SpinKitFadingCircle(
                        //     color: Colors.grey,),
                        //   ),
                        //   errorWidget: (context, url, error) =>
                        //     Center(child: new Icon(Icons.error)),
                        //   ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        //color: Colors.blue,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Delivery Man:  ',
                                    style: TextStyle(
                                      fontFamily: 'poppins',
                                      color: Colors.black,
                                      // fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  TextSpan(
                                    text: store.state.orerDetailsState['driver']['name'] == null ? ''
                                    : "${store.state.orerDetailsState['driver']['name']}",
                                    style: TextStyle(
                                      fontFamily: 'poppins',
                                      color: Colors.black,
                                      // fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Phone:  ',
                                    style: TextStyle(
                                      fontFamily: 'poppins',
                                      color: Colors.black,
                                      // fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  TextSpan(
                                    text: store.state.orerDetailsState['driver']['phone'] == null ? ''
                                    : "${store.state.orerDetailsState['driver']['phone']}",
                                    style: TextStyle(
                                      fontFamily: 'poppins',
                                      color: Colors.black,
                                      // fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ////////////////////// order delivery man end //////////////////////////

              /////////////// order summary start /////////////////
              Container(
                // margin: EdgeInsets.only(top: 19),
                padding: EdgeInsets.only(
                  top: 19,
                  left: 16,
                  right: 16,
                  bottom: 20,
                ),
                decoration: BoxDecoration(
                  color: Color(0xFFF0EFEF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  // 'Evan',
                                  store.state.orerDetailsState['user']['name']==null?"":
                                  '${store.state.orerDetailsState['user']['name']}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    fontFamily: 'poppins',
                                  ),
                                ),
                                Text(
                                  store.state.orerDetailsState['user']['address']==null?"":
                                  '${store.state.orerDetailsState['user']['address']}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    // fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    fontFamily: 'poppins',
                                  ),
                                ),
                                Text(
                                  store.state.orerDetailsState['user']['city']==null?"":
                                  '${store.state.orerDetailsState['user']['city']}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    // fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    fontFamily: 'poppins',
                                  ),
                                ),
                                Text(
                                  store.state.orerDetailsState['user']['phone']==null?"":
                                  '${store.state.orerDetailsState['user']['phone']}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    // fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    fontFamily: 'poppins',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Invoice',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontFamily: 'poppins',
                                ),
                              ),
                              Text(
                                '#${store.state.orerDetailsState['id']}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontFamily: 'poppins',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2.5,
                          child: Text(
                            'Product',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontFamily: 'poppins',
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 12,
                          child: Text(
                            'QTY',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontFamily: 'poppins',
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 10,
                          margin: EdgeInsets.only(
                            left: 19,
                            right: 19,
                          ),
                          child: Text(
                            'Price',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontFamily: 'poppins',
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 10,
                          child: Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontFamily: 'poppins',
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.white,
                      thickness: 0.5,
                    ),
                    ////////// items list start /////////
                    Column(
                      children: List.generate(
                        store.state.orerDetailsState['items'].length,
                        (index) {
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width /
                                        2.35,
                                    child: Text(
                                      store.state.orerDetailsState['items'][index]['product']['name'] == null
                                          ? ''
                                          : "${store.state.orerDetailsState['items'][index]['product']['name']}",
                                      style: TextStyle(
                                        fontSize: 12,
                                        // fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        fontFamily: 'poppins',
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 12,
                                    child: Text(
                                      store.state.orerDetailsState['items'][index]['quantity'] == null
                                          ? ''
                                          : "${store.state.orerDetailsState['items'][index]['quantity']}",
                                      style: TextStyle(
                                        fontSize: 12,
                                        // fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        fontFamily: 'poppins',
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 10,
                                    margin: EdgeInsets.only(
                                      left: 19,
                                      right: 19,
                                    ),
                                    child: Text(
                                      store.state.orerDetailsState['items'][index]['price'] == null
                                          ? ''
                                          : "${store.state.orerDetailsState['items'][index]['price']}",
                                      style: TextStyle(
                                        fontSize: 12,
                                        // fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        fontFamily: 'poppins',
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 10,
                                    child: Text(
                                      store.state.orerDetailsState['items'][index]['price'] == null
                                          ? ''
                                          : "${store.state.orerDetailsState['items'][index]['price']*store.state.orerDetailsState['items'][index]['quantity']}",
                                      style: TextStyle(
                                        fontSize: 12,
                                        // fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        fontFamily: 'poppins',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                color: Colors.white,
                                thickness: 0.5,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    ////////// items list end /////////
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sub Total:  ',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontFamily: 'poppins',
                          ),
                        ),
                        Text(
                          'Discount:  ',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontFamily: 'poppins',
                          ),
                        ),
                        Text(
                          'Delivery charge:  ',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontFamily: 'poppins',
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          store.state.orerDetailsState['subTotal'] == null
                           ? ''
                          : "৳${store.state.orerDetailsState['subTotal']}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontFamily: 'poppins',
                          ),
                        ),
                        Text(
                          store.state.orerDetailsState['discount_amount'] == null
                           ? ''
                          : "৳${store.state.orerDetailsState['discount_amount']}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontFamily: 'poppins',
                          ),
                        ),
                        Text(
                          store.state.orerDetailsState['shipingCharge'] == null
                           ? ''
                          : "৳${store.state.orerDetailsState['shipingCharge']}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontFamily: 'poppins',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(
                color: Color(0xFF979797),
                thickness: 0.5,
              ),
              ///////// Grand Total start /////////
              Container(
                // margin: EdgeInsets.only(top: 0, bottom: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Grand Total:  ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontFamily: 'poppins',
                      ),
                    ),
                    Text(
                      store.state.orerDetailsState['total'] == null
                           ? ''
                          : "৳${store.state.orerDetailsState['total']}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontFamily: 'poppins',
                      ),
                    ),
                  ],
                ),
              ),
              ///////// Grand Total end /////////
              /////////////// order summary end /////////////////

     /////////////// cancel/re - order start /////////////////
              //////////////////////////// Cancle Order Button Start ///////////////
              store.state.orerDetailsState['status'] == "Pending"?
              GestureDetector(
                onTap: _isCancelOrderPressed? null: _cancelOrderButton,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                      EdgeInsets.only(top: 15, bottom: 15, left: 30, right: 30),
                  margin: EdgeInsets.only(top: 40, bottom: 25),
                  decoration: BoxDecoration(
                    color: Color(0xFFF3F2F2),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isCancelOrderPressed ? "Canceling..." : 'Cancel Order',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      // Text(
                      //   '(04:48)',
                      //   textAlign: TextAlign.center,
                      //   style: TextStyle(
                      //     fontSize: 16,
                      //     fontWeight: FontWeight.w500,
                      //     color: Colors.black,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ):
              //////////////////////////// Cancle Button Start ///////////////

              //////////////////////////// Re Order Button Start ///////////////
              store.state.orerDetailsState['status'] == "Delivered" || store.state.orerDetailsState['status'] =="Canceled" ?
              GestureDetector(
                onTap: _isReOrderPressed? null:  _checkingCart,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  margin: EdgeInsets.only(top: 40, bottom: 25),
                  decoration: BoxDecoration(
                    color: Color(0xFF0487FF),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    'Re Order',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ) : 
              Container()
              //////////////////////////// Re Order Button End ///////////////
        /////////////// cancel/re - order end /////////////////
            ],
          ),
        ),
      ),
    );
    }
    );
  }

  ///
  Container buildTotalDetailsContainer(var title, var amount) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            '$title ',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontFamily: 'poppins',
            ),
          ),
          Text(
            '৳$amount',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontFamily: 'poppins',
            ),
          ),
        ],
      ),
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
  


Future<void> _checkingCart() async {
  if(store.state.cartListState.length > 0){
    _errorDialog("Your previous cart will be reset!");
    }
    else{
      _reOrderButton();
    }
}


  ////////// RE Order start //////////
  Future<void> _reOrderButton() async {
    setState(() {
      _isReOrderPressed = true;
    });

    //await Future.delayed(const Duration(seconds: 1));

      var data = {
      'order_id': store.state.orerDetailsState['id'],
    };

    //print(store.state.productDetailsState);
    print(data);
    // setState(() {
    //   _isReOrderPressed = false;
    // });
    // return;

    var res = await CallApi().postDataWithToken(data, 'ordermodule/reOrder');
    var body = json.decode(res.body);
    print('body - $body');

    if (res.statusCode == 200) {
      _showMsg('Payment successful!', 2);
      Navigator.pushReplacement(context,ScaleRoute(page: CartPage("Reorder"),));
    } 
    else if (res.statusCode == 401) {
      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
    else if (res.statusCode == 422) {
      _showMsg(body['message'], 1);
    }
     else {
      _showMsg("Something went wrong! Please try again", 1);
    }


    setState(() {
      _isReOrderPressed = false;
    });
  }

  ////////// RE Order  end //////////
  
   ////////// Cancel Order start //////////
  Future<void> _cancelOrderButton() async {
    setState(() {
      _isCancelOrderPressed = true;
    });

    //await Future.delayed(const Duration(seconds: 1));

      var data = {
      'order_id': store.state.orerDetailsState['id'],
    };

    //print(store.state.productDetailsState);
    print(data);
    // setState(() {
    //   _isCancelOrderPressed = false;
    // });
    // return;

    var res = await CallApi().postDataWithToken(data, 'ordermodule/updateOrderStatusCancel');
    var body = json.decode(res.body);
    print('body - $body');

    if (res.statusCode == 200) {
      _showMsg('Order canceled successfully!', 2);
      for(var d in store.state.recentOrderState){
        if(d['id'] == store.state.orerDetailsState['id']){
          store.state.recentOrderState.remove(d);
          store.state.pastOrderState.add(d);
          d['status'] = "Canceled";
          break;
        }
      }
      store.dispatch(RecentOrderAction(store.state.recentOrderState));
      Navigator.pop(context);
    } 
    else if (res.statusCode == 401) {
      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
    else if (res.statusCode == 422) {
      _showMsg(body['message'], 1);
    }
     else {
      _showMsg("Something went wrong! Please try again", 1);
    }


    setState(() {
      _isCancelOrderPressed = false;
    });
  }

  ////////// Cancel Order  end //////////
  
  ////////////// Error Dialog STart //////////
  Future<Null> _errorDialog(title) async {
    return showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5),
                        topLeft: Radius.circular(5),
                      ),
                      border: Border.all(color: Colors.white)),
                  padding: EdgeInsets.only(top: 20),
                  child: Container(
                      width: 55,
                      height: 55,
                      margin: EdgeInsets.all(15),
                      child: Image.asset("assets/images/alarm.png")
                      ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white)),
                  padding: EdgeInsets.only(bottom: 10, top: 10, left: 10, right:10),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'quicksand',
                        color: Color(0xff003A5B),
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(top: 0, bottom: 20, left: 30, right: 30),
                  decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                              ),
                              border: Border.all(color: Colors.white)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                            width: 100,
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(10),
                           // margin: EdgeInsets.only(top: 0, bottom: 20, left: 30, right: 30),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.black)
                            ),
                            child: Text("Cancel",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "quicksand"))),
                      ),


                      GestureDetector(
                        onTap: () {
                          _reOrderButton();
                          Navigator.pop(context);
                        },
                        child: Container(
                            width: 100,
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(10),
                           // margin: EdgeInsets.only(top: 0, bottom: 20, left: 30, right: 30),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text("Continue",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "quicksand"))),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
   ////////////// Errort Dialog End //////////
}
