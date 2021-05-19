// RestaurantsHome
import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:duare/Screens/ProductDetailsPage/productDetailsPage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:duare/Api/api.dart';
import 'package:duare/Models/AllBannerModel.dart';
import 'package:duare/Redux/action.dart';
import 'package:duare/Redux/state.dart';
import 'package:duare/Screens/SubCategoryScreen/subCategoryScreen.dart';
import 'package:duare/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:duare/RouteTransition/routeAnimation.dart';
import 'package:duare/Screens/RestaurantDetailsPage/restaurantDetailsPage.dart';
import 'package:duare/Screens/LoginScreen/loginScreen.dart';


class RestaurantsHome extends StatefulWidget {
  @override
  _RestaurantsHomeState createState() => _RestaurantsHomeState();
}

class _RestaurantsHomeState extends State<RestaurantsHome> {


  var _timer;
  ////////////////// Page View Controller essentials start ////////////////

  PageController _pageController;
  int currentIndex = 0;

  static const _kDuration = const Duration(milliseconds: 300);
  static const _kCurve = Curves.easeIn;

  onChangedFunction(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  nextFunction() {
    _pageController.nextPage(duration: _kDuration, curve: _kCurve);
  }

  previousFunction() {
    _pageController.previousPage(duration: _kDuration, curve: _kCurve);
  }

  slide() {
    _timer = Timer.periodic(Duration(seconds: 2), (Timer t) {
      if (currentIndex >= 0 && currentIndex < 2)
        nextFunction();
      else {
        _pageController.jumpToPage(0);
      }
    });
  }

  @override
  void initState() {
    _pageController = PageController(
      // viewportFraction: 0.75,
      initialPage: 0,
    );

     slide();
    _getAllBanners();
    _getPartnerShop();
    _showRestaurantBestDeals(); 
    _showAllRestaurant(); 
    _getCartData(); 
    _getAnnouncment(); 
    // _getCategory();
    super.initState();
  }




   Future<void> _pull() async {
      _getAllBanners();
      _getPartnerShop();
    _showRestaurantBestDeals(); 
    _showAllRestaurant(); 
    _getCartData(); 
    _getAnnouncment(); 
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }


  ///////////////// get Announcment start /////////////////
  _getAnnouncment() async {
     store.dispatch(AnnouncmentLoadingtAction(true));

    var res = await CallApi().getDataWithToken('usermodule/getAnnouncement');
    var body = json.decode(res.body);
    print(res.statusCode);
    print('body - $body');
    print('.....................');

    if (res.statusCode == 200) {
      store.dispatch(AnnouncmentAction(body['data']));
    } else{
      _showMsg("Something went wrong!", 1);
    }

      store.dispatch(AnnouncmentLoadingtAction(false));
  }
  ///////////////// get Announcment end /////////////////




    ///////////////// get banners start /////////////////
  _getAllBanners() async {
    // store.dispatch(BannerLoadingAction(true));

    var res = await CallApi().getDataWithTokenandQuery(
        'usermodule/getAllBanners', '&catId=${store.state.whichHomeState['id']}');
    var body = json.decode(res.body);
    // print(res.statusCode);
    // print('body - $body');
    // print('.....................');

    if (res.statusCode == 200) {
      var allBanner = allBannerModelFromJson(res.body);
    //  print('allBanner - $allBanner');
      store.dispatch(RestuarantBannerListAction(allBanner));
    }
  store.dispatch(RestaurantBannerLoadingAction(false));
  }
  ///////////////// get banners end /////////////////



  ///////////////// get banners start /////////////////
  _getPartnerShop() async {
    // store.dispatch(BannerLoadingAction(true));

    var res = await CallApi().getDataWithToken('productmodule/getPartnerShops');
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
      store.dispatch(PartnerRestaurantListAction(body['data']));

    } else if (res.statusCode == 401) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
        store.dispatch(PartnerRestaurantLoadingAction(false));
  }
  ///////////////// get banners end /////////////////
  

