import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:duare/Api/api.dart';
import 'package:duare/Redux/action.dart';
import 'package:duare/Redux/state.dart';
import 'package:duare/RouteTransition/routeAnimation.dart';
import 'package:duare/Screens/LoginScreen/loginScreen.dart';
import 'package:duare/Screens/ProductDetailsPage/productDetailsPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../main.dart';

class CategoryBrandsProductsListingScreen extends StatefulWidget {
  final productCat;
  CategoryBrandsProductsListingScreen(this.productCat);
  @override
  _CategoryBrandsProductsListingScreenState createState() =>
      _CategoryBrandsProductsListingScreenState();
}

class _CategoryBrandsProductsListingScreenState
    extends State<CategoryBrandsProductsListingScreen> {
  var _isExpanded = -1;


  ///////////////// get Brand and product List start /////////////////
  _getBrandList() async {
    store.dispatch(CatBrandListLoadingAction(true));
    
    var res = await CallApi().getDataWithTokenandQuery('productmodule/getCatWiseBrandList', '&product_cat_id=${widget.productCat['id']}');
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
      store.dispatch(CatBrandListAction(body));
      print(store.state.catBrandListState);
      store.dispatch(CatBrandListLoadingAction(false));

    } else if (res.statusCode == 401) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
        // store.dispatch(CatBrandListLoadingAction(false));
  }
  ///////////////// get Brand and product List end /////////////////
  


  @override
  void initState() {
    _getBrandList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        ////// this is the connector which mainly changes state/ui
        converter: (store) => store.state,
        builder: (context, items) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F7),
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: Colors.white,
      //   centerTitle: true,
      //   automaticallyImplyLeading: false,
      //   leading: IconButton(
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //     icon: Icon(
      //       Icons.arrow_back,
      //       color: Color(0xFF263238),
      //     ),
      //   ),
      //   title: Text(
      //     'Powder Milk',
      //     style: TextStyle(
      //       fontFamily: 'poppins',
      //       color: Color(0xFF263238),
      //       fontSize: 22,
      //       fontWeight: FontWeight.w600,
      //     ),
      //   ),
      // ),
      body: 
      store.state.catBrandListLoadingState != false ?
             SpinKitCircle(
                              color: Color(0xFF0487FF),
                              // size: 30,
                            )
                            :
                            Container(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 3.75,
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset(
                      'assets/images/milkPowderBg.png',
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
                    child: 
                    Container(
                      // width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(top: 6),
                      alignment: Alignment.topCenter,
                      child: Text(
                        // 'Powder Milk',
                        '${widget.productCat['name']}',
                        style: TextStyle(
                          fontFamily: 'poppins',
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  //////////////// product brands list start ////////////////
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 16, right: 16),
                        height: MediaQuery.of(context).size.height -
                            MediaQuery.of(context).size.height / 4.5,
                        decoration: BoxDecoration(
                          // color: Colors.red,
                          color: Color(0xFFF5F5F7),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                        ),
                        child: ListView.builder(
                          padding: EdgeInsets.only(bottom: 5.0),
                          physics: BouncingScrollPhysics(),
                          // scrollDirection: Axis.horizontal,
                          itemCount: store.state.catBrandListState['data'].length,
                          itemBuilder: (BuildContext ctx, int index) {
                            return Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                    top: 20,
                                  ),
                                  padding: EdgeInsets.only(
                                      left: 20, right: 20, top: 15, bottom: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        //'Nestle',
                                        '${store.state.catBrandListState['data'][index]['products'][index]['brand']['name']}',
                                        style: TextStyle(
                                          fontFamily: 'poppins',
                                          color: Color(0xFF263238),
                                          // fontSize: 22,
                                          fontWeight: FontWeight.w500,
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
                                        child: Container(
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: Color(0xFF00B658),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            _isExpanded == index
                                                ? Icons.keyboard_arrow_up
                                                : Icons.keyboard_arrow_down,
                                            color: Colors.white,
                                            size: 25,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                _isExpanded == index
                                    ? Column(
                                        children: List.generate(
                                          store.state.catBrandListState['data'][index]['products'].length,
                                          (ind) {
                                            return Column(
                                              children: [
                                                Container(
                                                  // margin: EdgeInsets.only(top: 1),
                                                  padding: EdgeInsets.all(20),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: index == 1
                                                        ? BorderRadius.only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    12),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    12),
                                                          )
                                                        : BorderRadius.all(
                                                            Radius.circular(0),
                                                          ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              height: 75,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          18),
                                                              child:store.state.catBrandListState['data'][index]['products'][ind]['photo'].length==0?
                                                                  Image.asset(
                                                                "assets/images/img (5).png",
                                                                fit: BoxFit
                                                                    .contain,
                                                              ):
                                                    CachedNetworkImage(
                                                         imageUrl: store.state.catBrandListState['data'][index]['products'][ind]['photo'][0]['image'],
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
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                   // 'Arla Dano Daily Pushti Powder milk',
                                                                   "${store.state.catBrandListState['data'][index]['products'][ind]['name']}",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Color(
                                                                          0xFF263238),
                                                                      fontFamily:
                                                                          'poppins',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          4),
                                                                  Text(
                                                                    'From:  ৳'+store.state.catBrandListState['data'][index]['products'][ind]['variations'][0]['price'].toString(),
                                                                    //'From ৳240',
                                                                   // "From ৳${store.state.catBrandListState['data'][index]['products'][ind]['name']}",
                                                      //              store.state.catBrandListState['data'][index]['products'][ind]['percentage'] ==null ||
                                                      // store.state.catBrandListState['data'][index]['products'][ind]['percentage']==0?
                                                      // 'From:  ৳'+store.state.catBrandListState['data'][index]['products'][ind]['variations'][0]['price'].toString():
                                                      // 'From:  ৳'+ (store.state.catBrandListState['data'][index]['products'][ind]['variations'][0]['price']-
                                                      // ( (store.state.catBrandListState['data'][index]['products'][ind]['percentage']*(store.state.catBrandListState['data'][index]['products'][ind]['variations'][0]['price']))/
                                                      //           100)).toString(),
                                                                    style:
                                                                        TextStyle(
                                                                      color: Color(
                                                                          0xFF00B658),
                                                                      fontFamily:
                                                                          'poppins',
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
                                                          Navigator.push(
                                                              context,
                                                              SlideLeftRoute(
                                                                page:
                                                                    ProductDetailsPage(store.state.catBrandListState['data'][index]['products'][ind]['id']),
                                                                   // ProductDetailsPage(store.state.productList[index]),
                                                              ));
                                                        },
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(9),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            shape:
                                                                BoxShape.circle,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        0,
                                                                        0,
                                                                        0,
                                                                        0.06),
                                                                blurRadius: 7,
                                                                spreadRadius: 0,
                                                                offset: Offset(
                                                                    0, 5),
                                                              ),
                                                            ],
                                                          ),
                                                          child: Icon(
                                                            Icons.arrow_forward,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                if (index != 1)
                                                  Container(
                                                    height: 1,
                                                    color: Color(0xFFEDE9E9),
                                                  ),
                                              ],
                                            );
                                          },
                                        ),
                                      )
                                    : Container(),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  //////////////// product brands list end ////////////////
                ],
              ),
            ),
            Container(),
          ],
        ),
      ),
    );
    }
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
