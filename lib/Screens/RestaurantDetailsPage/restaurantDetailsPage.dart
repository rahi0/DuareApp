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

class RestaurantDetailsPage extends StatefulWidget {
  var restaurantID;
  RestaurantDetailsPage(this.restaurantID);
  @override
  _RestaurantDetailsPageState createState() => _RestaurantDetailsPageState();
}

class _RestaurantDetailsPageState extends State<RestaurantDetailsPage> {

  @override
  void initState() {
    _getRestaurentDetails();
    super.initState();
  }

  ///////////////// get banners start /////////////////
  _getRestaurentDetails() async {
    store.dispatch(RestauranDetailsLoadingAction(true));

    var res = await CallApi().getDataWithToken('productmodule/getSingleRestaurant/${widget.restaurantID}');
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
       store.dispatch(RestauranDetailsAction(body['data']));

    } else if (res.statusCode == 401) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
     store.dispatch(RestauranDetailsLoadingAction(false));
  }
  ///////////////// get banners end /////////////////
  
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        ////// this is the connector which mainly changes state/ui
        converter: (store) => store.state,
        builder: (context, items) { 
    return Scaffold(
      backgroundColor: Colors.white,
      body: store.state.restaurantDetailsLoadingState ?
              Center(
                child: SpinKitCircle(
                  color: Color(0xFF0487FF),
                  // size: 30,
                 ),
              ) :
      SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Column(
            children: [
              Container(
                // height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 3.75,
                      width: MediaQuery.of(context).size.width,
                      child: store.state.restaurantDetailstState['image']== null ?
                      Image.asset(
                        'assets/images/Rectangle 15.png',
                        fit: BoxFit.cover,
                        // colorBlendMode: BlendMode.luminosity,
                        // color: Color.fromRGBO(0, 0, 0, 0.2),
                      ): CachedNetworkImage(
                            imageUrl: "${store.state.restaurantDetailstState['image']}",
                            fit: BoxFit.cover,
                            placeholder:(context, url) => Center(
                            child: SpinKitFadingCircle(
                              color: Colors.grey,),
                            ),
                            errorWidget: (context, url, error) =>
                             Center(child: new Icon(Icons.error)),
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
                          'Restaurants',
                          style: TextStyle(
                            fontFamily: 'poppins',
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 154,
                      height: 112,
                      margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 5.5,
                        left: 40,
                        right: 40,
                      ),
                      padding: EdgeInsets.all(3),
                      // margin: EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Color.fromRGBO(0, 182, 88, 0.37),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: store.state.restaurantDetailstState['image']== null ?
                      Image.asset(
                        'assets/images/Rectangle 557.png',
                        fit: BoxFit.cover,
                      ):
                       ClipRRect(
                         borderRadius: BorderRadius.circular(12),
                         child: CachedNetworkImage(
                            imageUrl: "${store.state.restaurantDetailstState['image']}",
                            fit: BoxFit.cover,
                            placeholder:(context, url) => Center(
                            child: SpinKitFadingCircle(
                              color: Colors.grey,),
                            ),
                            errorWidget: (context, url, error) =>
                             Center(child: new Icon(Icons.error)),
                          ),
                       ),
                    ),
                    Positioned(
                      bottom: 55,
                      right: 0,
                      child: store.state.restaurantDetailstState['shop_status'] == null ? Container():
                      Container(
                        padding: EdgeInsets.only(
                            left: 19, right: 19, top: 3, bottom: 3),
                        decoration: BoxDecoration(
                          color: Color(0xFF00B658),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Text(
                          // 'Open',
                          "${store.state.restaurantDetailstState['shop_status']}",
                          style: TextStyle(
                            fontFamily: 'poppins',
                            color: Colors.white,
                            fontSize: 12,
                            // fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              /////////////////// Restaurants details start //////////////////
              Container(
                // width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 40),
                alignment: Alignment.topCenter,
                child: Text(
                  // 'Restaurants',
                  store.state.restaurantDetailstState['name']==null?"":
                  '${store.state.restaurantDetailstState['name']}',
                  style: TextStyle(
                    fontFamily: 'poppins',
                    color: Color(0xFF333436),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                // width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 5, left: 20, right: 20),
                alignment: Alignment.topCenter,
                child: Text(
                  // '(Chowmohona, Moulovibazar)',
                  store.state.restaurantDetailstState['address']==null?"":
                  '(${store.state.restaurantDetailstState['address']})',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'poppins',
                    color: Color(0xFF00B658),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(right: 30, left: 30, top: 20, bottom: 0),
                // alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Color(0xFFDADADA),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            // alignment: Alignment.center,
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  color: Color(0xFFDADADA),
                                  width: 1,
                                ),
                                // bottom: BorderSide(
                                //   color: Color(0xFFDADADA),
                                //   width: 1,
                                // ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_pin,
                                  color: Color(0xFF00B658),
                                ),
                                Container(
                                  child: Text(
                                    // ' 4.5 km',
                                    " ${store.state.restaurantDetailstState['distant']}",
                                    style: TextStyle(
                                      fontFamily: 'poppins',
                                      color: Color(0xFF333436),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            decoration: BoxDecoration(
                              border: Border(
                                // bottom: BorderSide(
                                //   color: Color(0xFFDADADA),
                                //   width: 1,
                                // ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Color(0xFFFFC833),
                                ),
                                Container(
                                  child: Text(
                                    store.state.restaurantDetailstState['avg_rating'] == null ? 
                                    store.state.restaurantDetailstState['reviews_count'] == null ?
                                    ' 0.0 (0 Reviews)' :
                                    ' 0.0 (0 Reviews)' :
                                    ' ${store.state.restaurantDetailstState['avg_rating']['averageRating']} (${store.state.restaurantDetailstState['reviews_count']} Reviews)',
                                    style: TextStyle(
                                      fontFamily: 'poppins',
                                      color: Color(0xFF333436),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Container(
                    //   // padding: EdgeInsets.only(top: 10, bottom: 10),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       Expanded(
                    //         child: Container(
                    //           padding: EdgeInsets.only(top: 10, bottom: 10),
                    //           decoration: BoxDecoration(
                    //             border: Border(
                    //               right: BorderSide(
                    //                 color: Color(0xFFDADADA),
                    //                 width: 1,
                    //               ),
                    //             ),
                    //           ),
                    //           child: Row(
                    //             mainAxisAlignment: MainAxisAlignment.center,
                    //             children: [
                    //               Text(
                    //                 'Min order   \$25',
                    //                 style: TextStyle(
                    //                   fontFamily: 'poppins',
                    //                   color: Color(0xFF333436),
                    //                   fontSize: 14,
                    //                   fontWeight: FontWeight.w500,
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //       Expanded(
                    //         child: Center(
                    //           child: Container(
                    //             padding: EdgeInsets.only(top: 10, bottom: 10),
                    //             child: Text(
                    //               'Delivery fee   \$25',
                    //               style: TextStyle(
                    //                 fontFamily: 'poppins',
                    //                 color: Color(0xFF333436),
                    //                 fontSize: 14,
                    //                 fontWeight: FontWeight.w500,
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
              /////////////////// Restaurants details end //////////////////

              /////////////////// Restaurants menu start //////////////////
              store.state.restaurantDetailstState['restaurant_category'].length <= 0?
               Container(
                 height: MediaQuery.of(context).size.height/3,
                 child: Center(
                   child: Text(
                               'No item available',
                               style: TextStyle(
                                 fontFamily: 'poppins',
                                 color: Color(0xFF263238),
                                 fontSize: 16,
                                 fontWeight: FontWeight.w500,
                               ),
                               overflow: TextOverflow.ellipsis,
                             ),
                 ),
               ):
              Container(
                height: MediaQuery.of(context).size.height / 1.5,
                child: DefaultTabController(
                  length: store.state.restaurantDetailstState['restaurant_category'].length,
                  child: new Scaffold(
                    backgroundColor: Colors.white,
                    appBar: new AppBar(
                      elevation: 2,
                      automaticallyImplyLeading: false,
                      backgroundColor: Colors.white,
                      actions: <Widget>[],
                      title: new TabBar(
                        // labelPadding: EdgeInsets.zero,
                        indicatorPadding: EdgeInsets.symmetric(horizontal: 15),
                        isScrollable: true,
                        labelColor: Color(0xFF263238),
                        labelStyle: TextStyle(fontSize: 16),
                        tabs: List.generate(
                          store.state.restaurantDetailstState['restaurant_category'].length,
                          (index) {
                            return Tab(text: "${store.state.restaurantDetailstState['restaurant_category'][index]['category_name']}");
                          }),
                        // [
                        //   new Tab(text: "Noodles & Pasta"),
                        //   new Tab(text: "Snacks"),
                        //   new Tab(text: "Combo Packs")
                        // ],
                        indicatorColor: Color(0xFF0487FF),
                        unselectedLabelColor: Color(0xFF263238),
                      ),
                    ),
                    body: TabBarView(
                      children: List.generate(
                          store.state.restaurantDetailstState['restaurant_category'].length,
                          (index) {
                            return SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: RestaurentMenuList(store.state.restaurantDetailstState['restaurant_category'][index]),
                        );
                          }),
                      
                      // [
                      //   ,
                      //   SingleChildScrollView(
                      //     physics: BouncingScrollPhysics(),
                      //     child: Container(),
                      //   ),
                      //   SingleChildScrollView(
                      //     physics: BouncingScrollPhysics(),
                      //     child: Container(),
                      //   ),
                      // ],
                    ),
                  ),
                ),
              ),
              /////////////////// Restaurants menu end //////////////////
            ],
          ),
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





///////////////////////////////////// Product List Class ///////////////////////////////////////////////////////////

class RestaurentMenuList extends StatefulWidget {
  final restaurentCategory;
  RestaurentMenuList(this.restaurentCategory);
  @override
  _RestaurentMenuListState createState() => _RestaurentMenuListState();
}

class _RestaurentMenuListState extends State<RestaurentMenuList> {

  @override
  void initState() {
    _getRestaurentDetails();
    super.initState();
  }

  ///////////////// get banners start /////////////////
  _getRestaurentDetails() async {
   store.dispatch(RestaurentMenuListLoadingAction(true));

    var res = await CallApi().getDataWithToken('productmodule/getSingleRestaurantMenuProducts/${widget.restaurentCategory['id']}');
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
      store.dispatch(RestaurentMenuListAction(body['data']));

    } else if (res.statusCode == 401) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else{
      _showMsg('Something went wrong!', 1);
    }
    store.dispatch(RestaurentMenuListLoadingAction(false));
  }
  ///////////////// get banners end /////////////////
  @override
  Widget build(BuildContext context) {
    return store.state.restaurantMenuListLoadingState ?
              Container(
                height: MediaQuery.of(context).size.height/3,
                child: Center(
                  child: SpinKitCircle(
                    color: Color(0xFF0487FF),
                    // size: 30,
                   ),
                ),
              ) :
              Container(
                            margin: EdgeInsets.only(top: 35, bottom: 10),
                            child: store.state.restaurantMenuListState.length <= 0?
                              Container(
                                height: MediaQuery.of(context).size.height/3,
                                child: Center(
                                  child: Text(
                                              'No item available',
                                              style: TextStyle(
                                                fontFamily: 'poppins',
                                                color: Color(0xFF263238),
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                ),
                              ):
                            Column(
                              children: List.generate(
                                store.state.restaurantMenuListState.length,
                                (index) {
                                  return GestureDetector(
                                    onTap: (){
                                       Navigator.push(context,SlideLeftRoute(page:ProductDetailsPage(store.state.restaurantMenuListState[index]['id'])));
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.only(
                                          left: 16, right: 16, bottom: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color.fromRGBO(0, 0, 0, 0.03),
                                            blurRadius: 15,
                                            spreadRadius: 0,
                                            offset: Offset(1, 8),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: MediaQuery.of(context).size.width/4.1,
                                            width: MediaQuery.of(context).size.width/4.3,
                                            child: ClipRRect(
                                              borderRadius:BorderRadius.circular(5),
                                              child: store.state.restaurantMenuListState[index]['image'] == null ?
                                              Image.asset(
                                                "assets/images/Rectangle 554.png",
                                                fit: BoxFit.cover,
                                              ) :
                                             CachedNetworkImage(
                                                           imageUrl: store.state.restaurantMenuListState[index]['image'],
                                                           fit: BoxFit.cover,
                                                           placeholder:(context, url) => Center(
                                                             child: SpinKitFadingCircle(
                                                               color: Colors.grey,),
                                                           ),
                                                           errorWidget: (context, url, error) =>
                                                               Center(child: new Icon(Icons.error)),
                                                         ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              margin: EdgeInsets.only(left: 10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    // 'Lebanese bread',
                                                    '${store.state.restaurantMenuListState[index]['name']}',
                                                    style: TextStyle(
                                                      fontFamily: 'poppins',
                                                      color: Color(0xFF263238),
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        top: 6, bottom: 8),
                                                    child: Text(
                                                      // '(Breakfast)',
                                                      '(${widget.restaurentCategory['category_name']})',
                                                      style: TextStyle(
                                                        fontFamily: 'poppins',
                                                        color: Color(0xFF263238),
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    // 'From Tk6.00',
                                                    'From Tk${store.state.restaurantMenuListState[index]['variations'][0]['price']}',
                                                    style: TextStyle(
                                                      fontFamily: 'poppins',
                                                      color: Color(0xFF00B658),
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
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