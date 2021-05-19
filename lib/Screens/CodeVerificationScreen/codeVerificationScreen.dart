import 'dart:async';

import 'package:duare/RouteTransition/routeAnimation.dart';
import 'package:duare/Screens/LoginScreen/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class CodeVerificationScreen extends StatefulWidget {
  @override
  _CodeVerificationScreenState createState() => _CodeVerificationScreenState();
}

class _CodeVerificationScreenState extends State<CodeVerificationScreen> {
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType> errorController;
  var currentText;
  bool _isCompleted = false;

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
          'Verify',
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
          margin: EdgeInsets.only(top: 25, left: 16, right: 16),
          child: Column(
            children: [
              Text(
                'Enter the verification code',
                style: TextStyle(
                  fontFamily: 'poppins',
                  color: Color(0xFF263238),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 42),
                child: Text(
                  'We just send you a verification code via phone +65 556 798 241',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'poppins',
                    color: Color(0xFF333436).withOpacity(0.5),
                    fontSize: 14,
                    // fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              ///////////////// pin code field start //////////////////
              PinCodeTextField(
                appContext: context,
                length: 4,
                obscureText: false,
                animationType: AnimationType.fade,
                keyboardType: TextInputType.number,
                textStyle: TextStyle(
                  fontSize: 22,
                  // fontWeight: FontWeight.bold,
                  fontFamily: 'poppins',
                ),
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(10),
                  borderWidth: 1,
                  fieldHeight: 51,
                  // fieldWidth: 88,
                  fieldWidth: MediaQuery.of(context).size.width / 4.75,
                  activeFillColor: Colors.white,
                  inactiveFillColor: Colors.white,
                  selectedFillColor: Colors.white,
                  selectedColor: Color.fromRGBO(45, 45, 45, 0.1),
                  inactiveColor: Color.fromRGBO(45, 45, 45, 0.1),
                  // activeColor: Color(0xFF0101D3),
                  activeColor: Colors.white,
                ),
                animationDuration: Duration(milliseconds: 300),
                backgroundColor: Colors.white,
                enableActiveFill: true,
                errorAnimationController: errorController,
                controller: textEditingController,
                onCompleted: (v) {
                  print("Completed");
                  setState(() {
                    _isCompleted = true;
                  });
                  // _showMsg('OTP verified successfully!', 2);

                  Navigator.pushReplacement(
                      context, SlideLeftRoute(page: LoginScreen()));
                },
                onChanged: (value) {
                  print(value);
                  setState(() {
                    currentText = value;

                    if (currentText.length < 4) _isCompleted = false;
                  });
                },
              ),
              ///////////////// pin code field end //////////////////

              ////////////////////// Submit button start //////////////////////
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  margin: EdgeInsets.only(top: 40, bottom: 20),
                  decoration: BoxDecoration(
                    color: Color(0xFF0487FF),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    'Submit',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              ////////////////////// Submit button end //////////////////////

              Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  'The verification code will expire in 00:59',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'poppins',
                    color: Color(0xFF333436).withOpacity(0.5),
                    fontSize: 14,
                    // fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  'Resend Code',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'poppins',
                    color: Color(0xFF00B658),
                    fontSize: 14,
                    // fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
