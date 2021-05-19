import 'dart:convert';

import 'package:duare/Api/api.dart';
import 'package:duare/Redux/action.dart';
import 'package:duare/Redux/state.dart';
import 'package:duare/RouteTransition/routeAnimation.dart';
import 'package:duare/Screens/LoginScreen/loginScreen.dart';
import 'package:duare/ShopOwnerSection/ShopOwnerDrawer/ShopOwnerDrawer.dart';
import 'package:duare/ShopOwnerSection/ShopOwnerProductsSubCategoryListPage/ShopOwnerProductsSubCategoryListPage.dart';
import 'package:duare/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ShopOwnerProductsCategoryListPage extends StatefulWidget {
  @override
  _ShopOwnerProductsCategoryListPageState createState() =>
      _ShopOwnerProductsCategoryListPageState();
}

class _ShopOwnerProductsCategoryListPageState
    extends State<ShopOwnerProductsCategoryListPage> {
  TextEditingController searchController = TextEditingController();
  bool _searchOn = false;

  ///////////////// get ProductCategories start /////////////////
  _getAllProductCategories() async {
    store.dispatch(SoProductCategoriesLoadingAction(true));

    var res = await CallApi().getDataWithTokenandQuery(
        'shopownermodule/getAllProductCategory',
        '&category_id=${store.state.soShopCategoryState['id']}');
    print('res - $res');
    var body = json.decode(res.body);
    print('body - $body');
    print('.....................');

    if (res.statusCode == 200) {
      var productCategories = body['data'];

      store.dispatch(ShopOwnerProductCategoriesAction(productCategories));
    } else if (res.statusCode == 401) {
      _showMsg("Login expired!", 1);
      Navigator.push(context, SlideLeftRoute(page: LoginScreen()));
    } else {
      _showMsg("Something went wrong", 1);
    }

    store.dispatch(SoProductCategoriesLoadingAction(false));
  }
  ///////////////// get ProductCategories end /////////////////

  ///
  Future<void> _onRefresh() async {
    _getAllProductCategories();
  }

  @override
  void initState() {
    _getAllProductCategories();
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
          drawer: ShopOwnerDrawer(),
          appBar: AppBar(
            backgroundColor: appColor,
            title: Text(
              'Product Categories List',
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
                margin: EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ////////////////////// search text field start //////////////////////
                    Container(
                      margin: EdgeInsets.only(top: 19),
                      decoration: BoxDecoration(
                        color: Color(0xFFF0EFEF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        onChanged: (val) {
                          if (searchController.text.isNotEmpty) {
                            setState(() {
                              _searchOn = true;
                            });
                          } else {
                            setState(() {
                              _searchOn = false;
                            });
                          }
                        },
                        controller: searchController,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          suffixIcon:
                              // _searchOn
                              //     ? IconButton(
                              //         onPressed: () {
                              //           setState(() {
                              //             searchController.clear();
                              //             _searchOn = false;
                              //           });
                              //         },
                              //         icon: Icon(
                              //           Icons.cancel,
                              //           color: Colors.grey,
                              //         ),
                              //       )
                              //     :
                              Icon(
                            FlutterIcons.search_fea,
                            color: Colors.black,
                          ),
                          hintText: "Search here",
                          hintStyle: TextStyle(
                              color: Colors.black, fontFamily: 'poppins'),
                          contentPadding:
                              EdgeInsets.only(left: 10, top: 17, bottom: 16),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    ////////////////////// search text field end //////////////////////

                    _searchOn
                        ?
                        ////////////////////// Category search results grid start //////////////////////
                        Container(
                            margin: EdgeInsets.only(top: 25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Categories',
                                  style: TextStyle(
                                    fontFamily: 'poppins',
                                    color: Color(0xFF263238),
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 20, bottom: 25),
                                  child: Wrap(
                                    // alignment:
                                    // allTaskData.length <= 1
                                    //     ? WrapAlignment.start
                                    //     : WrapAlignment.spaceAround,
                                    spacing: 20.0,
                                    runSpacing: 20,
                                    // runAlignment: WrapAlignment.spaceBetween,
                                    // crossAxisAlignment: WrapCrossAlignment.center,
                                    children: List.generate(
                                      4,
                                      (index) {
                                        return GestureDetector(
                                          onTap: () {
                                            // Navigator.push(
                                            //     context,
                                            //     ScaleRoute(
                                            //       page:
                                            //           ShopOwnerProductsSubCategoryListPage(),
                                            //     ));
                                          },
                                          child: Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                child: Container(
                                                  // color: Colors.red,
                                                  height: 100,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2.4,
                                                  child: Image.asset(
                                                    'assets/images/Rectangle 1031.png',
                                                    fit: BoxFit.cover,
                                                    colorBlendMode:
                                                        BlendMode.luminosity,
                                                    color: Color.fromRGBO(
                                                        0, 0, 0, 0.37),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: 100,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2.4,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      child: Text(
                                                        'Milk',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: 'poppins',
                                                          // fontWeight: FontWeight.w500,
                                                        ),
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
                                ),
                                ////////////////////// Category search results grid End //////////////////////

                                ////////////////////// Product search results grid Start //////////////////////
                                Text(
                                  'Products',
                                  style: TextStyle(
                                    fontFamily: 'poppins',
                                    color: Color(0xFF263238),
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 20, bottom: 25),
                                  child: Wrap(
                                    // alignment:
                                    // allTaskData.length <= 1
                                    //     ? WrapAlignment.start
                                    //     : WrapAlignment.spaceAround,
                                    spacing: 20.0,
                                    runSpacing: 20,
                                    // runAlignment: WrapAlignment.spaceBetween,
                                    // crossAxisAlignment: WrapCrossAlignment.center,
                                    children: List.generate(
                                      4,
                                      (index) {
                                        return GestureDetector(
                                          onTap: () {},
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.4,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  // color: Colors.red,
                                                  height: 122,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2.4,
                                                  padding: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(5),
                                                    ),
                                                    border: Border.all(
                                                      width: 0.5,
                                                      color: Color(0xFF9C9A9A),
                                                    ),
                                                  ),
                                                  child: Image.asset(
                                                    'assets/images/img (1).png',
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                    top: 6,
                                                    // bottom: 6,
                                                  ),
                                                  child: Text(
                                                    'Radhoni Chili Powder',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontFamily: 'poppins',
                                                      color: Color(0xFF263238),
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                ), ////////////////////// Product search results grid End //////////////////////
                              ],
                            ),
                          )
                        :
                        ////////////////////// recomended for you grid start //////////////////////
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                  top: 40,
                                ),
                                child: Text(
                                  'Product Categories',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'poppins',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Divider(
                                color: Colors.black,
                                // height: 0.5,
                                thickness: 0.5,
                              ),
                              store.state.soProductCategoriesLoadingState
                                  ?
                                  //////////////////// progress inidcator start //////////////////////
                                  Center(
                                      child: Container(
                                        margin: EdgeInsets.only(
                                          top: 20,
                                        ),
                                        child: SpinKitCircle(
                                          color: Color(0xFF0487FF),
                                        ),
                                      ),
                                    )
                                  ////////////////////// progress inidcator end //////////////////////
                                  : store.state.shopOwnerProductCategoriesState
                                              .length ==
                                          0
                                      ?
                                      ////////////////////// no orders text container start //////////////////////
                                      Center(
                                          child: Container(
                                            margin: EdgeInsets.only(
                                              top: 20,
                                            ),
                                            child: Text(
                                              'No Product Categories Found',
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
                                      : Container(
                                          margin: EdgeInsets.only(
                                              top: 20, bottom: 25),
                                          child: Wrap(
                                            spacing: 20.0,
                                            runSpacing: 20,
                                            children: List.generate(
                                              store
                                                  .state
                                                  .shopOwnerProductCategoriesState
                                                  .length,
                                              (index) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        ScaleRoute(
                                                          page: ShopOwnerProductsSubCategoryListPage(
                                                              store.state
                                                                      .shopOwnerProductCategoriesState[
                                                                  index]['id']),
                                                        ));
                                                  },
                                                  child: Stack(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        child: Container(
                                                          // color: Colors.red,
                                                          height: 100,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              2.4,
                                                          child: Image.network(
                                                            '${store.state.shopOwnerProductCategoriesState[index]['image']}',
                                                            // Image.asset('assets/images/Rectangle 1031.png',
                                                            fit: BoxFit.cover,
                                                            colorBlendMode:
                                                                BlendMode
                                                                    .luminosity,
                                                            color:
                                                                Color.fromRGBO(
                                                                    0,
                                                                    0,
                                                                    0,
                                                                    0.37),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 100,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            2.4,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              child: Text(
                                                                // 'Milk',
                                                                '${store.state.shopOwnerProductCategoriesState[index]['name']}',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontFamily:
                                                                      'poppins',
                                                                ),
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
                                        ),
                            ],
                          ),
                    ////////////////////// recomended for you grid end //////////////////////
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
