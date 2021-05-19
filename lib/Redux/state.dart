import 'package:duare/Redux/action.dart';

class AppState {
  ///  state where you want to store
  var userInfoState;
  var categoryListState;
  var whichHomeState;
//  var bannerListState;
  List<String> categoryNamesListState;
  var categoryIdListState;

  /////// shop Owner Product Categories ////////
  var shopOwnerProductCategoriesState;
  var soProductCategoriesLoadingState = true;

  /////// shop Owner Product Sub Categories ////////
  var soProductSubCategoriesState;
  var soProductSubCategoriesLoadingState = true;

  /////// shop Owner Product Brands ////////
  var soBrandNamesListState;
  var soBrandIdsListState;

  var soShopCategoryState;

  var soMenuCategoriesState;

  /////// shop owner products list ///////
  var soProductsListState;
  bool soProductsLoadingState = true;

  /////// shop owner product variations list ///////
  var soVariationState;
  bool soVariationLoadingState = true;

  var soProductDetailsState;

  bool soRestaurantMenuLoadingState = true;

  bool soDashboardLoadingState = true;

  /////////////// shop owner orders //////////////
  var soNewOrdersState;
  var soProcessingOrdersState;
  var soPickupOrdersState;
  var soCancelledOrdersState;
  var soDeliveredOrdersState;
  bool soNewOrdersLoadingState = true;
  bool soProcessingOrdersLoadingState = true;
  bool soPickupOrdersLoadingState = true;
  bool soCancelledOrdersLoadingState = true;
  bool soDeliveredOrdersLoadingState = true;

  var soOrderDetailState;
  bool soOrderDetailLoadingState = true;

  /////// delivery address ////////
  List deliveryAddress = [];
  bool deliveryAddressLoading = true;

  /////////////// category Loading ///////
  bool categoryLoading = true;

  /////////////// banner Loading ///////
  //  bool bannerLoading = true;

  ///  Country List ///////
  List countryList = [];

  /////////////// banner Loading ///////
  bool countryLoading = true;

  ///  City List ///////
  List cityList = [];

  ////////// electronics category ///////////

  List electronicsCategoryList = [];
  bool electronicsCategoryLoading = true;

  ////////// grocery category ///////////

  List groceryCategoryList = [];
  bool groceryCategoryLoading = true;

  ////////// medicine category ///////////

  List medicineCategoryList = [];
  bool medicineCategoryLoading = true;

  ////////// electronics banner ///////////

  List electronicsBannerList = [];
  bool electronicsBannerLoading = true;

  ////////// grocery banner ///////////

  List groceryBannerList = [];
  bool groceryBannerLoading = true;

  ////////// medicine banner ///////////

  List medicineBannerList = [];
  bool medicineBannerLoading = true;

  ////////// restaurant banner ///////////

  List restaurantBannerList = [];
  bool restaurantBannerLoading = true;

  //////////  products ///////////

  List productList = [];
  bool productLoading = true;

  //////// favourite products ///////////

  List favouriteProductList = [];
  bool favouriteProductLoading = true;

  ////////// offer products ///////////

  List offerProductList = [];
  bool offerProductLoading = true;

  //////////grocery featured products ///////////
  List groceryFeaturedProductList = [];
  bool groceryFeaturedProductLoading = true;

  ////////// search products ///////////

  var searchProductList = {};
  bool searchProductLoading = false;
  bool searchState = false;

  //////////grocery featured products ///////////
  List recommendedProductList = [];
  bool recommendedProductLoading = true;

  ////////// restaurant list ///////////

  ////////// restaurant list ///////////

  List allRestaurantList = [];
  List closedRestaurantList = [];
  bool allRestaurantLoading = true;

  ////////// partner restaurant list ///////////

  List partnerRestaurantList = [];
  bool partnerRestaurantLoading = true;

  //////////  prescription list ///////////
  ////////// Category Brand Product List ///////////

  var catBrandListState = {};
  bool catBrandListLoadingState = true;

  List prescriptionList = [];
  bool prescriptionLoading = true;

  ////////// Resturant Best Deals List ///////

  var resturantBestDealsListState = [];
  bool resturantBestDealsLoadingState = true;

  ////////// Get Plan List ///////

  var getPlansListState = [];
  bool getPlansLoadingState = true;

