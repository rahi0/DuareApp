import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:duare/Api/api.dart';
import 'package:duare/Redux/action.dart';
import 'package:duare/Redux/state.dart';
import 'package:duare/Screens/AddressesScreen/addressesScreen.dart';
import 'package:duare/Screens/LoginScreen/loginScreen.dart';
import 'package:duare/Screens/ProductDetailsPage/productDetailsPage.dart';
import 'package:duare/main.dart';
import 'package:flutter/material.dart';
import 'package:duare/RouteTransition/routeAnimation.dart';
import 'package:duare/Screens/PaymentScreen/paymentScreen.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CartPage extends StatefulWidget {
  final whichPage;
  CartPage(this.whichPage);
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  var totalPrice;
  var price;
  var subTotal =0;
  var cashBack;
  var totalCashback;
  List coupons=[];
  var couponCashback;
  double deliveryCharge=0.0;
  // var subTotal;
  bool isCouponApply = false;
  bool couponApplied = false;
  TextEditingController couponController = TextEditingController();

  var _isExpanded = -1;

  //List addressList = ['Home'];
  var _currentAddressSelected = "Address";
  var _currentAddress="Select Delivery Address";
  var _currentAddressID;

  void _onDropDownAddressSelected(String newValueSelected) {
    setState(() {
      _currentAddressSelected = newValueSelected;
      // print('_currentAddressListSelected ----------------------- ');
      // print(_currentAddressSelected);
    });
    if (store.state.deliveryAddress.length > 0) {
        for (var d in store.state.deliveryAddress) {

          if(d['title']==newValueSelected){

            /////////////// Address Assigned /////////
            setState(() {
              _currentAddress = d['address'];
              _currentAddressID = d['id'];
            });
            // print(d['id']);
            break;
          } 
        } 
      }
      _getDeliveryCharge();
  }


  @override
  void initState() {
     _getCartData();
     _showDeliveryAddress();
     _getFrequentlyBoughtData();
    // _getCuponData();
    super.initState();
  }



  ////////////////// Get Address /////////////
  Future<void> _getDeliveryCharge() async {
     // store.dispatch(DeliveryAddressLoadingAction(true));
     var data = {
      'id': "${_currentAddressID}",
    };
    print(data);
    var res = await CallApi().postDataWithToken(data, 'ordermodule/getDeliveryPrice');
    var body = json.decode(res.body);
    print('body - $body');
    if (res.statusCode == 200) {
      var body = json.decode(res.body);
      print(body);
      setState(() {
        deliveryCharge = double.parse("${body['price']}");
            });
    }
    else if (res.statusCode == 401) {
      
      _showMsg("Login expired!", 1);
       Navigator.push( context, SlideLeftRoute(page: LoginScreen()));
    }
    else{

         _showMsg("Something went wrong", 1);

    }
   //store.dispatch(DeliveryAddressLoadingAction(false));
  }
  ////////////////// Get Address /////////////


  ////////////////// Get Address /////////////
  Future<void> _showDeliveryAddress() async {
      store.dispatch(DeliveryAddressLoadingAction(true));
    var res = await CallApi()
        .getDataWithToken('usermodule/getDeleveryAddress');

    if (res.statusCode == 200) {
      var body = json.decode(res.body);
      print(body);
     // store.dispatch(DeliveryAddressAction(body));
       List addressList = [];
      addressList.add({
        "id": 0,
        "countryCode": null,
        "country": null,
        "city": null, 
        "title": "Address",
        "phone": null, 
        "state": null, 
        "address": "Select Delivery Address", 
        "apartment_number": 0, 
        "lat": null, 
        "long": null, 
        "user_id": 0,
        "created_at": "2020-04-16T16:21:28.000000Z",
        "updated_at": "2020-04-16T16:21:28.000000Z"
      });
      store.dispatch(DeliveryAddressAction(addressList));
      if (body.length > 0) {
        for (var d in body) {
          store.state.deliveryAddress.add(d);
        }
      }
      store.dispatch(DeliveryAddressAction(store.state.deliveryAddress));
    }
    else if (res.statusCode == 401) {
      
      _showMsg("Login expired!", 1);
       Navigator.push( context, SlideLeftRoute(page: LoginScreen()));
    }
    else{

         _showMsg("Something went wrong", 1);

    }
   store.dispatch(DeliveryAddressLoadingAction(false));
  }
  ////////////////// Get Address /////////////
  

