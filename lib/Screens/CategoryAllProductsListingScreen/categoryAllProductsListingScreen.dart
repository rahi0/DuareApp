import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:duare/Api/api.dart';
import 'package:duare/Redux/action.dart';
import 'package:duare/Redux/state.dart';
import 'package:duare/Screens/LoginScreen/loginScreen.dart';
import 'package:duare/Screens/ProductDetailsPage/productDetailsPage.dart';
import 'package:duare/main.dart';
import 'package:flutter/material.dart';
import 'package:duare/RouteTransition/routeAnimation.dart';
import 'package:duare/Screens/CartPage/cartPage.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CategoryAllProductsListingScreen extends StatefulWidget {

  final page;
  final data;
  CategoryAllProductsListingScreen(this.page,this.data);

  @override
  _CategoryAllProductsListingScreenState createState() =>
      _CategoryAllProductsListingScreenState();
}

class _CategoryAllProductsListingScreenState
    extends State<CategoryAllProductsListingScreen> {
  
  // var totalPrice;
  // var price;
  // var subTotal;

  @override
  void initState() {

    //_calculatePrice();


   if(widget.page=="subCategory"){
       _getCategory("");
   }
   else{
      store.dispatch(ProductListAction(widget.data));
      store.dispatch(ProductLoadingAction(false));
   }
   
    super.initState();
  }

   Future<void> _pull() async {
   _getCategory("pull");
  }
      
 ////////////////// get categories list start ////////////////////
  _getCategory(type) async {

    if(type==""){
        store.dispatch(ProductLoadingAction(true));
    }
    else{
store.dispatch(ProductLoadingAction(false));
    }
    

    var res =
        await CallApi().getDataWithToken('productmodule/getAllProductBySubCategoryId/${widget.data['id']}');
    var body = json.decode(res.body);
    print(res.statusCode);   
    print('body - $body');

    if (body['message'] == "You are not allowed to access this route... ") {
      _showMsg('Your login has expired!', 1);
      Navigator.pushReplacement(context, SlideLeftRoute(page: LoginScreen()));

    } ////////// checking if token is expired
    else if (res.statusCode == 200) {
      var body = json.decode(res.body); 
     

      for(var d in body['data']){
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
      store.dispatch(ProductListAction(body['data']));

    } else if (res.statusCode == 401) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
        store.dispatch(ProductLoadingAction(false));
  }
  ////////////////// get categories list end ////////////////////
  

  // _calculatePrice(){
   
  //  // print(totalPrice);
  //   totalPrice = 0;
  //   price = 0;
  //   for (var d in store.state.cartListState) {
  //     price = d['variation']['price'] * d['quantity'];
  //     totalPrice = totalPrice + price;
    
  //   }
  //   setState(() { 
  //      subTotal = totalPrice;
  //  //totalPrice= subTotal + delifee;
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        ////// this is the connector which mainly changes state/ui
        converter: (store) => store.state,
        builder: (context, items) { 
          return Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: Container(
          color: Colors.white,
          child: Container(
            height: 84,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.06),
                  blurRadius: 10,
                  spreadRadius: 0,
                  offset: Offset(0, -1),
                ),
              ],
            ),
            ////////////////////// cart button start //////////////////////
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    ScaleRoute(
                      page: CartPage("Normal"),
                    ));
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 12, bottom: 11),
                margin: EdgeInsets.only(top: 15, bottom: 15, left: 20, right: 20),
                decoration: BoxDecoration(
                  color: Color(0xFF0487FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      padding:EdgeInsets.only(left: 10, right: 10, top: 4, bottom: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white),
                      ),
                      child: Text(
                        // '1',
                        '${store.state.cartListState.length}',
                        // textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'poppins',
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      'View your cart',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'poppins',
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 20),
                      child: Text(
                        '৳98',
                        // '৳${subTotal}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'poppins',
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ////////////////////// cart button end //////////////////////
          ),
        ),
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
                          height: MediaQuery.of(context).size.height / 3.75,
                          width: MediaQuery.of(context).size.width,
                          child:  widget.page=="subCategory"?
                          CachedNetworkImage(
                                                            imageUrl: widget.data['image'],
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
                                                          ):
                          Image.asset(
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
                              widget.page=="subCategory"? widget.data['name']:
                              widget.page,
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
                          store.state.productLoading?
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
                                  'Please wait to see products....',
                                 
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
               ): Container(
                          margin: EdgeInsets.only(
                            bottom: 10,
                            // top: 35,
                           // top: MediaQuery.of(context).size.height / 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: Container(
                              margin: EdgeInsets.only(
                                left: 16,
                                right: 16,
                                top: 18,
                              ),
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    // margin: EdgeInsets.only(left: 24),
                                    margin: EdgeInsets.only(top: 6, bottom: 20),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Color(0xFF00B658),        
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      'All',
                                      style: TextStyle(
                                        fontFamily: 'poppins',
                                        color: Color(0xFF263238),
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Wrap(
                                    spacing: 20.0,
                                    runSpacing: 13,
                                    children: List.generate(
                                      store.state.productList.length,    
                                      (index) {
                                         
                                        return GestureDetector(       
                                          onTap: (){       
                                              Navigator.push(
                                                                  context,
                                                                  SlideLeftRoute(
                                                                    page:
                                                                        ProductDetailsPage(store.state.productList[index]['id']),
                                                                  ));
                                          }, 
                                            child: Container(
                                              width: MediaQuery.of(context).size.width /2.35,
                                              // padding: EdgeInsets.all(10),
                                             // margin: EdgeInsets.only(
                                             // left: 16,
                                             // right: 16,
                                             // bottom: 20,
                                            // ),
                                              // decoration: BoxDecoration(
                                              // color: Colors.blue,
                                              //   borderRadius: BorderRadius.circular(12),
                                              // ),
                                              child: Column(
                                           crossAxisAlignment:
                                               CrossAxisAlignment.start,
                                           children: [
                                             Stack(
                                               children: [
                                                 Container(
                                                   // height: 100,
                                                   // width: 100,
                                                   width: MediaQuery.of(context)
                                                           .size
                                                           .width /
                                                       2.35,
                                                   padding: EdgeInsets.all(30),
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
                                                   child: Container(
                                                     height: 100,
                                                     width: 100,
                                                     child:store.state.productList[index]['photo'].length==0?
                                                     Image.asset(
                                                "assets/images/placeHolder.jpg",
                                                height: 100,
                                                width: 100,
                                                fit: BoxFit.cover,
                                              ):
                                              CachedNetworkImage(
                                                            imageUrl: store.state.productList[index]['photo'][0]['image'],
                                                            fit: BoxFit.cover,  
                                                            height: 100,
                                                            width: 100,
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
                                                 Positioned(
                                                   bottom: 0,
                                                   right: 0,
                                                   child: GestureDetector(
                                                     onTap: () {
                                                       // Navigator.push(
                                                       //     context,
                                                       //     ScaleRoute(
                                                       //       page: CartPage(),
                                                       //     ));
                                                      
                                                     },
                                                     child: Container(
                                                       padding: EdgeInsets.all(3),
                                                       decoration: BoxDecoration(
                                                         color: Color(0xFF0487FF),
                                                         borderRadius:
                                                             BorderRadius.all(
                                                           Radius.circular(5),
                                                         ),
                                                       ),
                                                       child: Icon(
                                                         Icons.add,
                                                         color: Colors.white,
                                                       ),
                                                     ),
                                                   ),
                                                 ),
                                                 
                                                 ///////////// stock out start ///////////////
                                                

                                                  store.state.productList[index]['stock']==0?
                                                 
                                                   Positioned(
                                                     right: 0,
                                                     child: Container(
                                                       margin: EdgeInsets.only(
                                                           top: 20),
                                                       padding: EdgeInsets.only(
                                                           top: 3,
                                                           bottom: 3,
                                                           left: 18),
                                                       width:
                                                           MediaQuery.of(context)
                                                                   .size
                                                                   .width /
                                                               4.5,
                                                       decoration: BoxDecoration(
                                                         color: Color(0xFF00B658),
                                                         borderRadius:
                                                             BorderRadius.only(
                                                           bottomLeft:
                                                               Radius.circular(5),
                                                           topLeft:
                                                               Radius.circular(5),
                                                         ),
                                                       ),
                                                       child: Text(
                                                         'Stock Out',
                                                         style: TextStyle(
                                                           fontFamily: 'poppins',
                                                           fontSize: 12,
                                                           color: Colors.white,
                                                         ),
                                                       ),
                                                     ),
                                                   ): Container(),
                                                 ///////////// stock out end ///////////////
                                                                     

                                                //////////  discount start /////////
                                                 store.state.productList[index]['stock']==0?
                                                 Container():
                                                  Positioned(
                                              right: 20,
                                              top: 8,
                                              child: 
                                              store.state.productList[index]['percentage']==null ||
                                           store.state.productList[index]['percentage']==0?
                                           Container():
                                            Container(
                                                // margin: EdgeInsets.only(left: 24),
                                                padding: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Color(0xFF00B658),
                                                ),
                                                margin: EdgeInsets.only(top: 6),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      store.state.productList[index]['percentage'].toString()+'%',
                                                      style: TextStyle(
                                                        fontFamily: 'poppins',
                                                        color: Colors.white,
                                                        fontSize: 8,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Off',
                                                      style: TextStyle(
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
                                                //////////  discount end /////////
                                               ],
                                             ),
                                             Container(
                                               // margin: EdgeInsets.only(left: 24),
                                               margin: EdgeInsets.only(top: 6),
                                               child: Text(
                                                 store.state.productList[index]['name'],
                                                 style: TextStyle(
                                                   fontFamily: 'poppins',
                                                   color: Color(0xFF263238),
                                                   fontSize: 16,
                                                   fontWeight: FontWeight.w500,
                                                 ),
                                               ),
                                             ),  
                                             store.state.productList[index]['variations'].length==0?
                                             Container():
                                             Container(    
                                               margin: EdgeInsets.only(bottom: 3),
                                               child: Text(
                                                 'From:  ৳'   +store.state.productList[index]['variations'][0]['price'].toString(),
                                                      // store.state.productList[index]['percentage'] ==null ||
                                                      // store.state.productList[index]['percentage']==0?
                                                      // 'From:  ৳'   +store.state.productList[index]['variations'][0]['price'].toString():
                                                      // 'From:  ৳'+ (store.state.productList[index]['variations'][0]['price']-
                                                      // ( (store.state.productList[index]['percentage']*(store.state.productList[index]['variations'][0]['price']))/
                                                      //           100)).toString(),
     
                                                    style: TextStyle(
                                                   fontFamily: 'poppins',
                                                   color: Color(0xFF00B658),
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
    