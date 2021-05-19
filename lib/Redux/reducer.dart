import 'package:duare/Redux/action.dart';
import 'package:duare/Redux/state.dart';

AppState reducer(AppState state, dynamic action) {
  if (action is UserInfoAction) {
    return state.copywith(
        userInfoState: action
            .userInfoAction ///// your updating list where you store by applying logic
        );
  } else if (action is CategoryListAction) {
    return state.copywith(categoryListState: action.categoryListAction);
  } else if (action is WhichHomeAction) {
    return state.copywith(whichHomeState: action.whichHomeAction);
  } 
  // else if (action is BannerListAction) {
  //   return state.copywith(bannerListState: action.bannerListAction);
  // }
   else if (action is CategoryIdListAction) {
    return state.copywith(categoryIdListState: action.categoryIdListAction);
  } else if (action is CategoryNamesListAction) {
    return state.copywith(
        categoryNamesListState: action.categoryNamesListAction);
  } else if (action is DeliveryAddressAction) {
    return state.copywith(
        deliveryAddress: action.deliveryAddressAction);
  } 
  else if (action is DeliveryAddressLoadingAction) {
    return state.copywith(
        deliveryAddressLoading: action.deliveryAddressLoadingAction);
  }
  else if (action is CategoryLoadingAction) {
    return state.copywith(
        categoryLoading: action.categoryLoadingAction);
  }
  // else if (action is BannerLoadingAction) {
  //   return state.copywith(
  //       bannerLoading: action.bannerLoadingAction);
  // }
   else if (action is CountryListAction) {
    return state.copywith(
      countryList: action.countryListAction);
  }
   else if (action is CountryLoadingAction) {
    return state.copywith(
      countryLoading: action.countryLoadingAction);
  }

  else if (action is CityListAction) {
    return state.copywith(
      cityList: action.cityListAction);
  }

   else if (action is ElectronicsCategoryListAction) {
    return state.copywith(
      electronicsCategoryList: action.electronicsCategoryListAction);
  }
   else if (action is ElectronicsCategoryLoadingAction) {
    return state.copywith(
      electronicsCategoryLoading: action.electronicsCategoryLoadingAction);
  }


   else if (action is GroceryCategoryListAction) {
    return state.copywith(
      groceryCategoryList: action.groceryCategoryListAction);
  }
   else if (action is GroceryCategoryLoadingAction) {
    return state.copywith(
      groceryCategoryLoading: action.groceryCategoryLoadingAction);
  }


   else if (action is MedicineCategoryListAction) {
    return state.copywith(
      medicineCategoryList: action.medicineCategoryListAction);
  }
   else if (action is MedicineCategoryLoadingAction) {
    return state.copywith(
      medicineCategoryLoading: action.medicineCategoryLoadingAction);
  }


  
   else if (action is ElectronicsBannerListAction) {
    return state.copywith(
      electronicsBannerList: action.electronicsBannerListAction);
  }
   else if (action is ElectronicsBannerLoadingAction) {
    return state.copywith(
      electronicsBannerLoading: action.electronicsBannerLoadingAction);
  }


   else if (action is GroceryBannerListAction) {
    return state.copywith(
      groceryBannerList: action.groceryBannerListAction);
  }
   else if (action is GroceryBannerLoadingAction) {
    return state.copywith(
      groceryBannerLoading: action.groceryBannerLoadingAction);
  }


   else if (action is MedicineBannerListAction) {
    return state.copywith(
      medicineBannerList: action.medicineBannerListAction);
  }
   else if (action is MedicineBannerLoadingAction) {
    return state.copywith(
      medicineBannerLoading: action.medicineBannerLoadingAction);
  }

   else if (action is RestuarantBannerListAction) {
    return state.copywith(
      restaurantBannerList: action.restaurantBannerListAction);
  }
   else if (action is RestaurantBannerLoadingAction) {
    return state.copywith(
      restaurantBannerLoading: action.restaurantBannerLoadingAction);
  }


     else if (action is ProductListAction) {
    return state.copywith(
      productList: action.productListAction);
  }
   else if (action is ProductLoadingAction) {
    return state.copywith(
      productLoading: action.productLoadingAction);
  }


   else if (action is FavouriteProductListAction) {
    return state.copywith(
      favouriteProductList: action.favouriteProductListAction);
  }
   else if (action is FavouriteProductLoadingAction) {
    return state.copywith(
      favouriteProductLoading: action.favouriteProductLoadingAction);
  }

   else if (action is OfferProductListAction) {
    return state.copywith(
      offerProductList: action.offerProductListAction);
  }
   else if (action is OfferProductLoadingAction) {
    return state.copywith(
      offerProductLoading: action.offerProductLoadingAction);
   }
   else if (action is GroceryFeaturedProductListAction) {
    return state.copywith(
      groceryFeaturedProductList: action.groceryFeaturedProductListAction);
  }
   else if (action is GroceryFeaturedProductLoadingAction) {
    return state.copywith(
      groceryFeaturedProductLoading: action.groceryFeaturedProductLoadingAction);
  }
   else if (action is SearchProductListAction) {
    return state.copywith(
      searchProductList: action.searchProductListAction);
  }
   else if (action is SearchProductLoadingAction) {
    return state.copywith(
      searchProductLoading: action.searchProductLoadingAction);
  }
   else if (action is SearchStateAction) {
    return state.copywith(
      searchState: action.searchStateAction);
  }

   else if (action is RecommendedProductListAction) {
    return state.copywith(
      recommendedProductList: action.recommendedProductListAction);
  }
   else if (action is RecommendedProductLoadingAction) {
    return state.copywith(
      recommendedProductLoading: action.recommendedProductLoadingAction);
  }

   else if (action is PartnerRestaurantListAction) {
    return state.copywith(
      partnerRestaurantList: action.partnerRestaurantListAction);
  }

    else if (action is PartnerRestaurantLoadingAction) {
    return state.copywith(
      partnerRestaurantLoading: action.partnerRestaurantLoadingAction);
  }

  
   else if (action is AllRestaurantListAction) {
    return state.copywith(
      allRestaurantList: action.allRestaurantListAction);
  }

   else if (action is AllRestaurantLoadingAction) {
    return state.copywith(
      allRestaurantLoading: action.allRestaurantLoadingAction);
  }
  

  else if (action is CatBrandListAction) {
    return state.copywith(
      catBrandListState: action.catBrandListAction);
  }


  else if (action is CatBrandListLoadingAction) {
    return state.copywith(
      catBrandListLoadingState: action.catBrandListLoadingAction);
  }

  else if (action is ResturantBestDealsListAction) {
    return state.copywith(
      resturantBestDealsListState: action.resturantBestDealsListAction);
  }


  else if (action is ResturantBestDealsListLoadingAction) {
    return state.copywith(
      resturantBestDealsLoadingState: action.resturantBestDealsListLoadingAction);
  }


  else if (action is GetPlansListAction) {
    return state.copywith(
      getPlansListState: action.getPlansListAction);
  }


  else if (action is GetPlansListLoadingAction) {
    return state.copywith(
      getPlansLoadingState: action.getPlansListLoadingAction);
  }

  else if (action is RecentlyPurchasedMedListAction) {
    return state.copywith(
      recentlyPurchasedMedListState: action.recentlyPurchasedMedListAction);
  }


  else if (action is RecentlyPurchasedMedListLoadingAction) {
    return state.copywith(
      recentlyPurchasedMedLoadingState: action.recentlyPurchasedMedListLoadingAction);
  }

  else if (action is RecentOrderAction) {
    return state.copywith(
      recentOrderState: action.recentOrderAction);
  }

  else if (action is PastOrderAction) {
    return state.copywith(
      pastOrderState: action.pastOrderAction);
  }

  else if (action is OrderLoadingAction) {
    return state.copywith(
      orderLoadingState: action.orderLoadingAction);
  }

  else if (action is OrderDetailsAction) {
    return state.copywith(
      orerDetailsState: action.orderDetailsAction);
  }

  else if (action is OrderDetailsLoadingAction) {
    return state.copywith(
      orerDetailsLoadingState: action.orderDetailsLoadingAction);
  }


  else if (action is CartListAction) {
    return state.copywith(
      cartListState: action.cartListAction);
  }

  else if (action is CartListLoadingAction) {
    return state.copywith(
      cartLoadingState: action.cartListLoadingAction);
  }

  else if (action is FrequentlyBoughtListAction) {
    return state.copywith(
      frequentlyBoughtListState: action.frequentlyBoughtListAction);
  }

  else if (action is FrequentlyBoughtListLoadingAction) {
    return state.copywith(
      frequentlyBoughtLoadingState: action.frequentlyBoughtListLoadingAction);
  }

  else if (action is ProductDetailsAction) {
    return state.copywith(
      productDetailsState: action.productDetailsAction);
  }

  else if (action is ProductDetailsLoadingAction) {
    return state.copywith(
      productDetailsLoadingState: action.productDetailsLoadingAction);
  }

  else if (action is ElectronicsBestDealsAction) {
    return state.copywith(
      electronicBestDealListState: action.electronicsBestDealsAction);
  }

  else if (action is ElectronicsBestDealsLoadingAction) {
    return state.copywith(
      electronicBestDealLoadingState: action.electronicsBestDealsLoadingAction);
  }

  else if (action is RestauranDetailsAction) {
    return state.copywith(
      restaurantDetailstState: action.restauranDetailsAction);
  }

  else if (action is RestauranDetailsLoadingAction) {
    return state.copywith(
      restaurantDetailsLoadingState: action.restauranDetailsLoadingAction);
  }

  else if (action is RestaurentMenuListAction) {
    return state.copywith(
      restaurantMenuListState: action.restaurentMenuListAction);
  }

  else if (action is RestaurentMenuListLoadingAction) {
    return state.copywith(
      restaurantMenuListLoadingState: action.restaurentMenuListLoadingAction);
  }


  else if (action is PrescriptionListAction) {
    return state.copywith(
      prescriptionListState: action.prescriptionListAction);
  }

   else if (action is PrescriptionListLoadingAction) {
    return state.copywith(
      prescriptionListLoadingState: action.prescriptionListLoadingAction);
  }

   else if (action is ClosedRestaurentListAction) {
    return state.copywith(
      closedRestaurantList: action.closedRestaurentListAction);
  }

  else if (action is ScheduleListAction) {
    return state.copywith(
      scheduleListState: action.scheduleListAction);
  }

   else if (action is ScheduleLisLoadingtAction) {
    return state.copywith(
      scheduleListLoadingState: action.scheduleLisLoadingtAction);
  }

  else if (action is AnnouncmentAction) {
    return state.copywith(
      announcmentState: action.announcmentAction);
  }

   else if (action is AnnouncmentLoadingtAction) {
    return state.copywith(
      announcmentLoadingState: action.announcmentLoadingtAction);
  }
 
  /////////////////////////////////////////////////////////////////////
  else if (action is ShopOwnerProductCategoriesAction) {
    return state.copywith(
      shopOwnerProductCategoriesState: action.shopOwnerProductCategoriesAction);
  }
 
 
  else if (action is SoProductCategoriesLoadingAction) {
    return state.copywith(
      soProductCategoriesLoadingState: action.soProductCategoriesLoadingAction);
  }
 
  else if (action is SoProductSubCategoriesAction) {
    return state.copywith(
      soProductSubCategoriesState: action.soProductSubCategoriesAction);
  }
 
  else if (action is SoProductSubCategoriesLoadingAction) {
    return state.copywith(
      soProductSubCategoriesLoadingState: action.soProductSubCategoriesLoadingAction);
  }
 
  else if (action is SoBrandNamesListAction) {
    return state.copywith(
      soBrandNamesListState: action.soBrandNamesListAction);
  }
 
  else if (action is SoBrandIdsListAction) {
    return state.copywith(
      soBrandIdsListState: action.soBrandIdsListAction);
  }
 
  else if (action is SoShopCategoryAction) {
    return state.copywith(
      soShopCategoryState: action.soShopCategoryAction);
  }
 
  else if (action is SoMenuCategoriesAction) {
    return state.copywith(
      soMenuCategoriesState: action.soMenuCategoriesAction);
  }
 
  else if (action is SoProductsListAction) {
    return state.copywith(
      soProductsListState: action.soProductsListAction);
  }
 
  else if (action is SoProductsLoadingAction) {
    return state.copywith(
      soProductsLoadingState: action.soProductsLoadingAction);
  }
 
  else if (action is SoVariationAction) {
    return state.copywith(
      soVariationState: action.soVariationAction);
  }
 
  else if (action is SoVariationLoadingAction) {
    return state.copywith(
      soVariationLoadingState: action.soVariationLoadingAction);
  }
 
  else if (action is SoProductDetailsAction) {
    return state.copywith(
      soProductDetailsState: action.soProductDetailsAction);
  }
 
  else if (action is SoRestaurantMenuLoadingAction) {
    return state.copywith(
      soRestaurantMenuLoadingState: action.soRestaurantMenuLoadingAction);
  }
 
  else if (action is SoDashboardLoadingAction) {
    return state.copywith(
      soDashboardLoadingState: action.soDashboardLoadingAction);
  }
  
  else if (action is SoNewOrdersAction ) {
    return state.copywith(
     soNewOrdersState: action.soNewOrdersAction);
  }

  else if (action is SoProcessingOrdersAction ) {
    return state.copywith(
      soProcessingOrdersState: action.soProcessingOrdersAction);
  }

  else if (action is SoPickupOrdersAction ) {
    return state.copywith(
      soPickupOrdersState: action.soPickupOrdersAction);
  }

  else if (action is SoCancelledOrdersAction ) {
    return state.copywith(
      soCancelledOrdersState: action.soCancelledOrdersAction);
  }

  else if (action is SoDeliveredOrdersAction ) {
    return state.copywith(
      soDeliveredOrdersState: action.soDeliveredOrdersAction);
  }
  
  else if (action is SoNewOrdersLoadingAction ) {
    return state.copywith(
      soNewOrdersLoadingState: action.soNewOrdersLoadingAction);
  }

  else if (action is SoProcessingOrdersLoadingAction ) {
    return state.copywith(
      soProcessingOrdersLoadingState: action.soProcessingOrdersLoadingAction);
  }

  else if (action is SoPickupOrdersLoadingAction ) {
    return state.copywith(
      soPickupOrdersLoadingState: action.soPickupOrdersLoadingAction);
  }

  else if (action is SoCancelledOrdersLoadingAction ) {
    return state.copywith(
      soCancelledOrdersLoadingState: action.soCancelledOrdersLoadingAction);
  }

  else if (action is SoDeliveredOrdersLoadingAction ) {
    return state.copywith(
      soDeliveredOrdersLoadingState: action.soDeliveredOrdersLoadingAction);
  }
  
  else if (action is SoOrderDetailAction ) {
    return state.copywith(
      soOrderDetailState: action.soOrderDetailAction);
  }
  
  else if (action is SoOrderDetailLoadingAction) {
    return state.copywith(
      soOrderDetailLoadingState: action.soOrderDetailLoadingAction);
  }


  ////////////////////// Driver Section ////////////////////////////
  else if (action is DriverDashboardAction ) {
    return state.copywith(
      driverHomeState: action.driverDashboardAction);
  }
  
  else if (action is DriverDashboardLoadingAction) {
    return state.copywith(
      driverHomeLoadingState: action.driverDashboardLoadingAction);
  }


  else if (action is DriverNewOrderAction ) {
    return state.copywith(
      driverNewOrderState: action.driverNewOrderAction);
  }
  
  else if (action is DriverNewOrderLoadingAction) {
    return state.copywith(
      driverNewOrderLoadingState: action.driverNewOrderLoadingAction);
  }

  else if (action is DriverProcessingOrderAction ) {
    return state.copywith(
      driverProcessingOrderState: action.driverProcessingOrderAction);
  }
  
  else if (action is DriverProcessingOrderLoadingAction) {
    return state.copywith(
      driverProcessingOrderLoadingState: action.driverProcessingOrderLoadingAction);
  }

  else if (action is DriverPickupOrderAction ) {
    return state.copywith(
      driverPickupOrderState: action.driverPickupOrderAction);
  }
  
  else if (action is DriverPickupOrderLoadingAction) {
    return state.copywith(
      driverPickupOrderLoadingState: action.driverPickupOrderLoadingAction);
  }

  else if (action is DriverDeliveredOrderAction ) {
    return state.copywith(
      driverDeliveredOrderState: action.driverDeliveredOrderAction);
  }
  
  else if (action is DriverDeliveredOrderLoadingAction) {
    return state.copywith(
      driverDeliveredOrderLoadingState: action.driverDeliveredOrderLoadingAction);
  }

  else if (action is DriverOrderDetailsAction ) {
    return state.copywith(
      driverOrderDetailsState: action.driverOrderDetailsAction);
  }
  
  else if (action is DriverOrderDetailsLoadingAction) {
    return state.copywith(
      driverOrderDetailsLoadingState: action.driverOrderDetailsLoadingAction);
  }

  ////////////////////// Driver Section ////////////////////////////
 
 

  return state;
}