  ////////// Recenly Purchased Medicine List ///////

  var recentlyPurchasedMedListState = [];
  bool recentlyPurchasedMedLoadingState = true;

  ////////// Order List ///////

  var recentOrderState = [];
  var pastOrderState = [];
  bool orderLoadingState = true;

  ////////// Order Details ///////

  var orerDetailsState = {};
  bool orerDetailsLoadingState = true;

  ////////// Cart List ///////

  var cartListState = [];
  bool cartLoadingState = true;

  ////////// Frequently Bought Cart List ///////

  var frequentlyBoughtListState = [];
  bool frequentlyBoughtLoadingState = true;

  ////////// Product Details ///////

  var productDetailsState = {};
  bool productDetailsLoadingState = true;

  //////////Electronics Best Deals List ///////

  var electronicBestDealListState = [];
  bool electronicBestDealLoadingState = true;

  ////////// Restaurant Details ///////////

  var restaurantDetailstState = {};
  bool restaurantDetailsLoadingState = true;

  ////////// Restaurant Menu List ///////////

  var restaurantMenuListState = [];
  bool restaurantMenuListLoadingState = true;

  ////////// Prescription List ///////////

  var prescriptionListState = [];
  bool prescriptionListLoadingState = true;

  ////////// Schedule List ///////////
 
 var scheduleListState = [];
 bool scheduleListLoadingState = true;

 ////////// Schedule List ///////////
 
 var announcmentState = {};
 bool announcmentLoadingState = true;

/////////////////////// Driver Section ////////////////////////////
////////// Dashboard List ///////////
 
 var driverHomeState = {};
 bool driverHomeLoadingState = true;

 ////////// New orders List ///////////
 
 var driverNewOrderState = [];
 bool driverNewOrderLoadingState = true;

 ////////// Processing orders List ///////////
 
 var driverProcessingOrderState = [];
 bool driverProcessingOrderLoadingState = true;

 ////////// Pickup orders List ///////////
 
 var driverPickupOrderState = [];
 bool driverPickupOrderLoadingState = true;

 ////////// Delivered orders List ///////////
 
 var driverDeliveredOrderState = [];
 bool driverDeliveredOrderLoadingState = true;

 //////////  order Details ///////////
 
