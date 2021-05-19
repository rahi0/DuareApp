import 'package:cached_network_image/cached_network_image.dart';
import 'package:duare/RouteTransition/routeAnimation.dart';
import 'package:duare/Screens/CategoryAllProductsListingScreen/categoryAllProductsListingScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SubCategoryScreen extends StatefulWidget {

  final data;
  SubCategoryScreen(this.data);
  @override
  _SubCategoryScreenState createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Column(
            children: [
              Container(
                child: Stack(
                  children: [
                   
                    Container(
                      height: MediaQuery.of(context).size.height / 3.75,
                      width: MediaQuery.of(context).size.width,
                      child: CachedNetworkImage(
                                imageUrl: widget.data['image'],
                                fit: BoxFit.cover,
                                    colorBlendMode: BlendMode.luminosity,
                        color: Color.fromRGBO(0, 0, 0, 0.2),
                                                         
                                                          placeholder:
                                                              (context, url) =>
                                                                  Center(
                                                                child:SpinKitFadingCircle(
                                                                  color: Colors.grey,),
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Center(child: new Icon(Icons.error)),
                                                        )
                      
                      // Image.asset(
                      //   'assets/images/Vector 3.png',
                      //   fit: BoxFit.cover,
                      //   colorBlendMode: BlendMode.luminosity,
                      //   color: Color.fromRGBO(0, 0, 0, 0.2),
                      // ),
                    ),
                   
                    SafeArea(
                      child: Container(
                        // width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(top: 6),
                        alignment: Alignment.topCenter,
                        child: Text(
                          widget.data['name'],
                          style: TextStyle(
                            fontFamily: 'poppins',
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Container(
                        margin: EdgeInsets.only(
                          bottom: 10,
                          // top: 35,
                          top: MediaQuery.of(context).size.height / 5.75,
                        ),
                        child: Column(
                          children: List.generate(
                            widget.data['product_sub_category'].length,
                            (index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      ScaleRoute(
                                        page:
                                            CategoryAllProductsListingScreen("subCategory",
                            widget.data['product_sub_category'][index]),
                                            ),
                                      );
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.only(
                                    left: 16,
                                    right: 16,
                                    bottom: 20,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color.fromRGBO(0, 0, 0, 0.03),
                                        blurRadius: 15,
                                        spreadRadius: 0,
                                        offset: Offset(1, 8),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(left: 24),
                                          child: Text(
                                            widget.data['product_sub_category'][index]['name'],
                                            style: TextStyle(
                                              fontFamily: 'poppins',
                                              color: Color(0xFF263238),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: MediaQuery.of(context).size.width/4.5,
                                        width: MediaQuery.of(context).size.width/3.5,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5), 
                                          child:  widget.data['product_sub_category'][index]['image'] == null?
                                          Image.asset(
                                            'assets/images/placeHolder.jpg',
                                            fit: BoxFit.cover,
                                            colorBlendMode: BlendMode.luminosity,
                                            color: Color.fromRGBO(0, 0, 0, 0.2),
                                          ) :
                                          CachedNetworkImage(
                                                          imageUrl: widget.data['product_sub_category'][index]['image'],
                                                          fit: BoxFit.contain,
                                                          placeholder:
                                                              (context, url) =>
                                                                  Center(
                                                            child: SpinKitFadingCircle(
                                                              color: Colors.grey,),
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Center(child: new Icon(Icons.error)),
                                                        ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                      Positioned(
                        child: SafeArea(
                        child:
                            InkWell(
                          onTap: () {
                           Navigator.of(context).pop();
                          },
                          child: Container(
                            padding: EdgeInsets.only(left: 20, top: 6),
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        // ),
                    ),
                     ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
