import 'dart:convert';

import 'package:duare/Api/api.dart';
import 'package:duare/Redux/action.dart';
import 'package:duare/Redux/state.dart';
import 'package:duare/RouteTransition/routeAnimation.dart';
import 'package:duare/Screens/LoginScreen/loginScreen.dart';
import 'package:duare/ShopOwnerSection/ShopOwnerAddProductPage/ShopOwnerAddProductPage.dart';
import 'package:duare/ShopOwnerSection/ShopOwnerDrawer/ShopOwnerDrawer.dart';
import 'package:duare/ShopOwnerSection/ShopOwnerProductEditPage/ShopOwnerProductEditPage.dart';
import 'package:duare/ShopOwnerSection/ShopOwnerProductVariationPage/ShopOwnerProductVariationPage.dart';
import 'package:duare/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ShopOwnerProductsListPage extends StatefulWidget {
  var productSubcategoryId;

  ShopOwnerProductsListPage(this.productSubcategoryId);

  @override
  _ShopOwnerProductsListPageState createState() =>
      _ShopOwnerProductsListPageState();
}

class _ShopOwnerProductsListPageState extends State<ShopOwnerProductsListPage> {
  TextEditingController searchController = TextEditingController();

  ScrollController _controller = new ScrollController();

  int _lastId;

  bool _isLoadingMore = false;

  ///////////////// get Product start /////////////////
  _getAllProducts() async {
    // store.dispatch(SoProductsLoadingAction(true));
    var res = await CallApi().getDataWithTokenandQuery(
        'shopownermodule/getProducts',
        '&product_subcategory_id=${widget.productSubcategoryId}');
    print('res - $res');
    var body = json.decode(res.body);
    print('body - $body');
    print('.....................');

    if (res.statusCode == 200) {
      var product = body['data'];

      if (product.length > 0) {
        _lastId = product[product.length - 1]['id'];
      }

      store.dispatch(SoProductsListAction(product));
    } else if (res.statusCode == 401) {
      _showMsg("Login expired!", 1);
      Navigator.push(context, SlideLeftRoute(page: LoginScreen()));
    } else {
      _showMsg("Something went wrong", 1);
    }
    store.dispatch(SoProductsLoadingAction(false));
  }
  ///////////////// get Product end /////////////////

  //////////////// get more Product start ////////////////
  Future<void> _loadMoreProducts(lastID) async {
    setState(() {
      _isLoadingMore = true;
    });

    var res = await CallApi().getDataWithTokenandQuery(
        'shopownermodule/getProducts', '&lastId=$lastID');
    print('res - $res');
    var body = json.decode(res.body);
    print('body - $body');
    print('..........more more more...........');

    if (res.statusCode == 200) {
      var loadList = body['data'];
      if (loadList.length > 0) {
        _lastId = loadList[loadList.length - 1]['id'];
      }

      var idList =
          store.state.soProductsListState.map((obj) => obj['id']).toList();
      for (int i = 0; i < loadList.length; i++) {
        if (!idList.contains(loadList[i]['id']))
          store.state.soProductsListState.add(loadList[i]);
      }
    }

    if (!mounted) return;
    setState(() {
      _isLoadingMore = false;
    });
  }
  //////////////// get more Product end ////////////////

  ///
  Future<void> _onRefresh() async {
    _getAllProducts();
  }

