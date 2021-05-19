import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:duare/Api/api.dart';
import 'package:duare/Redux/action.dart';
import 'package:duare/Redux/state.dart';
import 'package:duare/RouteTransition/routeAnimation.dart';
import 'package:duare/Screens/CategoryBrandsProductsListingScreen/categoryBrandsProductsListingScreen.dart';
import 'package:duare/Screens/LoginScreen/loginScreen.dart';
import 'package:duare/Screens/ProductDetailsPage/productDetailsPage.dart';
import 'package:duare/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();

}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  // bool _searchOn = false;


  @override
  void initState() {
     
   // _getRecommended();


   print(store.state.whichHomeState['id']);

   if(store.state.whichHomeState['id']==1) {
     store.dispatch(RecommendedProductListAction(store.state.electronicsCategoryList));
      _getRecommended();
   }
   else if(store.state.whichHomeState['id']==2) {
     store.dispatch(RecommendedProductListAction(store.state.groceryCategoryList));
      _getRecommended();
   }
   else if(store.state.whichHomeState['id']==4) {
     store.dispatch(RecommendedProductListAction(store.state.medicineCategoryList));
      _getRecommended();
   }


    super.initState();
  }

  

 ////////////////// get recommended list start ////////////////////
  _getRecommended() async {
   //store.dispatch(RecommendedProductLoadingAction(true));
    var res =
        await CallApi().getDataWithToken('productmodule/getAllProductCategoryById/${store.state.whichHomeState['id']}');
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
      store.dispatch(RecommendedProductListAction(body['data']));

    } else if (res.statusCode == 401) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
        store.dispatch(RecommendedProductLoadingAction(false));
  }
  ////////////////// get recommended list end  ////////////////////


  Future<void> _search(String value) async {
   store.dispatch(SearchProductListAction({}));
   store.dispatch(SearchProductLoadingAction(true));
    var res = await CallApi()
        .getDataWithTokenandQuery('productmodule/getProductBySearch',
        '&str=$value''&cat_id=${store.state.whichHomeState['id']}'
        );

    if (res.statusCode == 200) {
      var body = json.decode(res.body);
      print(body);

     if(body['data']['products'].length>0){
        for(var d in body['data']['products']){
        if(d['variations'].length>0){
             for(var data in d['variations']){
          if(data['stock']==0){
            d['stock']=0;
          }
          else{
             d['stock']=1;
             break;
          }
        }
        }
      }
     }
       

       store.dispatch(SearchProductListAction(body['data']));

    }   
    else if (res.statusCode == 401) {
      _showMsg('Your login has expired!', 1);
      Navigator.pushReplacement(context, SlideLeftRoute(page: LoginScreen()));
    }
    else{   

        _showMsg('Something went wrong!! Please try again', 1);
    }
      store.dispatch(SearchProductLoadingAction(false));
  }
  @override                                                                                      
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        ////// this is the connector which mainly changes state/ui
        converter: (store) => store.state,
        builder: (context, items) { 
          return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'Search',
            style: TextStyle(
              fontFamily: 'poppins',
              color: Color(0xFF263238),
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
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

                         store.dispatch(SearchStateAction(true));
                         _search(searchController.text);
                       
                       
                        // setState(() {
                        //     _searchOn = true;
                        //  });
                      } else {
                          store.dispatch(SearchStateAction(false));
                        // setState(() {
                        //   _searchOn = false;
                        // });
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
                          store.state.searchState?
                               IconButton(
                                  onPressed: () {
                                    searchController.clear();
                                    store.dispatch(SearchStateAction(false));
                                     store.dispatch(SearchProductListAction({}));
                                  },
                                  icon: Icon(
                                    Icons.cancel,
                                    color: Colors.grey,
                                  ),
                                )
                              :
                          Icon(
                        FlutterIcons.search_fea,
                        color: Colors.black,
                      ),
                      hintText: "Search here",
                      hintStyle:
                          TextStyle(color: Colors.black, fontFamily: 'poppins'),
                      contentPadding:
                          EdgeInsets.only(left: 10, top: 17, bottom: 16),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                ////////////////////// search text field end //////////////////////
                  
                 
                    ////////////////////// recomended for you grid start //////////////////////
                  
                    store.state.searchProductLoading?
             Container(
               margin: EdgeInsets.only(top:80),
               child: SpinKitCircle( 
                              color: Color(0xFF0487FF),
                              // size: 30,
                            ),
             ):
              store.state.searchState?
                    ////////////////////// Category search results grid start //////////////////////
                  store.state.searchProductList['categories'].length==0 &&
                  store.state.searchProductList['products'].length==0 ?
                   Center(

                              child: Container(
                                height: MediaQuery.of(context).size.height/3,
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [

                                    Icon(
                     Icons.search_off_rounded,
                      size: 70,
                      color:appColor
                    ),        
                                    Container(
                                      margin: EdgeInsets.only(top:10),
                                      child: Text(
                                              'No result found for "${searchController.text}"',
                                              style: TextStyle(
                                                fontFamily: 'poppins',
                                                color: Colors.black54,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ):
                  
                    Container(
                        margin: EdgeInsets.only(top: 25),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          store.state.searchProductList['categories'].length==0?
                  Container(): Column(
                     mainAxisAlignment: MainAxisAlignment.start,
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
                                 store.state.searchProductList['categories'].length,
                                  (index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            SlideLeftRoute(
                                              page:
                                                  CategoryBrandsProductsListingScreen(store.state.searchProductList['categories'][index]),  
                                            ));
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
                                              child: 
                                               store.state.searchProductList['categories'][index]['image']==null ||
                                               store.state.searchProductList['categories'][index]['image']=="" ?
                                               Image.asset(
                                                "assets/images/placeHolder.jpg",
                                                fit: BoxFit.cover,
                                                 colorBlendMode:BlendMode.luminosity,
                                                 color:Color.fromRGBO(0, 0, 0, 0.37),
                                              ):
                                              CachedNetworkImage(
                                                            imageUrl: store.state.searchProductList['categories'][index]['image'],
                                                            fit: BoxFit.cover,  
                                                             colorBlendMode:BlendMode.luminosity,
                                                              color:Color.fromRGBO(0, 0, 0, 0.37),
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
                                                    store.state.searchProductList['categories'][index]['name']==null?
                                                    "":store.state.searchProductList['categories'][index]['name'],
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
                             ],
                           ),
                            ////////////////////// Category search results grid End //////////////////////

                            ////////////////////// Product search results grid Start //////////////////////
                            store.state.searchProductList['products'].length==0? 
             Container():
              Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                                  store.state.searchProductList['products'].length,
                                  (index) {
                                    return GestureDetector(
                                      onTap: () {
                                            Navigator.push(
                                                                  context,
                                                                  SlideLeftRoute(
                                                                    page:
                                                                        ProductDetailsPage(store.state.searchProductList['products'][index]['id']),
                                                                  ));
                                      },
                                      child: Stack(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context).size.width /
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
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(5),
                                                    ),
                                                    border: Border.all(
                                                      width: 0.5,
                                                      color: Color(0xFF9C9A9A),
                                                    ),
                                                  ),
                                                  child: 
                                                  store.state.searchProductList['products'][index]['photo'].length==0?
                                                  Image.asset(
                                                    "assets/images/placeHolder.jpg",
                                                    fit: BoxFit.contain,
                                                  ):
                                                  CachedNetworkImage(
                                                                imageUrl: store.state.searchProductList['products'][index]['photo'][0]['image'],
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
                                                              ),
                                                  // Image.asset(
                                                  //   'assets/images/img (1).png',
                                                  //   fit: BoxFit.contain,
                                                  // ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                    top: 6,
                                                    // bottom: 6,
                                                  ),
                                                  child: Text(
                                                    store.state.searchProductList['products'][index]['name'],
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
                                     
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ), 
                ],
              ),
                           ////////////////////// Product search results grid End //////////////////////
                          ],
                        ),
                      )
                    :
             
            
             store.state.whichHomeState['id']==3?
             Container():
             Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              top: 40,
                            ),
                            child: Text(
                              'Recomended For You',
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
                                store.state.recommendedProductList.length,
                                (index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                            context,
                                            SlideLeftRoute(
                                              page:
                                                  CategoryBrandsProductsListingScreen(store.state.recommendedProductList[index]), 
                                            ));
                                    },
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(5),
                                          child: Container(
                                            // color: Colors.red,
                                            height: 100,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /2.4,
                                            child: 
                                            store.state.recommendedProductList[index]['image']==null ||
                                            store.state.recommendedProductList[index]['image']==""?
                                            Image.asset(
                                               "assets/images/placeHolder.jpg",
                                              fit: BoxFit.cover,
                                              colorBlendMode: BlendMode.luminosity,
                                              color: Color.fromRGBO(0, 0, 0, 0.37),
                                            ):
                                            CachedNetworkImage( 
                              imageUrl:store.state.recommendedProductList[index]['image'],
                               fit: BoxFit.cover,
                               colorBlendMode: BlendMode.luminosity,
                               color: Color.fromRGBO(0, 0, 0, 0.37),
                              
                              placeholder: (context, url) => Center(
                                child: SpinKitFadingCircle(
                                  color: Colors.grey,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  Center(child: new Icon(Icons.error)),
                            )
                                          ),
                                        ),
                                        Container(
                                          height: 100,
                                          width:
                                              MediaQuery.of(context).size.width /
                                                  2.4,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                child: Text(
                                                 store.state.recommendedProductList[index]['name']==null?
                                                 "":store.state.recommendedProductList[index]['name'],
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
                        ],
                      ),
                ////////////////////// recomended for you grid end //////////////////////
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
