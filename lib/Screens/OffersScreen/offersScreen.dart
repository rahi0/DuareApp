import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:duare/Api/api.dart';
import 'package:duare/Redux/action.dart';
import 'package:duare/Redux/state.dart';
import 'package:duare/RouteTransition/routeAnimation.dart';
import 'package:duare/Screens/LoginScreen/loginScreen.dart';
import 'package:duare/Screens/ProductDetailsPage/productDetailsPage.dart';
import 'package:duare/main.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class OffersScreen extends StatefulWidget {
  @override
  _OffersScreenState createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  @override

   void initState() {
   _showOffer();
  
    super.initState();
  }

    Future<void> _pull() async {
   _showOffer();
  }

     Future<void> _showOffer() async {
    var res = await CallApi()
        .getDataWithToken('productmodule/getAllOfferProducts');
 
    if (res.statusCode == 200) {
      var body = json.decode(res.body);
        print(body);
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
      store.dispatch(OfferProductListAction(body['data']));
    }
    else if (res.statusCode == 401) {
      
      _showMsg("Login Expired!", 1);
       Navigator.push( context, SlideLeftRoute(page: LoginScreen()));
    }
    else{

         _showMsg("Something went wrong", 1);

    }
   store.dispatch(OfferProductLoadingAction(false));
  }
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        ////// this is the connector which mainly changes state/ui
        converter: (store) => store.state,
        builder: (context, items) { 
          return  Scaffold(
        backgroundColor: Color(0xFFF9F9F9),
        body: RefreshIndicator(
                    onRefresh: _pull,
                  child: SingleChildScrollView(
             physics:AlwaysScrollableScrollPhysics(),
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
                              'My Offers',
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

                    store.state.offerProductLoading?
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
                                  'Please wait to see offers....',
                                 
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
                    margin: EdgeInsets.only(
                      // left: 16,
                      // right: 16,
                      top: 35,
                    ),
                    child: Wrap(
                      spacing: 20.0,
                      runSpacing: 13,
                      children: List.generate(
                       store.state.offerProductList.length,
                        (index) {
                          return InkWell(
                            onTap: (){
                                 Navigator.push(
                                   context,
                                   SlideLeftRoute(page:
                                   ProductDetailsPage(store.state.offerProductList[index]['id'])));

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
                                                     child:store.state.offerProductList[index]['photo'].length==0?
                                                     Image.asset(
                                                "assets/images/placeHolder.jpg",
                                                fit: BoxFit.contain,
                                                 height: 100,
                                                width: 100,
                                              ):
                                              CachedNetworkImage(
                                                            imageUrl: store.state.offerProductList[index]['photo'][0]['image'],
                                                            fit: BoxFit.cover,
                                                             height: 100,
                                                              width: 100,
                                                          //      colorBlendMode: BlendMode.luminosity,
                                                          //  color: Color.fromRGBO(0, 0, 0, 0.2),
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
                                                

                                                  store.state.offerProductList[index]['stock']==0?
                                                
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
                                                   ):Container(),
                                                 ///////////// stock out end ///////////////
                                                

                                                //////////  discount start /////////
                                                 store.state.offerProductList[index]['stock']==0?
                                                 Container():
                                                  Positioned(
                                              right: 20,
                                              top: 8,
                                              child: 
                                              store.state.offerProductList[index]['percentage']==null ||
                                           store.state.offerProductList[index]['percentage']==0?
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
                                                      store.state.offerProductList[index]['percentage'].toString()+'%',
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
                                                 store.state.offerProductList[index]['name']==null?"":
                                                  store.state.offerProductList[index]['name'],
                                                 style: TextStyle(
                                                   fontFamily: 'poppins',
                                                   color: Color(0xFF263238),
                                                   fontSize: 16,
                                                   fontWeight: FontWeight.w500,
                                                 ),
                                               ),
                                             ),
                                             store.state.offerProductList[index]['variations'].length==0?
                                             Container():
                                             Container(
                                               margin: EdgeInsets.only(bottom: 3),
                                               child: Text(
                                                 store.state.offerProductList[index]['percentage'] ==null ||
                                                      store.state.offerProductList[index]['percentage']==0?
                                                      'From:  ৳'+store.state.offerProductList[index]['variations'][0]['price'].toString():
                                                      'From:  ৳'+ (store.state.offerProductList[index]['variations'][0]['price']-
                                                      ( (store.state.offerProductList[index]['percentage']*(store.state.offerProductList[index]['variations'][0]['price']))/
                                                                100)).toString(),
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