  ////////////////// get Restaurant Best Deals list start ////////////////////    
     Future<void> _showRestaurantBestDeals() async {
    var res = await CallApi()
        .getDataWithToken('productmodule/getRestaurantBestDeals/${store.state.whichHomeState['id']}');
    print(res.statusCode);
    if (res.statusCode == 200) {
      var body = json.decode(res.body);
        print(body);        
      store.dispatch(ResturantBestDealsListAction(body['data']));
    }
    else if (res.statusCode == 401) {
      
      _showMsg("Login Expired!", 1);
       Navigator.push( context, SlideLeftRoute(page: LoginScreen()));
    }
    else{
           _showMsg("Something went wrong", 1);
      }
   store.dispatch(ResturantBestDealsListLoadingAction(false));
  }

  ////////////////// get Restaurant Best Deals list end //////////////////// 
  
  ////////////////// get All Restaurant list start ////////////////////    
     Future<void> _showAllRestaurant() async {
    var res = await CallApi()
        .getDataWithToken('productmodule/getAllRestaurant');
    print(res.statusCode);
    if (res.statusCode == 200) {
      var body = json.decode(res.body);
        print(body);        
      // store.dispatch(AllRestaurantListAction(body['data']));
      store.dispatch(AllRestaurantListAction(body['openRestaurants']));
      store.dispatch(ClosedRestaurentListAction(body['closeRestaurants']));
    }
    else if (res.statusCode == 401) {
      
      _showMsg("Login Expired!", 1);
       Navigator.push( context, SlideLeftRoute(page: LoginScreen()));
    }
    else{
           _showMsg("Something went wrong", 1);
      }
   store.dispatch(AllRestaurantLoadingAction(false));
  }

  ////////////////// get All Restaurant list end //////////////////// 

