import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:duare/Api/api.dart';
import 'package:duare/Redux/action.dart';
import 'package:duare/RouteTransition/routeAnimation.dart';
import 'package:duare/Screens/LoginScreen/loginScreen.dart';
import 'package:duare/ShopOwnerSection/ShopOwnerDrawer/ShopOwnerDrawer.dart';
import 'package:duare/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopOwnerProductEditPage extends StatefulWidget {
  var productId;

  ShopOwnerProductEditPage(this.productId);

  @override
  _ShopOwnerProductEditPageState createState() =>
      _ShopOwnerProductEditPageState();
}

class _ShopOwnerProductEditPageState extends State<ShopOwnerProductEditPage> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();
  TextEditingController productSizeController = TextEditingController();
  TextEditingController productCompanyController = TextEditingController();
  TextEditingController productBoughtPriceController = TextEditingController();
  TextEditingController productSalePriceController = TextEditingController();
  TextEditingController productDiscountController = TextEditingController();
  TextEditingController productWarrantyController = TextEditingController();

  bool _isLoading = false;
  bool mustPrescribed = false;
  var otherImages = [];

  /////////////////////////// brand dropdown start ////////////////////////
  List<String> brandNames = [];
  var brandIds = [];
  var _currentBrandSelected;
  var brandId = -1;

  void _onDropDownBrandSelected(String newValueSelected) {
    setState(() {
      _currentBrandSelected = newValueSelected;
      print('_currentBrandSelected ----------------------- ');
      print(_currentBrandSelected);

      for (int i = 0; i < store.state.soBrandNamesListState.length; i++) {
        if (_currentBrandSelected == store.state.soBrandNamesListState[i]) {
          brandId = store.state.soBrandIdsListState[i];
          print('brandId -------------------- $brandId');
          break;
        }
      }
    });
  }
  /////////////////////////// brand dropdown end ////////////////////////

  /////////////////////////// restaurant menu category dropdown start ////////////////////////
  List<String> menuCatNames = [];
  var menuCatIds = [];
  var _currentMenuCategorySelected;
  var menuCatId = -1;

  void _onDropDownMenuCategorySelected(String newValueSelected) {
    setState(() {
      _currentMenuCategorySelected = newValueSelected;
      print('_currentMenuCategorySelected ----------------------- ');
      print(_currentMenuCategorySelected);

      for (int i = 0; i < store.state.soMenuCategoriesState.length; i++) {
        if (_currentMenuCategorySelected ==
            store.state.soMenuCategoriesState[i]['category_name']) {
          menuCatId = store.state.soMenuCategoriesState[i]['id'];
          print('menuCatId -------------------- $menuCatId');
          break;
        }
      }
    });
  }
  /////////////////////////// restaurant menu category dropdown end ////////////////////////

  /////////////////////////// product category dropdown start ////////////////////////
  List<String> productCatNames = [];
  var productCatIds = [];
  var _currentProductCategorySelected;
  var productCatId = -1;

  void _onDropDownProductCategorySelected(String newValueSelected) {
    setState(() {
      _currentProductCategorySelected = newValueSelected;
      print('_currentProductCategorySelected ----------------------- ');
      print(_currentProductCategorySelected);

      for (int i = 0;
          i < store.state.shopOwnerProductCategoriesState.length;
          i++) {
        if (_currentProductCategorySelected ==
            store.state.shopOwnerProductCategoriesState[i]['name']) {
          productCatId = store.state.shopOwnerProductCategoriesState[i]['id'];
          print('productCatId -------------------- $productCatId');
          break;
        }
      }
    });
  }
  /////////////////////////// product category dropdown end ////////////////////////

  /////////////////////////// product sub category dropdown start ////////////////////////
  List<String> productSubCatNames = [];
  var productSubCatIds = [];
  var _currentProductSubCategorySelected;
  var productSubCatId = -1;

  void _onDropDownProductSubCategorySelected(String newValueSelected) {
    setState(() {
      _currentProductSubCategorySelected = newValueSelected;
      print('_currentProductSubCategorySelected ----------------------- ');
      print(_currentProductSubCategorySelected);

      for (int i = 0; i < store.state.soProductSubCategoriesState.length; i++) {
        if (_currentProductSubCategorySelected ==
            store.state.soProductSubCategoriesState[i]['name']) {
          productSubCatId = store.state.soProductSubCategoriesState[i]['id'];
          print('productSubCatId -------------------- $productSubCatId');
          break;
        }
      }
    });
  }
  /////////////////////////// product sub category dropdown end ////////////////////////

