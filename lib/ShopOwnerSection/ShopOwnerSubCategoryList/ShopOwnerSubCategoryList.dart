import 'dart:convert';

import 'package:duare/Api/api.dart';
import 'package:duare/Models/ShopOwnerModels/SoProductSubCategoriesModel.dart';
import 'package:duare/Redux/action.dart';
import 'package:duare/Redux/state.dart';
import 'package:duare/Screens/LoginScreen/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:duare/main.dart';
import 'package:duare/RouteTransition/routeAnimation.dart';
import 'package:duare/ShopOwnerSection/ShopOwnerAddSubCategory/ShopOwnerAddSubCategory.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ShopOwnerSubCategoryList extends StatefulWidget {
  var productCategoryId;

  ShopOwnerSubCategoryList(this.productCategoryId);

  @override
  _ShopOwnerSubCategoryListState createState() =>
      _ShopOwnerSubCategoryListState();
}

class _ShopOwnerSubCategoryListState extends State<ShopOwnerSubCategoryList> {
  ScrollController _controller = new ScrollController();

  int _lastId;

  bool _isLoadingMore = false;

  ///////////////// get Product sub Categories start /////////////////
  _getAllProductSubCategories() async {
    var res = await CallApi().getDataWithTokenandQuery(
        'shopownermodule/getProductSubCategory',
        '&product_category_id=${widget.productCategoryId}');
    print('res - $res');
    var body = json.decode(res.body);
    print('body - $body');
    print('.....................');

    if (res.statusCode == 200) {
      var productSubCategories =
          soProductSubCategoriesModelFromJson(res.body).data;

      if (productSubCategories.length > 0) {
        _lastId = productSubCategories[productSubCategories.length - 1].id;
      }

      store.dispatch(SoProductSubCategoriesAction(productSubCategories));
      print(
          'store.state.soProductSubCategoriesState  --- ${store.state.soProductSubCategoriesState}');
    } else if (res.statusCode == 401) {
      _showMsg("Login expired!", 1);
      Navigator.push(context, SlideLeftRoute(page: LoginScreen()));
    } else {
      _showMsg("Something went wrong", 1);
    }
    store.dispatch(SoProductSubCategoriesLoadingAction(false));
  }
  ///////////////// get ProductSubCategories end /////////////////

  //////////////// get more ProductSubCategories start ////////////////
  Future<void> _loadMoreProductSubCategories(lastID) async {
    setState(() {
      _isLoadingMore = true;
    });

    var res = await CallApi().getDataWithTokenandQuery(
        'shopownermodule/getProductSubCategory',
        '&product_category_id=${widget.productCategoryId}&lastId=$lastID');
    print('res - $res');
    var body = json.decode(res.body);
    // print('body - $body');
    // print('..........more more more...........');

    if (res.statusCode == 200) {
      var loadList = soProductSubCategoriesModelFromJson(res.body).data;
      if (loadList.length > 0) {
        _lastId = loadList[loadList.length - 1].id;
      }
      var idList =
          store.state.soProductSubCategoriesState.map((obj) => obj.id).toList();
      for (int i = 0; i < loadList.length; i++) {
        if (!idList.contains(loadList[i].id))
          store.state.soProductSubCategoriesState.add(loadList[i]);
      }
    }

    if (!mounted) return;
    setState(() {
      _isLoadingMore = false;
    });
  }
  //////////////// get more ProductSubCategories end ////////////////

  ///
  Future<void> _onRefresh() async {
    _getAllProductSubCategories();
  }

  ///
  @override
  void initState() {
    store.dispatch(SoProductSubCategoriesLoadingAction(true));
    store.dispatch(SoProductSubCategoriesAction([]));
    _controller.addListener(() {
      if (_controller.position.atEdge) {
        if (_controller.position.pixels == 0) {
        }
        // you are at top position

        else {
          print("bottom");
          if (_isLoadingMore == false) {
            _loadMoreProductSubCategories(
                _lastId); //api will be call at the bottom at the list
          } else {}
        }
        // you are at bottom position
      }
    });
    _getAllProductSubCategories();
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
          appBar: AppBar(
            titleSpacing: 0,
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
            actions: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    ScaleRoute(
                        page:
                            ShopOwnerAddSubCategory(widget.productCategoryId)),
                  );
                },
                child: Container(
                  margin:
                      EdgeInsets.only(right: 10, left: 10, top: 0, bottom: 5),
                  child: Icon(
                    Icons.add_circle_outline,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              controller: _controller,
              child: Container(
                margin: EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 20,
                  bottom: 20,
                ),
                child: Column(
                  children: [
                    store.state.soProductSubCategoriesLoadingState
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
                        : store.state.soProductSubCategoriesState.length == 0
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
                                  store
                                      .state.soProductSubCategoriesState.length,
                                  (index) {
                                    return GestureDetector(
                                      onTap: () {},
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(10),
                                            margin: EdgeInsets.only(
                                              left: 0,
                                              right: 0,
                                              bottom: 10,
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
                                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      right: 25, left: 10),
                                                  height: 80,
                                                  width: 80,
                                                  child: Image.network(
                                                    '${store.state.soProductSubCategoriesState[index].image}',
                                                    // Image.asset('assets/images/medicine 1.png',
                                                    fit: BoxFit.cover,
                                                    colorBlendMode:
                                                        BlendMode.luminosity,
                                                    color: Color.fromRGBO(
                                                        0, 0, 0, 0.2),
                                                  ),
                                                ),
                                                Text(
                                                  '${store.state.soProductSubCategoriesState[index].name}',
                                                  // 'Green Tea',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                    fontFamily: 'poppins',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                    _isLoadingMore
                        ? Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(20),
                            child: Center(
                              child: SpinKitFadingCircle(
                                color: Colors.grey.withOpacity(0.3),
                                size: 40,
                              ),
                            ),
                          )
                        : Container()
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
