import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:duare/Api/api.dart';
import 'package:duare/Redux/action.dart';
import 'package:duare/Redux/state.dart';
import 'package:duare/RouteTransition/routeAnimation.dart';
import 'package:duare/Screens/CartPage/cartPage.dart';
import 'package:duare/Screens/LoginScreen/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../main.dart';

class ProductDetailsPage extends StatefulWidget {
  final id;
  ProductDetailsPage(this.id);

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  var productType;
  bool _isLoading = false;
  bool addedToCart = false;
  var _qty = 1;

  _decrement() {
    if (_qty == 1) {
      return;
    } else {
      setState(() {
        _qty--;
      });
    }
    // _handleIncDec();
  }

  _increment() {
    setState(() {
      _qty++;
    });
    // _handleIncDec();
  }

  List nameList = [];
  List priceList = [];
  List stockList = [];
  List idList = [];
  var _currentNameSelected = '';
  var _currentStockSelected = 0;
  var _currentPriceSelected = 0;
  var _currentVariationIdSelected = 0;

  void _onDropDownSizeSelected(String newValueSelected) {
   
    for (var d in store.state.productDetailsState['variations']) {
      if (d['name'] == newValueSelected) {
        if (!mounted) return;
        setState(() {
        _currentPriceSelected = d['price'];
        _currentStockSelected = d['stock'];
        _currentVariationIdSelected = d['id'];
        _currentNameSelected = newValueSelected;
        });
       
        break;
      }
    }
    // setState(() {
    //   _currentNameSelected = newValueSelected;
    //   print('_currentNameSelected ----------------------- ');
    //   print(_currentNameSelected);
    // });
  }

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

  // slide() {
  //   _timer = Timer.periodic(Duration(seconds: 2), (Timer t) {
  //     if (currentIndex >= 0 && currentIndex < 2)
  //       nextFunction();
  //     else {
  //       _pageController.jumpToPage(0);
  //     }
  //   });
  // }

  @override
  void initState() {

    _getProductDetails();

    // if (widget.data['variations'].length > 0) {
    //   for (var d in widget.data['variations']) {
    //     nameList.add(d['name']);
    //     priceList.add(d['price']);
    //     stockList.add(d['stock']);
    //     idList.add(d['id']);

    //     _currentNameSelected =  nameList[0];
    //     _currentPriceSelected = priceList[0];
    //     _currentStockSelected = stockList[0];
    //     _currentVariationIdSelected = idList[0];
    //   }
    // }

    _pageController = PageController(
      // viewportFraction: 0.75,
      initialPage: 0,
    );

    // slide();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    // _timer.cancel();
    super.dispose();
  }