 var driverOrderDetailsState = {};
 bool driverOrderDetailsLoadingState = true;
      
/////////////////////// Driver Section ////////////////////////////
  AppState({
    this.userInfoState,
    this.categoryListState,
    this.whichHomeState,   
    this.categoryNamesListState,
    this.categoryIdListState,
    this.deliveryAddress,
    this.deliveryAddressLoading,
    this.categoryLoading,
    this.countryList,
    this.countryLoading,
    this.cityList,
    this.electronicsCategoryList,
    this.electronicsCategoryLoading, 
    this.groceryCategoryList, 
    this.groceryCategoryLoading, 
    this.medicineCategoryList, 
    this.medicineCategoryLoading,
    this.electronicsBannerList,
    this.electronicsBannerLoading, 
    this.groceryBannerList, 
    this.groceryBannerLoading, 
    this.medicineBannerList, 
    this.medicineBannerLoading,
    this.restaurantBannerList, 
    this.restaurantBannerLoading,
    this.productList,
    this.productLoading, 
    this.favouriteProductList, 
    this.favouriteProductLoading, 
    this.offerProductList, 
    this.offerProductLoading,
    this.groceryFeaturedProductList, 
    this.groceryFeaturedProductLoading,
    this.searchProductList,
    this.searchProductLoading,
    this.searchState,
    this.recommendedProductList,
    this.recommendedProductLoading,
    this.allRestaurantList,
    this.allRestaurantLoading,
    this.partnerRestaurantList,
    this.partnerRestaurantLoading,
    this.catBrandListState,
    this.catBrandListLoadingState,
    this.resturantBestDealsListState,
    this.resturantBestDealsLoadingState,
    this.getPlansListState,
    this.getPlansLoadingState,
    this.recentlyPurchasedMedListState,
    this.recentlyPurchasedMedLoadingState,
    this.recentOrderState,
    this.pastOrderState,
    this.orderLoadingState,
    this.orerDetailsState,
    this.orerDetailsLoadingState,
    this.cartListState,
    this.cartLoadingState,
    this.frequentlyBoughtListState,
    this.frequentlyBoughtLoadingState,
    this.productDetailsState,
    this.productDetailsLoadingState,
    this.electronicBestDealListState,
    this.electronicBestDealLoadingState,
    this.restaurantDetailstState,
    this.restaurantDetailsLoadingState,
    this.restaurantMenuListState,
    this.restaurantMenuListLoadingState,
    this.prescriptionListState,
    this.prescriptionListLoadingState,
    this.closedRestaurantList,
    this.scheduleListState,
    this.scheduleListLoadingState,
    this.announcmentLoadingState,
    this.announcmentState,
    this.prescriptionLoading,
    this.prescriptionList,
    //////////////////////////////////////////////////////////////
      this.shopOwnerProductCategoriesState,
      this.soProductCategoriesLoadingState,
      this.soProductSubCategoriesState,
      this.soProductSubCategoriesLoadingState,
      this.soBrandNamesListState,
      this.soBrandIdsListState,
      this.soShopCategoryState,
      this.soMenuCategoriesState,
      this.soProductsListState,
      this.soProductsLoadingState,
      this.soVariationState,
      this.soVariationLoadingState,
      this.soProductDetailsState,
      this.soRestaurantMenuLoadingState,
      this.soDashboardLoadingState,
      this.soNewOrdersState,
      this.soProcessingOrdersState,
      this.soPickupOrdersState,
      this.soCancelledOrdersState,
      this.soDeliveredOrdersState,
      this.soNewOrdersLoadingState,
      this.soProcessingOrdersLoadingState,
      this.soPickupOrdersLoadingState,
      this.soCancelledOrdersLoadingState,
      this.soDeliveredOrdersLoadingState,
      this.soOrderDetailState,
      this.soOrderDetailLoadingState,
      ///////////////////////////////////////////////////////////////
      
      /////////////////////// Driver Section ////////////////////////////
      this.driverHomeState,
      this.driverHomeLoadingState,
      this.driverNewOrderState,
      this.driverNewOrderLoadingState,
      this.driverProcessingOrderState,
      this.driverProcessingOrderLoadingState,
      this.driverPickupOrderState,
      this.driverPickupOrderLoadingState,
      this.driverDeliveredOrderState,
      this.driverDeliveredOrderLoadingState,
      this.driverOrderDetailsState,
      this.driverOrderDetailsLoadingState
      /////////////////////// Driver Section ////////////////////////////
  });     

