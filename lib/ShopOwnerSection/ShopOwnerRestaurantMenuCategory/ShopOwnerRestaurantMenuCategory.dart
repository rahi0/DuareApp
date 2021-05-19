import 'dart:convert';

import 'package:duare/Api/api.dart';
import 'package:duare/Redux/action.dart';
import 'package:duare/Redux/state.dart';
import 'package:duare/RouteTransition/routeAnimation.dart';
import 'package:duare/Screens/LoginScreen/loginScreen.dart';
import 'package:duare/ShopOwnerSection/ShopOwnerDrawer/ShopOwnerDrawer.dart';
import 'package:duare/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ShopOwnerRestaurantMenuCategory extends StatefulWidget {
  @override
  _ShopOwnerRestaurantMenuCategoryState createState() =>
      _ShopOwnerRestaurantMenuCategoryState();
}

class _ShopOwnerRestaurantMenuCategoryState
    extends State<ShopOwnerRestaurantMenuCategory> {
  var menuCatList = [];
  var listMenuCat = [];

  bool _isLoading = false;

  ///////////////////// addRestaurantMenuCategory start //////////////////////////
  _addRestaurantMenuCategory() async {
    setState(() {
      _isLoading = true;
    });

    setState(() {
      _isLoading = true;
    });

    var data = {
      // 'shop_id': widget.productId,
      // 'category_name': productNameController.text,
    };

    print('----------------------data---------------------');
    print(data);
    print('----------------------data---------------------');

    var res = await CallApi()
        .postDataWithToken(data, 'shopownermodule/addRestaurantMenuCategory');
    print('res - $res');
    var body = json.decode(res.body);
    print('body - $body');
    print('res.statusCode  - ${res.statusCode}');

    if (res.statusCode == 200) {
    } else if (res.statusCode == 401) {
      _showMsg("Login expired!", 1);
      Navigator.push(context, SlideLeftRoute(page: LoginScreen()));
    } else {
      _showMsg('Something went wrong!', 1);
    }

    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
  }
  ///////////////////// addRestaurantMenuCategory end //////////////////////////

  ////////////////// get menuCategories list start ////////////////////
  _getAllMenuCategories() async {
    // store.dispatch(SoRestaurantMenuLoadingAction(true));
    var res =
        await CallApi().getDataWithToken('shopownermodule/getMenuCategories');
    var body = json.decode(res.body);
    print(res.statusCode);
    print('body - $body');
    print('.....................');

    if (body['message'] == "You are not allowed to access this route... ") {
      _showMsg('Your login has expired!', 1);
      Navigator.pushReplacement(context, SlideLeftRoute(page: LoginScreen()));
    } ////////// checking if token is expired
    else if (res.statusCode == 200) {
      var allMenuCategoriesData = json.decode(res.body);

      var menuCategories = allMenuCategoriesData['data'];
      print('menuCategories - $menuCategories');

      menuCatList = menuCategories.map((obj) => obj['name']).toList();
    } else if (res.statusCode == 401) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
    _getAllRestaurantMenuCategories();

    store.dispatch(SoRestaurantMenuLoadingAction(false));
  }
  ////////////////// get menuCategories list end ////////////////////

  ////////////////// get Restaurant Menu Categories list start ////////////////////
  _getAllRestaurantMenuCategories() async {
    var res = await CallApi()
        .getDataWithToken('shopownermodule/getRestaurantMenuCategories');
    var body = json.decode(res.body);
    print(res.statusCode);
    print('body - $body');
    print('.....................');

    if (body['message'] == "You are not allowed to access this route... ") {
      _showMsg('Your login has expired!', 1);
      Navigator.pushReplacement(context, SlideLeftRoute(page: LoginScreen()));
    } ////////// checking if token is expired
    else if (res.statusCode == 200) {
      var restaurantMenuCategoriesData = json.decode(res.body);

      var restaurantMenuCategories = restaurantMenuCategoriesData['data'];
      print('restaurantMenuCategories - $restaurantMenuCategories');

      setState(() {
        listMenuCat = restaurantMenuCategories
            .map((obj) => obj['category_name'])
            .toList();
      });
    } else if (res.statusCode == 401) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }
  ////////////////// get Restaurant Menu Categories list end ////////////////////

  @override
  void initState() {
    _getAllMenuCategories();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      ////// this is the connector which mainly changes state/ui
      converter: (store) => store.state,
      builder: (context, items) {
        return Scaffold(
          drawer: ShopOwnerDrawer(),
          appBar: AppBar(
            backgroundColor: appColor,
            title: Text(
              'Add Menu Category',
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
              margin: EdgeInsets.only(
                left: 10,
                right: 10,
                top: 20,
                bottom: 20,
              ),
              child: store.state.soRestaurantMenuLoadingState
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
                      children: [
                        Container(
                          child: Column(
                              children:
                                  List.generate(menuCatList.length, (index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  // if (!listMenuCat.contains("${menuCatList[index]}")) {
                                  if (listMenuCat
                                      .contains("${menuCatList[index]}")) {
                                    listMenuCat.remove("${menuCatList[index]}");
                                  } else {
                                    // listMenuCat = [];
                                    listMenuCat.add("${menuCatList[index]}");
                                  }
                                  print(listMenuCat);
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.only(
                                    top: 20, left: 10, right: 10, bottom: 5),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            child: Text(
                                              "${menuCatList[index]}",
                                              style: TextStyle(
                                                color: Color(0xff000000),
                                                fontSize: 17,
                                                fontFamily: "poppins",
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    listMenuCat.contains(menuCatList[index])
                                        ? Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                                color: appColor,
                                                borderRadius:
                                                    BorderRadius.circular(3)),
                                            child: Icon(Icons.done,
                                                color: Colors.white, size: 14),
                                          )
                                        : Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              color: Color(0xffD4DDE3),
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            );
                          })),
                        ),

                        ////////////////////// buttons start ////////////////////////
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ////////////////////// Cancel Button Start //////////////////////
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width / 2.75,
                                  padding: EdgeInsets.only(top: 15, bottom: 15),
                                  margin: EdgeInsets.only(top: 10, bottom: 20),
                                  decoration: BoxDecoration(
                                    // color: Colors.white,
                                    border: Border.all(
                                      color: Color(0xFF0487FF),
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    'Cancel',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF0487FF),
                                    ),
                                  ),
                                ),
                              ),
                              ////////////////////// Cancel Button End //////////////////////

                              ////////////////////// Save Button Start //////////////////////
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width / 2.75,
                                  padding: EdgeInsets.only(top: 15, bottom: 15),
                                  margin: EdgeInsets.only(top: 10, bottom: 20),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF0487FF),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    'Save',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              ////////////////////// Save Button End //////////////////////
                            ],
                          ),
                        ),
                        ////////////////////// buttons end ////////////////////////
                      ],
                    ),
            ),
          ),
        );
      },
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