  ////////////////// get Product Details start ////////////////////
  _getProductDetails() async {
    store.dispatch(ProductDetailsLoadingAction(true));
    var res =
        await CallApi().getDataWithToken('productmodule/getSingleProduct/${widget.id}');
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
      store.dispatch(ProductDetailsAction(body['data']));

      if (store.state.productDetailsState['variations'].length > 0) {
      for (var d in store.state.productDetailsState['variations']) {
        nameList.add(d['name']);
        priceList.add(d['price']);
        stockList.add(d['stock']);
        idList.add(d['id']);

        _currentNameSelected =  nameList[0];
        _currentPriceSelected = priceList[0];
        _currentStockSelected = stockList[0];
        _currentVariationIdSelected = idList[0];
      }
    }

    } else if (res.statusCode == 401) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else{
           _showMsg("Something went wrong", 1);
      }
        store.dispatch(ProductDetailsLoadingAction(false));
  }
  ////////////////// get Product Details end ////////////////////

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
              automaticallyImplyLeading: false,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
              actions: [
                if(store.state.productDetailsLoadingState==false)
                IconButton(
                  onPressed: () {
                    store.state.productDetailsState['favorite'] == null
                        ? _addFavourite()
                        : removeFavourite();
                  },
                  icon: Icon(
                    store.state.productDetailsState['favorite'] == null
                        ? FlutterIcons.heart_fea
                        : Icons.favorite,
                    color: store.state.productDetailsState['favorite'] == null
                        ? Colors.black
                        : Colors.red,
                  ),
                ),
              ],
            ),
            body: store.state.productDetailsLoadingState ?
              Center(
                child: SpinKitCircle(
                  color: Color(0xFF0487FF),
                  // size: 30,
                 ),
              ) :
            Container(
              child: Column(
                children: [
                  /////////////// product image slider start /////////////////
                  Container(
                    height: MediaQuery.of(context).size.height / 3.5,
                    padding: EdgeInsets.only(top: 20),
                    color: Colors.white,
                    child: store.state.productDetailsState['photo'].length==0?
                      Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(
                                top: 5, bottom: 10, right: 20, left: 20),
                            child:Image.asset(
                                                "assets/images/placeHolder.jpg",
                                                fit: BoxFit.contain,
                                              )
                            
                            ):
                      PageView.builder(
                      physics: BouncingScrollPhysics(),
                      controller: _pageController,
                      onPageChanged: onChangedFunction,
                      pageSnapping: false,
                      itemCount: store.state.productDetailsState['photo'].length==0?1:store.state.productDetailsState['photo'].length,
                      itemBuilder: (BuildContext ctx, int index) {
                        return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(
                                top: 5, bottom: 10, right: 20, left: 20),
                            child:
                            store.state.productDetailsState['photo'].length==0?
                           Image.asset(
                                                "assets/images/placeHolder.jpg",
                                                fit: BoxFit.contain,
                                              ):
                             CachedNetworkImage(
                              imageUrl: store.state.productDetailsState['photo'][index]['image'],
                              fit: BoxFit.contain,
                              
                              placeholder: (context, url) => Center(
                                child: SpinKitFadingCircle(
                                  color: Colors.grey,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  Center(child: new Icon(Icons.error)),
                            )

                            
                            );
                      },
                    ),
                  ),
                  /////////////// product image slider end /////////////////

                  ///////////////// indicator start ////////////////////
                  Container(
                    margin: EdgeInsets.only(top: 20, bottom: 20),
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    // color: Colors.white,
                    child: Transform.scale(
                      scale: 0.4,
                      child: store.state.productDetailsState['photo'].length==0?
                      Container():SmoothPageIndicator(
                        controller: _pageController, // PageController
                        count: store.state.productDetailsState['photo'].length==0?0:store.state.productDetailsState['photo'].length,
                        effect: ExpandingDotsEffect(
                          dotWidth: 35,
                          spacing: 10,
                          expansionFactor: 1.1,
                          dotHeight: 3,
                          activeDotColor: Color(0xFF00B658),
                          dotColor: Color(0xFFDADADA),
                        ), // your preferred effect
                      ),
                    ),
                  ),
                  ///////////////// indicator end ////////////////////

                  ///////////////// product details container start ////////////////
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(left: 16, right: 16, top: 35),
                      decoration: BoxDecoration(
                        // color: Colors.red,
                        color: Color(0xFFF5F3F3),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Container(
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      store.state.productDetailsState['name'],
                                      style: TextStyle(
                                        color: Color(0xFF263238),
                                        fontFamily: 'poppins',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 40),
                                  Text(
                                  "৳ " +_currentPriceSelected.toString(),
                                    style: TextStyle(
                                      color: Color(0xFF00B658),
                                      fontSize: 18,
                                      fontFamily: 'poppins',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.only(top: 20, bottom: 20),
                                child: Text(
                                  "${store.state.productDetailsState['description']}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'poppins',
                                    // fontSize: 18,
                                    // fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),

                              //////////// size dropdown start ///////////

                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Size',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'poppins',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                          isDense: true,
                                          icon: Icon(
                                            Icons.keyboard_arrow_down,
                                            color: Colors.black,
                                          ),
                                          value: _currentNameSelected,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                            fontFamily: 'poppins',
                                          ),
                                          items: nameList.map((var value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text("$value   "),
                                            );
                                          }).toList(),
                                          onChanged: (var newValueSelected) {
                                            _onDropDownSizeSelected(
                                                newValueSelected);
                                            print(newValueSelected);
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                              //////////// size dropdown end ////////////

                              //////////// quantity +/- start ///////////
                              Container(
                                margin: EdgeInsets.only(top: 5, bottom: 5),
                                child: Text(
                                  'QTY',
                                  style: TextStyle(
                                    color: Color(0xFF263238),
                                    fontFamily: 'poppins',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      _decrement();
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(9),
                                      decoration: BoxDecoration(
                                        color: Color(0xFF00B658),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.remove,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.only(left: 15, right: 15),
                                    child: Text(
                                      '$_qty',
                                      style: TextStyle(
                                        color: Color(0xFF263238),
                                        fontFamily: 'poppins',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _increment();
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(9),
                                      decoration: BoxDecoration(
                                        color: Color(0xFF00B658),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              //////////// quantity +/- end ////////////

                              //////////// add to basket button start ///////////
                              GestureDetector(
                                onTap: (){
                                  if(addedToCart){
                                  Navigator.pushReplacement( context,ScaleRoute(page: CartPage("Normal"),));
                                  } else{
                                   _checkingCart();
                                  //  _addToBasket();
                                  }
                                } ,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.only(top: 15, bottom: 15),
                                  margin: EdgeInsets.only(top: 50, bottom: 40),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF0487FF),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: 
                                  _isLoading ? 
                                   Container(  
                                    height: 27,
                                    child: SpinKitThreeBounce(
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ) :
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        addedToCart ?
                                        'View Your Cart' :
                                        'Add to Basket',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Icon(
                                        Icons.shopping_cart,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              //////////// add to basket button end /////////////
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  ///////////////// product details container start ////////////////
                ],
              ),
            ),
          );
        });
  }

  ////////// add favorite start //////////
  Future<void> _addFavourite() async {
    for (var d in store.state.productList) {
      if (d['id'] == store.state.productDetailsState['id']) {
        d['favorite'] = {
          "id": 0,
          "product_id": store.state.productDetailsState['id'],
          "user_id": store.state.userInfoState['id']
        };
        break;
      }
    }
    store.dispatch(ProductListAction(store.state.productList));

    var data = {
      'user_id': store.state.userInfoState['id'],
      'product_id': store.state.productDetailsState['id']
    };

    print(data);

    var res = await CallApi()
        .postDataWithToken(data, 'productmodule/storeProductFavorate');
    var body = json.decode(res.body);
    print('body - $body');

    if (res.statusCode == 200) {
      _showMsg('Added to favourite!', 2);

      for (var d in store.state.productList) {
        if (d['id'] == store.state.productDetailsState['id']) {
          d['favorite'] = {
            "id": body['data']['id'],
            "product_id": body['data']['product_id'],
            "user_id": body['data']['user_id'],
          };
          break;
        }
      }
      store.dispatch(ProductListAction(store.state.productList));

      store.state.favouriteProductList.add({
        "id": body['data']['id'],
        "product_id": body['data']['product_id'],
        "user_id": body['data']['user_id'],
        "created_at": body['data']['created_at'],
        "updated_at": body['data']['updated_at'],
        "product": store.state.productDetailsState
      });
      store.dispatch(
          FavouriteProductListAction(store.state.favouriteProductList));
    } else {
      for (var d in store.state.productList) {
        if (d['id'] == store.state.productDetailsState['id']) {
          d['favorite'] = null;
          break;
        }
      }
      store.dispatch(ProductListAction(store.state.productList));
      _showMsg("Something went wrong! Please try again", 1);
    }
  }

  ////////// add favorite end //////////

  ////////// remove favorite start //////////
  Future<void> removeFavourite() async {
    int favId = store.state.productDetailsState['favorite']['id'];
    for (var d in store.state.productList) {
      if (d['id'] == store.state.productDetailsState['id']) {
        d['favorite'] = null;
        break;
      }
    }
    store.dispatch(ProductListAction(store.state.productList));

    var data = {
      // 'user_id':store.state.userInfoState['id'],
      'id': favId
    };

    print(data);

    var res = await CallApi()
        .postDataWithToken(data, 'productmodule/deleteProductFavorate');
    var body = json.decode(res.body);
    print('body - $body');

    if (res.statusCode == 200) {
      _showMsg('Removed from favourite!', 2);

      for (var d in store.state.productList) {
        if (d['id'] == store.state.productDetailsState['id']) {
          d['favorite'] = null;
          break;
        }
      }
      store.dispatch(ProductListAction(store.state.productList));

      print('print');
      print(store.state.favouriteProductList.length);
      for (var d in store.state.favouriteProductList) {
        if (d['product_id'] == store.state.productDetailsState['id']) {
          store.state.favouriteProductList.remove(d);
          break;
        }
      }
      print('print2');
      print(store.state.favouriteProductList.length);
      store.dispatch(
          FavouriteProductListAction(store.state.favouriteProductList));
    } else {
      for (var d in store.state.productList) {
        if (d['id'] == store.state.productDetailsState['id']) {
          d['favorite'] = {
            "id": favId,
            "product_id": store.state.productDetailsState['id'],
            "user_id": store.state.userInfoState['id']
          };
          break;
        }
      }
      store.dispatch(ProductListAction(store.state.productList));
      _showMsg("Something went wrong! Please try again", 1);
    }
  }

  ////////// remove favorite end //////////
  

  
 ////////// _checkingCart start //////////
  Future<void> _checkingCart() async {
    setState(() {
      productType = store.state.whichHomeState['id']==3 ? "Food" : "General";
    });

    if(store.state.cartListState.length<=0){
      _addToBasket();
    }else{
        if (productType == store.state.cartListState[store.state.cartListState.length-1]['type']) {
        
        if(productType == "Food"){
          if(store.state.productDetailsState['partner_shop_id'] == store.state.cartListState[store.state.cartListState.length-1]['store_id']){
            _addToBasket();
          }else{
             _errorDialog("Cant't add items from two shop at a time! If you want to continue, previous cart will be reset.");
          }
        }else{
          if(store.state.whichHomeState['id'] != store.state.cartListState[store.state.cartListState.length-1]['category_id']){
            _errorDialog("This itme cant't be added! If you want to continue, previous cart will be reset.");
          }else{
            _addToBasket();
          }
          
        }
      }

      else {
         _errorDialog("This itme cant't be added! If you want to continue, previous cart will be reset.");
      }
    }
  }

  ////////// _checkingCart end //////////


  ////////// add To Basket start //////////
  Future<void> _addToBasket() async {
    setState(() {
      _isLoading = true;
    });

    var data = {
      'user_id': store.state.userInfoState['id'],
      'product_id': store.state.productDetailsState['id'],
      'variation_id': _currentVariationIdSelected,
      'category_id': store.state.productDetailsState['category_id'],
      'quantity': _qty,
      'type': store.state.whichHomeState['id']==3 ? "Food" : "General",
      'store_id': store.state.productDetailsState['partner_shop_id'],
    };

    //print(store.state.productDetailsState);
    print(data);

    var res = await CallApi().postDataWithToken(data, 'ordermodule/storeCart');
    var body = json.decode(res.body);
    print('body - $body');

    if (res.statusCode == 200) {
      _showMsg('Added to cart!', 2);
     store.dispatch(CartListAction(body['data']));
      setState(() {
        addedToCart = true;
      });
    } 
    else if (res.statusCode == 401) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
    else if (res.statusCode == 422) {
      _showMsg(body['message'], 1);
    }
     else {
      _showMsg("Something went wrong! Please try again", 1);
    }

    setState(() {
      _isLoading = false;
    });
  }
  ////////// add To Basket end //////////

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
  

   ////////////// Error Dialog STart //////////
  Future<Null> _errorDialog(title) async {
    return showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5),
                        topLeft: Radius.circular(5),
                      ),
                      border: Border.all(color: Colors.white)),
                  padding: EdgeInsets.only(top: 20),
                  child: Container(
                      width: 55,
                      height: 55,
                      margin: EdgeInsets.all(15),
                      child: Image.asset("assets/images/alarm.png")
                      ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white)),
                  padding: EdgeInsets.only(bottom: 10, top: 10, left: 10, right:10),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'quicksand',
                        color: Color(0xff003A5B),
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(top: 0, bottom: 20, left: 30, right: 30),
                  decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                              ),
                              border: Border.all(color: Colors.white)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                            width: 100,
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(10),
                           // margin: EdgeInsets.only(top: 0, bottom: 20, left: 30, right: 30),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.black)
                            ),
                            child: Text("Cancel",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "quicksand"))),
                      ),


                      GestureDetector(
                        onTap: () {
                          _addToBasket();
                          Navigator.pop(context);
                        },
                        child: Container(
                            width: 100,
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(10),
                           // margin: EdgeInsets.only(top: 0, bottom: 20, left: 30, right: 30),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text("Continue",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "quicksand"))),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
   ////////////// Errort Dialog End //////////
}