  AppState copywith({
    userInfoState,
    categoryListState,
    whichHomeState,
    bannerListState,
    categoryNamesListState,
    categoryIdListState,
    deliveryAddress,
    deliveryAddressLoading,
    categoryLoading,
    bannerLoading,
    countryList,
    countryLoading,
    cityList,
    electronicsCategoryList,
    electronicsCategoryLoading, 
    groceryCategoryList, 
    groceryCategoryLoading, 
    medicineCategoryList, 
    medicineCategoryLoading,
    electronicsBannerList,
    electronicsBannerLoading,        
    groceryBannerList, 
    groceryBannerLoading, 
    medicineBannerList, 
    medicineBannerLoading,
    restaurantBannerList,
    restaurantBannerLoading,
    productList,
    productLoading, 
    favouriteProductList, 
    favouriteProductLoading, 
    offerProductList, 
    offerProductLoading,
    groceryFeaturedProductList, 
    groceryFeaturedProductLoading,
    searchProductList,
    searchProductLoading,
    searchState,
    recommendedProductList,
    recommendedProductLoading,
    allRestaurantList,
    allRestaurantLoading,
    partnerRestaurantList,
    partnerRestaurantLoading,
    prescriptionList, 
    prescriptionLoading,
    catBrandListState,
    catBrandListLoadingState,
    resturantBestDealsListState,
    resturantBestDealsLoadingState,
    getPlansListState,
    getPlansLoadingState,
    recentlyPurchasedMedListState,
    recentlyPurchasedMedLoadingState,
    recentOrderState,
    pastOrderState,
    orderLoadingState,
    orerDetailsState,
    orerDetailsLoadingState,
    cartListState,
    cartLoadingState,
    frequentlyBoughtListState,
    frequentlyBoughtLoadingState,
    productDetailsState,
    productDetailsLoadingState,
    electronicBestDealListState,
    electronicBestDealLoadingState,
    restaurantDetailstState,
    restaurantDetailsLoadingState,
    restaurantMenuListState,
    restaurantMenuListLoadingState,
    prescriptionListState,
    prescriptionListLoadingState,
    closedRestaurantList,
    scheduleListState,
    scheduleListLoadingState,
    announcmentLoadingState,
    announcmentState,
    //////////////////////////////////////////////////////////////////
      shopOwnerProductCategoriesState,
      soProductCategoriesLoadingState,
      soProductSubCategoriesState,
      soProductSubCategoriesLoadingState,
      soBrandNamesListState,
      soBrandIdsListState,
      soShopCategoryState,
      soMenuCategoriesState,
      soProductsListState,
      soProductsLoadingState,
      soVariationState,
      soVariationLoadingState,
      soProductDetailsState,
      soRestaurantMenuLoadingState,
      soDashboardLoadingState,
      soNewOrdersState,
      soProcessingOrdersState,
      soPickupOrdersState,
      soCancelledOrdersState,
      soDeliveredOrdersState,
      soNewOrdersLoadingState,
      soProcessingOrdersLoadingState,
      soPickupOrdersLoadingState,
      soCancelledOrdersLoadingState,
      soDeliveredOrdersLoadingState,
      soOrderDetailState,
      soOrderDetailLoadingState,
      ///////////////////////////////////////////////////////////////////
      
      /////////////////////// Driver Section ////////////////////////////
      driverHomeState,
      driverHomeLoadingState,
      driverNewOrderState,
      driverNewOrderLoadingState,
      driverProcessingOrderState,
      driverProcessingOrderLoadingState,
      driverPickupOrderState,
      driverPickupOrderLoadingState,
      driverDeliveredOrderState,
      driverDeliveredOrderLoadingState,
      driverOrderDetailsState,
      driverOrderDetailsLoadingState
      /////////////////////// Driver Section ////////////////////////////
   
    }) {           
 
    return AppState(
      userInfoState: userInfoState ?? this.userInfoState,
      categoryListState: categoryListState ?? this.categoryListState,
      whichHomeState: whichHomeState ?? this.whichHomeState,
      // bannerListState: bannerListState ?? this.bannerListState,
      categoryNamesListState:
          categoryNamesListState ?? this.categoryNamesListState,
      categoryIdListState: categoryIdListState ?? this.categoryIdListState,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      deliveryAddressLoading:
          deliveryAddressLoading ?? this.deliveryAddressLoading,
      categoryLoading: categoryLoading ?? this.categoryLoading,
      //bannerLoading: bannerLoading ?? this.bannerLoading,
      countryList: countryList ?? this.countryList,
      countryLoading: countryLoading ?? this.countryLoading,
      cityList: cityList ?? this.cityList,
      electronicsCategoryList:
          electronicsCategoryList ?? this.electronicsCategoryList,
      electronicsCategoryLoading:
          electronicsCategoryLoading ?? this.electronicsCategoryLoading,
      groceryCategoryList: groceryCategoryList ?? this.groceryCategoryList,
      groceryCategoryLoading:
          groceryCategoryLoading ?? this.groceryCategoryLoading,
      medicineCategoryList: medicineCategoryList ?? this.medicineCategoryList,
      medicineCategoryLoading:
          medicineCategoryLoading ?? this.medicineCategoryLoading,
      electronicsBannerList:
          electronicsBannerList ?? this.electronicsBannerList,
      electronicsBannerLoading:
          electronicsBannerLoading ?? this.electronicsBannerLoading,
      groceryBannerList: groceryBannerList ?? this.groceryBannerList,
      groceryBannerLoading: groceryBannerLoading ?? this.groceryBannerLoading,
      medicineBannerList: medicineBannerList ?? this.medicineBannerList,
      medicineBannerLoading:
          medicineBannerLoading ?? this.medicineBannerLoading,
      restaurantBannerList: restaurantBannerList ?? this.restaurantBannerList,
      restaurantBannerLoading:
          restaurantBannerLoading ?? this.restaurantBannerLoading,
      productList: productList ?? this.productList,
      productLoading: productLoading ?? this.productLoading,
      favouriteProductList: favouriteProductList ?? this.favouriteProductList,
      favouriteProductLoading:
          favouriteProductLoading ?? this.favouriteProductLoading,
      offerProductList: offerProductList ?? this.offerProductList,
      offerProductLoading: offerProductLoading ?? this.offerProductLoading,
      groceryFeaturedProductList:
          groceryFeaturedProductList ?? this.groceryFeaturedProductList,
      groceryFeaturedProductLoading:
          groceryFeaturedProductLoading ?? this.groceryFeaturedProductLoading,
      searchProductList: searchProductList ?? this.searchProductList,
      searchProductLoading: searchProductLoading ?? this.searchProductLoading,
      searchState: searchState ?? this.searchState,
      recommendedProductList:
          recommendedProductList ?? this.recommendedProductList,
      recommendedProductLoading:
          recommendedProductLoading ?? this.recommendedProductLoading,
      allRestaurantList: allRestaurantList ?? this.allRestaurantList,
      allRestaurantLoading: allRestaurantLoading ?? this.allRestaurantLoading,

      prescriptionList: prescriptionList ?? this.prescriptionList,
      prescriptionLoading: prescriptionLoading ?? this.prescriptionLoading,
      ////////////////////////////////////////////////////////////////////
      shopOwnerProductCategoriesState: shopOwnerProductCategoriesState ??
          this.shopOwnerProductCategoriesState,
      soProductCategoriesLoadingState: soProductCategoriesLoadingState ??
          this.soProductCategoriesLoadingState,
      soProductSubCategoriesState:
          soProductSubCategoriesState ?? this.soProductSubCategoriesState,
      soProductSubCategoriesLoadingState: soProductSubCategoriesLoadingState ??
          this.soProductSubCategoriesLoadingState,
      soBrandNamesListState:
          soBrandNamesListState ?? this.soBrandNamesListState,
      soBrandIdsListState: soBrandIdsListState ?? this.soBrandIdsListState,
      soShopCategoryState: soShopCategoryState ?? this.soShopCategoryState,
      soMenuCategoriesState:
          soMenuCategoriesState ?? this.soMenuCategoriesState,
      soProductsListState: soProductsListState ?? this.soProductsListState,
      soProductsLoadingState:
          soProductsLoadingState ?? this.soProductsLoadingState,
      soVariationState: soVariationState ?? this.soVariationState,
      soVariationLoadingState:
          soVariationLoadingState ?? this.soVariationLoadingState,
      soProductDetailsState:
          soProductDetailsState ?? this.soProductDetailsState,
      soRestaurantMenuLoadingState:
          soRestaurantMenuLoadingState ?? this.soRestaurantMenuLoadingState,
      soDashboardLoadingState:
          soDashboardLoadingState ?? this.soDashboardLoadingState,
      soNewOrdersState: soNewOrdersState ?? this.soNewOrdersState,
      soProcessingOrdersState:
          soProcessingOrdersState ?? this.soProcessingOrdersState,
      soPickupOrdersState: soPickupOrdersState ?? this.soPickupOrdersState,
      soCancelledOrdersState:
          soCancelledOrdersState ?? this.soCancelledOrdersState,
      soDeliveredOrdersState:
          soDeliveredOrdersState ?? this.soDeliveredOrdersState,
      soNewOrdersLoadingState:
          soNewOrdersLoadingState ?? this.soNewOrdersLoadingState,
      soProcessingOrdersLoadingState:
          soProcessingOrdersLoadingState ?? this.soProcessingOrdersLoadingState,
      soPickupOrdersLoadingState:
          soPickupOrdersLoadingState ?? this.soPickupOrdersLoadingState,
      soCancelledOrdersLoadingState:
          soCancelledOrdersLoadingState ?? this.soCancelledOrdersLoadingState,
      soDeliveredOrdersLoadingState:
          soDeliveredOrdersLoadingState ?? this.soDeliveredOrdersLoadingState,
      soOrderDetailState: soOrderDetailState ?? this.soOrderDetailState,
      soOrderDetailLoadingState:
          soOrderDetailLoadingState ?? this.soOrderDetailLoadingState,

      partnerRestaurantList:partnerRestaurantList ?? this.partnerRestaurantList,
      partnerRestaurantLoading:partnerRestaurantLoading ?? this.partnerRestaurantLoading,
      catBrandListState: catBrandListState ?? this.catBrandListState,
      catBrandListLoadingState : catBrandListLoadingState ?? this.catBrandListLoadingState,
      resturantBestDealsListState : resturantBestDealsListState ?? this.resturantBestDealsListState,
      resturantBestDealsLoadingState : resturantBestDealsLoadingState ?? this.resturantBestDealsLoadingState,
      getPlansListState : getPlansListState ?? this.getPlansListState,
      getPlansLoadingState : getPlansLoadingState ?? this.getPlansLoadingState,
      recentlyPurchasedMedListState : recentlyPurchasedMedListState ?? this.recentlyPurchasedMedListState,
      recentlyPurchasedMedLoadingState : recentlyPurchasedMedLoadingState ?? this.recentlyPurchasedMedLoadingState,
      recentOrderState : recentOrderState ?? this.recentOrderState,
      pastOrderState : pastOrderState ?? this.pastOrderState,
      orderLoadingState : orderLoadingState ?? this.orderLoadingState,
      orerDetailsState : orerDetailsState ?? this.orerDetailsState,
      orerDetailsLoadingState : orerDetailsLoadingState ?? this.orerDetailsLoadingState,
      cartListState : cartListState ?? this.cartListState,
      cartLoadingState : cartLoadingState ?? this.cartLoadingState,
      frequentlyBoughtListState : frequentlyBoughtListState ?? this.frequentlyBoughtListState,
      frequentlyBoughtLoadingState : frequentlyBoughtLoadingState ?? this.frequentlyBoughtLoadingState,
      productDetailsState : productDetailsState ?? this.productDetailsState,
      productDetailsLoadingState : productDetailsLoadingState ?? this.productDetailsLoadingState,
      electronicBestDealListState : electronicBestDealListState ?? this.electronicBestDealListState,
      electronicBestDealLoadingState : electronicBestDealLoadingState ?? this.electronicBestDealLoadingState,
      restaurantDetailstState : restaurantDetailstState ?? this.restaurantDetailstState,
      restaurantDetailsLoadingState : restaurantDetailsLoadingState ?? this.restaurantDetailsLoadingState,
      restaurantMenuListState : restaurantMenuListState ?? this.restaurantMenuListState,
      restaurantMenuListLoadingState : restaurantMenuListLoadingState ?? this.restaurantMenuListLoadingState,
      prescriptionListState : prescriptionListState ?? this.prescriptionListState,
      prescriptionListLoadingState : prescriptionListLoadingState ?? this.prescriptionListLoadingState,
      closedRestaurantList : closedRestaurantList ?? this.closedRestaurantList,
      scheduleListState : scheduleListState ?? this.scheduleListState,
      scheduleListLoadingState : scheduleListLoadingState ?? this.scheduleListLoadingState,
      announcmentLoadingState : announcmentLoadingState ?? this.announcmentLoadingState,
      announcmentState : announcmentState ?? this.announcmentState,

      /////////////////////// Driver Section ////////////////////////////
      driverHomeState : driverHomeState ?? this.driverHomeState,
      driverHomeLoadingState : driverHomeLoadingState ?? this.driverHomeLoadingState,
      driverNewOrderState : driverNewOrderState ?? this.driverNewOrderState,
      driverNewOrderLoadingState : driverNewOrderLoadingState ?? this.driverNewOrderLoadingState,
      driverProcessingOrderState : driverProcessingOrderState ?? this.driverProcessingOrderState,
      driverProcessingOrderLoadingState : driverProcessingOrderLoadingState ?? this.driverProcessingOrderLoadingState,
      driverPickupOrderState : driverPickupOrderState ?? this.driverPickupOrderState,
      driverPickupOrderLoadingState : driverPickupOrderLoadingState ?? this.driverPickupOrderLoadingState,
      driverDeliveredOrderState : driverDeliveredOrderState ?? this.driverDeliveredOrderState,
      driverDeliveredOrderLoadingState : driverDeliveredOrderLoadingState ?? this.driverDeliveredOrderLoadingState,
      driverOrderDetailsState : driverOrderDetailsState ?? this.driverOrderDetailsState,
      driverOrderDetailsLoadingState : driverOrderDetailsLoadingState ?? this.driverOrderDetailsLoadingState,
      /////////////////////// Driver Section ////////////////////////////
    );
  }
}
