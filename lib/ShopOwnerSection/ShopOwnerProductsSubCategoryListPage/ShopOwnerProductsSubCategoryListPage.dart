import 'dart:convert';

import 'package:duare/Api/api.dart';
import 'package:duare/Redux/action.dart';
import 'package:duare/Redux/state.dart';
import 'package:duare/RouteTransition/routeAnimation.dart';
import 'package:duare/Screens/LoginScreen/loginScreen.dart';
import 'package:duare/ShopOwnerSection/ShopOwnerProductsListPage/ShopOwnerProductsListPage.dart';
import 'package:duare/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ShopOwnerProductsSubCategoryListPage extends StatefulWidget {
  var productCatId;

  ShopOwnerProductsSubCategoryListPage(this.productCatId);

  @override
  _ShopOwnerProductsSubCategoryListPageState createState() =>
      _ShopOwnerProductsSubCategoryListPageState();
}

class _ShopOwnerProductsSubCategoryListPageState
    extends State<ShopOwnerProductsSubCategoryListPage> {
  ///////////////// get Product sub Categories start /////////////////
  _getProductSubCategories() async {
    store.dispatch(SoProductSubCategoriesLoadingAction(true));

    var res = await CallApi().getDataWithTokenandQuery(
        'shopownermodule/getAllProductSubCategory',
        '&product_category_id=${widget.productCatId}');

    print('res - $res');
    var body = json.decode(res.body);
    print('body - $body');
    print('.....................');

    if (res.statusCode == 200) {
      var productSubCategories = body['data'];

      store.dispatch(SoProductSubCategoriesAction(productSubCategories));
    } else if (res.statusCode == 401) {
      _showMsg("Login expired!", 1);
      Navigator.push(context, SlideLeftRoute(page: LoginScreen()));
    } else {
      _showMsg("Something went wrong", 1);
    }

    store.dispatch(SoProductSubCategoriesLoadingAction(false));
  }
  ///////////////// get Product sub Categories end /////////////////

  ///  ///
  Future<void> _onRefresh() async {
    _getProductSubCategories();
  }

  @override
  void initState() {
    _getProductSubCategories();
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
          backgroundColor: Color(0xFFF9F9F9),
          // drawer: ShopOwnerDrawer(),
          appBar: AppBar(
            backgroundColor: appColor,
            title: Text(
              'Product Sub Categories',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontFamily: 'poppins',
              ),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Container(
                child: Column(
                  children: [
                    Container(
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Container(
                          margin: EdgeInsets.only(
                            bottom: 10,
                            top: 15,
                          ),
                          child: store.state.soProductSubCategoriesLoadingState
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
                              : store.state.soProductSubCategoriesState
                                          .length ==
                                      0
                                  ?
                                  ////////////////////// no orders text container start //////////////////////
                                  Center(
                                      child: Container(
                                        child: Text(
                                          'No Product Sub Categories Found',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                            fontFamily: 'poppins',
                                          ),
                                        ),
                                      ),
                                    )
                                  ////////////////////// no orders text container end //////////////////////
                                  : Column(
                                      children: List.generate(
                                        store.state.soProductSubCategoriesState
                                            .length,
                                        (index) {
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  ScaleRoute(
                                                    page: ShopOwnerProductsListPage(
                                                        store.state
                                                                .soProductSubCategoriesState[
                                                            index]['id']),
                                                  ));
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              margin: EdgeInsets.only(
                                                left: 16,
                                                right: 16,
                                                bottom: 20,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Color.fromRGBO(
                                                        0, 0, 0, 0.03),
                                                    blurRadius: 15,
                                                    spreadRadius: 0,
                                                    offset: Offset(1, 8),
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          left: 24),
                                                      child: Text(
                                                        // 'Frozen Fish',
                                                        '${store.state.soProductSubCategoriesState[index]['name']}',
                                                        style: TextStyle(
                                                          fontFamily: 'poppins',
                                                          color:
                                                              Color(0xFF263238),
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 96,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      child:
                                                          // Image.asset("assets/images/Rectangle 1025.png",
                                                          Image.network(
                                                        '${store.state.soProductSubCategoriesState[index]['image']}',
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                        ),
                      ),
                    ),
                  ],
                ),
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
