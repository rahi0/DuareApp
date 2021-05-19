import 'package:duare/RouteTransition/routeAnimation.dart';
import 'package:duare/Screens/CodeVerificationScreen/codeVerificationScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();

  bool obscure = true;

  _handleChangePassword() {
    if (oldPasswordController.text.isEmpty) {
      // return _showMsg('Phone number can\'t be empty!', 1);
    }
    if (newPasswordController.text.isEmpty) {
      // return _showMsg('Password can\'t be empty!', 1);
    }

    Navigator.pushReplacement(
        context, SlideLeftRoute(page: CodeVerificationScreen()));
  }

  @override
  Widget build(BuildContext context) {
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
          'Change Password',
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
          margin: EdgeInsets.only(left: 16, right: 16, top: 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //////////////// old password start ///////////////////
              Text(
                'Old Password',
                style: TextStyle(
                  fontFamily: 'poppins',
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),

              Container(
                margin: EdgeInsets.only(bottom: 35, top: 15),
                decoration: BoxDecoration(
                  // color: Color(0xFFF0EFEF),
                  border: Border.all(
                    color: Color(0xFFDADADA),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                  controller: oldPasswordController,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  style: TextStyle(
                    color: Color(0xffB1B1B1),
                    fontFamily: 'poppins',
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: Color(0xFF9098B1),
                    ),

                    // hintText: "Type here....",
                    // hintStyle: TextStyle(
                    //   // fontSize: 13,
                    //   color: Color(0xffB1B1B1),
                    //   fontFamily: 'poppins',
                    // ),
                    contentPadding:
                        EdgeInsets.only(left: 18, top: 15, bottom: 14),
                    border: InputBorder.none,
                  ),
                ),
              ),
              //////////////// old password end ///////////////////

              //////////////// new password start ///////////////////
              Text(
                'New Password',
                style: TextStyle(
                  fontFamily: 'poppins',
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 35, top: 15),
                decoration: BoxDecoration(
                  // color: Color(0xFFF0EFEF),
                  border: Border.all(
                    color: Color(0xFFDADADA),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                  controller: newPasswordController,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  style: TextStyle(
                    color: Color(0xffB1B1B1),
                    fontFamily: 'poppins',
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: Color(0xFF9098B1),
                    ),
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
                        size: 20,
                      ),
                    ),
                    // hintText: "Type here....",
                    // hintStyle: TextStyle(
                    //   // fontSize: 13,
                    //   color: Color(0xffB1B1B1),
                    //   fontFamily: 'poppins',
                    // ),
                    contentPadding:
                        EdgeInsets.only(left: 18, top: 15, bottom: 14),
                    border: InputBorder.none,
                  ),
                ),
              ),
              //////////////// new password end ///////////////////

              ////////////////////// next button start //////////////////////
              GestureDetector(
                onTap: () {
                  _handleChangePassword();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  margin: EdgeInsets.only(top: 10, bottom: 20),
                  decoration: BoxDecoration(
                    color: Color(0xFF0487FF),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    'Next',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              ////////////////////// next button end //////////////////////
            ],
          ),
        ),
      ),
    );
  }
}
