import 'package:duare/DriverSection/DriverHomePage/DriverHomePage.dart';
import 'package:duare/Redux/reducer.dart';
import 'package:duare/Redux/state.dart';
import 'package:duare/Screens/LoginScreen/loginScreen.dart';
import 'package:duare/Screens/SplashScreen/SplashScreen.dart';
import 'package:duare/ShopOwnerSection/ShopOwnerHomepage/ShopOwnerHomepage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

////////////////  store initialization   ///////////////
final store = Store<AppState>(
  reducer,
  initialState: AppState(
    userInfoState: {},
    whichHomeState: {},
    categoryListState: {},
    //bannerListState: {},
    categoryNamesListState: [],
    categoryIdListState: {},
    deliveryAddress: [],
    deliveryAddressLoading: true,
    categoryLoading: true,
    //bannerLoading: true,  
    countryList: [],
    countryLoading: true,
    cityList: [],
    electronicsCategoryList: [],
    electronicsCategoryLoading: true,
    groceryCategoryList: [],
    groceryCategoryLoading: true,  
    medicineCategoryList: [],
    medicineCategoryLoading: true,                           
    electronicsBannerList: [],
    electronicsBannerLoading: true,
    groceryBannerList: [],
    groceryBannerLoading: true,        
    medicineBannerList: [],
    medicineBannerLoading: true,
    restaurantBannerList: [],
    restaurantBannerLoading: true,
    productList: [],
    productLoading: true,
    favouriteProductList: [],
    favouriteProductLoading: true,
    offerProductList: [],
    offerProductLoading: true,
    groceryFeaturedProductList: [],
    groceryFeaturedProductLoading: true,
    searchProductList: {},
    searchProductLoading: false,
    searchState:false,
    allRestaurantList: [],
    closedRestaurantList: [],
    allRestaurantLoading: true,       
    partnerRestaurantList: [], 
    partnerRestaurantLoading: true,
    catBrandListState: {},
    catBrandListLoadingState: true,
    resturantBestDealsListState: [],
    resturantBestDealsLoadingState: true,
    getPlansListState: [],
    getPlansLoadingState: true,
    recentlyPurchasedMedListState: [],
    recentlyPurchasedMedLoadingState: true,
    recentOrderState: [],
    pastOrderState: [],
    orderLoadingState: true,
    orerDetailsState: {},
    orerDetailsLoadingState: true,
    cartListState: [],
    cartLoadingState: true,
    frequentlyBoughtListState: [],
    frequentlyBoughtLoadingState: true,
    productDetailsState: {},
    productDetailsLoadingState: true,
    electronicBestDealListState: [],
    electronicBestDealLoadingState: true,
    restaurantDetailstState: {},
    restaurantDetailsLoadingState: true,
    restaurantMenuListState: [],
    restaurantMenuListLoadingState: true,
    prescriptionListState: [],
    prescriptionListLoadingState: true,
    scheduleListState: [],
    scheduleListLoadingState: true,
    announcmentState: {},
    announcmentLoadingState: true,
 // ),
      /////////////////////////////////////
      soBrandNamesListState: [],
      soBrandIdsListState: [],
      shopOwnerProductCategoriesState: {},
      soProductCategoriesLoadingState: true,
      soProductSubCategoriesState: {},
      soProductSubCategoriesLoadingState: true,
      soShopCategoryState: {},
      soMenuCategoriesState: {},
      soProductsListState: {},
      soProductsLoadingState: true,
      soVariationState: {},
      soVariationLoadingState: true,
      soProductDetailsState: {},
      soRestaurantMenuLoadingState: true,
      soDashboardLoadingState: true,
      soNewOrdersState: {},
      soProcessingOrdersState: {},
      soPickupOrdersState: {},
      soCancelledOrdersState: {},
      soDeliveredOrdersState: {},
      soNewOrdersLoadingState: true,
      soProcessingOrdersLoadingState: true,
      soPickupOrdersLoadingState: true,
      soCancelledOrdersLoadingState: true,
      soDeliveredOrdersLoadingState: true,
      soOrderDetailState: {},
      soOrderDetailLoadingState: true,
      /////////////////////////////////////
      
      ////////////////Driver section /////////////////////
      driverHomeState: {},
      driverHomeLoadingState: true,
      driverNewOrderState: [],
      driverNewOrderLoadingState: true,
      driverProcessingOrderState: [],
      driverProcessingOrderLoadingState: true,
      driverPickupOrderState: [],
      driverPickupOrderLoadingState: true,
      driverDeliveredOrderState: [],
      driverDeliveredOrderLoadingState: true,
      driverOrderDetailsState: {},
      driverOrderDetailsLoadingState: true,
      ////////////////Driver section /////////////////////
      ),
);

Color appColor = Color(0xFF0487FF);

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  void firebaseCheck() {
    _firebaseMessaging.getToken().then((token) async {
      print("Notification token");
      print(token);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage:");
        print('message --- $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch:");
        print(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume::");
        print(message);
      },
    );

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));

    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  @override
  void initState() {
    firebaseCheck();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: StoreConnector<AppState, AppState>(
        ////// this is the connector which mainly changes state/ui
        converter: (store) => store.state,
        builder: (context, items) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: SplashScreen(),
            //home: DriverHomepage(),
            // home: ShopOwnerHomepage(),
          );
        },
      ),
    );
  }
}
