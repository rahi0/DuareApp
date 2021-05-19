import 'dart:convert';

import 'package:duare/Api/api.dart';
import 'package:duare/Redux/state.dart';
import 'package:duare/RouteTransition/routeAnimation.dart';
import 'package:duare/Screens/CategorySelectionScreen/categorySelectionScreen.dart';
import 'package:duare/Screens/LoginScreen/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RequestProductScreen extends StatefulWidget {
  @override
  _RequestProductScreenState createState() => _RequestProductScreenState();
}

class _RequestProductScreenState extends State<RequestProductScreen> {


  TextEditingController productNameController = TextEditingController();

  bool _isLoading = false;

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
          centerTitle: true,
          title: Text(
            'Request a Product',
            style: TextStyle(
              fontFamily: 'poppins',
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            margin: EdgeInsets.only(right: 16, left: 16, top: 20, bottom: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Request Product',
                  style: TextStyle(
                    fontFamily: 'poppins',
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                ////////////// text field start //////////////
                Container(
                  margin: EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    // color: Color(0xFFF0EFEF),
                    border: Border.all(
                      color: Color(0xFFDADADA),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    maxLines: null,
                    minLines: 3,
                    controller: productNameController,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'poppins',
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      hintText: "Product name, Company.....",
                      hintStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: Color(0xffB1B1B1),
                        fontFamily: 'poppins',
                      ),
                      contentPadding:
                          EdgeInsets.only(left: 18, top: 12, bottom: 11),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                ////////////// text field start //////////////

                //////////// Send button start ///////////
                GestureDetector(
                  onTap: () {
                     _isLoading ? null : _sendProductName();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(top: 15, bottom: 15),
                    margin: EdgeInsets.only(top: 40, bottom: 25),
                    decoration: BoxDecoration(
                      color: Color(0xFF0487FF),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child:  _isLoading
                        ? Container(  
                            height: 27,
                            child: SpinKitThreeBounce(
                              color: Colors.white,
                              size: 30,
                            ),
                          )
                        :Text(
                      'Send',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                //////////// Send button end /////////////
              ],
            ),
          ),
        ),
      );
        }
        );
  }

  
  Future<void> _sendProductName() async {
    if (productNameController.text.isEmpty) {
      return _showMsg('Product name can\'t be empty!', 1);
    }
    else{

if (!mounted) return;
 setState(() {
      _isLoading = true;
    });

    var data = {
     
     'text':productNameController.text
    };
  
    print(data);

    var res = await CallApi().postDataWithToken(data, 'productmodule/requestAProduct');
    var body = json.decode(res.body);
    print('body - $body');
    print('res.statusCode  - ${res.statusCode}');

    if (res.statusCode == 200) {
      _showMsg('Product name send successfully!', 2);
    Navigator.of(context).pop(); 
    } 
     else if (res.statusCode == 422) {
      _showMsg('Login Expired!', 2);
      Navigator.push( context, SlideLeftRoute(page: LoginScreen()));
   
    }
    else {

      _showMsg("Something went wrong!! Please Try Again", 1);
     
    }

    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
    }

   
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
