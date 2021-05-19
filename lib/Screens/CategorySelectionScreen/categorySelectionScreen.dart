import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:duare/Api/api.dart';
import 'package:duare/Models/AllCategoryModel.dart';
import 'package:duare/Redux/action.dart';
import 'package:duare/Redux/state.dart';
import 'package:duare/RouteTransition/routeAnimation.dart';
import 'package:duare/Screens/BottomNavBarScreen/bottomNavBarScreen.dart';
import 'package:duare/Screens/LoginScreen/loginScreen.dart';
import 'package:duare/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class CategorySelectionScreen extends StatefulWidget {
  @override
  _CategorySelectionScreenState createState() =>
      _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {

  var userData;

    Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            //   title: new Text('Are you sure?'),
            content: new Text('Are you sure you want to exit this app?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text(
                  'No',
                  // style: TextStyle(color: appColor),
                ),
              ),
              new FlatButton(
                onPressed: () => exit(0),
                child: new Text(
                  'Yes',
                  // style: TextStyle(color: appColor),
                ),
              ),
            ],
          ),
        )) ??
        false;
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

  ////////////////// get categories list start ////////////////////
  _getAllCategories() async {
   

    var res =
        await CallApi().getDataWithToken('productmodule/getAllCategory');
    var body = json.decode(res.body);
    print(res.statusCode);
    print('body - $body');
    print('.....................');

    if (body['message'] == "You are not allowed to access this route... ") {
      _showMsg('Your login has expired!', 1);
      Navigator.pushReplacement(context, SlideLeftRoute(page: LoginScreen()));
    } ////////// checking if token is expired
    else if (res.statusCode == 200) {
      var allCategoryData = json.decode(res.body); //allCategoryModelFromJson(res.body).data;
      
      var allCategory = allCategoryData['data'];
      print('allCategory - $allCategory');
      store.dispatch(CategoryListAction(allCategory));

      List<String> catNames = [];
      var catIds = [];
      for (int i = 0; i < allCategory.length; i++) {
        catNames.add('${allCategory[i]['name']}');
        catIds.add(allCategory[i]['id']);

        print('catNames --- $catNames');

        store.dispatch(CategoryIdListAction(catIds));
        store.dispatch(CategoryNamesListAction(catNames));

        print('catNames store --- ${store.state.categoryNamesListState}');
      }
    } else if (res.statusCode == 401) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
        store.dispatch(CategoryLoadingAction(false));
  }
  ////////////////// get categories list end ////////////////////

  @override
  void initState() {
    _getUserInfo();
    _getAllCategories();
    super.initState();
  }

  void _getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('userData');
    if (userJson != null) {
      var user = json.decode(userJson);
      if (!mounted) return;
        userData = user;
        store.dispatch(UserInfoAction(userData));
    
    } 
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        ////// this is the connector which mainly changes state/ui
        converter: (store) => store.state,
        builder: (context, items) { 
          return WillPopScope(
        onWillPop: _onWillPop,
            child: Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            child: Column(
              children: [
                //////////////////// Duare Logo Start //////////////////////
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF8F8F8),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  padding: EdgeInsets.only(top: 80, bottom: 20),
                  // height: ,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _showServiceClosedAlertDialog();
                        },
                        child: Center(
                          child: Image.asset("assets/images/duare2 (1).png"),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 20, bottom: 40),
                        child: Text(
                          'you select, we deliver',
                          style: TextStyle(
                            fontFamily: 'poppins',
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //////////////////// Duare Logo End //////////////////////

                Expanded(
                  child: store.state.categoryLoading
                      ? SpinKitCircle(
                          color: Color(0xFF0487FF),
                          // size: 30,
                        )
                      : SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              /////////////////// explore our item text Start //////////////////
                              Container(
                                padding: EdgeInsets.only(top: 40, bottom: 25),
                                child: Text(
                                  'Explore Our Items',
                                  style: TextStyle(
                                    fontFamily: 'poppins',
                                    color: Color(0xFF263238),
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              ////////////////// explore our item text End ///////////////////

                              ////////////////// Categories Grid Start ///////////////////
                              Wrap(
                                spacing: 20.0,
                                runSpacing: 13,
                                children: List.generate(
                                  store.state.categoryListState.length,
                                  (index) {
                                    return Container(
                                      child: GestureDetector(
                                        onTap: () {
                                          store.dispatch(WhichHomeAction(store
                                              .state.categoryListState[index]));

                                          Navigator.pushReplacement(
                                              context,
                                              FadeRoute(
                                                  page: BottomNavBarScreen(0)));
                                        },
                                        child: buildCategoryContainer(
                                          context,
                                          store
                                              .state.categoryListState[index]['image'],
                                          store.state.categoryListState[index]['name'],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),

                              ////////////////// Order by WhatsApp Start ///////////////////
                              GestureDetector(
                                onTap: () {
                                  launchWhatsApp('+8801785671700', "");
                                },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 25, top: 25),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Can’t use app?',
                                            style: TextStyle(
                                              fontFamily: 'poppins',
                                              color: Color(0xFF979797),
                                              fontSize: 12,
                                            ),
                                          ),
                                          Text(
                                            'Order by WhatsApp',
                                            style: TextStyle(
                                              fontFamily: 'poppins',
                                              color: Color(0xFF263238),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 10),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color.fromRGBO(0, 0, 0, 0.09),
                                              spreadRadius: 0,
                                              blurRadius: 24,
                                              offset: Offset(0,
                                                  3), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        padding: EdgeInsets.all(15),
                                        child: Image.asset(
                                            "assets/images/whatsapp 1.png"),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              ////////////////// Order by WhatsApp End ///////////////////
                            ],
                          ),
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

  buildCategoryContainer(BuildContext context, var catImg, var catName) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
        border: Border.all(
          width: 0.5,
          color: Color(0xFFECE4E4),
        ),
      ),
      padding: EdgeInsets.only(
          // left: 20, right: 20,
          top: 32,
          bottom: 30),
      width: MediaQuery.of(context).size.width / 2.35,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 79,
            width: 79,
            child: Image.network(catImg),
          ),
          SizedBox(height: 10),
          Text(
            // 'Grocery',
            catName,
            style: TextStyle(
              fontFamily: 'poppins',
              color: Color(0xFF263238),
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  ///////////// App Service Closed Alert Dialog start //////////////
  void _showServiceClosedAlertDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color(0XFF0487FF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(12.0),
              ),
            ),
            content: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                margin: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 35,
                  bottom: 35,
                ),
                child: Column(
                  children: [
                    Center(
                      child: Image.asset("assets/images/abuse 1.png"),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        // left: 20,
                        // right: 20,
                        top: 35,
                        bottom: 25,
                      ),
                      child: Text(
                        'Now Our Service Is Off',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'poppins',
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      'You Can Make Schedule Order',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'poppins',
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    ////////////////////// OrderNow button start //////////////////////
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(top: 15, bottom: 15),
                        margin: EdgeInsets.only(top: 20, bottom: 0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          // color: Color(0xFF0487FF),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          'Order Now',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            // color: Colors.white,
                            color: Color(0xFF0487FF),
                          ),
                        ),
                      ),
                    ),
                    ////////////////////// OrderNow button end //////////////////////
                  ],
                ),
              ),
            ),
          );
        });
  }
  /////////////////////////////  Show Dialog for add User Type End  ///////////////////////////////////////

  ///////////// App Service Closed Alert Dialog end //////////////

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