  @override
  Widget build(BuildContext context) {
     return StoreConnector<AppState, AppState>(
        ////// this is the connector which mainly changes state/ui
        converter: (store) => store.state,
        builder: (context, items) { 
          return RefreshIndicator(
                    onRefresh: _pull,
                  child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
           child: Container(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              store.state.restaurantBannerLoading?
             SpinKitCircle(
                              color: Color(0xFF0487FF),
                              // size: 30,
                            ):
            store.state.restaurantBannerList.length> 0?
                Stack(
                  children: [
                    Container(
                        height: 200,
                        padding: EdgeInsets.only(top: 20),
                        color: Colors.white,
                        child: PageView.builder(
                          physics: BouncingScrollPhysics(),
                          controller: _pageController,
                          onPageChanged: onChangedFunction,
                          pageSnapping: false,
                          itemCount: store.state.restaurantBannerList.length,
                          itemBuilder: (BuildContext ctx, int index) {
                            return Container(
                              width: 250,
                              margin: EdgeInsets.only(
                                  top: 5, bottom: 10, right: 20, left: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                  store.state.restaurantBannerList[index].image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                    ),

                    ///////////////// indicator start ////////////////////
                    Positioned(
                        bottom: 10,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          // color: Colors.white,
                          child: Transform.scale(
                            scale: 0.4,
                            child: SmoothPageIndicator(
                              controller: _pageController, // PageController
                              count: store.state.restaurantBannerList.length,
                              effect: ExpandingDotsEffect(
                                dotWidth: 18,
                                spacing: 12,
                                expansionFactor: 1.1,
                                dotHeight: 18,
                                activeDotColor: Color(0xFF0487FF),
                                dotColor: Color(0xFFB4B4B4),
                              ), // your preferred effect
                            ),
                          ),
                        ),
                    ),
                    ///////////////// indicator end ////////////////////
                  ],
                ):Container(),

              ////////////// voucher ad start ////////////////
              
              store.state.announcmentLoadingState? Container():
              store.state.announcmentState == null ? Container():
              Container(
                margin: EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 40),
                child: Row(
                  children: [
                    Icon(
                        FlutterIcons.megaphone_oct,
                        color: Color(0xFF0487FF),
                        size: 30,
                    ),
                    SizedBox(
                        width: 12,
                    ),
                    Expanded(
                        child: RichText(
                          text: TextSpan(children: [
                            // TextSpan(
                            //   text: 'Use',
                            //   style: TextStyle(
                            //     fontFamily: 'poppins',
                            //     color: Colors.black,
                            //     fontSize: 12,
                            //     // fontWeight: FontWeight.w600,
                            //   ),
                            // ),
                            TextSpan(
                              // text: ' Duare5 ',
                              text: '${store.state.announcmentState['details']}',
                              style: TextStyle(
                                fontFamily: 'poppins',
                                color: Color(0xFF0487FF),
                                fontSize: 12,
                                // fontWeight: FontWeight.w600,
                              ),
                            ),
                            // TextSpan(
                            //   text: 'to get 5% discount on Grocery & Medicine',
                            //   style: TextStyle(
                            //     fontFamily: 'poppins',
                            //     color: Colors.black,
                            //     fontSize: 12,
                            //     // fontWeight: FontWeight.w600,
                            //   ),
                            // ),
                          ]),
                        ),
                    ),
                  ],
                ),
              ),
              ////////////// voucher ad end ////////////////

              ///////////////// Best Deals start ////////////////
              store.state.resturantBestDealsListState.length==0?
              Container():
              Container(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        'Best Deals',
                        style: TextStyle(
                          fontFamily: 'poppins',
                          color: Color(0xFF263238),
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                    ),
                    GestureDetector(
                        onTap: () {
                           Navigator.push(
                              context,
                              ScaleRoute(
                                page: SubCategoryScreen(""),
                              ));
                        },
                        child: Text(
                          'View all',
                          style: TextStyle(
                            fontFamily: 'poppins',
                            color: Color(0xFF0487FF),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ),
                  ],
                ),
              ),

              store.state.resturantBestDealsLoadingState?
               Container(
                 height: 220,
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     SpinKitCircle(
                                    color: Color(0xFF0487FF),
                                    // size: 30,
                                  ),
                    Container(
                      width:  MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(top:8),
                        alignment: Alignment.center,
                        child: Text(
                                    'Please wait to see featured products....',
                                   
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
               ): 
               Container(
                height: store.state.resturantBestDealsListState.length==0? 0: 220,
                margin: EdgeInsets.only(left: 15),
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  padding: EdgeInsets.only(bottom: 5.0),
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: store.state.resturantBestDealsListState.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    return GestureDetector(
                        onTap: () {
                          Navigator.push(context,SlideLeftRoute(page:ProductDetailsPage(store.state.resturantBestDealsListState[index]['id'])));
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 20),
                          // width: MediaQuery.of(context).size.width / 2.25,
                          width: 172,
                          height: 141,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 5, right: 5, top: 8, bottom: 15),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                      border: Border.all(
                                        width: 0.5,
                                        color: Color(0xFFBCBCBC),
                                      ),
                                    ),
                                    child: Container(
                                      height: 130,
                                      width: 175,
                                      child: //Image.asset("assets/images/image 6 (2).png"),
                                      store.state.resturantBestDealsListState[index]['photo'].length==0?
                                    Image.asset("assets/images/image 6 (2).png") :
                                           CachedNetworkImage(
                                                         imageUrl: store.state.resturantBestDealsListState[index]['photo'][0]['image'],
                                                        // fit: BoxFit.cover,
                                                         placeholder:(context, url) => Center(
                                                           child: SpinKitFadingCircle(
                                                             color: Colors.grey,),
                                                         ),
                                                         errorWidget: (context, url, error) =>
                                                             Center(child: new Icon(Icons.error)),
                                                       ),
                                    )
                                  ),
                                  /////////////// From : TK 4000 //////////////////
                                  Positioned(
                                    right: 0,
                                    child: Container(
                                      margin: EdgeInsets.only(top: 20),
                                      padding:
                                          EdgeInsets.only(top: 3, bottom: 3, left: 9),
                                      width: MediaQuery.of(context).size.width / 3.75,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF00B658),
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(5),
                                          topLeft: Radius.circular(5),
                                        ),
                                      ),
                                      child: Text(
                                       // 'From : TK 40',
                                        'From:  TK '+store.state.resturantBestDealsListState[index]['variations'][0]['price'].toString(),
                                        style: TextStyle(
                                          fontFamily: 'poppins',
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  /////////////// From : TK 4000 //////////////////
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  top: 6,
                                  bottom: 6,
                                ),
                                child: Text(
                                  // 'Burger',
                                  '${store.state.resturantBestDealsListState[index]['name']}',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: 'poppins',
                                    color: Color(0xFF263238),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  // 'Cafe la Jawab',
                                  '${store.state.resturantBestDealsListState[index]['pshop']['name']}',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: 'poppins',
                                    color: Color(0xFF979797),
                                    fontSize: 14,
                                    // fontWeight: FontWeight.w500,
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
              ///////////////// Best Deals end ////////////////

              ///////////////// our new partners start ////////////////
              // Column(
              // children: List.generate(
              // 1,
              // (index) {
              // return
              store.state.partnerRestaurantLoading?
               Container(
                 height: 220,
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     SpinKitCircle(
                                    color: Color(0xFF0487FF),
                                    // size: 30,
                                  ),
                    Container(
                      width:  MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(top:8),
                        alignment: Alignment.center,
                        child: Text(
                                    'Please wait to see our new partners....',
                                   
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
               ):
              Column(
                children: [
                  Container(
                    padding:
                          EdgeInsets.only(left: 16, right: 16, bottom: 20, top: 20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Our New Partners',
                            style: TextStyle(
                              fontFamily: 'poppins',
                              color: Color(0xFF263238),
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              'View all',
                              style: TextStyle(
                                fontFamily: 'poppins',
                                color: Color(0xFF0487FF),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                    ),
                  ),
                  Container(
                    height: 200,
                    margin: EdgeInsets.only(left: 15),
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                        padding: EdgeInsets.only(bottom: 5.0),
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: store.state.partnerRestaurantList.length,
                        itemBuilder: (BuildContext ctx, int index) {
                          // Row(
                          //   children: List.generate(
                          //     10,
                          //     (index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  ScaleRoute(
                                    page: RestaurantDetailsPage(store.state.partnerRestaurantList[index]['id']),
                                  ));
                            },
                            child: Container(
                              // height: 180,
                              // width: MediaQuery.of(context).size.width / 2.25,
                              margin: EdgeInsets.only(right: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 141,
                                    width: 172,
                                    padding: EdgeInsets.only(
                                        left: 5, right: 5, top: 8, bottom: 17),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                      border: Border.all(
                                        width: 0.5,
                                        color: Color(0xFFBCBCBC),
                                      ),
                                    ),
                                    child: store.state.partnerRestaurantList[index]['image']==null?
                                    Image.asset(
                                      "assets/images/image 6 (4).png",
                                      fit: BoxFit.cover,
                                    )
                                    :
                                    CachedNetworkImage(
                                                         imageUrl: store.state.partnerRestaurantList[index]['image'],
                                                         fit: BoxFit.cover,
                                                         placeholder:(context, url) => Center(
                                                           child: SpinKitFadingCircle(
                                                             color: Colors.grey,),
                                                         ),
                                                         errorWidget: (context, url, error) =>
                                                             Center(child: new Icon(Icons.error)),
                                                       )
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      top: 6,),
                                    child: Text( 
                                     store.state.partnerRestaurantList[index]['name']==null?
                                     "":store.state.partnerRestaurantList[index]['name'],
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: 'poppins',
                                        color: Color(0xFF263238),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Text(     
                                       store.state.partnerRestaurantList[index]['address']==null?
                                     "":store.state.partnerRestaurantList[index]['address'],
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: 'poppins',
                                        color: Color(0xFF979797),
                                        fontSize: 14,
                                        // fontWeight: FontWeight.w500,
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
                ],
              ),
              //       ;   
              //     }, 
              //   ),
              // ),
              ///////////////// our new partners end ////////////////

              //////////////// all restuaranst list start //////////////
            //store.state.allRestaurantList.length==0?Container(): 
            Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(top: 20, left: 16),
                    child: Text(
                      'All Restaurants',
                      style: TextStyle(
                        fontFamily: 'poppins',
                        color: Color(0xFF263238),
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
             store.state.allRestaurantLoading?
             Container(
               margin: EdgeInsets.only(
                  bottom: 40,
                  top: 40,
                ),
               child: SpinKitCircle(
                                color: Color(0xFF0487FF),
                                // size: 30,
                              ),
             ):
             
            //  store.state.allRestaurantList.length==0?Container():
             store.state.allRestaurantList.length==0?
             Container(
               height: 90,
               child: Center(
                                
                                child: Text(
                                        'Restaurants not available',
                                        style: TextStyle(
                                          fontFamily: 'poppins',
                                          color: Colors.grey,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                              ),
             ):
              Container(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: 20,
                  top: 40,
                ),
                child: Column(
                  children: List.generate(
               store.state.allRestaurantList.length,
               (index) {
                   return GestureDetector(
                     onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RestaurantDetailsPage(store.state.allRestaurantList[index]['id'])),
                        );
                      // 
                     },
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Container(
                           // padding: EdgeInsets.only(
                           //   left: 16,
                           //   right: 16,
                           // bottom: 20,
                           //   top: 20,
                           // ),
                           child: Stack(
                             children: [
                               ClipRRect(
                                 borderRadius: BorderRadius.circular(10),
                                 child: Container(
                                      height: 170,
                                      width: MediaQuery.of(context).size.width,
                                      child:  
                                //       Image.asset(
                                //    'assets/images/Rectangle 15.png', 
                                //    fit: BoxFit.cover,
                                //    // colorBlendMode: BlendMode.luminosity,
                                //    // color: Color.fromRGBO(0, 0, 0, 0.2),
                                //  ),
                                      
                                      store.state.allRestaurantList[index]['image'] == null ?
                                      //  store.state.allRestaurantList[index]['image'] == null?
                                    Image.asset("assets/images/Rectangle 15.png") :
                                    CachedNetworkImage(
                                      imageUrl: store.state.allRestaurantList[index]['image'],
                                      fit: BoxFit.cover,
                                      placeholder:(context, url) => Center(
                                        child: SpinKitFadingCircle(
                                                color: Colors.grey,),
                                              ),
                                      errorWidget: (context, url, error) => Center(child: new Icon(Icons.error)),
                                      ),
                                    )
                               ),
                               /////////////// delievry time start //////////////////
                               Positioned(
                                 right: 0,
                                 bottom: 20,
                                 child: store.state.allRestaurantList[index]['delivery_time'] == null ? Container():
                                 Container(
                                   margin: EdgeInsets.only(top: 20),
                                   padding: EdgeInsets.only(
                                       top: 3, bottom: 3, left: 9),
                                   width: MediaQuery.of(context).size.width / 4,
                                   decoration: BoxDecoration(
                                     color: Color(0xFF00B658),
                                     borderRadius: BorderRadius.only(
                                       bottomLeft: Radius.circular(5),
                                       topLeft: Radius.circular(5),
                                     ),
                                   ),
                                   child: Text(
                                    //  '20-30 mins',
                                     '${store.state.allRestaurantList[index]['delivery_time']}',
                                     style: TextStyle(
                                       fontFamily: 'poppins',
                                       fontSize: 12,
                                       color: Colors.white,
                                     ),
                                   ),
                                 ),
                               ),
                               /////////////// delievry time end //////////////////
                             ],
                           ),
                         ),
                         Container(
                           margin: EdgeInsets.only(
                             top: 6,
                             // bottom: 6,
                           ),
                           child: Text(
                            //  'Eat & Meat',
                             '${store.state.allRestaurantList[index]['name']}',
                             overflow: TextOverflow.ellipsis,
                             style: TextStyle(
                               fontFamily: 'poppins',
                               color: Color(0xFF263238),
                               fontSize: 16,
                               fontWeight: FontWeight.w500,
                             ),
                           ),
                         ),
                         Container(
                           margin: EdgeInsets.only(bottom: 20),
                           child: Text(
                            //  'Saifur Rahman Road',
                            store.state.allRestaurantList[index]['address'] == null ? "":
                             '${store.state.allRestaurantList[index]['address']}',
                             overflow: TextOverflow.ellipsis,
                             style: TextStyle(
                               fontFamily: 'poppins',
                               color: Colors.black,
                               fontSize: 14,
                               // fontWeight: FontWeight.w500,
                             ),
                           ),
                         ),
                       ],
                     ),
                   );
               },
                  ),
                ),
              ),
             
              //////////////// all restuaranst list end //////////////

              //////////////// closed restuaranst list start //////////////
              store.state.closedRestaurantList.length==0? Container():
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 10, left: 16),
                child: Text(
                  'Order for Later',
                  style: TextStyle(
                    fontFamily: 'poppins',
                    color: Color(0xFF263238),
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: 20,
                  top: 20,
                ),
                child: Column(
                  children: List.generate(
                    store.state.closedRestaurantList.length,
                    (index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RestaurantDetailsPage(store.state.closedRestaurantList[index]['id'])),
                        );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 170,
                                child: Stack(         
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 170,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child:  store.state.closedRestaurantList[index]['image'] == null ?
                                      //  store.state.allRestaurantList[index]['image'] == null?
                                    Image.asset(
                                      "assets/images/Rectangle 15.png",
                                      fit: BoxFit.cover,
                                      colorBlendMode: BlendMode.luminosity,
                                      color: Color.fromRGBO(0, 0, 0, 0.4),
                                    ) :
                                    CachedNetworkImage(
                                      imageUrl: store.state.closedRestaurantList[index]['image'],
                                      fit: BoxFit.cover,
                                      colorBlendMode: BlendMode.luminosity,
                                      color: Color.fromRGBO(0, 0, 0, 0.4),
                                      placeholder:(context, url) => Center(
                                        child: SpinKitFadingCircle(
                                                color: Colors.grey,),
                                              ),
                                      errorWidget: (context, url, error) => Center(child: new Icon(Icons.error)),
                                      ),
                                      ),
                                    ),
                                    /////////////// delievry time start //////////////////
                                    Container(    
                                      width: MediaQuery.of(context).size.width,
                                      height: 170,        
                                      child: Column(            
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(top: 20),
                                            padding: EdgeInsets.only(
                                                top: 13,
                                                bottom: 13,
                                                left: 29,
                                                right: 29),
                                            // width:   
                                            //     MediaQuery.of(context).size.width / 2.35,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF00B658),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(12),
                                              ),
                                            ),
                                            child: Text(  
                                              'Closed for Now',
                                              style: TextStyle(
                                                fontFamily: 'poppins',
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    /////////////// delievry time end //////////////////
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  top: 6,
                                  // bottom: 6,
                                ),
                                child: Text(
                                  // 'Eat & Meat',
                                  '${store.state.closedRestaurantList[index]['name']}',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: 'poppins',
                                    color: Color(0xFF263238),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                                         
                              Container(
                                margin: EdgeInsets.only(bottom: 20),
                                child: Text(
                                  // 'Saifur Rahman Road',
                                  store.state.closedRestaurantList[index]['address'] == null ? "":
                                 '${store.state.closedRestaurantList[index]['address']}',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: 'poppins',
                                    color: Colors.black,
                                    fontSize: 14,
                                    // fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                                  
                            ],
                          ),
                        );
                    },
                  ),
                ),
              ),
              //////////////// closed restuaranst list end //////////////
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
  

  ////////////////// get cart list start ////////////////////
  _getCartData() async {
   // store.dispatch(CartListLoadingAction(true));
    var res =
        await CallApi().getDataWithToken('ordermodule/getAllCartData');
    var body = json.decode(res.body);
    print(res.statusCode);
    // print('body - $body');
    // print('.....................');

    if (body['message'] == "You are not allowed to access this route... ") {
      _showMsg('Your login has expired!', 1);
      Navigator.pushReplacement(context, SlideLeftRoute(page: LoginScreen()));

    } ////////// checking if token is expired
    else if (res.statusCode == 200) {
      var body = json.decode(res.body); 
      print(body);
     store.dispatch(CartListAction(body['data']));

    } else if (res.statusCode == 401) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else{
           _showMsg("Something went wrong", 1);
      }
      // store.dispatch(CartListLoadingAction(false));
  }
  ////////////////// get cart list end ////////////////////
}
 