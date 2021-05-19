import 'dart:convert';
import 'dart:io';
import 'package:duare/Api/api.dart';
import 'package:duare/DriverSection/DriverHomePage/DriverHomePage.dart';
import 'package:duare/Redux/action.dart';
import 'package:duare/RouteTransition/routeAnimation.dart';
import 'package:duare/Screens/CategorySelectionScreen/categorySelectionScreen.dart';
import 'package:duare/Screens/GetStartedScreen/getStartedScreen.dart';
import 'package:duare/ShopOwnerSection/ShopOwnerHomepage/ShopOwnerHomepage.dart';
import 'package:duare/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool obscure = true;
  bool _isLoading = false;

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            //   title: new Text('Are you sure?'),
            content: new Text('Are you sure you want to exit this app?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text(
                  'No',
                  // style: TextStyle(color: appColor),
                ),
              ),
              new FlatButton(
                onPressed: () => exit(0),
                child: new Text(
                  'Yes',
                  // style: TextStyle(color: appColor),
                ),
              ),
            ],
          ),
        )) ??
        false;
  }

  Future<void> _handleLogin() async {
    if (phoneController.text.isEmpty) {
      return _showMsg('Phone number can\'t be empty!', 1);
    }
    if (passwordController.text.isEmpty) {
      return _showMsg('Password can\'t be empty!', 1);
    }

    setState(() {
      _isLoading = true;
    });

    var data = {
      'phone': phoneController.text,
      'password': passwordController.text,
    };

    // print('----------------------data---------------------');
    // print(data);
    // print('----------------------data---------------------');

    var res = await CallApi().postData(data, 'usermodule/login');
    // print('res - $res');
    var body = json.decode(res.body);
    print('body - $body');
    // print('res.statusCode  - ${res.statusCode}');

    if (res.statusCode == 200) {
      _showMsg('You have logged in successfully!', 2);

      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', body['token']);
      localStorage.setString('userData', json.encode(body['user']));

      store.state.userInfoState = body['user'];
      store.dispatch(UserInfoAction(store.state.userInfoState));

      store.state.userInfoState["userType"] == "Driver" ?
      Navigator.pushReplacement(context, SlideLeftRoute(page: DriverHomepage())) :
      store.state.userInfoState["userType"] == "ShopOwner" ?
      Navigator.pushReplacement(context, SlideLeftRoute(page: ShopOwnerHomepage())) :
      Navigator.pushReplacement(context, SlideLeftRoute(page: CategorySelectionScreen()));
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
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar:
            ////////////////////// sign up option button start //////////////////////
            Container(
          padding: EdgeInsets.only(bottom: 20.0, left: 25),
          child: Row(
            children: [
              Text(
                'Don\'t have an account? ',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'poppins',
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GetStartedScreen()),
                  );
                },
                child: Container(
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Color(0xFF0487FF),
                      fontWeight: FontWeight.w700,
                      fontFamily: 'poppins',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        ////////////////////// sign up option button end //////////////////////

        body: SingleChildScrollView(
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
                    "Log In",
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
                ////////////////////// password text field end //////////////////////

                ////////////////////// forgot password ? reset option button start //////////////////////
                Container(
                  padding: EdgeInsets.only(bottom: 20.0, top: 17),
                  child: Row(
                    children: [
                      Text(
                        'Forgot password? ',
                        style: TextStyle(
                          color: Color(0xFF263238),
                          fontWeight: FontWeight.w600,
                          fontFamily: 'poppins',
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigator.pushReplacement(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => RegisterScreen()),
                          // );
                        },
                        child: Container(
                          child: Text(
                            'Reset',
                            style: TextStyle(
                              color: Color(0xFF0487FF),
                              fontWeight: FontWeight.w700,
                              fontFamily: 'poppins',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ////////////////////// forgot password ? reset option button end //////////////////////

                SizedBox(height: 40),
                ////////////////////// sign in button start //////////////////////
                GestureDetector(
                  onTap: () {
                    _isLoading ? null : _handleLogin();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(top: 12, bottom: 11),
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
                            // _isLoading ? 'Please Wait...' :
                            'Log In',
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
                ////////////////////// sign in button end //////////////////////
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
