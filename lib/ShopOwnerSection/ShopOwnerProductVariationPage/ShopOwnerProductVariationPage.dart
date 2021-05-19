import 'dart:convert';

import 'package:duare/Api/api.dart';
import 'package:duare/Redux/action.dart';
import 'package:duare/Redux/state.dart';
import 'package:duare/RouteTransition/routeAnimation.dart';
import 'package:duare/Screens/LoginScreen/loginScreen.dart';
import 'package:duare/ShopOwnerSection/ShopOwnerAddProductVariationPage/ShopOwnerAddProductVariationPage.dart';
import 'package:duare/ShopOwnerSection/ShopOwnerEditProductVariationPage/ShopOwnerEditProductVariationPage.dart';
import 'package:duare/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ShopOwnerProductVariationPage extends StatefulWidget {
  var productId;

  ShopOwnerProductVariationPage(this.productId);

  @override
  _ShopOwnerProductVariationPageState createState() =>
      _ShopOwnerProductVariationPageState();
}

class _ShopOwnerProductVariationPageState
    extends State<ShopOwnerProductVariationPage> {
  ///////////////// get Product variations start /////////////////
  _getProductVariations() async {
    // store.dispatch(SoVariationLoadingAction(true));

    var res = await CallApi().getDataWithTokenandQuery(
        'shopownermodule/getProductVariations',
        '&product_id=${widget.productId}');

    print('res - $res');
    var body = json.decode(res.body);
    print('body - $body');
    print('.....................');

    if (res.statusCode == 200) {
      var productVariations = body['data']['variations'];
      print('productVariations -- $productVariations');

      store.dispatch(SoVariationAction(productVariations));
    } else if (res.statusCode == 401) {
      _showMsg("Login expired!", 1);
      Navigator.push(context, SlideLeftRoute(page: LoginScreen()));
    } else {
      _showMsg("Something went wrong", 1);
    }

    store.dispatch(SoVariationLoadingAction(false));
  }
  ///////////////// get Product variations end /////////////////

  ///
  Future<void> _onRefresh() async {
    _getProductVariations();
  }

  @override
  void initState() {
    _getProductVariations();
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
          appBar: AppBar(
            backgroundColor: appColor,
            title: Text(
              'Product Variations',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontFamily: 'poppins',
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    ScaleRoute(
                        page:
                            ShopOwnerAddProductVariationPage(widget.productId)),
                  );
                },
                child: Container(
                  margin:
                      EdgeInsets.only(right: 10, left: 10, top: 0, bottom: 5),
                  child: Icon(
                    Icons.add_circle_outline,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Container(
                margin:
                    EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                child: store.state.soVariationLoadingState
                    ?
                    //////////////////// progress inidcator start //////////////////////
                    Center(
                        child: Container(
                          child: SpinKitCircle(
                            color: Color(0xFF0487FF),
                          ),
                        ),
                      )
                    ////////////////////// progress inidcator end //////////////////////
                    : store.state.soVariationState.length == 0
                        ?
                        ////////////////////// no product Variations text container start //////////////////////
                        Center(
                            child: Container(
                              child: Text(
                                'No Product Variations Found',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  fontFamily: 'poppins',
                                ),
                              ),
                            ),
                          )
                        ////////////////////// no product Variations text container end //////////////////////
                        : Column(
                            children: [
                              //////////////////////// product variations list start ////////////////////////
                              Column(
                                children: List.generate(
                                  store.state.soVariationState.length,
                                  (index) {
                                    return Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin:
                                                    EdgeInsets.only(bottom: 5),
                                                child: Text(
                                                  // '1kg',
                                                  '${store.state.soVariationState[index]['name']}',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontFamily: 'poppins',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: '${store.state.soVariationState[index]['stock']}' ==
                                                              '0'
                                                          ? ''
                                                          : '${store.state.soVariationState[index]['stock']} ',
                                                      style: TextStyle(
                                                        fontFamily: 'poppins',
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          '${store.state.soVariationState[index]['stock']}' ==
                                                                  '0'
                                                              ? 'Out of Stock'
                                                              : ' In Stock',
                                                      style: TextStyle(
                                                        fontFamily: 'poppins',
                                                        color:
                                                            '${store.state.soVariationState[index]['stock']}' ==
                                                                    '0'
                                                                ? Colors.red
                                                                : Colors.green,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                'Buy: ৳${store.state.soVariationState[index]['purchase_price']}  Sell: ৳${store.state.soVariationState[index]['price']}',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Divider(),
                                            ],
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              print('edit');
                                              Navigator.push(
                                                context,
                                                ScaleRoute(
                                                    page: ShopOwnerEditProductVariationPage(
                                                        store.state
                                                                .soVariationState[
                                                            index])),
                                              );
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(5),
                                              child: Icon(Icons.edit),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              //////////////////////// product variations list end ////////////////////////
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
