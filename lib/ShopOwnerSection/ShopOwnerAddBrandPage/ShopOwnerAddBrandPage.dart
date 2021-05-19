import 'dart:convert';

import 'package:duare/Api/api.dart';
import 'package:duare/RouteTransition/routeAnimation.dart';
import 'package:duare/Screens/LoginScreen/loginScreen.dart';
import 'package:duare/ShopOwnerSection/ShopOwnerDrawer/ShopOwnerDrawer.dart';
import 'package:duare/ShopOwnerSection/ShopOwnerHomepage/ShopOwnerHomepage.dart';
import 'package:duare/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ShopOwnerAddBrandPage extends StatefulWidget {
  @override
  _ShopOwnerAddBrandPageState createState() => _ShopOwnerAddBrandPageState();
}

class _ShopOwnerAddBrandPageState extends State<ShopOwnerAddBrandPage> {
  TextEditingController brandNameController = TextEditingController();

  bool _isLoading = false;

  ////////////////// add product method start ////////////////////////
  _addBrand() async {
    if (brandNameController.text.isEmpty) {
      return _showMsg('Brand name can\'t be empty!', 1);
    }

    setState(() {
      _isLoading = true;
    });

    var data = {
      'name': brandNameController.text,
    };

    print('----------------------data---------------------');
    print(data);
    print('----------------------data---------------------');

    var res =
        await CallApi().postDataWithToken(data, 'shopownermodule/addBrands');
    print('res - $res');
    var body = json.decode(res.body);
    print('body - $body');
    print('res.statusCode  - ${res.statusCode}');

    if (res.statusCode == 200) {
      _showMsg('Product added successfully!', 2);

      Navigator.pushReplacement(context, FadeRoute(page: ShopOwnerHomepage()));
    } else if (res.statusCode == 401) {
      _showMsg("Login expired!", 1);
      Navigator.push(context, SlideLeftRoute(page: LoginScreen()));
    } else {
      _showMsg('Something went wrong!', 1);
    }

    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
  }
  ////////////////// add brand method end ////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: ShopOwnerDrawer(),
      appBar: AppBar(
        backgroundColor: appColor,
        title: Text(
          'Add Brand',
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
          child: Container(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10, top: 15),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xFFDADADA),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextField(
                    controller: brandNameController,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'poppins',
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Brand Name',
                      contentPadding:
                          EdgeInsets.only(left: 18, top: 15, bottom: 14),
                      border: InputBorder.none,
                    ),
                  ),
                ),

                ////////////////////// Continue button start //////////////////////
                GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    _isLoading ? null : _addBrand();
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
                            'Add Brand',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
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
