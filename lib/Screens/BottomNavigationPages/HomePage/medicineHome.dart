import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:duare/Api/api.dart';
import 'package:duare/Models/AllBannerModel.dart';
import 'package:duare/Redux/action.dart';
import 'package:duare/Redux/state.dart';
import 'package:duare/RouteTransition/routeAnimation.dart';
import 'package:duare/Screens/CategoryAllProductsListingScreen/categoryAllProductsListingScreen.dart';
import 'package:duare/Screens/LoginScreen/loginScreen.dart';
import 'package:duare/Screens/ProductDetailsPage/productDetailsPage.dart';
import 'package:duare/Screens/SubCategoryScreen/subCategoryScreen.dart';
import 'package:duare/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MedicineHome extends StatefulWidget {
  @override
  _MedicineHomeState createState() => _MedicineHomeState();
}

class _MedicineHomeState extends State<MedicineHome> {


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
     _getCategory();
     _showRecentlyPurchased();
     _getCartData();
     _getAnnouncment();
    super.initState();
  }

   
     Future<void> _pull() async {
      _getAllBanners();   
        _getCategory();
        _showRecentlyPurchased();
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
    print(res.statusCode);
    print('body - $body');
    print('.....................');

    if (res.statusCode == 200) {
      var allBanner = allBannerModelFromJson(res.body);
      print('allBanner - $allBanner');
      store.dispatch(MedicineBannerListAction(allBanner));
    }

      store.dispatch(MedicineBannerLoadingAction(false));
  }
  ///////////////// get banners end /////////////////


 ////////////////// get categories list start ////////////////////
  _getCategory() async {
    var res =
        await CallApi().getDataWithToken('productmodule/getAllProductCategoryById/${store.state.whichHomeState['id']}');
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
      store.dispatch(MedicineCategoryListAction(body['data']));

    } else if (res.statusCode == 401) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else{
           _showMsg("Something went wrong", 1);
      }
        store.dispatch(MedicineCategoryLoadingAction(false));
  }
  ////////////////// get categories list end ////////////////////
  

  ////////////////// get Medicine Resently Purchased list start ////////////////////    
   
     Future<void> _showRecentlyPurchased() async {
    var res = await CallApi()
        .getDataWithToken('productmodule/getMedicineResentlyPurchased/${store.state.whichHomeState['id']}');
    print(res.statusCode);
    if (res.statusCode == 200) {
      var body = json.decode(res.body);
        print("lalal");        
        print(body);        
      store.dispatch(RecentlyPurchasedMedListAction(body['data']));
    }
    else if (res.statusCode == 401) {
      
      _showMsg("Login Expired!", 1);
       Navigator.push( context, SlideLeftRoute(page: LoginScreen()));
    }
    else{
           _showMsg("Something went wrong", 1);
      }
  store.dispatch(RecentlyPurchasedMedListLoadingAction(false));
  }
  
  ////////////////// get Medicine Resently Purchased list end //////////////////// 
  

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
              store.state.medicineBannerLoading?
             SpinKitCircle(
                              color: Color(0xFF0487FF),
                              // size: 30,
                            ):
            store.state.medicineBannerList.length> 0?Stack(
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
                        itemCount: store.state.medicineBannerList.length,
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
                                store.state.medicineBannerList[index].image,
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
                            count: store.state.medicineBannerList.length,
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

              ///////////////// featured items start ////////////////
              store.state.recentlyPurchasedMedListState.length==0?
              Container():
              Container(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        'Recently Purchased',
                        style: TextStyle(
                          fontFamily: 'poppins',
                          color: Color(0xFF263238),
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                    ),
                    GestureDetector(
                        onTap: () {

                          Navigator.push(context,
                            ScaleRoute( page:CategoryAllProductsListingScreen("Recently Purchased",
                            store.state.recentlyPurchasedMedListState),),
                          );
                          //  Navigator.push(
                          //     context,
                          //     ScaleRoute(
                          //       page: SubCategoryScreen(""),
                          //     ));
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

              store.state.recentlyPurchasedMedLoadingState?
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
                height: store.state.recentlyPurchasedMedListState.length==0?0:230,
                margin: EdgeInsets.only(left: 15),
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  padding: EdgeInsets.only(bottom: 5.0),
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: store.state.recentlyPurchasedMedListState.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    return GestureDetector(
                        onTap: () {
                          Navigator.push(context,SlideLeftRoute(page:ProductDetailsPage(store.state.recentlyPurchasedMedListState[index]['id']),));
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 20),
                          width: MediaQuery.of(context).size.width / 2.25,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                             // if (store.state.medicineBannerList.length != 0)
                                Stack(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(12),
                                        ),
                                        border: Border.all(
                                          width: 0.5,
                                          color: Color(0xFFBCBCBC),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 122,
                                            height: 140,
                                            margin: EdgeInsets.only(
                                                left: 29,
                                                right: 29,
                                                top: 8,
                                                bottom: 8),
                                            child: store.state.recentlyPurchasedMedListState[index]['photo'].length==0?
                                            Image.asset(
                                              "assets/images/med.jpg",
                                              fit: BoxFit.cover,
                                            ):
                                           CachedNetworkImage(
                                                         imageUrl: "${store.state.recentlyPurchasedMedListState[index]['photo'][0]['image']}",
                                                        // fit: BoxFit.cover,
                                                         placeholder:(context, url) => Center(
                                                           child: SpinKitFadingCircle(
                                                             color: Colors.grey,),
                                                         ),
                                                         errorWidget: (context, url, error) =>
                                                             Center(child: new Icon(Icons.error)),
                                                       ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    /////////////// From : TK 4000 //////////////////
                                    Positioned(
                                      right: 0,
                                      child: Container(
                                        margin: EdgeInsets.only(top: 20),
                                        padding: EdgeInsets.only(
                                            top: 3, bottom: 3, left: 9),
                                        width:
                                            MediaQuery.of(context).size.width / 3.7,
                                        decoration: BoxDecoration(
                                          color: Color(0xFF00B658),
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(5),
                                            topLeft: Radius.circular(5),
                                          ),
                                        ),
                                        child: Text(
                                          'From:  TK '+store.state.recentlyPurchasedMedListState[index]['variations'][0]['price'].toString(),
                                          // 'From : TK 40',
                                          // store.state.recentlyPurchasedMedListState[index]['percentage'] ==null ||
                                          //             store.state.recentlyPurchasedMedListState[index]['percentage']==0?
                                          //             'From:  TK '+store.state.recentlyPurchasedMedListState[index]['variations'][0]['price'].toString():
                                          //             'From:  TK '+ (store.state.recentlyPurchasedMedListState[index]['variations'][0]['price']-
                                          //             ( (store.state.recentlyPurchasedMedListState[index]['percentage']*(store.state.recentlyPurchasedMedListState[index]['variations'][0]['price']))/
                                          //                       100)).toString(),
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
                                  // 'Seclo',
                                  '${store.state.recentlyPurchasedMedListState[index]['name']}',
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
                                  // 'Unilever',
                                  store.state.recentlyPurchasedMedListState[index]['brand']['name']==null ? "":
                                  '${store.state.recentlyPurchasedMedListState[index]['brand']['name']}',
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
              ///////////////// featured items end ////////////////

               ///////////////// category start ////////////////
              store.state.medicineCategoryLoading?
               Container(
                 height: MediaQuery.of(context).size.height/3,
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     SpinKitCircle(
                                    color: Color(0xFF0487FF),
                                    // size: 30,
                                  ),
                    Container(
                        margin: EdgeInsets.only(top:8),
                        child: Text(
                                    'Please wait to see category....',
                                   
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
                children: List.generate(
                  store.state.medicineCategoryList.length,
                  (index) {
                    return Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                                left: 16, right: 16, bottom: 20, top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  store.state.medicineCategoryList[index]['name'],
                                  style: TextStyle(
                                    fontFamily: 'poppins',
                                    color: Color(0xFF263238),
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                               store.state.medicineCategoryList[index]['product_sub_category'].length==0?
                               Container(): GestureDetector(
                                  onTap: () {

                                         Navigator.push(
                              context,
                              ScaleRoute(
                                page: SubCategoryScreen(store.state.medicineCategoryList[index]),
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
                          Container(
                            height: 220,
                            margin: EdgeInsets.only(left: 15),
                            width: MediaQuery.of(context).size.width,
                            child: store.state.medicineCategoryList[index]['product_sub_category'].length==0?
                            Center(

                              child: Text(
                                      'No products is available',
                                      style: TextStyle(
                                        fontFamily: 'poppins',
                                        color: Colors.grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                            ):
                            ListView.builder(
                              padding: EdgeInsets.only(bottom: 5.0),
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: store.state.medicineCategoryList[index]['product_sub_category'].length,
                              itemBuilder: (BuildContext ctx, int subIndex) {
                                // Row(
                                //   children: List.generate(
                                //     10,
                                //     (index) {
                                return GestureDetector(
                                  onTap: () {
                                      Navigator.push(
                              context,
                              ScaleRoute(
                                page: CategoryAllProductsListingScreen("subCategory",
                                store.state.medicineCategoryList[index]['product_sub_category'][subIndex]),
                              ));
                                  },
                                  child: Container(
                                    width: 172, height: 141,
                                    // width: MediaQuery.of(context).size.width / 2.25,
                                    margin: EdgeInsets.only(right: 20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          // padding: EdgeInsets.all(5),
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
                                          child: Column(
                                            children: [ 
                                             store.state.medicineCategoryList[index]['product_sub_category'][subIndex]['image'] == null?
                                          Image.asset(
                                            'assets/images/placeHolder.jpg',
                                            fit: BoxFit.cover,
                                            colorBlendMode: BlendMode.luminosity,
                                            color: Color.fromRGBO(0, 0, 0, 0.2),
                                          ) :
                                              CachedNetworkImage(
                                                              imageUrl: store.state.medicineCategoryList[index]['product_sub_category'][subIndex]['image'],
                                                              fit: BoxFit.cover,
                                                              placeholder:
                                                                  (context, url) =>
                                                                      Center(
                                                                child: SpinKitFadingCircle(
                                                                  color: Colors.grey,),
                                                              ),
                                                              errorWidget: (context,
                                                                      url, error) =>
                                                                  Center(child: new Icon(Icons.error)),
                                                            )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                            top: 6,
                                            // bottom: 6,
                                          ),
                                          child: Text(
                                            store.state.medicineCategoryList[index]['product_sub_category'][subIndex]['name'],
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontFamily: 'poppins',
                                              color: Color(0xFF263238),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
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
                    );
                  },
                ),
              ),
              ///////////////// category end ////////////////
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
