import 'dart:convert';
import 'dart:io';

import 'package:duare/Api/api.dart';
import 'package:duare/Redux/action.dart';
import 'package:duare/RouteTransition/routeAnimation.dart';
import 'package:duare/Screens/LoginScreen/loginScreen.dart';
import 'package:duare/ShopOwnerSection/ShopOwnerDrawer/ShopOwnerDrawer.dart';
import 'package:duare/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ShopOwnerEditProductVariationPage extends StatefulWidget {
  var variationData;

  ShopOwnerEditProductVariationPage(this.variationData);

  @override
  _ShopOwnerEditProductVariationPageState createState() =>
      _ShopOwnerEditProductVariationPageState();
}

class _ShopOwnerEditProductVariationPageState
    extends State<ShopOwnerEditProductVariationPage> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController productBoughtPriceController = TextEditingController();
  TextEditingController productSalePriceController = TextEditingController();
  TextEditingController productStockController = TextEditingController();

  bool _isLoading = false;

  //////////////////////// edit variation start /////////////////////////////
  _editVariation() async {
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
      'variation_id': widget.variationData['id'],
      'product_id': widget.variationData['product_id'],
      'price': productSalePriceController.text,
      'purchase_price': productBoughtPriceController.text,
      'stock': productStockController.text,
    };

    print('----------------------data---------------------');
    print(data);
    print('----------------------data---------------------');

    var res = await CallApi()
        .postDataWithToken(data, 'shopownermodule/editProductVariation');
    print('res - $res');
    var body = json.decode(res.body);
    print('body - $body');
    print('res.statusCode  - ${res.statusCode}');

    if (res.statusCode == 200) {
      _showMsg('Product variation updated successfully!', 2);
      Navigator.pop(context);

      for (int i = 0; i < store.state.soVariationState.length; i++) {
        if (store.state.soVariationState[i]['id'] ==
            widget.variationData['id']) {
          store.state.soVariationState[i] = body['data'];
          break;
        }
      }

      store.dispatch(SoVariationAction(store.state.soVariationState));
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
  //////////////////////// edit variation end /////////////////////////////

  @override
  void initState() {
    productNameController.text = '${widget.variationData['name']}';
    productBoughtPriceController.text =
        '${widget.variationData['purchase_price']}';
    productSalePriceController.text = '${widget.variationData['price']}';
    productStockController.text = '${widget.variationData['stock']}';

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor,
        title: Text(
          'Edit Product Variation',
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
              buildTextFieldContainer(
                  "Variation Name", TextInputType.text, productNameController),
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
              buildTextFieldContainer("Stock",
                  TextInputType.numberWithOptions(), productStockController),
              //////////////// product Discount Percentage  end ///////////////////

              ////////////////////// Continue button start //////////////////////
              GestureDetector(
                onTap: () {
                  _isLoading ? null : _editVariation();
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
                          'Update',
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