  ///
  @override
  void initState() {
    _controller.addListener(() {
      if (_controller.position.atEdge) {
        if (_controller.position.pixels == 0) {
          if (!mounted) return;
          setState(() {
            print("top");
          });
        }
        // you are at top position

        else {
          print("bottom");
          if (_isLoadingMore == false) {
            _loadMoreProducts(
                _lastId); //api will be call at the bottom at the list
          } else {
            print("loading.....................");
          }
        }
        // you are at bottom position
      }
    });
    _getAllProducts();
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
          backgroundColor: Colors.white,
          // drawer: ShopOwnerDrawer(),
          appBar: AppBar(
            backgroundColor: appColor,
            title: Text(
              'Product List',
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
                    ScaleRoute(page: ShopOwnerAddProductPage()),
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
                margin:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
                child: Column(
                  children: [
                    // ////////////////////// search text field start //////////////////////
                    // Container(
                    //   margin: EdgeInsets.only(top: 19, bottom: 25),
                    //   decoration: BoxDecoration(
                    //     color: Color(0xFFF0EFEF),
                    //     borderRadius: BorderRadius.circular(12),
                    //   ),
                    //   child: TextField(
                    //     onChanged: (val) {
                    //       if (searchController.text.isNotEmpty) {
                    //         store.dispatch(SearchStateAction(true));
                    //         // _search(searchController.text);
                    //       } else {
                    //         store.dispatch(SearchStateAction(false));
                    //       }
                    //     },
                    //     controller: searchController,
                    //     keyboardType: TextInputType.text,
                    //     style: TextStyle(
                    //       color: Colors.black,
                    //       fontFamily: 'poppins',
                    //       fontWeight: FontWeight.w500,
                    //     ),
                    //     decoration: InputDecoration(
                    //       suffixIcon: store.state.searchState
                    //           ? IconButton(
                    //               onPressed: () {
                    //                 searchController.clear();
                    //               },
                    //               icon: Icon(
                    //                 Icons.cancel,
                    //                 color: Colors.grey,
                    //               ),
                    //             )
                    //           : Icon(
                    //               FlutterIcons.search_fea,
                    //               color: Colors.black,
                    //             ),
                    //       hintText: "Search products",
                    //       hintStyle:
                    //           TextStyle(color: Colors.black, fontFamily: 'poppins'),
                    //       contentPadding:
                    //           EdgeInsets.only(left: 10, top: 17, bottom: 16),
                    //       border: InputBorder.none,
                    //     ),
                    //   ),
                    // ),
                    // ////////////////////// search text field end //////////////////////

                    store.state.soProductsLoadingState
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
                        : store.state.soProductsListState.length == 0
                            ?
                            ////////////////////// no products text container start //////////////////////
                            Center(
                                child: Container(
                                  child: Text(
                                    'No Products Found',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      fontFamily: 'poppins',
                                    ),
                                  ),
                                ),
                              )
                            ////////////////////// no products text container end //////////////////////
                            :
                            //////////////////////// products list start ////////////////////////
                            Column(
                                children: List.generate(
                                  store.state.soProductsListState.length,
                                  (index) {
                                    return Container(
                                      child: Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              print('tap');
                                              // _showActionSheet();
                                              // show variations listing
                                              Navigator.push(
                                                  context,
                                                  ScaleRoute(
                                                    page: ShopOwnerProductVariationPage(
                                                        store.state
                                                                .soProductsListState[
                                                            index]['id']),
                                                  ));
                                            },
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: 90,
                                                  width: 85,
                                                  padding: EdgeInsets.only(
                                                      top: 5, bottom: 5),
                                                  margin: EdgeInsets.only(
                                                      right: 15),
                                                  child: Image.network(
                                                    '${store.state.soProductsListState[index]['image']}',
                                                    //  Image.asset(                                      "assets/images/img (5).png",
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            bottom: 5),
                                                        child: Text(
                                                          // 'Dano Milk Powder',
                                                          '${store.state.soProductsListState[index]['name']}',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16,
                                                            fontFamily:
                                                                'poppins',
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                      RichText(
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text: 'Duare',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'poppins',
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    print('edit');
                                                    Navigator.push(
                                                        context,
                                                        ScaleRoute(
                                                          page: ShopOwnerProductEditPage(
                                                              store.state
                                                                      .soProductsListState[
                                                                  index]['id']),
                                                        ));
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.all(5),
                                                    child: Icon(Icons.edit),
                                                  ),
                                                ),
                                              ],
                                            ),
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
                    //////////////////////// products list end ////////////////////////

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

  ///////////////////////// cupertino action sheet start /////////////////////////////
  _showActionSheet() {
    return showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text(
            'Dano Milk Powder',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontFamily: 'poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          message: Text(
            'Duare 1kg',
            style: TextStyle(
              color: Colors.black,
              fontSize: 17,
              fontFamily: 'poppins',
            ),
          ),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: Text('Edit'),
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => ShopOwnerProductEditPage()),
                // );
              },
            ),
            CupertinoActionSheetAction(
              child: Text('Set Unavailable'),
              onPressed: () {/** */},
            ),
            CupertinoActionSheetAction(
              child: Text('Delete'),
              onPressed: () {/** */},
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            child: Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }
  ///////////////////////// cupertino action sheet end /////////////////////////////

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