///////////////// Image Picker Essentials Start /////////////////////
  File _pickedImage;
  bool _isUpload = false;
  bool _isUploadOthers = false;
  var uploadImgbody;

  void _pickImage(var type) async {
    final file = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() => _pickedImage = file);
      _uploadImage(_pickedImage, type);
    }
  }
  ///////////////// Image Picker Essentials End /////////////////////

  //////////////////// upload image method start //////////////////////////////
  Future<void> _uploadImage(filePath, type) async {
    setState(() {
      type == 'cover' ? _isUpload = true : _isUploadOthers = true;
    });

    _getToken() async {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      print(localStorage.getString('token'));
      return localStorage.getString('token');
    }

    String fileName = filePath.path.split('/').last;
    FormData dataa = FormData.fromMap({
      "image": await MultipartFile.fromFile(
        filePath.path,
        filename: fileName,
      ),
    });

    Dio dio = new Dio();
    ///// Add header to dio
    dio.options.headers["Authorization"] = 'Bearer ' + await _getToken();
    //// parsing url
    var uri =
        Uri.parse(CallApi().uploadApiUrl() + "shopownermodule/uploadImage");
    //// posting image
    dio.post("$uri", data: dataa).then((response) async {
      if (response.statusCode != 200) {
        print("Oise na Upload");
        setState(() {
          type == 'cover' ? _isUpload = false : _isUploadOthers = false;
        });
      } else if (response.statusCode == 200) {
        print("Oise Upload");

        setState(() {
          type == 'cover' ? _isUpload = false : _isUploadOthers = false;
          if (type == 'cover')
            uploadImgbody = response.data['image'];
          else
            otherImages.add(response.data['image']);
        });
      } else {
        print("Oise na Upload");
        setState(() {
          type == 'cover' ? _isUpload = false : _isUploadOthers = false;
        });
      }
    }).catchError((error) => print('error == $error'));
  }
  //////////////////// upload image method end //////////////////////////////

  ////////////////// get brands list start ////////////////////
  _getAllBrands() async {
    var res = await CallApi().getDataWithToken('shopownermodule/getBrands');
    var body = json.decode(res.body);
    print(res.statusCode);
    print('body - $body');
    print('.....................');

    if (body['message'] == "You are not allowed to access this route... ") {
      _showMsg('Your login has expired!', 1);
      Navigator.pushReplacement(context, SlideLeftRoute(page: LoginScreen()));
    } ////////// checking if token is expired
    else if (res.statusCode == 200) {
      var allBrandData = json.decode(res.body);

      var allBrand = allBrandData['data'];
      print('allBrand - $allBrand');

      for (int i = 0; i < allBrand.length; i++) {
        brandNames.add('${allBrand[i]['name']}');
        brandIds.add(allBrand[i]['id']);

        store.dispatch(SoBrandIdsListAction(brandIds));
        store.dispatch(SoBrandNamesListAction(brandNames));

        print('brandNames store --- ${store.state.soBrandNamesListState}');
      }
    } else if (res.statusCode == 401) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }
  ////////////////// get brands list end ////////////////////

  ///////////////// get ProductCategories start /////////////////
  _getAllProductCategories() async {
    store.dispatch(SoProductCategoriesLoadingAction(true));

    var res = await CallApi().getDataWithTokenandQuery(
        'shopownermodule/getAllProductCategory',
        '&category_id=${store.state.soShopCategoryState['id']}');
    print('res - $res');
    var body = json.decode(res.body);
    print('body - $body');
    print('.....................');

    if (res.statusCode == 200) {
      var productCategories = body['data'];

      store.dispatch(ShopOwnerProductCategoriesAction(productCategories));

      for (int i = 0; i < productCategories.length; i++) {
        productCatNames.add('${productCategories[i]['name']}');
        productCatIds.add(productCategories[i]['id']);

        print('productCatNames --- $productCatNames');
      }
    } else if (res.statusCode == 401) {
      _showMsg("Login expired!", 1);
      Navigator.push(context, SlideLeftRoute(page: LoginScreen()));
    } else {
      _showMsg("Something went wrong", 1);
    }

    _getAllBrands();
    _getRestaurantMenuCategories();
    _getProductDetails();
    store.dispatch(SoProductCategoriesLoadingAction(false));
  }
  ///////////////// get ProductCategories end /////////////////

  ///////////////// get Product sub Categories start /////////////////
  _getProductSubCategories() async {
    store.dispatch(SoProductSubCategoriesLoadingAction(true));

    var res = await CallApi().getDataWithTokenandQuery(
        'shopownermodule/getAllProductSubCategory',
        '&product_category_id=$productCatId');

    print('res - $res');
    var body = json.decode(res.body);
    print('body - $body');
    print('.....................');

    if (res.statusCode == 200) {
      var productSubCategories = body['data'];

      store.dispatch(SoProductSubCategoriesAction(productSubCategories));

      for (int i = 0; i < productSubCategories.length; i++) {
        productSubCatNames.add('${productSubCategories[i]['name']}');
        productSubCatIds.add(productSubCategories[i]['id']);

        print('productSubCatNames --- $productSubCatNames');
      }
    } else if (res.statusCode == 401) {
      _showMsg("Login expired!", 1);
      Navigator.push(context, SlideLeftRoute(page: LoginScreen()));
    } else {
      _showMsg("Something went wrong", 1);
    }

    store.dispatch(SoProductSubCategoriesLoadingAction(false));
  }
  ///////////////// get Product sub Categories end /////////////////

  ///////////////// get Restaurant menuCategories start /////////////////
  _getRestaurantMenuCategories() async {
    var res = await CallApi().getDataWithTokenandQuery(
        'shopownermodule/getRestaurantMenuCategories', '');

    print('res - $res');
    var body = json.decode(res.body);
    print('body - $body');
    print('.....................');

    if (res.statusCode == 200) {
      var menuCategories = body['data'];

      store.dispatch(SoMenuCategoriesAction(menuCategories));

      for (int i = 0; i < menuCategories.length; i++) {
        menuCatNames.add('${menuCategories[i]['category_name']}');
        menuCatIds.add(menuCategories[i]['id']);

        print('menuCatNames --- $menuCatNames');
      }
    } else if (res.statusCode == 401) {
      _showMsg("Login expired!", 1);
      Navigator.push(context, SlideLeftRoute(page: LoginScreen()));
    } else {
      _showMsg("Something went wrong", 1);
    }
  }
  ///////////////// get Restaurant menu Categories end /////////////////

  @override
  void initState() {
    store.dispatch(SoProductSubCategoriesLoadingAction(false));
    _getAllProductCategories();
    // TODO: implement initState
    super.initState();
  }

  ///////////////////// get product details start ////////////////////////
  _getProductDetails() async {
    var res = await CallApi().getDataWithTokenandQuery(
        'shopownermodule/getProductDetails', '&id=${widget.productId}');

    print('res - $res');
    var body = json.decode(res.body);
    print('body - $body');
    print('.....................');

    if (res.statusCode == 200) {
      store.dispatch(SoProductDetailsAction(body['data']));

      setState(() {
        if (body['data']['restaurant_menu_category'] != null) {
          menuCatId = body['data']['restaurant_menu_category']['id'];
          _currentMenuCategorySelected =
              body['data']['restaurant_menu_category']['category_name'];
        }
        if (body['data']['brand'] != null) {
          brandId = body['data']['brand']['id'];
          _currentBrandSelected = body['data']['brand']['name'];
        }
        if (body['data']['category'] != null) {
          productCatId = body['data']['category']['id'];
          _currentProductCategorySelected = body['data']['category']['name'];
        }
        if (body['data']['sub_category'] != null) {
          productSubCatId = body['data']['sub_category']['id'];
          _currentProductSubCategorySelected =
              body['data']['sub_category']['name'];
        }
        productNameController.text = '${body['data']['name']}';
        productDescriptionController.text = '${body['data']['description']}';
        productDiscountController.text = '${body['data']['percentage']}';
        productWarrantyController.text = body['data']['warranty'] == null
            ? ""
            : '${body['data']['warranty']}';
        uploadImgbody = body['data']['image'];
        otherImages = body['data']['photo'].map((obj) => obj['image']).toList();
        mustPrescribed = body['data']['must_prescribed'] == 0 ? false : true;
      });
    } else if (res.statusCode == 401) {
      _showMsg("Login expired!", 1);
      Navigator.push(context, SlideLeftRoute(page: LoginScreen()));
    } else {
      _showMsg("Something went wrong", 1);
    }
  }
  ///////////////////// get product details end ////////////////////////

  ////////////////// edit product method start ////////////////////////
  _editProduct() async {
    if (productNameController.text.isEmpty) {
      return _showMsg('Sub category name can\'t be empty!', 1);
    }
    if (uploadImgbody == null) {
      return _showMsg('Product cover image can\'t be empty!', 1);
    }
    if (store.state.soShopCategoryState['id'] == 3) {
      if (menuCatId == -1)
        return _showMsg('Restaurant menu category can\'t be empty!', 1);
    } else {
      if (productCatId == -1)
        return _showMsg('Product category can\'t be empty!', 1);
      if (productSubCatId == -1)
        return _showMsg('Product sub category can\'t be empty!', 1);
    }

    setState(() {
      _isLoading = true;
    });

    var data = {
      'product_id': widget.productId,
      'name': productNameController.text,
      'description': productDescriptionController.text,
      'cover_image': uploadImgbody,
      'category_id': store.state.soShopCategoryState['id'],
      'product_category_id': productCatId == -1 ? 0 : productCatId,
      'product_subcategory_id': productSubCatId == -1 ? 0 : productSubCatId,
      'restaurant_category_id': menuCatId == -1 ? 0 : menuCatId,
      'brand_id': brandId,
      'isFeatured': 0,
      'must_prescribed': mustPrescribed ? 1 : 0,
      'discount_percentage': productDiscountController.text,
      'warranty': productWarrantyController.text,
      'other_images': otherImages,
    };

    print('----------------------data---------------------');
    print(data);
    print('----------------------data---------------------');

    var res =
        await CallApi().postDataWithToken(data, 'shopownermodule/editProduct');
    print('res - $res');
    var body = json.decode(res.body);
    print('body - $body');
    print('res.statusCode  - ${res.statusCode}');

    if (res.statusCode == 200) {
      _showMsg('Product updated successfully!', 2);

      for (int i = 0; i < store.state.soProductsListState.length; i++) {
        if (store.state.soProductsListState[i]['id'] == widget.productId) {
          store.state.soProductsListState[i] = body['data'];
          break;
        }
      }
      store.dispatch(SoProductsListAction(store.state.soProductsListState));
      Navigator.pop(context);
    } else if (res.statusCode == 401) {
      _showMsg("Login expired!", 1);
      Navigator.push(context, SlideLeftRoute(page: LoginScreen()));
    } else {
      _showMsg('Something went wrong!', 1);
    }

    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
  }
  ////////////////// edit product method end ////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: ShopOwnerDrawer(),
      appBar: AppBar(
        backgroundColor: appColor,
        title: Text(
          'Edit Product',
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
          child: store.state.soProductCategoriesLoadingState
              ?
              //////////////////// progress inidcator start //////////////////////
              Center(
                  child: Container(
                    child: SpinKitCircle(
                      color: Color(0xFF0487FF),
                    ),
                  ),
                )
              ////////////////////// progress inidcator end //////////////////////
              : Column(
                  children: [
                    //////////////// product name start ///////////////////
                    buildTextFieldContainer("Product Name", TextInputType.text,
                        productNameController),
                    //////////////// product name end ///////////////////

                    //////////////// product Description start ///////////////////
                    buildTextFieldContainer("Product Description",
                        TextInputType.text, productDescriptionController),
                    //////////////// product Description end ///////////////////

                    //////////////// product warranty start ///////////////////
                    buildTextFieldContainer("Warranty", TextInputType.text,
                        productWarrantyController),
                    //////////////// product warranty end ///////////////////

                    //////////////// product Discount Percentage start ///////////////////
                    buildTextFieldContainer(
                        "Discount Percentage",
                        TextInputType.numberWithOptions(),
                        productDiscountController),
                    //////////////// product Discount Percentage  end ///////////////////

                    /////////////////// brand id dropdown start ///////////////////
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(bottom: 10, top: 15),
                      padding: EdgeInsets.only(
                          bottom: 5, top: 5, right: 10, left: 18),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xFFDADADA),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                            hint: Text(
                              'Select Product Brand',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 17,
                                fontFamily: 'poppins',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            icon: Container(
                              margin: EdgeInsets.only(top: 0, left: 5),
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.black,
                                size: 25,
                              ),
                            ),
                            value: _currentBrandSelected,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w500,
                            ),
                            items: brandNames.map((var value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                ),
                              );
                            }).toList(),
                            onChanged: (var newValueSelected) {
                              _onDropDownBrandSelected(newValueSelected);
                              print(newValueSelected);
                            }),
                      ),
                    ),
                    /////////////////// brand id dropdown end ///////////////////

                    store.state.soShopCategoryState['id'] == 3
                        ?
                        /////////////////// RestaurantMenuCategory dropdown start ///////////////////
                        Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(bottom: 10, top: 15),
                            padding: EdgeInsets.only(
                                bottom: 5, top: 5, right: 10, left: 18),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xFFDADADA),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                  hint: Text(
                                    'Select Menu Category',
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 17,
                                      fontFamily: 'poppins',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  icon: Container(
                                    margin: EdgeInsets.only(top: 0, left: 5),
                                    child: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.black,
                                      size: 25,
                                    ),
                                  ),
                                  value: _currentMenuCategorySelected,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontFamily: 'poppins',
                                    fontWeight: FontWeight.w500,
                                  ),
                                  items: menuCatNames.map((var value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (var newValueSelected) {
                                    _onDropDownMenuCategorySelected(
                                        newValueSelected);
                                    print(newValueSelected);
                                  }),
                            ),
                          )
                        :
                        /////////////////// RestaurantMenuCategory dropdown end ///////////////////

                        Column(
                            children: [
                              /////////////////// product category id dropdown start ///////////////////
                              Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(bottom: 10, top: 15),
                                padding: EdgeInsets.only(
                                    bottom: 5, top: 5, right: 10, left: 18),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color(0xFFDADADA),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                      hint: Text(
                                        'Select Product Category',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 17,
                                          fontFamily: 'poppins',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      icon: Container(
                                        margin:
                                            EdgeInsets.only(top: 0, left: 5),
                                        child: Icon(
                                          Icons.keyboard_arrow_down,
                                          color: Colors.black,
                                          size: 25,
                                        ),
                                      ),
                                      value: _currentProductCategorySelected,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 17,
                                        fontFamily: 'poppins',
                                        fontWeight: FontWeight.w500,
                                      ),
                                      items: productCatNames.map((var value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (var newValueSelected) {
                                        _onDropDownProductCategorySelected(
                                            newValueSelected);
                                        print(newValueSelected);
                                        _getProductSubCategories();
                                      }),
                                ),
                              ),
                              /////////////////// Product category id dropdown end ///////////////////

                              ///
                              store.state.soProductSubCategoriesLoadingState
                                  ? Container(
                                      alignment: Alignment.topCenter,
                                      margin:
                                          EdgeInsets.only(bottom: 8, top: 30),
                                      child: Text(
                                        "Please wait to select Sub-Category...",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: appColor,
                                          fontFamily: 'poppins',
                                          fontSize: 15,
                                        ),
                                      ),
                                    )
                                  :
                                  /////////////////// product sub category id dropdown start ///////////////////
                                  Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin:
                                          EdgeInsets.only(bottom: 10, top: 15),
                                      padding: EdgeInsets.only(
                                          bottom: 5,
                                          top: 5,
                                          right: 10,
                                          left: 18),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Color(0xFFDADADA),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                            onTap: () {
                                              print('tap');
                                            },
                                            hint: Text(
                                              productSubCatNames.length == 0
                                                  ? 'No Sub Categories Found'
                                                  : 'Select Product Sub Category',
                                              style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 17,
                                                fontFamily: 'poppins',
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            icon: Container(
                                              margin: EdgeInsets.only(
                                                  top: 0, left: 5),
                                              child: Icon(
                                                Icons.keyboard_arrow_down,
                                                color:
                                                    productSubCatNames.length ==
                                                            0
                                                        ? Colors.grey
                                                        : Colors.black,
                                                size: 25,
                                              ),
                                            ),
                                            value:
                                                _currentProductSubCategorySelected,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 17,
                                              fontFamily: 'poppins',
                                              fontWeight: FontWeight.w500,
                                            ),
                                            // iconDisabledColor: Colors.grey[200],
                                            items: productSubCatNames
                                                .map((var value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(
                                                  value,
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (var newValueSelected) {
                                              _onDropDownProductSubCategorySelected(
                                                  newValueSelected);
                                              print(newValueSelected);
                                            }),
                                      ),
                                    ),
                              /////////////////// Product sub category id dropdown end ///////////////////
                            ],
                          ),

                    store.state.soShopCategoryState['id'] != 4
                        ? Container()
                        :
                        /////////////////////// Medicine prescription required on purchase start //////////////////
                        Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    left: 10, top: 10, bottom: 5),
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Text(
                                      'Requires Prescription',
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 17,
                                        fontFamily: 'poppins',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          mustPrescribed = true;
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            'Yes',
                                            style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 17,
                                              fontFamily: 'poppins',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(5),
                                            child: Icon(
                                              mustPrescribed
                                                  ? Icons
                                                      .radio_button_checked_outlined
                                                  : Icons
                                                      .radio_button_unchecked_outlined,
                                              color: mustPrescribed
                                                  ? Color(0xFF00B658)
                                                  : Color(0xFFDADADA),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          mustPrescribed = false;
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            'No',
                                            style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 17,
                                              fontFamily: 'poppins',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(5),
                                            child: Icon(
                                              !mustPrescribed
                                                  ? Icons
                                                      .radio_button_checked_outlined
                                                  : Icons
                                                      .radio_button_unchecked_outlined,
                                              color: !mustPrescribed
                                                  ? Color(0xFF00B658)
                                                  : Color(0xFFDADADA),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                    /////////////////////// Medicine prescription required on purchase end //////////////////

                    ///////////////////// product cover image start ///////////////////
                    Container(
                      margin: EdgeInsets.all(10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Product Cover Image:',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 17,
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    ///
                    GestureDetector(
                      onTap: () {
                        _pickImage('cover');
                      },
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: uploadImgbody != null
                            ? Container(
                                padding: EdgeInsets.all(5),
                                height: 195,
                                width: 205,
                                child: Center(
                                  child: Image.network(
                                    '$uploadImgbody',
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, progress) {
                                      return progress == null
                                          ? child
                                          : LinearProgressIndicator();
                                    },
                                  ),
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    child: Icon(
                                      FlutterIcons.upload_ent,
                                      color: Colors.black87,
                                      size: 30,
                                    ),
                                  ),
                                  Text(
                                    'Upload Image',
                                    style: TextStyle(
                                      color: Color(0xffB1B1B1),
                                      fontFamily: 'poppins',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    //////////////////// product cover image start ///////////////////

                    ///////////////////// product images start ///////////////////
                    Container(
                      margin: EdgeInsets.all(10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Other Product Images:',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 17,
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    ///
                    GestureDetector(
                      onTap: () {
                        _pickImage('other');
                      },
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ////
                            otherImages.length == 0
                                ? Container()
                                : Container(
                                    alignment: Alignment.centerLeft,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Wrap(
                                        children: List.generate(
                                            otherImages.length, (index) {
                                          return Container(
                                            margin: EdgeInsets.only(top: 15),
                                            child: Stack(
                                              children: [
                                                Container(
                                                    padding: EdgeInsets.all(5),
                                                    height: 95,
                                                    width: 105,
                                                    child: Image.network(
                                                      '${otherImages[index]}',
                                                      fit: BoxFit.cover,
                                                      loadingBuilder: (context,
                                                          child, progress) {
                                                        return progress == null
                                                            ? child
                                                            : LinearProgressIndicator();
                                                      },
                                                    )),
                                                Positioned(
                                                  right: 0,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white54,
                                                      // shape:
                                                      //     BoxShape.circle,
                                                    ),
                                                    child: IconButton(
                                                        icon: Icon(Icons.close),
                                                        onPressed: () {
                                                          if (!mounted) return;
                                                          setState(() {
                                                            otherImages
                                                                .removeAt(
                                                                    index);
                                                          });
                                                        }),
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        }),
                                      ),
                                    ),
                                  ),
                            ////
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Icon(
                                FlutterIcons.upload_ent,
                                color: Colors.black87,
                                size: 30,
                              ),
                            ),
                            Text(
                              'Upload Images',
                              style: TextStyle(
                                color: Color(0xffB1B1B1),
                                fontFamily: 'poppins',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    //////////////////// product images start ///////////////////

                    ////////////////////// Continue button start //////////////////////
                    GestureDetector(
                      onTap: () {
                        _isLoading ? null : _editProduct();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(top: 15, bottom: 15),
                        margin: EdgeInsets.only(top: 20, bottom: 20),
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
                                'Continue',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    ////////////////////// Continue button end //////////////////////
                  ],
                ),
        ),
      ),
    );
  }

  Container buildTextFieldContainer(
      var label, var textInputTyp, var controller) {
    return Container(
      margin: EdgeInsets.only(bottom: 10, top: 15),
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0xFFDADADA),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextField(
        controller: controller,
        keyboardType: textInputTyp,
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'poppins',
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: label,
          contentPadding: EdgeInsets.only(left: 18, top: 15, bottom: 14),
          border: InputBorder.none,
        ),
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
