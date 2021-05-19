import 'package:duare/RouteTransition/routeAnimation.dart';
import 'package:duare/ShopOwnerSection/ShopOwnerAddBrandPage/ShopOwnerAddBrandPage.dart';
import 'package:duare/ShopOwnerSection/ShopOwnerAddProductPage/ShopOwnerAddProductPage.dart';
import 'package:duare/ShopOwnerSection/ShopOwnerAddProductPage/ShopOwnerAddProductSubcategoryListPage.dart';
import 'package:duare/ShopOwnerSection/ShopOwnerHomepage/ShopOwnerHomepage.dart';
import 'package:duare/ShopOwnerSection/ShopOwnerOrderDashboard/ShopOwnerOrderDashboard.dart';
import 'package:duare/ShopOwnerSection/ShopOwnerProductsCategoryListPage/ShopOwnerProductsCategoryListPage.dart';
import 'package:duare/ShopOwnerSection/ShopOwnerProductsListPage/ShopOwnerProductsListPage.dart';
import 'package:duare/ShopOwnerSection/ShopOwnerCategoryList/ShopOwnerCategoryList.dart';
import 'package:duare/ShopOwnerSection/ShopOwnerRestaurantMenuCategory/ShopOwnerRestaurantMenuCategory.dart';
import 'package:duare/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class ShopOwnerDrawer extends StatefulWidget {
  @override
  _ShopOwnerDrawerState createState() => _ShopOwnerDrawerState();
}

class _ShopOwnerDrawerState extends State<ShopOwnerDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      Colors.blue[700],
                      Colors.blue[400],
                    ],
                  )),
                  child: Container(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child:
                            //  _isLoadingUser
                            //     ? Container(
                            //         height: 80,
                            //         width: 80,
                            //         margin: EdgeInsets.only(bottom: 10),
                            //         child: CircularProgressIndicator(),

                            //       )
                            //     :
                            Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: ClipOval(
                              child: Container(
                            height: 80,
                            width: 80,
                            color: Colors.white,
                            child: Icon(
                              Icons.person,
                              size: 40,
                            ),
                          )),
                        ),
                      ),
                      Container(
                        child: new Text(
                          // "Humayun Rahi",
                          store.state.userInfoState['name'] == null
                              ? ""
                              : "${store.state.userInfoState['name']}",
                          style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontFamily: "Poppins",
                              fontSize: 22,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  )),
                ),

                Container(),
                //////////// dashboard Button Start ////////////////
                InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context, FadeRoute(page: ShopOwnerHomepage()));
                    },
                    child: buttonContainer(
                      "Dashboard",
                    )),
                //////////// dashboard Button End ////////////////

                //////////// today's orders Button Start ////////////////
                InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context, FadeRoute(page: ShopOwnerOrderDashboard()));
                    },
                    child: buttonContainer(
                      "Today's Orders",
                    )),
                //////////// today's orders Button End ////////////////

                //////////// Product List Button Start ////////////////
                InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context,
                          FadeRoute(page: ShopOwnerProductsCategoryListPage()));
                      // FadeRoute(page: ShopOwnerProductsListPage()));
                    },
                    child: buttonContainer(
                      "Product List",
                    )),
                //////////// Product List Button End ////////////////

                //////////// Add Product  Button Start ////////////////
                InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context, FadeRoute(page: ShopOwnerAddProductPage()));
                      // page: ShopOwnerAddProductSubcategoryListPage()));
                    },
                    child: buttonContainer(
                      "Add Product",
                    )),
                //////////// Add Product Button End ////////////////

                //////////// Add Restaurant Menu Categories Button Start ////////////////
                store.state.soShopCategoryState['id'] == 3
                    ? InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.push(
                              context,
                              FadeRoute(
                                  page: ShopOwnerRestaurantMenuCategory()));
                        },
                        child: buttonContainer(
                          "Add Menu Category",
                        ))
                    : Container(),
                //////////// Add Restaurant Menu Categories Button End ////////////////

                //////////// Add Brand Button Start ////////////////
                InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context, FadeRoute(page: ShopOwnerAddBrandPage()));
                    },
                    child: buttonContainer(
                      "Add Brand",
                    )),
                //////////// Add Brand Button End ////////////////

                //////////// Category List Button Start ////////////////
                InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context, FadeRoute(page: ShopOwnerCategoryList()));
                    },
                    child: buttonContainer(
                      "Product Categories",
                    )),
                //////////// Category List Button End ////////////////

                //////////// Help Button Start ////////////////
                InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      launch("tel:+8801750118555");
                      // Navigator.push(
                      //     context, FadeRoute(page: ShopOwnerHomepage()));
                    },
                    child: buttonContainer(
                      "Help",
                    )),
                //////////// Help Button End ////////////////

                //////////// Logout Button Start ////////////////
                InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context, FadeRoute(page: ShopOwnerHomepage()));
                    },
                    child: buttonContainer(
                      "Logout",
                    )),
                //////////// Logout Button End ////////////////
              ],
            ),
          ),
        ),
      ),
    );
  }

  ////////////// buttonContainer ////////////////
  buttonContainer(var title) {
    return Container(
      // color: Colors.red,
      padding: EdgeInsets.only(left: 30, top: 15),
      margin: EdgeInsets.only(bottom: 5, top: 0),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Color(0xFF263238),
              fontFamily: 'poppins',
            ),
          ),
        ],
      ),
    );
  }
  ////////////// buttonContainer ////////////////
}
