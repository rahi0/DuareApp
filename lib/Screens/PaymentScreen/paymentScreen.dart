import 'dart:async';
import 'dart:convert';

import 'package:duare/Api/api.dart';
import 'package:duare/Redux/action.dart';
import 'package:duare/Redux/state.dart';
import 'package:duare/Screens/LoginScreen/loginScreen.dart';
import 'package:duare/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:duare/RouteTransition/routeAnimation.dart';
import 'package:duare/Screens/OrderPlacedScreen/orderPlacedScreen.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class PaymentScreen extends StatefulWidget {
  final orderData;
  final subTotal;
  PaymentScreen(this.orderData, this.subTotal);
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  TextEditingController noteController = TextEditingController();

  bool _isCheckedSchedule = false;
  bool _isCheckedCash = false;
  bool _isCheckedBkash = false;
  bool _isCheckedRocket = false;
  bool _isCheckedCard = false;
  bool _isCheckedRedeem = false;
  bool _isPaymentPressed = false;
  bool _isSchedulePressed = false;
  bool _isLoading = true;
  bool _isRedeemAvailable = true;
  var selectedTime;
  var selectedTimeID;
  var paymentOption = "Cash on Delivery";

  ///////////////////// Date Picker Essentials Start ///////////////////////
  String dateTo = "${DateFormat("yyyy-MM-dd").format(DateTime.now())}";
  DateTime selectedDateTo = DateTime.now();
  var dateTextController = new TextEditingController();

  Future<Null> _selectDateTo(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDateTo,
        firstDate: DateTime(1964, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDateTo) {
      setState(() {
        selectedDateTo = picked;
        // dateTo = "${DateFormat("dd/MM/yyyy").format(selectedDateTo)}";
        dateTo = "${DateFormat("yyyy-MM-dd").format(selectedDateTo)}";
        /////////// for time /////////
        selectedTimeID = null;
        selectedTime = null;
      });
    }
  }
  ///////////////////// Date Picker Essentials End ///////////////////////

  ////// <<<<< Time Picker start>>>>> //////
  TimeOfDay _time = TimeOfDay.now();
  TimeOfDay picked;
  String timeTo = '';
  var timeTextController = new TextEditingController();

  Future<Null> _selectTime(BuildContext context) async {
    picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    MaterialLocalizations localizations = MaterialLocalizations.of(context);
    String formattedTime =
        localizations.formatTimeOfDay(picked, alwaysUse24HourFormat: false);
    if (picked != null && picked != _time) {
      setState(() {
        _time = picked;
        timeTo = formattedTime;
      });
    }
  }

  ////// <<<<< Time Picker end >>>>> //////
  



  // ///////////////// get Account start /////////////////
  _getScheduleTime() async {
    store.dispatch(ScheduleLisLoadingtAction(true));

    var res = await CallApi().getDataWithToken('usermodule/getFranciseSchedule');
     var body = json.decode(res.body);
    // print(res.statusCode);
    // print('body - $body');
    // print('.....................');
 ////////// checking if token is expired
     if (res.statusCode == 200) {
      var body = json.decode(res.body); 
      print(body);
      store.dispatch(ScheduleListAction(body));
       

    } else if (res.statusCode == 401) {
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }else{
      _showMsg('Something went wrong!', 1);
    }
     store.dispatch(ScheduleLisLoadingtAction(false));
  }
  // ///////////////// get Account end /////////////////
  


  @override
  void initState() {
    _getScheduleTime();
    super.initState();
  }

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
        // backgroundColor: Colors.white,
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
          'Payment',
          style: TextStyle(
            fontFamily: 'poppins',
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: store.state.scheduleListLoadingState? 
               Center(
                 child: Container(
                 height: 220,
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     SpinKitCircle(
                        color: Color(0xFF0487FF),
                                    // size: 30,
                     ),
                   ],
                 ),             
               ),
       ) :
      SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 17, right: 17, top: 40),
          child: Column(
            children: [
              // Text(
              //   'Congratulations! Your order was placed immediately.',
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //     color: Color(0xFF00B658),
              //     fontSize: 14,
              //     fontFamily: 'poppins',
              //     // fontWeight: FontWeight.w500,
              //   ),
              // ),
              // Container(
              //   margin: EdgeInsets.only(top: 13, bottom: 12),
              //   child: Text(
              //     'OR',
              //     style: TextStyle(
              //       fontFamily: 'poppins',
              //       color: Colors.black,
              //       fontSize: 14,
              //       fontWeight: FontWeight.w500,
              //     ),
              //   ),
              // ),
              Text(
                'Select your desired time to receive your products.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF0487FF),
                  fontSize: 14,
                  fontFamily: 'poppins',
                  // fontWeight: FontWeight.w500,
                ),
              ),

              // ///////////////////// schedule order start ////////////////////
              // GestureDetector(
              //   onTap: () {
              //     setState(() {
              //       _isCheckedSchedule = !_isCheckedSchedule;
              //     });
              //   },
              //   child: Container(
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(5),
              //       border: Border.all(
              //         width: 0.5,
              //         color: _isCheckedSchedule
              //             ? Color(0xFF41AA74)
              //             : Color(0xFFDADADA),
              //       ),
              //     ),
              //     margin: EdgeInsets.only(top: 20, bottom: 10),
              //     child: Row(
              //       children: [
              //         IconButton(
              //           onPressed: () {
              //             setState(() {
              //               _isCheckedSchedule = !_isCheckedSchedule;
              //             });
              //           },
              //           icon: Icon(
              //             _isCheckedSchedule
              //                 ? Icons.radio_button_checked_outlined
              //                 : Icons.radio_button_unchecked_outlined,
              //             color: _isCheckedSchedule
              //                 ? Color(0xFF00B658)
              //                 : Color(0xFFDADADA),
              //           ),
              //         ),
              //         Text(
              //           'Schedule Order',
              //           style: TextStyle(
              //             fontFamily: 'poppins',
              //             color: Colors.black,
              //             fontSize: 16,
              //             fontWeight: FontWeight.w500,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // !_isCheckedSchedule
              //     ? Container()
              //     : 
              //     Container(
              //         margin: EdgeInsets.only(
              //           bottom: 14,
              //           // top: 10,
              //         ),
              //         padding: EdgeInsets.only(
              //             left: 20, right: 20, top: 12, bottom: 10),
              //         decoration: BoxDecoration(
              //           color: Color(0xFFDBE9EE),
              //           borderRadius: BorderRadius.all(
              //             Radius.circular(6),
              //           ),
              //           border: Border.all(
              //             width: 0.5,
              //             color: Color(0xFFD6D6D6),
              //           ),
              //         ),
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Row(
              //              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              //               children: [
              //                 Text(
              //                   'Delivery time',
              //                   style: TextStyle(
              //                     fontFamily: 'poppins',
              //                     color: Colors.black,
              //                     fontSize: 16,
              //                     fontWeight: FontWeight.w500,
              //                   ),
              //                 ),
              //                 Text(
              //                   'Delivery date',
              //                   style: TextStyle(
              //                     fontFamily: 'poppins',
              //                     color: Colors.black,
              //                     fontSize: 16,
              //                     fontWeight: FontWeight.w500,
              //                   ),
              //                 ),
              //               ],
              //             ),
              //             SizedBox(
              //               height: 20,
              //             ),
              //             Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //               children: [
              //                 GestureDetector(
              //                   onTap: () {
              //                     _selectTime(context);
              //                   },
              //                   child: Container(
              //                     width:
              //                         MediaQuery.of(context).size.width / 2.55,
              //                     padding: EdgeInsets.only(top: 10, bottom: 10),
              //                     decoration: BoxDecoration(
              //                       color: Color(0xFFC0D6DF),
              //                       borderRadius: BorderRadius.circular(5),
              //                     ),
              //                     child: Row(
              //                       mainAxisAlignment: MainAxisAlignment.center,
              //                       children: [
              //                         Text(
              //                           timeTo == "" ? 'Select Time' : timeTo,
              //                           style: TextStyle(
              //                             fontFamily: 'poppins',
              //                             color: Color(0xFF263238),
              //                             fontSize: 14,
              //                             // fontWeight: FontWeight.w500,
              //                           ),
              //                         ),
              //                         SizedBox(width: 22),
              //                         Icon(
              //                           FlutterIcons.edit_fea,
              //                           color: Color(0xFF263238),
              //                         ),
              //                       ],
              //                     ),
              //                   ),
              //                 ),
              //                 GestureDetector(
              //                   onTap: () {
              //                     _selectDateTo(context);
              //                   },
              //                   child: Container(
              //                     width:
              //                         MediaQuery.of(context).size.width / 2.55,
              //                     padding: EdgeInsets.only(top: 10, bottom: 10),
              //                     decoration: BoxDecoration(
              //                       color: Color(0xFFC0D6DF),
              //                       borderRadius: BorderRadius.circular(5),
              //                     ),
              //                     child: Row(
              //                       mainAxisAlignment: MainAxisAlignment.center,
              //                       children: [
              //                         Text(
              //                           dateTo == "" ? 'Select Date' : dateTo,
              //                           style: TextStyle(
              //                             fontFamily: 'poppins',
              //                             color: Color(0xFF263238),
              //                             fontSize: 14,
              //                             // fontWeight: FontWeight.w500,
              //                           ),
              //                         ),
              //                         SizedBox(width: 22),
              //                         Icon(
              //                           FlutterIcons.edit_fea,
              //                           color: Color(0xFF263238),
              //                         ),
              //                       ],
              //                     ),
              //                   ),
              //                 ),
              //               ],
              //             ),
              //             SizedBox(
              //               height: 20,
              //             ),
              //           ],
              //         ),
              //       ),
              // ///////////////////// schedule order end ////////////////////
              

              ///////////////////// schedule Date start ////////////////////
              Container(
                width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(bottom: 14,top: 20, ),
                     // padding: EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Delivery date',
                            style: TextStyle(
                              fontFamily: 'poppins',
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              _selectDateTo(context);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              decoration: BoxDecoration(
                                color: Color(0xFFC0D6DF),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    dateTo == "" ? 'Select Date' : "${DateFormat("dd-MM-yyyy").format(DateTime.parse(dateTo))}",
                                    style: TextStyle(
                                      fontFamily: 'poppins',
                                      color: Color(0xFF263238),
                                      fontSize: 14,
                                      // fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(width: 22),
                                  Icon(
                                    FlutterIcons.edit_fea,
                                    color: Color(0xFF263238),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
              ///////////////////// schedule Date start ////////////////////
              
              ///////////////////// schedule time start ////////////////////
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(bottom: 14,),
                      padding: EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 10),
                      decoration: BoxDecoration(
                        color: Color(0xFFDBE9EE),
                        borderRadius: BorderRadius.all(Radius.circular(6),),
                        border: Border.all(width: 0.5,color: Color(0xFFD6D6D6),
                        ),
                      ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isCheckedSchedule = !_isCheckedSchedule;
                         });
                       },
                      child: Container(
                        color: Color(0xFFDBE9EE),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedTime==null? "Delivery Time":
                              'Delivery Time   $selectedTime',
                              style: TextStyle(
                                fontFamily: 'poppins',
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                ),
                            ),
                            Icon(_isCheckedSchedule
                                  ? Icons.keyboard_arrow_up:Icons.keyboard_arrow_down,
                                   color:  Color(0xFF263238),
                            ),
                          ],
                        ),
                      ),
                    ),
                    !_isCheckedSchedule ? Container():
                    Container(
                      child: Column(
                        children: List.generate(
                          store.state.scheduleListState.length, (index){
                          return GestureDetector(
                              onTap: () {
                                if(!_isSchedulePressed){
                                  _doSchedule(store.state.scheduleListState[index]);
                                }else{
                                  null;
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFC0D6DF),
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    width: 0.5,
                                    color: selectedTimeID == store.state.scheduleListState[index]['id']
                                        ? Color(0xFF41AA74)
                                        : Color(0xFFDADADA),
                                  ),
                                ),
                                margin: EdgeInsets.only(top: 10, bottom: 5),
                                padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                                child: Row(
                                  children: [
                                    Icon(
                                        selectedTimeID == store.state.scheduleListState[index]['id']
                                            ? Icons.radio_button_checked_outlined
                                            : Icons.radio_button_unchecked_outlined,
                                        color: selectedTimeID == store.state.scheduleListState[index]['id']
                                            ? Color(0xFF00B658)
                                            : Color(0xFF263238),
                                      ),
                                    Container(
                                      margin: EdgeInsets.only(left: 5),
                                      child: Text(
                                        '${store.state.scheduleListState[index]['startTime']} - ${store.state.scheduleListState[index]['endTime']}',
                                        style: TextStyle(
                                          fontFamily: 'poppins',
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                        }),
                      ),
                    )
                  ],
                ),
              ),
              ///////////////////// schedule time end ////////////////////

              /////////////// additional notes start //////////////////
              Container(
                margin: EdgeInsets.only(top: 30, bottom: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Additional Notes',
                      style: TextStyle(
                        fontFamily: 'poppins',
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '  (Optional)',
                      style: TextStyle(
                        fontFamily: 'poppins',
                        color: Color(0xFFB1B1B1),
                        fontSize: 14,
                        // fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 40),
                decoration: BoxDecoration(
                  // color: Color(0xFFF0EFEF),
                  border: Border.all(
                    color: Color(0xFFDADADA),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                  maxLines: null,
                  minLines: 3,
                  controller: noteController,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'poppins',
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: "Type here....",
                    hintStyle: TextStyle(
                      fontSize: 13,
                      color: Color(0xffB1B1B1),
                      fontFamily: 'poppins',
                    ),
                    contentPadding:
                        EdgeInsets.only(left: 18, top: 12, bottom: 11),
                    border: InputBorder.none,
                  ),
                ),
              ),
              /////////////// additional notes end //////////////////

              /////////////// payment options start /////////////////
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Payment Options',
                  style: TextStyle(
                    fontFamily: 'poppins',
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              /////////// cash on delivery start //////////
              GestureDetector(
                onTap: () {
                  setState(() {
                    paymentOption = "Cash on Delivery";
                    _isRedeemAvailable = true;
                    // _isCheckedCash = !_isCheckedCash;
                    // _isCheckedBkash = false;
                    // _isCheckedRocket = false;
                    // _isCheckedCard = false;
                    // _isCheckedRedeem = false;
                  });
                  print(paymentOption);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      width: 1,
                      color: paymentOption == "Cash on Delivery"
                          ? Color(0xFF41AA74)
                          : Color(0xFFDADADA),
                    ),
                  ),
                  margin: EdgeInsets.only(top: 20, bottom: 12),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            paymentOption = "Cash on Delivery";
                            _isRedeemAvailable = true;
                            // _isCheckedCash = !_isCheckedCash;
                            // _isCheckedBkash = false;
                            // _isCheckedRocket = false;
                            // _isCheckedCard = false;
                            // _isCheckedRedeem = false;
                          });
                          print(paymentOption);
                        },
                        icon: Icon(
                          paymentOption == "Cash on Delivery"
                              ? Icons.radio_button_checked_outlined
                              : Icons.radio_button_unchecked_outlined,
                          color: paymentOption == "Cash on Delivery"
                              ? Color(0xFF00B658)
                              : Color(0xFFDADADA),
                        ),
                      ),
                      Text(
                        'Cash on Delivery',
                        style: TextStyle(
                          fontFamily: 'poppins',
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              /////////// cash on delivery end //////////

              // /////////// bkash rocket option row start ///////////
              // Row(
              //   children: [
              //     Expanded(
              //       child: GestureDetector(
              //         onTap: () {
              //           setState(() {
              //             _isCheckedBkash = !_isCheckedBkash;
              //             _isCheckedCash = false;
              //             _isCheckedRocket = false;
              //             _isCheckedCard = false;
              //             _isCheckedRedeem = false;
              //           });
              //         },
              //         child: Container(
              //           decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(5),
              //             border: Border.all(
              //               width: 1,
              //               color: _isCheckedBkash
              //                   ? Color(0xFF41AA74)
              //                   : Color(0xFFDADADA),
              //             ),
              //           ),
              //           margin: EdgeInsets.only(top: 8, bottom: 12),
              //           child: Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: [
              //               Row(
              //                 children: [
              //                   IconButton(
              //                     onPressed: () {
              //                       setState(() {
              //                         _isCheckedBkash = !_isCheckedBkash;
              //                         _isCheckedCash = false;
              //                         _isCheckedRocket = false;
              //                         _isCheckedCard = false;
              //                         _isCheckedRedeem = false;
              //                       });
              //                     },
              //                     icon: Icon(
              //                       _isCheckedBkash
              //                           ? Icons.radio_button_checked_outlined
              //                           : Icons.radio_button_unchecked_outlined,
              //                       color: _isCheckedBkash
              //                           ? Color(0xFF00B658)
              //                           : Color(0xFFDADADA),
              //                     ),
              //                   ),
              //                   Text(
              //                     'Bkash',
              //                     style: TextStyle(
              //                       fontFamily: 'poppins',
              //                       color: Colors.black,
              //                       fontSize: 16,
              //                       fontWeight: FontWeight.w500,
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //               Container(
              //                 height: 27,
              //                 margin: EdgeInsets.only(right: 5),
              //                 child: Image.asset(
              //                   'assets/images/bkashLogo.png',
              //                   fit: BoxFit.contain,
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //     ),
              //     SizedBox(
              //       width: 10,
              //     ),
              //     Expanded(
              //       child: GestureDetector(
              //         onTap: () {
              //           setState(() {
              //             _isCheckedRocket = !_isCheckedRocket;
              //             _isCheckedBkash = false;
              //             _isCheckedCash = false;
              //             _isCheckedCard = false;
              //             _isCheckedRedeem = false;
              //           });
              //         },
              //         child: Container(
              //           decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(5),
              //             border: Border.all(
              //               width: 1,
              //               color: _isCheckedRocket
              //                   ? Color(0xFF41AA74)
              //                   : Color(0xFFDADADA),
              //             ),
              //           ),
              //           margin: EdgeInsets.only(top: 8, bottom: 12),
              //           child: Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: [
              //               Row(
              //                 children: [
              //                   IconButton(
              //                     onPressed: () {
              //                       setState(() {
              //                         _isCheckedRocket = !_isCheckedRocket;
              //                         _isCheckedBkash = false;
              //                         _isCheckedCash = false;
              //                         _isCheckedCard = false;
              //                         _isCheckedRedeem = false;
              //                       });
              //                     },
              //                     icon: Icon(
              //                       _isCheckedRocket
              //                           ? Icons.radio_button_checked_outlined
              //                           : Icons.radio_button_unchecked_outlined,
              //                       color: _isCheckedRocket
              //                           ? Color(0xFF00B658)
              //                           : Color(0xFFDADADA),
              //                     ),
              //                   ),
              //                   Text(
              //                     'Rocket',
              //                     style: TextStyle(
              //                       fontFamily: 'poppins',
              //                       color: Colors.black,
              //                       fontSize: 16,
              //                       fontWeight: FontWeight.w500,
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //               Container(
              //                 height: 27,
              //                 margin: EdgeInsets.only(right: 5),
              //                 child: Image.asset(
              //                   'assets/images/rocketLogo.png',
              //                   fit: BoxFit.contain,
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              // /////////// bkash rocket option row end ///////////

              // /////////// card start ///////////
              // GestureDetector(
              //   onTap: () {
              //     setState(() {
              //       _isCheckedCard = !_isCheckedCard;
              //       _isCheckedBkash = false;
              //       _isCheckedCash = false;
              //       _isCheckedRocket = false;
              //       _isCheckedRedeem = false;
              //     });
              //   },
              //   child: Container(
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(5),
              //       border: Border.all(
              //         width: 1,
              //         color: _isCheckedCard
              //             ? Color(0xFF41AA74)
              //             : Color(0xFFDADADA),
              //       ),
              //     ),
              //     margin: EdgeInsets.only(top: 8, bottom: 8),
              //     child: Row(
              //       children: [
              //         Expanded(
              //           child: Row(
              //             children: [
              //               IconButton(
              //                 onPressed: () {
              //                   setState(() {
              //                     _isCheckedCard = !_isCheckedCard;
              //                     _isCheckedBkash = false;
              //                     _isCheckedCash = false;
              //                     _isCheckedRocket = false;
              //                     _isCheckedRedeem = false;
              //                   });
              //                 },
              //                 icon: Icon(
              //                   _isCheckedCard
              //                       ? Icons.radio_button_checked_outlined
              //                       : Icons.radio_button_unchecked_outlined,
              //                   color: _isCheckedCard
              //                       ? Color(0xFF00B658)
              //                       : Color(0xFFDADADA),
              //                 ),
              //               ),
              //               Text(
              //                 'Card',
              //                 style: TextStyle(
              //                   fontFamily: 'poppins',
              //                   color: Colors.black,
              //                   fontSize: 16,
              //                   fontWeight: FontWeight.w500,
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //         Container(
              //           height: 21,
              //           width: 28,
              //           child: Image.asset(
              //             'assets/images/american-express 1.png',
              //             fit: BoxFit.contain,
              //           ),
              //         ),
              //         Container(
              //           height: 21,
              //           width: 28,
              //           child: Image.asset(
              //             'assets/images/visa 1.png',
              //             fit: BoxFit.contain,
              //           ),
              //         ),
              //         Container(
              //           height: 21,
              //           width: 28,
              //           child: Image.asset(
              //             'assets/images/image 140.png',
              //             fit: BoxFit.contain,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // /////////// card end ///////////

              /////////// Redeem cashback start ///////////
              GestureDetector(
                onTap: () {
                  checkRedeem();
                  setState(() {
                    paymentOption = "Redeem Cashback";
                    // _isCheckedRedeem = !_isCheckedRedeem;
                    // _isCheckedBkash = false;
                    // _isCheckedCash = false;
                    // _isCheckedCard = false;
                    // _isCheckedRocket = false;
                  });
                  print(paymentOption);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      width: 1,
                      color: paymentOption != "Cash on Delivery"
                          ? Color(0xFF41AA74)
                          : Color(0xFFDADADA),
                    ),
                  ),
                  margin: EdgeInsets.only(top: 8, bottom: 10),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          checkRedeem();
                          setState(() {
                            paymentOption = "Redeem Cashback";
                            // _isCheckedRedeem = !_isCheckedRedeem;
                            // _isCheckedBkash = false;
                            // _isCheckedCash = false;
                            // _isCheckedCard = false;
                            // _isCheckedRocket = false;
                          });
                          print(paymentOption);
                        },
                        icon: Icon(
                          paymentOption != "Cash on Delivery"
                              ? Icons.radio_button_checked_outlined
                              : Icons.radio_button_unchecked_outlined,
                          color: paymentOption != "Cash on Delivery"
                              ? Color(0xFF00B658)
                              : Color(0xFFDADADA),
                        ),
                      ),
                      Text(
                        'Redeem Cashback',
                        style: TextStyle(
                          fontFamily: 'poppins',
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              /////////// Redeem cashback end ///////////
              _isRedeemAvailable != false ? Container():
              Container(
                margin: EdgeInsets.only(bottom: 30),
                child: Text(
                          "You don't have enough duare points. Balance: ${double.parse(store.state.userInfoState['duare_points'])}",
                          style: TextStyle(
                            fontFamily: 'poppins',
                            color: Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
              ),
              /////////////// payment options end /////////////////

              /////////////// order summary start /////////////////
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Order Summary',
                  style: TextStyle(
                    fontFamily: 'poppins',
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 19),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2.55,
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
                        store.state.cartListState.length,
                        (index) {
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width /
                                        2.55,
                                    child: Text(
                                      '${store.state.cartListState[index]['product']['name']}',
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
                                      //"",
                                      '${store.state.cartListState[index]['quantity']}',
                                      textAlign: TextAlign.center,
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
                                      '${store.state.cartListState[index]['variation']['price']}',
                                      textAlign: TextAlign.center,
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
                                      '${(store.state.cartListState[index]['variation']['price'])*store.state.cartListState[index]['quantity']}',
                                      textAlign: TextAlign.center,
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

                    buildTotalDetailsContainer(1, 'Sub Total:', '${widget.subTotal}'),
                    buildTotalDetailsContainer(1, 'Delivery Charge:', '${widget.orderData['shipingCharge']}'),
                   paymentOption== "Redeem Cashback" ? Container() : buildTotalDetailsContainer(2, 'Total Cashback:', '${widget.orderData['discount_amount']}'),
                    ///////// Grand Total start /////////
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Grand Total:  ',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontFamily: 'poppins',
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width/4,
                            alignment: Alignment.centerRight,
                            child: Text(
                              '৳${widget.subTotal+widget.orderData['shipingCharge']}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontFamily: 'poppins',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ///////// Grand Total end /////////
                  ],
                ),
              ),
              /////////////// order summary end /////////////////

              //////////// Pay button start ///////////
              GestureDetector(
                onTap: _isPaymentPressed ? null: _doPayment,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  margin: EdgeInsets.only(top: 40, bottom: 25),
                  decoration: BoxDecoration(
                    color: Color(0xFF0487FF),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: _isPaymentPressed ? 
                                   Container(  
                                    height: 20,
                                    child: SpinKitThreeBounce(
                                      color: Colors.white,
                                      size: 23,
                                    ),
                                  ) :
                  Text(
                    'Pay',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              //////////// Pay button end /////////////
            ],
          ),
        ),
      ),
    );
  }
  );
  }

  Container buildTotalDetailsContainer(var cashType, var title, var amount) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            //color: Colors.red,
            child: Text(
              '$title ',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: cashType == 2? Colors.green: Colors.black,
                fontFamily: 'poppins',
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width/4,
            //color: Colors.green,
            alignment: Alignment.centerRight,
            child: Text(
              '৳$amount',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: cashType == 2? Colors.green:Colors.black,
                fontFamily: 'poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }


  /////////////// check redeem //////////////
  checkRedeem() async {
    if(double.parse(store.state.userInfoState['duare_points'])< (widget.subTotal+widget.orderData['shipingCharge'])){
      setState(() {
        _isRedeemAvailable = false;
      });
      print(double.parse(store.state.userInfoState['duare_points']));
      print(widget.subTotal+widget.orderData['shipingCharge']);
    } 
    else{
      print(double.parse(store.state.userInfoState['duare_points']));
      print(widget.subTotal+widget.orderData['shipingCharge']);
    }
  }
  /////////////// check redeem //////////////


  ////////// Payment start //////////
  Future<void> _doPayment() async {
    setState(() {
      _isPaymentPressed = true;
    });

    //await Future.delayed(const Duration(seconds: 1));

    if(selectedTimeID==null){
      _showMsg("Delivery time is not selected!", 1);
    } 
    else if (_isRedeemAvailable == false){
      _showMsg("Not enough duare points!", 1);
    }
    else{

      var data = {
      'user_id': store.state.userInfoState['id'],
      'category_id': widget.orderData['category_id'],
      'franchise_id': store.state.userInfoState['franchise_id'],
      'address_id': widget.orderData['address_id'],
      'shipingCharge': widget.orderData['shipingCharge'],
      'discount_amount': paymentOption== "Redeem Cashback" ? 0:widget.orderData['discount_amount'],
      'delivery_time': selectedTime,
      'orderDate': dateTo,
      'paymentType': paymentOption,
      'orderType': widget.orderData['orderType'],
      'coupon': paymentOption== "Redeem Cashback" ? "" : widget.orderData['coupon'],
      'remarks': noteController.text==null ? "" : noteController.text,
      'schedule_id': selectedTimeID
    };

    //print(store.state.productDetailsState);
    print(data);
   // return;

    var res = await CallApi().postDataWithToken(data, 'ordermodule/storeOrder');
    var body = json.decode(res.body);
    print('body - $body');

    if (res.statusCode == 200) {
      _showMsg('Payment successful!', 2);
      Navigator.pushReplacement(context,ScaleRoute(page: OrderPlacedScreen(),));
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

    }

    setState(() {
      _isPaymentPressed = false;
    });
  }

  ////////// Payment end //////////
  

  ////////// Check Schedule start //////////
  Future<void> _doSchedule(scheduleTime) async {
    setState(() {
      _isSchedulePressed = true;
      selectedTimeID = scheduleTime['id'];
      selectedTime = "${scheduleTime['startTime']} - ${scheduleTime['endTime']}";
    });

    print(selectedTimeID);
    print(selectedTime);

    //await Future.delayed(const Duration(seconds: 1));


      var data = {
      'id': scheduleTime['id'],
      'max_order': scheduleTime['max_order'],
      'date': dateTo,
    };

    //print(store.state.productDetailsState);
    print(data);
  //   setState(() {
  //     _isSchedulePressed = false;
  //   });
  //  return;

    var res = await CallApi().postDataWithToken(data, 'ordermodule/checkOrderSchedule');
    var body = json.decode(res.body);
    print('body - $body');

    if (res.statusCode == 200) {
      _showMsg('Schedule available!', 2);
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
      _isSchedulePressed = false;
    });
  }

  ////////// Check Schedule end //////////
  
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
