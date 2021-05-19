import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:duare/Api/api.dart';
import 'package:duare/Redux/action.dart';
import 'package:duare/Redux/state.dart';
import 'package:duare/RouteTransition/routeAnimation.dart';
import 'package:duare/Screens/LoginScreen/loginScreen.dart';
import 'package:duare/Screens/ProductDetailsPage/productDetailsPage.dart';
import 'package:duare/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    _showFavourite();

    super.initState();
  }

  Future<void> _pull() async {
    _showFavourite();
  }

  Future<void> _showFavourite() async {
    var res = await CallApi().getDataWithToken(
        'productmodule/getAllProductFavorate/${store.state.userInfoState['id']}');

    if (res.statusCode == 200) {
      var body = json.decode(res.body);

      List fvrtList = body['data'];
      print(body['data']);

      for (var d in body['data']) {
        if (d['product'] == null) {
          print("Dfd");
          fvrtList.remove(d);
          break;
        }
      }

      for (var d in fvrtList) {
        d['product']['favorite'] = {
          "id": d['id'],
          "product_id": d['product_id'],
          "user_id": d['user_id'],
        };
        if (d['product']['variations'].length > 0) {
          for (var data in d['product']['variations']) {
            if (data['stock'] == 0) {
              d['stock'] = 0;
            } else {
              d['stock'] = 1;
              break;
            }
          }
        }
      }
      store.dispatch(FavouriteProductListAction(fvrtList));
    } else if (res.statusCode == 401) {
      _showMsg("Login expired!", 1);
      Navigator.push(context, SlideLeftRoute(page: LoginScreen()));
    } else {
      _showMsg("Something went wrong", 1);
    }
    store.dispatch(FavouriteProductLoadingAction(false));
  }

  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        ////// this is the connector which mainly changes state/ui
        converter: (store) => store.state,
        builder: (context, items) {
          return Scaffold(
            backgroundColor: Color(0xFFF9F9F9),
            body: RefreshIndicator(
              onRefresh: _pull,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        // height: MediaQuery.of(context).size.height,
                        child: Stack(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height / 3.5,
                              width: MediaQuery.of(context).size.width,
                              child: Image.asset(
                                'assets/images/Vector 3 (1).png',
                                fit: BoxFit.cover,
                                colorBlendMode: BlendMode.luminosity,
                                color: Color.fromRGBO(0, 0, 0, 0.2),
                              ),
                            ),
                            SafeArea(
                              child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SafeArea(
                              child: Container(
                                // width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(top: 6),
                                alignment: Alignment.topCenter,
                                child: Text(
                                  'My Favourites',
                                  style: TextStyle(
                                    fontFamily: 'poppins',
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      store.state.favouriteProductLoading
                          ? Container(
                              height: MediaQuery.of(context).size.height / 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SpinKitCircle(
                                    color: Color(0xFF0487FF),
                                    // size: 30,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 8),
                                    child: Text(
                                      'Please wait to see favourites....',
                                      style: TextStyle(
                                        fontFamily: 'poppins',
                                        color: Color(0xFF263238),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : store.state.favouriteProductList.length == 0
                              ? Container(
                                  alignment: Alignment.center,
                                  height:
                                      MediaQuery.of(context).size.height / 3,
                                  child: Text(
                                    'No items added to favourites',
                                    style: TextStyle(
                                      fontFamily: 'poppins',
                                      color: Color(0xFF263238),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                )
                              : Container(
                                  margin: EdgeInsets.only(
                                    // left: 16,
                                    // right: 16,
                                    top: 35,
                                  ),
                                  child: Wrap(
                                    spacing: 20.0,
                                    runSpacing: 13,
                                    children: List.generate(
                                      store.state.favouriteProductList.length,
                                      (index) {
                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                SlideLeftRoute(
                                                    page: ProductDetailsPage(store
                                                            .state
                                                            .favouriteProductList[
                                                        index]['product']['id'])));
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.3,    
                                            // padding: EdgeInsets.all(10),

                                            // decoration: BoxDecoration(
                                            // color: Colors.blue,
                                            //   borderRadius: BorderRadius.circular(12),
                                            // ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        // height: 100,
                                                        // width: 100,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            2.35,
                                                        padding:
                                                             EdgeInsets.all(30),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(5),
                                                          ),
                                                          border: Border.all(
                                                            width: 0.5,
                                                            color: Color(
                                                                0xFFE3E1E1),
                                                          ),
                                                         ),
                                                        child: Container(
                                                     height: 100,
                                                     width: 100,
                                                     child:store.state.favouriteProductList[index]['product']['photo'].length==0?
                                                     Image.asset(
                                                "assets/images/placeHolder.jpg",
                                                fit: BoxFit.contain,
                                              ):
                                              CachedNetworkImage(
                                                            imageUrl: store.state.favouriteProductList[index]['product']['photo'][0]['image'],
                                                            fit: BoxFit.cover,
                                                               colorBlendMode: BlendMode.luminosity,
                                                           color: Color.fromRGBO(0, 0, 0, 0.2),
                                                            placeholder:
                                                                (context, url) =>
                                                                    Center(
                                                              child: SpinKitFadingCircle(
                                                                color: Colors.grey,),
                                                            ),
                                                            errorWidget: (context,
                                                                    url, error) =>
                                                                Center(child: new Icon(Icons.error)),
                                                          ),
                                                   ),
                                                      ),
                                                      store.state.favouriteProductList[
                                                                          index]
                                                                      [
                                                                      'product']
                                                                  ['stock'] ==
                                                              0
                                                          ? Positioned(
                                                              right: 0,
                                                              child: Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            20),
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top: 3,
                                                                        bottom:
                                                                            3,
                                                                        left:
                                                                            18),
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    4.5,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Color(
                                                                      0xFF00B658),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            5),
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            5),
                                                                  ),
                                                                ),
                                                                child: Text(
                                                                  'Stock Out',
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'poppins',
                                                                    fontSize:
                                                                        12,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          : Container(),
                                                      ///////////// stock out end ///////////////
                                                      store.state.favouriteProductList[
                                                                          index]
                                                                      [
                                                                      'product']
                                                                  ['stock'] ==
                                                              0
                                                          ? Container()
                                                          : Positioned(
                                                              right: 18,
                                                              top: 11,
                                                              child: store.state.favouriteProductList[index]['product']
                                                                              ['percentage'] ==null ||
                                                                      store.state.favouriteProductList[index]['product']
                                                                              [
                                                                              'percentage'] ==
                                                                          0
                                                                  ? Container()
                                                                  : Container(
                                                                      // margin: EdgeInsets.only(left: 24),
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              8),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        color: Color(
                                                                            0xFF00B658),
                                                                      ),
                                                                      margin: EdgeInsets
                                                                          .only(
                                                                              top: 6),
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Text(
                                                                            store.state.favouriteProductList[index]['product']['percentage'].toString() +
                                                                                '%',
                                                                            style:
                                                                                TextStyle(
                                                                              fontFamily: 'poppins',
                                                                              color: Colors.white,
                                                                              fontSize: 8,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            'Off',
                                                                            style:
                                                                                TextStyle(
                                                                              fontFamily: 'poppins',
                                                                              color: Colors.white,
                                                                              fontSize: 8,
                                                                              // fontWeight: FontWeight.w600,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                            ),
                                                      Positioned(
                                                        bottom: 0,
                                                        right: 0,
                                                        child: GestureDetector(
                                                          onTap: () {},
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    3),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Color(
                                                                  0xFF0487FF),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(
                                                                Radius.circular(
                                                                    5),
                                                              ),
                                                            ),
                                                            child: Icon(
                                                                Icons.add,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  // margin: EdgeInsets.only(left: 24),
                                                  margin:
                                                      EdgeInsets.only(top: 6),
                                                  child: Text(
                                                    store.state.favouriteProductList[
                                                                        index]
                                                                    ['product']
                                                                ['name'] ==
                                                            null
                                                        ? ""
                                                        : store.state
                                                                    .favouriteProductList[
                                                                index]
                                                            ['product']['name'],
                                                    style: TextStyle(
                                                      fontFamily: 'poppins',
                                                      color: Color(0xFF263238),
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                store.state.favouriteProductList[index]['product']['variations'].length==0?
                                             Container():Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 3),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                          store.state.favouriteProductList[index]['product']['percentage'] ==null ||
                                                     store.state.favouriteProductList[index]['product']['percentage']==0?"":
                                                        store.state.favouriteProductList[index]['product']['variations'][0]['price']==null?"৳0.00":
                                                         '৳'+store.state.favouriteProductList[index]['product']['variations'][0]['price'].toString(),
                                                        style: TextStyle(
                                                          fontFamily: 'poppins',
                                                          color:
                                                              Color(0xFF979797),
                                                          fontSize: 12,
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough,
                                                          // fontWeight: FontWeight.w500,
                                                        ), 
                                                      ),
                                                     store.state.favouriteProductList[index]['product']['percentage'] ==null ||
                                                     store.state.favouriteProductList[index]['product']['percentage']==0?
                                                     Container(): SizedBox(width:10),
                                                      Text(
                                                     store.state.favouriteProductList[index]['product']['percentage'] ==null ||
                                                     store.state.favouriteProductList[index]['product']['percentage']==0?
                                                     '৳'+store.state.favouriteProductList[index]['product']['variations'][0]['price'].toString():
                                                  '৳'+ (store.state.favouriteProductList[index]['product']['variations'][0]['price']-
                                                    ( (store.state.favouriteProductList[index]['product']['percentage']*(store.state.favouriteProductList[index]['product']['variations'][0]['price']))/
                                                      100)).toString(),
                                                        style: TextStyle(
                                                          fontFamily: 'poppins',
                                                          color:
                                                              Color(0xFF00B658),
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600,
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
                                ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
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
