import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:duare/RouteTransition/routeAnimation.dart';
import 'package:duare/Screens/LoginScreen/loginScreen.dart';
import 'package:duare/Screens/GetStartedScreen/getStartedScreen.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
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

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  ////////////////// Page View Controller essentials end ////////////////

  ////////////////// Skip Method Start //////////////////
  void skipButton() async {
    // await Future.delayed(new Duration(seconds: 3));
    Navigator.pushReplacement(
        context,
        SlideLeftRoute(
          //page: GetStartedScreen(), 
           page: LoginScreen(),
        ));
  }
  ////////////////// Skip Method End //////////////////

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // backgroundColor: Color(0xFFE5E5E5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: skipButton,
            child: Container(
              margin: EdgeInsets.only(right: 15, top: 10),
              child: Text(
                'Skip',
                style: TextStyle(
                  fontFamily: 'poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: onChangedFunction,
                physics: BouncingScrollPhysics(),
                children: [
                  //////////////////// PageView 1 Start ////////////////////
                  SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 35),
                              child: Image.asset("assets/images/Ellipse 5.png"),
                            ),
                            Container(
                              child: Image.asset(
                                  "assets/images/healthy-food 1.png"),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text(
                            'Choose your favourite food',
                            style: TextStyle(
                              fontFamily: 'poppins',
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 15, left: 30, right: 30),
                          child: Text(
                            'Discover the best food from nearest restaurants.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'poppins',
                              fontSize: 16,
                              color: Color(0xFf979797),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //////////////////// PageView 1 End ////////////////////

                  //////////////////// PageView 2 Start ////////////////////
                  SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Container(
                          // height: MediaQuery.of(context).size.width / 1.5,
                          // width: MediaQuery.of(context).size.width,
                          child: Stack(
                            children: [
                              Container(
                                child: Image.asset(
                                  "assets/images/Ellipse 5 (1).png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 140),
                                child: Image.asset("assets/images/rider.png"),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 30),
                          child: Text(
                            'Fast Delivery to your place',
                            style: TextStyle(
                              fontFamily: 'poppins',
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 15, left: 30, right: 30),
                          child: Text(
                            'Fast delivery to your home, office or whereever you are.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'poppins',
                              fontSize: 16,
                              color: Color(0xFf979797),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //////////////////// PageView 2 End ////////////////////

                  //////////////////// PageView 3 Start ////////////////////
                  SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              alignment: Alignment.topRight,
                              margin: EdgeInsets.only(top: 35),
                              child:
                                  Image.asset("assets/images/lastEllipse.png"),
                            ),
                            Center(
                              child: Container(
                                child: Image.asset(
                                    "assets/images/delivery-courier 1.png"),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 30),
                          child: Text(
                            'Everything you need',
                            style: TextStyle(
                              fontFamily: 'poppins',
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 15, left: 30, right: 30),
                          child: Text(
                            'We deliver everything of your daily need such as grocery, Medicine, Restaurants food, Electrorincs, Fruits, Vegetables and etc.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'poppins',
                              fontSize: 16,
                              color: Color(0xFf979797),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //////////////////// PageView 3 End ////////////////////
                ],
              ),
            ),

            //////////////////////// Dots Indicator Start ////////////////////////
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 35, bottom: 25),
              child: SmoothPageIndicator(
                controller: _pageController, // PageController
                count: 3,
                effect: ScaleEffect(
                  scale: 1.4,
                  // expansionFactor: 1.4,
                  dotHeight: 10,
                  dotWidth: 10,
                  activeDotColor: Color(0xFF0487FF),
                  dotColor: Color(0xFF777777),
                ), // your preferred effect
              ),
            ),
            //////////////////////// Dots Indicator End ////////////////////////

            /////////////////////// Next Button Start //////////////////////
            GestureDetector(
              onTap: currentIndex == 2 ? skipButton : nextFunction,
              child: Container(
                margin: EdgeInsets.only(top: 30, bottom: 50),
                padding: EdgeInsets.only(top: 15, bottom: 14),
                width: MediaQuery.of(context).size.width / 2,
                decoration: BoxDecoration(
                  color: Color(0xFF0487FF),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Text(
                  currentIndex == 2 ? 'Get Started' : 'Next',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            ////////////////////// Next Button End //////////////////////
          ],
        ),
      ),
    );
  }
}
