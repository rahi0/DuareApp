import 'dart:convert';

import 'package:duare/Api/api.dart';
import 'package:duare/RouteTransition/routeAnimation.dart';
import 'package:flutter/material.dart';
import 'package:duare/Screens/LoginScreen/loginScreen.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
class RegisterScreen extends StatefulWidget {

  final country;
  final city;
  
  RegisterScreen(this.country, this.city);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool obscure = true;
  bool _isLoading = false;


          // Future<bool> _onWillPop() async {
          //     Navigator.of(context).pop();
          // }
  Future<void> _handleSignUp() async {
    if (nameController.text.isEmpty) {
      return _showMsg('Name can\'t be empty!', 1);
    }
    if (phoneController.text.isEmpty) {
      return _showMsg('Phone number can\'t be empty!', 1);
    }
    if (passwordController.text.isEmpty) {
      return _showMsg('Password can\'t be empty!', 1);
    }

    var data = {
      'name': nameController.text,
      'phone': phoneController.text,
      'password': passwordController.text,
      //'countryCode': '+88',
      'userType': 'General',
      // 'country': store.state.countryCityState['country'],
      'country': widget.country,
      //  == null ? 'Bangladesh' : store.state.countryCityState['country'],
      // 'state': store.state.countryCityState['city'],
      'city': widget.city,
      //'address': "Sylhet, Bangladesh",
    };

    print('data -- $data');

    setState(() {
      _isLoading = true;
    });

    var res = await CallApi().postData(data, 'usermodule/createUser');
    print('res - $res');
    var body = json.decode(res.body);
    print('body - $body');
    print('res.statusCode  - ${res.statusCode}');

    if (res.statusCode == 200) {
      _showMsg("Registration successful",2);
      Navigator.pushReplacement(context, SlideLeftRoute(page: LoginScreen()));
    } else {
      _showMsg(body['message'], 1);
    }  

    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        // backgroundColor: Color(0xFFF7F8FB),
        backgroundColor: Colors.white,
        bottomNavigationBar:
      ////////////////////// sign in option button start //////////////////////
      Container(
    // alignment: Alignment.bottomLeft,
    padding: EdgeInsets.only(bottom: 20.0, left: 25),
    child: Row(
      children: [
        Text(
          'Have an account? ',
          style: TextStyle(
            color: Color(0xFF263238),
            fontWeight: FontWeight.w700,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
          child: Container(
            child: Text(
              'Log In',
              style: TextStyle(
                color: Color(0xFF0487FF),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    ),
        ),
        ////////////////////// sign in option button end //////////////////////

        body: SafeArea(
    child: SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          children: [
            ////////////////////// instruction text start //////////////////////
            Container(
              margin:
                  EdgeInsets.only(top: 55, bottom: 20, left: 5, right: 5),
              child: Text(
                "Sign Up",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'poppins',
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF263238),
                ),
              ),
            ),
            ////////////////////// instruction text end //////////////////////

            ////////////////////// Full Name text field start //////////////////////
            _buildInputContainer(
              'Full Name',
              'Full Name',
              nameController,
              TextInputType.text,
            ),
            SizedBox(height: 40),
            ////////////////////// Full Name text field end //////////////////////

            ////////////////////// Phone text field start //////////////////////
            _buildInputContainer(
              'Phone',
              'Phone',
              phoneController,
              TextInputType.phone,
            ),
            SizedBox(height: 40),
            ////////////////////// phone text field end //////////////////////

            ////////////////////// password text field start //////////////////////
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                'Password',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'poppins',
                  color: Color(0xFF979797),
                ),
              ),
            ),
            // SizedBox(height: 5),
            Container(
              margin: EdgeInsets.only(bottom: 5),
              child: TextField(
                controller: passwordController,
                obscureText: obscure,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'poppins',
                ),
                decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        obscure = !obscure;
                      });
                    },
                    child: Icon(
                      obscure
                          ? FlutterIcons.eye_off_fea
                          : FlutterIcons.eye_fea,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                  isDense: true,
                  contentPadding: EdgeInsets.only(bottom: 5, top: 3),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: Color(0xFF777777),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            ////////////////////// password text field end //////////////////////

            ////////////////////// sign up button start //////////////////////
            GestureDetector(
              onTap: () {
                _isLoading ? null : _handleSignUp();
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 12, bottom: 12),
                margin: EdgeInsets.only(top: 10, bottom: 20),
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
                        'Sign Up',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'poppins',
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            ////////////////////// sign up button end //////////////////////
          ],
        ),
      ),
    ),
        ),
      );
  }

  Container _buildInputContainer(
    var label,
    var hintText,
    TextEditingController controller,
    TextInputType keyboardType,
  ) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'poppins',
              fontWeight: FontWeight.w500,
              color: Color(0xFF979797),
            ),
          ),
          // SizedBox(height: 5),
          Container(
            margin: EdgeInsets.only(bottom: 5),
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                fontFamily: 'poppins',
              ),
              decoration: InputDecoration(
                // hintText: "Email address",
                // hintText: hintText,
                // hintStyle: TextStyle(
                //   color: Color.fromRGBO(45, 45, 45, 0.35),
                //   fontSize: 16,
                //   fontWeight: FontWeight.w500,
                //   fontFamily: 'poppins',
                // ),
                isDense: true,
                contentPadding: EdgeInsets.only(bottom: 5, top: 3),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                    color: Color(0xFF777777),
                  ),
                ),
              ),
            ),
          ),
        ],
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
