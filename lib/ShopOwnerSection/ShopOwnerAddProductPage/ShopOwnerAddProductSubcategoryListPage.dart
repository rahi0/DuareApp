import 'package:duare/ShopOwnerSection/ShopOwnerAddProductPage/ShopOwnerAddProductPage.dart';
import 'package:duare/ShopOwnerSection/ShopOwnerDrawer/ShopOwnerDrawer.dart';
import 'package:flutter/material.dart';
import 'package:duare/main.dart';
import 'package:duare/RouteTransition/routeAnimation.dart';
import 'package:duare/ShopOwnerSection/ShopOwnerAddSubCategory/ShopOwnerAddSubCategory.dart';

class ShopOwnerAddProductSubcategoryListPage extends StatefulWidget {
  @override
  _ShopOwnerAddProductSubcategoryListPageState createState() =>
      _ShopOwnerAddProductSubcategoryListPageState();
}

class _ShopOwnerAddProductSubcategoryListPageState
    extends State<ShopOwnerAddProductSubcategoryListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: ShopOwnerDrawer(),
      appBar: AppBar(
        backgroundColor: appColor,
        title: Text(
          'Product Sub Categories',
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
              Column(
                children: List.generate(
                  5,
                  (index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            FadeRoute(page: ShopOwnerAddProductPage()));
                      },
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(
                              left: 0,
                              right: 0,
                              bottom: 10,
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
                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 25, left: 10),
                                  height: 80,
                                  width: 80,
                                  child: Image.asset(
                                    'assets/images/medicine 1.png',
                                    fit: BoxFit.cover,
                                    colorBlendMode: BlendMode.luminosity,
                                    color: Color.fromRGBO(0, 0, 0, 0.2),
                                  ),
                                ),
                                Text(
                                  'Green Tea',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    fontFamily: 'poppins',
                                  ),
                                ),
                                // Icon(
                                //   Icons.arrow_forward_ios,
                                //   color: Colors.black54,
                                //   size: 20,
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
