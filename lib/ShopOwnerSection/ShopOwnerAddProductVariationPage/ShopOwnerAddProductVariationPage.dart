import 'dart:convert';
import 'dart:io';

import 'package:duare/Api/api.dart';
import 'package:duare/Redux/action.dart';
import 'package:duare/Redux/state.dart';
import 'package:duare/RouteTransition/routeAnimation.dart';
import 'package:duare/Screens/LoginScreen/loginScreen.dart';
import 'package:duare/ShopOwnerSection/ShopOwnerDrawer/ShopOwnerDrawer.dart';
import 'package:duare/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ShopOwnerAddProductVariationPage extends StatefulWidget {
  var productId;

  ShopOwnerAddProductVariationPage(this.productId);

  @override
  _ShopOwnerAddProductVariationPageState createState() =>
      _ShopOwnerAddProductVariationPageState();
}

class _ShopOwnerAddProductVariationPageState
    extends State<ShopOwnerAddProductVariationPage> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController productBoughtPriceController = TextEditingController();
  TextEditingController productSalePriceController = TextEditingController();
  TextEditingController productStockController = TextEditingController();

  bool _isLoading = false;

  //////////////////////// add variation start /////////////////////////////
  _addVariation() async {
    if (productNameController.text.isEmpty) {
      return _showMsg('Variation name can\'t be empty!', 1);
    }
    if (productBoughtPriceController.text.isEmpty) {
      return _showMsg('Purchase price can\'t be empty!', 1);
    }
    if (productSalePriceController.text.isEmpty) {
      return _showMsg('Sale price can\'t be empty!', 1);
    }
    if (productStockController.text.isEmpty) {
      return _showMsg('Stock can\'t be empty!', 1);
    }

    setState(() {
      _isLoading = true;
    });

    var data = {
      'name': productNameController.text,
      'product_id': widget.productId,
      'price': productSalePriceController.text,
      'purchase_price': productBoughtPriceController.text,
      'stock': productStockController.text,
    };

    print('----------------------data---------------------');
    print(data);
    print('----------------------data---------------------');

    var res = await CallApi()
        .postDataWithToken(data, 'shopownermodule/addProductVariation');
    print('res - $res');
    var body = json.decode(res.body);
    print('body - $body');
    print('res.statusCode  - ${res.statusCode}');

    if (res.statusCode == 200) {
      _showMsg('Product variation added successfully!', 2);

      store.state.soVariationState.add(body['data']);
      store.dispatch(SoVariationAction(store.state.soVariationState));

      Navigator.pop(context);
    } else if (res.statusCode == 401) {
      _showMsg("Login expired!", 1);
      Navigator.push(context, SlideLeftRoute(page: LoginScreen()));
    } else {
      // _showMsg(body['message'], 1);
      _showMsg('Something went wrong!', 1);
    }

    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
  }
  //////////////////////// add variation end /////////////////////////////

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      ////// this is the connector which mainly changes state/ui
      converter: (store) => store.state,
      builder: (context, items) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: appColor,
            title: Text(
              'Add Product Variation',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontFamily: 'poppins',
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(
                left: 10,
                right: 10,
                top: 20,
                bottom: 20,
              ),
              child: Column(
                children: [
                  //////////////// product name start ///////////////////
                  buildTextFieldContainer("Variation Name", TextInputType.text,
                      productNameController),
                  //////////////// product name end ///////////////////

                  //////////////// product Buy Price start ///////////////////
                  buildTextFieldContainer(
                      "Purchase Price",
                      TextInputType.numberWithOptions(),
                      productBoughtPriceController),
                  //////////////// product Buy Price end ///////////////////

                  //////////////// product Sale start ///////////////////
                  buildTextFieldContainer(
                      "Sale Price",
                      TextInputType.numberWithOptions(),
                      productSalePriceController),
                  //////////////// product Sale Price end ///////////////////

                  //////////////// product Discount Percentage start ///////////////////
                  buildTextFieldContainer(
                      "Stock",
                      TextInputType.numberWithOptions(),
                      productStockController),
                  //////////////// product Discount Percentage  end ///////////////////

                  ////////////////////// Continue button start //////////////////////
                  GestureDetector(
                    onTap: () {
                      _isLoading ? null : _addVariation();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(top: 15, bottom: 15),
                      margin: EdgeInsets.only(top: 20, bottom: 20),
                      decoration: BoxDecoration(
                        color: Color(0xFF0487FF),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: _isLoading
                          ? Container(
                              height: 27,
                              child: SpinKitThreeBounce(
                                color: Colors.white,
                                size: 30,
                              ),
                            )
                          : Text(
                              'Add',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  ////////////////////// Continue button end //////////////////////
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Container buildTextFieldContainer(
      var label, var textInputTyp, var controller) {
    return Container(
      margin: EdgeInsets.only(bottom: 10, top: 15),
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0xFFDADADA),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextField(
        controller: controller,
        keyboardType: textInputTyp,
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'poppins',
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: label,
          contentPadding: EdgeInsets.only(left: 18, top: 15, bottom: 14),
          border: InputBorder.none,
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
