import 'dart:convert';
import 'dart:io';

import 'package:duare/Api/api.dart';
import 'package:duare/Redux/action.dart';
import 'package:duare/Redux/state.dart';
import 'package:duare/RouteTransition/routeAnimation.dart';
import 'package:duare/Screens/AddressesScreen/addressesScreen.dart';
import 'package:duare/Screens/ChangePasswordScreen/changePasswordScreen.dart';
import 'package:duare/Screens/EventInquiryScreen/eventInquiryScreen.dart';
import 'package:duare/Screens/FavoritesScreen/favoritesScreen.dart';
import 'package:duare/Screens/GetStartedScreen/getStartedScreen.dart';
import 'package:duare/Screens/LoginScreen/loginScreen.dart';
import 'package:duare/Screens/MembershipPlansScreen/membershipPlansScreen.dart';
import 'package:duare/Screens/OffersScreen/offersScreen.dart';
import 'package:duare/Screens/PrescriptionsScreen/prescriptionsScreenn.dart';
import 'package:duare/Screens/RequestProductScreen/requestProductScreen.dart';
import 'package:duare/Screens/PrivacyPolicyScreen/privacyPolicyScreen.dart';
import 'package:duare/Screens/ReturnPolicyScreen/returnPolicyScreen.dart';
import 'package:duare/Screens/TermScreen/TermScreen.dart';
import 'package:duare/Screens/UpdateCountryPage/updateCountryPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:duare/main.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

  @override
  void initState() {
   _getAccountDetails();
   //print(store.state.userInfoState);
    super.initState();
  }

  Future<void> _pull() async {
      _getAccountDetails();   
  }

  // ///////////////// get Account start /////////////////
  _getAccountDetails() async {
    //store.dispatch(RestauranDetailsLoadingAction(true));

    var res = await CallApi().getDataWithToken('usermodule/userInfo');
     var body = json.decode(res.body);
    // print(res.statusCode);
    // print('body - $body');
    // print('.....................');

    if (body['message'] == "You are not allowed to access this route... ") {
      _showMsg('Your login has expired!', 1);
      Navigator.pushReplacement(context, SlideLeftRoute(page: LoginScreen()));

    } ////////// checking if token is expired
    else if (res.statusCode == 200) {
      var body = json.decode(res.body); 
      print(body);
       store.dispatch(UserInfoAction(body['user']));
       

    } else if (res.statusCode == 401) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
     store.dispatch(RestauranDetailsLoadingAction(false));
  }
  // ///////////////// get Account end /////////////////
  
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        ////// this is the connector which mainly changes state/ui
        converter: (store) => store.state,
        builder: (context, items) { 
    return RefreshIndicator(
      onRefresh: _pull,
      child: Scaffold(
        backgroundColor: Color(0xFFF8F9FA),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xFFF8F9FA),
          // backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'My Account',
            style: TextStyle(
              fontFamily: 'poppins',
              color: Color(0xFF263238),
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Container(
          // height: MediaQuery.of(context).size.height,
          margin: EdgeInsets.only(top: 10),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 120),
                      padding: EdgeInsets.only(left: 16, right: 25, top: 120),
                      color: Colors.white,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Balance',
                                style: TextStyle(
                                  fontFamily: 'poppins',
                                  color: Color(0xFF263238),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '\$${store.state.userInfoState['duare_points']}',
                                style: TextStyle(
                                  fontFamily: 'poppins',
                                  color: Color(0xFF263238),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            thickness: 0.5,
                            color: Color(0xFFDBDBDB),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  SlideLeftRoute(page: AddressesScreen()));
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Delivery Address',
                                    style: TextStyle(
                                      fontFamily: 'poppins',
                                      color: Color(0xFF263238),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  // GestureDetector(
                                  //   onTap: () {},
                                  // child:
                                  Container(
                                    margin: EdgeInsets.only(right: 15),
                                    child: Icon(
                                      Icons.arrow_forward,
                                      color: Color(0xFF979797),
                                    ),
                                    // ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            thickness: 0.5,
                            color: Color(0xFFDBDBDB),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  SlideLeftRoute(page: PrescriptionsScreen()));
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Prescriptions',
                                    style: TextStyle(
                                      fontFamily: 'poppins',
                                      color: Color(0xFF263238),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  // GestureDetector(
                                  //   onTap: () {},
                                  //   child:
                                  Container(
                                    margin: EdgeInsets.only(right: 15),
                                    child: Icon(
                                      Icons.arrow_forward,
                                      color: Color(0xFF979797),
                                    ),
                                  ),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            thickness: 0.5,
                            color: Color(0xFFDBDBDB),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  SlideLeftRoute(page: ChangePasswordScreen()));
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Change Password',
                                    style: TextStyle(
                                      fontFamily: 'poppins',
                                      color: Color(0xFF263238),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  // GestureDetector(
                                  //   onTap: () {},
                                  //   child:
                                  Container(
                                    margin: EdgeInsets.only(right: 15),
                                    child: Icon(
                                      Icons.arrow_forward,
                                      color: Color(0xFF979797),
                                    ),
                                  ),
                                  // ),F
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            thickness: 0.5,
                            color: Color(0xFFDBDBDB),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context,SlideLeftRoute(page:UpdateCountryPage(),));
                              //GetStartedScreen()
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Change Country',
                                    style: TextStyle(
                                      fontFamily: 'poppins',
                                      color: Color(0xFF263238),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  // GestureDetector(
                                  //   onTap: () {},
                                  //   child:
                                  Container(
                                    margin: EdgeInsets.only(right: 15),
                                    child: Icon(
                                      Icons.arrow_forward,
                                      color: Color(0xFF979797),
                                    ),
                                  ),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            thickness: 0.5,
                            color: Color(0xFFDBDBDB),
                          ),
                          GestureDetector(
                            onTap: () {
                              
                              launchWhatsApp('+8801785671700', "");
                                
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Order on WhatsApp',
                                    style: TextStyle(
                                      fontFamily: 'poppins',
                                      color: Color(0xFF263238),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      margin: EdgeInsets.only(right: 15),
                                      child: Icon(
                                        Icons.arrow_forward,
                                        color: Color(0xFF979797),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            thickness: 0.5,
                            color: Color(0xFFDBDBDB),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  SlideLeftRoute(page: RequestProductScreen()));
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Request a Product',
                                    style: TextStyle(
                                      fontFamily: 'poppins',
                                      color: Color(0xFF263238),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  // GestureDetector(
                                  //   onTap: () {},
                                  //   child:
                                  Container(
                                    margin: EdgeInsets.only(right: 15),
                                    child: Icon(
                                      Icons.arrow_forward,
                                      color: Color(0xFF979797),
                                    ),
                                  ),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            thickness: 0.5,
                            color: Color(0xFFDBDBDB),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  SlideLeftRoute(page: EventInquiryScreen()));
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Event Inquiry',
                                    style: TextStyle(
                                      fontFamily: 'poppins',
                                      color: Color(0xFF263238),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 15),
                                    child: Icon(
                                      Icons.arrow_forward,
                                      color: Color(0xFF979797),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            thickness: 0.5,
                            color: Color(0xFFDBDBDB),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  SlideLeftRoute(page: FavoritesScreen()));
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'My Favourites',
                                    style: TextStyle(
                                      fontFamily: 'poppins',
                                      color: Color(0xFF263238),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 15),
                                    child: Icon(
                                      Icons.arrow_forward,
                                      color: Color(0xFF979797),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            thickness: 0.5,
                            color: Color(0xFFDBDBDB),
                          ),

                            GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  SlideLeftRoute(page: OffersScreen()));
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Offers',
                                    style: TextStyle(
                                      fontFamily: 'poppins',
                                      color: Color(0xFF263238),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 15),
                                    child: Icon(
                                      Icons.arrow_forward,
                                      color: Color(0xFF979797),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            thickness: 0.5,
                            color: Color(0xFFDBDBDB),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(top: 50),
                              child: Text(
                                'Help and Support',
                                style: TextStyle(
                                  fontFamily: 'poppins',
                                  color: Color(0xFF263238),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(top: 5),
                            child: Row(
                              children: [
                                Text(
                                  'duareapp@gmail.com  |  ',
                                  style: TextStyle(
                                    fontFamily: 'poppins',
                                    color: Color(0xFF263238),
                                    fontSize: 14,
                                    // fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Icon(
                                  FlutterIcons.whatsapp_faw,
                                  size: 20,
                                ),
                                Text(
                                  ' +8801750118555',
                                  style: TextStyle(
                                    fontFamily: 'poppins',
                                    color: Color(0xFF263238),
                                    fontSize: 14,
                                    // fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            thickness: 0.5,
                            color: Color(0xFFDBDBDB),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  ScaleRoute(page: PrivacyPolicyScreen()));
                            },
                            child: Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(top: 35, bottom: 10),
                              child: Text(
                                'Privacy Policy',
                                style: TextStyle(
                                  fontFamily: 'poppins',
                                  color: Color(0xFF263238),
                                  fontSize: 12,
                                  // fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context, ScaleRoute(page: TermScreen()));
                            },
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Terms and Condition',
                                style: TextStyle(
                                  fontFamily: 'poppins',
                                  color: Color(0xFF263238),
                                  fontSize: 12,
                                  // fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  ScaleRoute(page: ReturnPolicyScreen()));
                            },
                            child: Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(top: 10, bottom: 35),
                              child: Text(
                                'Return Policy',
                                style: TextStyle(
                                  fontFamily: 'poppins',
                                  color: Color(0xFF263238),
                                  fontSize: 12,
                                  // fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(top: 65, bottom: 15),
                          margin: EdgeInsets.all(40),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Color.fromRGBO(0, 182, 88, 0.37),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                store.state.userInfoState['name']==null?"":store.state.userInfoState['name'],
                                style: TextStyle(
                                  fontFamily: 'poppins',
                                  color: Color(0xFF263238),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                store.state.userInfoState['phone']==null?"":store.state.userInfoState['phone'],
                                style: TextStyle(
                                  fontFamily: 'poppins',
                                  color: Color(0xFF263238),
                                  // fontSize: 18,
                                  // fontWeight: FontWeight.w600,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    ScaleRoute(page: MembershipPlanScreen()),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(width: 39),
                                    Text(
                                      'Upgrade Membership',
                                      style: TextStyle(
                                        fontFamily: 'poppins',
                                        color: Color(0xFF00B658),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Container(
                                      margin: EdgeInsets.only(left: 10),
                                      child: Icon(
                                        FlutterIcons.edit_fea,
                                        color: Color(0xFF979797),
                                        size: 20,
                                      ),
                                    ),
                                    // SizedBox(width: 18),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                //height:200,
                                //width:MediaQuery.of(context).size.width/7,
                                child: CircleAvatar(
                                  
                                  radius: 50,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: AssetImage(
                                    "assets/images/account.png",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  });
  }

    /////////////////// launchWhatsApp method start ////////////////////
  void launchWhatsApp(String phone, String message) async {
    String url() {
      if (Platform.isIOS) {
        // return "whatsapp://wa.me/$phone/?text=${Uri.parse(message)}";
        return "https://wa.me/$phone/?text=${Uri.parse(message)}"; // new line
      } else {
        // return "whatsapp://send?phone=$phone&text=${Uri.parse(message)}";
        return "https://api.whatsapp.com/send?phone=$phone=${Uri.parse(message)}"; // new line
      }
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ${url()}';
    }
  }
  /////////////////// launchWhatsApp method end ////////////////////
  
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
