import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class DriverOrderDetailsPage extends StatefulWidget {
  final orderID;
  final whichPage;
  DriverOrderDetailsPage(this.orderID, this.whichPage);
  @override
  _DriverOrderDetailsPageState createState() => _DriverOrderDetailsPageState();
}

class _DriverOrderDetailsPageState extends State<DriverOrderDetailsPage> {

  bool _isAcceptPressed = false;
  bool _isPickUpPressed = false;
  bool _isDeliveredPressed = false;

  var pickUpCounter = 0;
  bool _isAllItemPicked = false;
  bool _isPicked = false;


  @override
  void initState() {
    print(widget.whichPage);
    _getDriverOrderDetails();
    //print(widget.orderID);
    super.initState();
  }


  ////////////////// get Driver Order Details start ////////////////////
  _getDriverOrderDetails() async {
    store.dispatch(DriverOrderDetailsLoadingAction(true));
    var res = await CallApi().getDataWithToken('drivermodule/getAllSingleOrders/${widget.orderID}');
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
     store.dispatch(DriverOrderDetailsAction(body['data']));

    } else if (res.statusCode == 401) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }else{
           _showMsg("Something went wrong", 1);
      }           
       store.dispatch(DriverOrderDetailsLoadingAction(false));
  }
  ////////////////// get Driver Order Details end ////////////////////  
  
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        ////// this is the connector which mainly changes state/ui
        converter: (store) => store.state,
        builder: (context, items) {
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
      body: store.state.driverOrderDetailsLoadingState?
      Center(
        child: SpinKitCircle(
          color: Color(0xFF0487FF),
           // size: 30,
        ),
      ) :
      Stack(
        children: [
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              margin: EdgeInsets.only(top: 20, bottom: 80, left: 15, right: 15),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  /////////////////// Order Information start /////////////////////
                  buildDetailsContainer(
                    'Order Information',
                    'Invoice ID: ',
                    store.state.driverOrderDetailsState['id']==null?"":'#${store.state.driverOrderDetailsState['id']}',
                    'Order Date: ',
                    store.state.driverOrderDetailsState['created_at']==null?"":'${DateFormat.yMd().add_jm().format(DateTime.parse(store.state.driverOrderDetailsState['created_at']))}',
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 15),
                    child: Divider(),
                  ),
                  /////////////////// Order Information end /////////////////////

                  /////////////////// Delivery Man Information start /////////////////////
                  widget.whichPage == "NewOrder"? Container():
                  buildDetailsContainer(
                    'Delivery Man Information',
                    'Name: ',
                    store.state.userInfoState['name']==null?"":'${store.state.userInfoState['name']}',
                    'Phone: ',
                    store.state.userInfoState['phone']==null?"":'${store.state.userInfoState['phone']}',
                  ),
                  widget.whichPage == "NewOrder"? Container():
                  Container(
                    margin: EdgeInsets.only(bottom: 15),
                    child: Divider(),
                  ),
                  /////////////////// Delivery Man Information end /////////////////////

                  /////////////////// Product Information start /////////////////////
                  buildDetailsContainer(
                    'Product Information',
                    'Payment Method: ',
                    store.state.driverOrderDetailsState['paymentType']==null?"":'${store.state.driverOrderDetailsState['paymentType']}',
                    'Total Bill: ',
                    store.state.driverOrderDetailsState['total']==null?"":'৳${store.state.driverOrderDetailsState['total']}',
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
                    store.state.driverOrderDetailsState['user']['name']==null?"":'${store.state.driverOrderDetailsState['user']['name']}',
                    'Phone: ',
                    store.state.driverOrderDetailsState['user']['phone']==null?"":'${store.state.driverOrderDetailsState['user']['phone']}',
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Address: ',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontFamily: 'poppins',
                        ),
                      ),
                      Expanded(
                        child: Text(
                          store.state.driverOrderDetailsState['user']['address']==null?"":'${store.state.driverOrderDetailsState['user']['address']}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontFamily: 'poppins',
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 15),
                    child: Divider(),
                  ),
                  /////////////////// Shipping Information end /////////////////////

                  /////////////////// Ordered Products List start /////////////////////
                  Column(
                    children: List.generate(
                      store.state.driverOrderDetailsState['items'].length,
                      (index) {
                        return GestureDetector(
                          onTap: () {
                                if(_isPicked){
                                  if(!mounted) return;
                                  setState(() {
                                    _isPicked = false;
                                    pickUpCounter--;
                                  });
                                }else{
                                  if(!mounted) return;
                                  setState(() {
                                    _isPicked = true;
                                    pickUpCounter++;
                                  });
                                }
                                  _chekPickedItem();
                                 print(pickUpCounter);
                              },
                          child: Container(
                            color: Colors.transparent,
                            child: Column(
                              children: [
                                widget.whichPage != "Processing"? Container():
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    _isPicked ? Icon(Icons.check_circle, color: Colors.green,):
                                    Icon(Icons.radio_button_unchecked, color: Colors.grey,),

                                    if(_isPicked)Text(
                                            _isPicked ? 'Picked':'Not Picked',
                                            style: TextStyle(
                                              color: _isPicked ? Colors.green:Colors.grey,
                                              fontFamily: 'poppins',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                  ],
                                ),
                                Row(
                                  children: [

                                    ///////////////////////// Image ///////////////////////
                                    Container(
                                      height: 100,
                                      width: 100,
                                      //color: Colors.red,
                                      margin: EdgeInsets.only(right: 10),
                                      child: store.state.driverOrderDetailsState['items'][index]['product']['image'] == null ?
                                      Image.asset(
                                        "assets/images/placeHolder.jpg",
                                         fit: BoxFit.contain,
                                      )
                                    :
                             CachedNetworkImage(
                              imageUrl: store.state.driverOrderDetailsState['items'][index]['product']['image'],
                              fit: BoxFit.contain,
                              
                              placeholder: (context, url) => Center(
                                child: SpinKitFadingCircle(
                                  color: Colors.grey,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  Center(child: new Icon(Icons.error)),
                            ),
                                    ),

                            ///////////////////////// Image ///////////////////////
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${store.state.driverOrderDetailsState['items'][index]['product']['name']}',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'poppins',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            'Size: ${store.state.driverOrderDetailsState['items'][index]['variation']['name']}',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'poppins',
                                            ),
                                          ),
                                          Text(
                                            store.state.driverOrderDetailsState['items'][index]['product']['brand']==null?"":
                                            'Company: ${store.state.driverOrderDetailsState['items'][index]['product']['brand']['name']}',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'poppins',
                                            ),
                                          ),
                                          Text(
                                            'Quantity: ${store.state.driverOrderDetailsState['items'][index]['quantity']}',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'poppins',
                                            ),
                                          ),
                                          Text(
                                            'Purchase Price: ৳${store.state.driverOrderDetailsState['items'][index]['variation']['purchase_price']}',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'poppins',
                                            ),
                                          ),
                                          Text(
                                            'Total Purchase Price: ৳${(double.parse(store.state.driverOrderDetailsState['items'][index]['variation']['purchase_price']))*store.state.driverOrderDetailsState['items'][index]['quantity']}',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'poppins',
                                            ),
                                          ),
                                          Text(
                                            'Sale Price: ৳${store.state.driverOrderDetailsState['items'][index]['variation']['price']}',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'poppins',
                                            ),
                                          ),
                                          Text(
                                            'Total Price: ৳${(store.state.driverOrderDetailsState['items'][index]['variation']['price'])*store.state.driverOrderDetailsState['items'][index]['quantity']}',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'poppins',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 5),
                                  child: Divider(),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  /////////////////// Ordered Products List end /////////////////////
                ],
              ),
            ),
          ),

          /////////////////////////// Buttons Start ///////////////////
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            //color: Colors.red,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ////////////////// Accept/Reject Order Button Start //////////////
                 widget.whichPage != "NewOrder"? Container():
                  Container(
                    color: Colors.white70,
                    padding: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ////////////////////// Reject Button Start //////////////////////
                        GestureDetector(
                          onTap: _isAcceptPressed ? null :_rejectOrder,
                          child: Container(
                            width: MediaQuery.of(context).size.width / 3,
                            padding: EdgeInsets.only(top: 13, bottom: 13),
                            margin: EdgeInsets.only(top: 10, bottom: 20),
                            decoration: BoxDecoration(
                              color: _isAcceptPressed ? Colors.grey : Colors.red[400],
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
                          onTap: _isAcceptPressed ? null : _acceptOrder,
                          child: Container(
                            width: MediaQuery.of(context).size.width / 3,
                            padding: EdgeInsets.only(top: 13, bottom: 13),
                            margin: EdgeInsets.only(top: 10, bottom: 20),
                            decoration: BoxDecoration(
                              color: _isAcceptPressed ? Colors.grey : Color(0xFF00B658),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              _isAcceptPressed ? "Accepting...":'Accept',
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
                  ////////////////// Accept/Reject Order Button End //////////////

                  ////////////////// PickUp Order Button Start //////////////
                  widget.whichPage != "Processing"? Container():
                  Container(
                    color: Colors.white70,
                    padding: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        
                        GestureDetector(
                          onTap: !_isAllItemPicked ? null : _isPickUpPressed ? null : _pickUpOrder,
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2,
                            padding: EdgeInsets.only(top: 13, bottom: 13),
                            margin: EdgeInsets.only(top: 10, bottom: 20),
                            decoration: BoxDecoration(
                              color: !_isAllItemPicked ? Colors.grey : _isPickUpPressed ? Colors.grey : Colors.blue,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              _isPickUpPressed ? "Loading...":'Order Pick Up',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ////////////////// PickUp Order Button End ///////////////
                  
                  ////////////////// Delivered Order Button Start //////////////
                  widget.whichPage != "Pickup"? Container():
                  Container(
                    color: Colors.white70,
                    padding: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        
                        GestureDetector(
                          onTap: _isDeliveredPressed ? null : _deliveredOrder,
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2,
                            padding: EdgeInsets.only(top: 13, bottom: 13),
                            margin: EdgeInsets.only(top: 10, bottom: 20),
                            decoration: BoxDecoration(
                              color: _isDeliveredPressed ? Colors.grey : Colors.blue,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              _isDeliveredPressed ? "Loading...":'Delivery Complete',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ////////////////// Delivered Order Button End ///////////////
              ],
            ),
          )
          /////////////////////////// Buttons Start ///////////////////
        ],
      ),
    );
  });
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


//////////////////////////// Reject Order Start ///////////////////////
void _rejectOrder() async{
  for(var d in store.state.driverNewOrderState){
    if(d['id'] == widget.orderID){
      store.state.driverNewOrderState.remove(d);
      store.dispatch(DriverNewOrderAction(store.state.driverNewOrderState));
      break;
    }
  }
  Navigator.pop(context);
}
//////////////////////////// Reject Order End ///////////////////////


//////////////////////////// Accept Order Start /////////////////////
  Future<void> _acceptOrder() async {
    setState(() {
      _isAcceptPressed = true;
    });

    // await Future.delayed(const Duration(seconds: 1));


      var data = {
      'order_id': widget.orderID,
    };

    print(data);
  //   setState(() {
  //     _isAcceptPressed = false;
  //   });
  //  return;

    var res = await CallApi().postDataWithToken(data, 'drivermodule/accpetOrders');
    var body = json.decode(res.body);
    print('body - $body');

    if (res.statusCode == 200) {
      _showMsg('Order has been accepted!', 2);
      await Future.delayed(const Duration(milliseconds: 300));
      for(var d in store.state.driverNewOrderState){
        if(d['id'] == widget.orderID){
          store.state.driverNewOrderState.remove(d);
          store.dispatch(DriverNewOrderAction(store.state.driverNewOrderState));
          break;
        }
      }
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
      _isAcceptPressed = false;
    });
  }
//////////////////////////// Accept Order End ///////////////////////


//////////////////////////// PickUp Order Start /////////////////////
  Future<void> _pickUpOrder() async {
    setState(() {
      _isPickUpPressed = true;
    });

    // await Future.delayed(const Duration(seconds: 1));


      var data = {
      'order_id': widget.orderID,
    };

    print(data);
  //   setState(() {
  //     _isPickUpPressed = false;
  //   });
  //  return;

    var res = await CallApi().postDataWithToken(data, 'drivermodule/changePickedStatus');
    var body = json.decode(res.body);
    print('body - $body');

    if (res.statusCode == 200) {
      _showMsg('Order has been picked up!', 2);
      await Future.delayed(const Duration(milliseconds: 300));
      for(var d in store.state.driverProcessingOrderState){
        if(d['id'] == widget.orderID){
          store.state.driverProcessingOrderState.remove(d);
          store.dispatch(DriverNewOrderAction(store.state.driverProcessingOrderState));
          break;
        }
      }
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
      _isPickUpPressed = false;
    });
  }
//////////////////////////// PickUp Order End ///////////////////////


//////////////////////////// PickUp Order Start /////////////////////
  Future<void> _deliveredOrder() async {
    setState(() {
      _isDeliveredPressed = true;
    });

    // await Future.delayed(const Duration(seconds: 1));


      var data = {
      'order_id': widget.orderID,
    };

    print(data);
  //   setState(() {
  //     _isDeliveredPressed = false;
  //   });
  //  return;

    var res = await CallApi().postDataWithToken(data, 'drivermodule/changeDeliveredStatus');
    var body = json.decode(res.body);
    print('body - $body');

    if (res.statusCode == 200) {
      _showMsg('Order status changed to delivered!', 2);
      await Future.delayed(const Duration(milliseconds: 300));
      for(var d in store.state.driverPickupOrderState){
        if(d['id'] == widget.orderID){
          store.state.driverPickupOrderState.remove(d);
          store.dispatch(DriverNewOrderAction(store.state.driverPickupOrderState));
          break;
        }
      }
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
      _isDeliveredPressed = false;
    });
  }
//////////////////////////// PickUp Order End ///////////////////////


Future<void> _chekPickedItem() async{

  if(store.state.driverOrderDetailsState['items'].length == pickUpCounter){
    print("oise");
    if(!mounted) return;
      setState(() {
       _isAllItemPicked = true;
     });
  } 
  else{
    print("kom");
    if(!mounted) return;
    setState(() {
       _isAllItemPicked = false;
     });
  }
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