////////////////// get cart list start ////////////////////
  _getCartData() async {
    store.dispatch(CartListLoadingAction(true));
    var res =
        await CallApi().getDataWithToken('ordermodule/getAllCartData');
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
     store.dispatch(CartListAction(body['data']));
     _calculatePrice();

    } else if (res.statusCode == 401) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else{
           _showMsg("Something went wrong", 1);
      }
       store.dispatch(CartListLoadingAction(false));
  }
  ////////////////// get cart list end ////////////////////
  

  ////////////////// Frequently Bought list start ////////////////////
  _getFrequentlyBoughtData() async {
    store.dispatch(FrequentlyBoughtListLoadingAction(true));
    var res = await CallApi().getDataWithTokenandQuery('ordermodule/getFrequentlybrought', '&category_id=${store.state.whichHomeState['id']}');
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
     store.dispatch(FrequentlyBoughtListAction(body['data']));

    } else if (res.statusCode == 401) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else{
           _showMsg("Something went wrong", 1);
      }
       store.dispatch(FrequentlyBoughtListLoadingAction(false));
  }
  ////////////////// get Frequently Bought list end ////////////////////
 
 ////////////////// get cart list start ////////////////////
  _getCuponData() async {
    // store.dispatch(CartListLoadingAction(true));
    var res =
        await CallApi().getDataWithToken('ordermodule/getPublicCoupon');
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
     // if(mounted) return;
      setState(() {
        coupons = body['data'];
      });
    //  store.dispatch(CartListAction(body['data']));

    } else if (res.statusCode == 401) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else{
           _showMsg("Something went wrong", 1);
      }
      // store.dispatch(CartListLoadingAction(false));
  }
  ////////////////// get cart list end ////////////////////
  

  _calculatePrice(){
   
   // print(totalPrice);
    totalPrice = 0;
    price = 0;
    cashBack = 0;
    totalCashback = 0;
    for (var d in store.state.cartListState) {
      price = d['variation']['price'] * d['quantity'];
      totalPrice = totalPrice + price;

      cashBack = d['product']['percentage'] ==null || d['product']['percentage']==0? 0 :((d['product']['percentage']*(d['variation']['price'])/100)*d['quantity']);
      totalCashback = totalCashback + cashBack;
    
    }

    setState(() { 
       subTotal = totalPrice;
   //totalPrice= subTotal + delifee;
    });
  }

  @override
  Widget build(BuildContext context) {
     return StoreConnector<AppState, AppState>(
        ////// this is the connector which mainly changes state/ui
        converter: (store) => store.state,
        builder: (context, items) { 
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFF8F9FA),
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
          'My Cart',
          style: TextStyle(
            fontFamily: 'poppins',
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          padding: EdgeInsets.only(left: 16, right: 16, top: 30),
          child: Column(
            children: [
              ////////////// cart products list start ////////////
              store.state.cartLoadingState?
               Container(
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
               ):
              Column(
                children: List.generate(
                  store.state.cartListState.length,
                  (index) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 20),
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 12, bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                //color: Colors.red,
                                width: MediaQuery.of(context).size.width/7,
                                height: 85,
                                margin: EdgeInsets.only(right: 18),
                                child: store.state.cartListState[index]['product']['image'] == null ?
                                Image.asset(
                                  "assets/images/image 10.png",
                                  fit: BoxFit.cover,
                                ):
                                           CachedNetworkImage(
                                                         imageUrl: "${store.state.cartListState[index]['product']['image']}",
                                                        // fit: BoxFit.cover,
                                                         placeholder:(context, url) => Center(
                                                           child: SpinKitFadingCircle(
                                                             color: Colors.grey,),
                                                         ),
                                                         errorWidget: (context, url, error) =>
                                                             Center(child: new Icon(Icons.error)),
                                                       ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            // 'Arla Dano Daily Pushti Powder Milk',
                                            '${store.state.cartListState[index]['product']['name']}',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'poppins',
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            if (_isExpanded == index) {
                                              setState(() {
                                                _isExpanded = -1;
                                              });
                                            } else {
                                              setState(() {
                                                _isExpanded = index;
                                              });
                                            }
                                          },
                                          child: Icon(
                                            _isExpanded == index
                                                ? Icons.keyboard_arrow_up
                                                : Icons.keyboard_arrow_down,
                                            color: Colors.black,
                                            size: 25,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          // 'QTY: 2',
                                          'QTY: ${store.state.cartListState[index]['quantity']}',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'poppins',
                                          ),
                                        ),
                                        Text(
                                          // 'Size: 1 Kg',
                                          'Size: ${store.state.cartListState[index]['variation']['name']}',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'poppins',
                                          ),
                                        ),
                                        Text(
                                          '৳${(store.state.cartListState[index]['variation']['price'])*store.state.cartListState[index]['quantity']}',
                                          // store.state.cartListState[index]['product']['percentage'] ==null ||
                                          //   store.state.cartListState[index]['product']['percentage']==0?
                                          //     '৳${(store.state.cartListState[index]['variation']['price'])*store.state.cartListState[index]['quantity']}':
                                          //     '৳'+ ((store.state.cartListState[index]['variation']['price']-
                                          //      ( (store.state.cartListState[index]['product']['percentage']*(store.state.cartListState[index]['variation']['price']))/
                                          //      100))*store.state.cartListState[index]['quantity']).toString(),
                                          style: TextStyle(
                                            color: Color(0xFF00B658),
                                            fontSize: 16,
                                            fontFamily: 'poppins',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            deleteCartItem(store.state.cartListState[index]);
                                          },
                                          child: Icon(
                                            FlutterIcons.trash_fea,
                                            color: Color(0xFF979797),
                                            size: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          ////////////////// qty +/- start //////////////////
                          _isExpanded == index
                                                ?Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _decrement(store.state.cartListState[index]);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF00B658),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.remove,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 15, right: 15),
                                  child: Text(
                                    // '$_qty'
                                    '${store.state.cartListState[index]['quantity']}',
                                    style: TextStyle(
                                      color: Color(0xFF263238),
                                      fontFamily: 'poppins',
                                      // fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _increment(store.state.cartListState[index]);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF00B658),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ) : Container(),
                          ///////////////// qty +/- start //////////////////
                        ],
                      ),
                    );
                  },
                ),
              ),
              ////////////// cart products list end ////////////

              ////////////// delivery address container start /////////////
              store.state.deliveryAddressLoading? Container():
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(
                  bottom: 30,
                  top: 10,
                ),
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Delivery Address: ',
                              style: TextStyle(
                                fontSize: 13,
                                // fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontFamily: 'poppins',
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width/4,
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                    isDense: true,
                                    isExpanded: true,
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.black,
                                    ),
                                    value: _currentAddressSelected,
                                    hint: Text("Select Address", overflow: TextOverflow.ellipsis),
                                    style: TextStyle(
                                      fontSize: 14,
                                       fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      fontFamily: 'poppins',
                                    ),
                                    items: store.state.deliveryAddress.map((var value) {
                                      return DropdownMenuItem<String>(
                                        value: value['title'],
                                        child: Text("${value['title']} ",),
                                      );
                                    }).toList(),
                                    onChanged: (var newValueSelected) {
                                      _onDropDownAddressSelected(newValueSelected);
                                      //print(newValueSelected);
                                    }),
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.push( context,ScaleRoute(page: AddressesScreen(),));
                          },
                          child: Container(
                            // width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(
                                top: 7, bottom: 7, left: 25, right: 25),
                            // margin: EdgeInsets.only(top: 40, bottom: 25),
                            decoration: BoxDecoration(
                              color: Color(0xFF0487FF),
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                width: 0.5,
                                color: Color(0xFFDFDFDF),
                              ),
                            ),
                            child: Text(
                              'Add ',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      // 'MM enterprise, dhaka-sylhet highway,moulovibazar, Bangladesh',
                      _currentAddress==null? "":
                      "${_currentAddress}",
                      style: TextStyle(
                        fontSize: 14,
                        // fontWeight: FontWeight.w500,
                        color: Color(0xFF979797),
                        fontFamily: 'poppins',
                      ),
                    ),
                  ],
                ),
              ),
              ////////////// delivery address container end /////////////

              ////////////// frequently bought together items list start ///////////////
              widget.whichPage == "Reorder" ? Container():
              store.state.frequentlyBoughtListState.length<= 0 ? Container():
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Frequently Bought Together',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontFamily: 'poppins',
                  ),
                ),
              ),
              store.state.frequentlyBoughtLoadingState ?
              Container(
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
               ):
               widget.whichPage == "Reorder" ? Container():
               store.state.frequentlyBoughtListState.length<= 0 ? Container():
              Container(
                height: 170,
                margin: EdgeInsets.only(left: 15),
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  padding: EdgeInsets.only(bottom: 5.0),
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: store.state.frequentlyBoughtListState.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(context,SlideLeftRoute(page:ProductDetailsPage(store.state.frequentlyBoughtListState[index]['id']),));
                      },
                      child: Container(
                        width: 110,
                        margin: EdgeInsets.only(top: 20, right: 22),
                        padding: EdgeInsets.only(
                            left: 12, right: 12, top: 15, bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: 58,
                              margin: EdgeInsets.only(bottom: 6),
                              child: store.state.frequentlyBoughtListState[index]['image'] == null ?
                              Image.asset(
                                "assets/images/img (4).png",
                                fit: BoxFit.contain,
                              ) :
                                             CachedNetworkImage(
                                                           imageUrl: "${store.state.frequentlyBoughtListState[index]['image']}",
                                                          // fit: BoxFit.cover,
                                                           placeholder:(context, url) => Center(
                                                             child: SpinKitFadingCircle(
                                                               color: Colors.grey,),
                                                           ),
                                                           errorWidget: (context, url, error) =>
                                                               Center(child: new Icon(Icons.error)),
                                                         ),
                            ),
                            Text(
                              //'${store.state.frequentlyBoughtListState[index]['product']['name']}',
                              '${store.state.frequentlyBoughtListState[index]['name']}',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                // fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontFamily: 'poppins',
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 6),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    // '৳240',
                                    '৳${(store.state.frequentlyBoughtListState[index]['variations'][0]['price'])}',
                                    // store.state.frequentlyBoughtListState[index]['percentage'] ==null ||
                                    //           store.state.frequentlyBoughtListState[index]['percentage']==0?
                                    //             '৳${(store.state.frequentlyBoughtListState[index]['variations'][0]['price'])}':
                                    //             '৳'+ (store.state.frequentlyBoughtListState[index]['variations'][0]['price']-
                                    //              ( (store.state.frequentlyBoughtListState[index]['percentage']*(store.state.frequentlyBoughtListState[index]['variations'][0]['price']))/
                                    //              100)).toString(),
                                    style: TextStyle(
                                      color: Color(0xFF00B658),
                                      fontSize: 14,
                                      fontFamily: 'poppins',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.black,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      size: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              ////////////// frequently bought together items list end ///////////////

              ///////////// coupon start /////////////
              couponApplied ? 
              Container(
                  margin: EdgeInsets.only(bottom: 20),
                  padding: EdgeInsets.only(top: 10, bottom: 10, left: 14, right: 15),
                   width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  width: 0.5,
                                  color: Color(0xFFDADADA),
                                ),
                              ),
                              child: Row(
                                children: [
                               Expanded(
                                    child: Text(
                                      "${couponCashback['code']} coupon has been applied.",
                                      style: TextStyle(
                                    fontFamily: 'poppins',
                                    color: Color(0xFF00B658),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  InkWell(
                                   splashColor: Colors.grey[200],
                              onTap: () {
                                  setState(() {
                                    couponApplied = false;
                                   couponCashback = null;
                                  });      
                              },
                               child: Container(
                                 padding:  EdgeInsets.all(5.0),
                                 child: Icon(
                                      FlutterIcons.close_circle_outline_mco,
                                      color: Color(0xFF979797),
                                      size: 25,
                                    ),
                               ),
                                ),
                                ],
                              ),
                        ) :
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 19),
                decoration: BoxDecoration(
                  color: Color(0xFFF0EFEF),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                  controller: couponController,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'poppins',
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      onTap: isCouponApply ? null : _applyCoupon,
                      child: Container(
                        margin: EdgeInsets.only(top: 8, bottom: 8, right: 12),
                        padding: EdgeInsets.only(
                            top: 7, bottom: 7, left: 25, right: 25),
                        decoration: BoxDecoration(
                          color: isCouponApply ? Colors.grey : Color(0xFF00B658),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          'Apply',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'poppins',
                          ),
                        ),
                      ),
                    ),
                    hintText: "Coupon",
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: Color(0xff4D4A4A),
                      fontFamily: 'poppins',
                    ),
                    contentPadding:
                        EdgeInsets.only(left: 20, top: 17, bottom: 16),
                    border: InputBorder.none,
                  ),
                ),
              ),
              ///////////// coupon end /////////////

              ///////////// checkout details start ///////////////
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
                    buildCheckoutDetailsRow(1, 'Sub Total', '$subTotal'),
                    buildCheckoutDetailsRow(1, 'Delivery Fee', '$deliveryCharge'),
                    buildCheckoutDetailsRow(2, 'Coupon Cashback', couponCashback==null ? 0 : couponCashback['validity_type']==1? "${((couponCashback['discount']*subTotal)/100)}" :"${couponCashback['discount']}"),
                    buildCheckoutDetailsRow(2, 'Product Cashback', "$totalCashback"),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            'Grand Total',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontFamily: 'poppins',
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            '৳${subTotal+deliveryCharge}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontFamily: 'poppins',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ///////////// checkout details start ///////////////

              //////////// Checkout button start ///////////
              GestureDetector(
                onTap: _checkOutButton,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  margin: EdgeInsets.only(top: 40, bottom: 25),
                  decoration: BoxDecoration(
                    color: Color(0xFF0487FF),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    'Checkout',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              //////////// Checkout button end /////////////
            ],
          ),
        ),
      ),
    );
    }
    );
  }

  buildCheckoutDetailsRow(var cashType, var title, var amount) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Text(
              // 'Sub Total',
              '$title',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: cashType == 2? Colors.green: Colors.black,
                fontFamily: 'poppins',
              ),
            ),
          ),
          Container(
            child: Text(
              // '\$100',
              '৳$amount',
              style: TextStyle(
                fontSize: 16,
                // fontWeight: FontWeight.w500,
                color: cashType == 2? Colors.green:Colors.black,
                fontFamily: 'poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }



  ////////// Delete Cart Item start //////////
  Future<void> deleteCartItem(cartItem) async {

    var data = {
      'id': cartItem['id']
    };
    print(data);

    _deleteDialog("Removing Item");
  //   Future.delayed(const Duration(seconds: 2), () {
  //     Navigator.pop(context);
  // });

    var res = await CallApi()
        .postDataWithToken(data, 'ordermodule/delCart');
    var body = json.decode(res.body);
    print('body - $body');

    if (res.statusCode == 200) {
      Navigator.pop(context);

      for (var d in store.state.cartListState) {
        if (d['id'] == cartItem['id']) {
          store.state.cartListState.remove(d);
          break;
        }
      }
      store.dispatch(CartListAction(store.state.cartListState));
      _calculatePrice();
      _showMsg('Removed from cart!', 2);
    } 
    else if (res.statusCode == 401) {
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
    else if (res.statusCode == 422) {
      Navigator.pop(context);
      _showMsg(body['message'], 1);
    }
    else {
      Navigator.pop(context);
      _showMsg("Something went wrong! Please try again", 1);
    }
  }
  ////////// Delete Cart Item end //////////
  


  _decrement(cartItem) {
    if (cartItem['quantity'] == 1) {
      return;
    } else {
      setState(() {
        cartItem['quantity']--;
      });
    }
    editCartItem(cartItem);
  }

  _increment(cartItem) {
    setState(() {
      cartItem['quantity']++;
    });
    editCartItem(cartItem);
  }
  ////////// EDit Cart Item start //////////
  Future<void> editCartItem(cartItem) async {

    var data = {
      'id': cartItem['id'],
      'user_id': cartItem['user_id'],
      'variation_id': cartItem['variation']['id'],
      'quantity': cartItem['quantity'],
    };
    print(data);

    var res = await CallApi()
        .postDataWithToken(data, 'ordermodule/editCart');
    var body = json.decode(res.body);
    print('body - $body');

    if (res.statusCode == 200) {
      store.dispatch(CartListAction(store.state.cartListState));
      _calculatePrice();
      //_showMsg('Quantity !', 2);
    } 
    else if (res.statusCode == 401) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
    else if (res.statusCode == 422) {
      _showMsg(body['message'], 1);
    }
    else {
      Navigator.pop(context);
      _showMsg("Something went wrong! Please try again", 1);
    }
  }
  ////////// Edit Cart Item end //////////
  

  ////////// Apply Coupon start //////////
  Future<void> _applyCoupon() async {
    setState(() {
      isCouponApply = true;
    });

    if(couponController.text.isEmpty){
      _showMsg("Enter a valid coupon!", 1);
    }
    else{
      var data = {
      'user_id': store.state.userInfoState['id'],
      'code': couponController.text,
    };

    //print(store.state.productDetailsState);
    print(data);

    var res = await CallApi().postDataWithToken(data, 'ordermodule/checkCoupon');
    var body = json.decode(res.body);
    print('body - $body');

    if (res.statusCode == 200) {
      _showMsg('Coupon added', 2);
      //print(totalCashback);
      if(!mounted) return;
      setState(() {
        couponController.text="";
        couponApplied = true;
        couponCashback = body['data'];
       //totalCashback = totalCashback+couponCashback['discount'];
      });

      print(couponCashback);
     
    } 
    else if (res.statusCode == 401) {
      Navigator.pushReplacement(
        context,
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
      isCouponApply = false;
    });
  }
  ////////// Apply Coupon  end //////////
  
  ////////////// Checkout Button Start ///////////////
  _checkOutButton() {

    if(store.state.cartListState.length <= 0){
     Navigator.pop(context);
    } 
    else if(_currentAddressID==null){
      _showMsg("Select or add an address!", 1);
    }
    else {
      var data = {
      'category_id': store.state.whichHomeState['id'],
      'address_id': _currentAddressID,
      'shipingCharge': deliveryCharge,
      'discount_amount': couponCashback==null ? totalCashback+0 : couponCashback['validity_type']==1? "${totalCashback+((couponCashback['discount']*subTotal)/100)}" :"${totalCashback+couponCashback['discount']}",
      'orderType': store.state.whichHomeState['id']==3 ? "Food" : "General",
      'coupon': couponCashback==null? "":"${couponCashback['code']}",
    };
    print(data);
    Navigator.pushReplacement(context,ScaleRoute(page: PaymentScreen(data, subTotal),));
    }
    
  }
  ////////////// Checkout Button Start ///////////////

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
  

  ////////////// Delete Dialog STart //////////
  Future<Null> _deleteDialog(title) async {
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
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      border: Border.all(color: Colors.white)),
                  padding: EdgeInsets.only(bottom: 20, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'quicksand',
                            color: Color(0xff003A5B),
                            fontWeight: FontWeight.w500,
                            fontSize: 18),
                      ),

                      Container(
                        margin: EdgeInsets.only(left: 10),
                        height: 15,
                        width: 15,
                        child: CircularProgressIndicator(strokeWidth: 2,))
                    ],
                  ),
                ),
                
              ],
            ),
          );
        });
  }
////////////// Delete Dialog End //////////
}