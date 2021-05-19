import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:duare/Api/api.dart';
import 'package:duare/Models/ShopOwnerModels/ShopOwnerProductCategoriesModel.dart';
import 'package:duare/Redux/action.dart';
import 'package:duare/Redux/state.dart';
import 'package:duare/RouteTransition/routeAnimation.dart';
import 'package:duare/Screens/LoginScreen/loginScreen.dart';
import 'package:duare/ShopOwnerSection/ShopOwnerDrawer/ShopOwnerDrawer.dart';
import 'package:flutter/material.dart';
import 'package:duare/main.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopOwnerAddCategory extends StatefulWidget {
  @override
  _ShopOwnerAddCategoryState createState() => _ShopOwnerAddCategoryState();
}

class _ShopOwnerAddCategoryState extends State<ShopOwnerAddCategory> {
  TextEditingController categoryNameController = TextEditingController();

  bool _isLoading = false;

  List<String> catNames = [];
  // List<String> catNames = ['Select Category'];
  var catIds = [];

  var _currentCategorySelected;
  // var _currentCategorySelected = 'Select Category';
  var catId = -1;

  void _onDropDownCategorySelected(String newValueSelected) {
    setState(() {
      _currentCategorySelected = newValueSelected;
      print('_currentCategorySelected ----------------------- ');
      print(_currentCategorySelected);

      for (int i = 0; i < store.state.categoryNamesListState.length; i++) {
        if (_currentCategorySelected == store.state.categoryNamesListState[i]) {
          catId = store.state.categoryIdListState[i];
          print('catId -------------------- $catId');
          break;
        }
      }
    });
  }

  //////////////////////// add category start /////////////////////////////
  _addCategory() async {
    if (categoryNameController.text.isEmpty) {
      return _showMsg('Product category name can\'t be empty!', 1);
    }
    if (_currentCategorySelected == null) {
      return _showMsg('Category can\'t be empty!', 1);
    }

    setState(() {
      _isLoading = true;
    });

    var data = {
      'category_id': catId,
      'name': categoryNameController.text,
      'image': uploadImgbody == null
          ? "http://duareadmin.duare.net/img/photo.jpg"
          : uploadImgbody,
    };

    print('----------------------data---------------------');
    print(data);
    print('----------------------data---------------------');

    var res = await CallApi()
        .postDataWithToken(data, 'shopownermodule/addProductCategory');
    print('res - $res');
    var body = json.decode(res.body);
    print('body - $body');
    print('res.statusCode  - ${res.statusCode}');

    if (res.statusCode == 200) {
      _showMsg('Catgeory added successfully!', 2);
      Navigator.pop(context);
      var data = {
        'data': [body['data']],
      };
      print('data----------------------------');
      print(data);
      print('data-----------------------------');

      var productCategory =
          shopOwnerProductCategoriesModelFromJson(json.encode(data)).data;
      print('productCategory');
      print(productCategory);

      store.state.shopOwnerProductCategoriesState.add(productCategory[0]);
      store.dispatch(ShopOwnerProductCategoriesAction(
          store.state.shopOwnerProductCategoriesState));
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
  //////////////////////// add category end /////////////////////////////

  ////////////////// get categories list start ////////////////////
  _getAllCategories() async {
    store.dispatch(CategoryLoadingAction(true));
    var res = await CallApi().getDataWithToken('shopownermodule/getCategory');
    var body = json.decode(res.body);
    print(res.statusCode);
    print('body - $body');
    print('.....................');

    if (body['message'] == "You are not allowed to access this route... ") {
      _showMsg('Your login has expired!', 1);
      Navigator.pushReplacement(context, SlideLeftRoute(page: LoginScreen()));
    } ////////// checking if token is expired
    else if (res.statusCode == 200) {
      var allCategoryData = json.decode(res.body);

      var allCategory = allCategoryData['data'];
      print('allCategory - $allCategory');
      store.dispatch(CategoryListAction(allCategory));

      for (int i = 0; i < allCategory.length; i++) {
        catNames.add('${allCategory[i]['name']}');
        catIds.add(allCategory[i]['id']);

        print('catNames --- $catNames');

        store.dispatch(CategoryIdListAction(catIds));
        store.dispatch(CategoryNamesListAction(catNames));

        print('catNames store --- ${store.state.categoryNamesListState}');
      }
    } else if (res.statusCode == 401) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
    store.dispatch(CategoryLoadingAction(false));
  }
  ////////////////// get categories list end ////////////////////

///////////////// Image Picker Essentials Start /////////////////////
  File _pickedImage;
  bool _isUpload = false;
  var uploadImgbody;

  void _pickImage() async {
    final file = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() => _pickedImage = file);
      _uploadImage(_pickedImage);
    }
  }
  ///////////////// Image Picker Essentials End /////////////////////

  //////////////////// upload image method start //////////////////////////////
  Future<void> _uploadImage(filePath) async {
    setState(() {
      _isUpload = true;
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
          _isUpload = false;
        });
      } else if (response.statusCode == 200) {
        print("Oise Upload");

        setState(() {
          _isUpload = false;
          uploadImgbody = response.data['image'];
        });
      } else {
        print("Oise na Upload");
        setState(() {
          _isUpload = false;
        });
      }
    }).catchError((error) => print('error == $error'));
  }
  //////////////////// upload image method start //////////////////////////////

  ///
  @override
  void initState() {
    _getAllCategories();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      ////// this is the connector which mainly changes state/ui
      converter: (store) => store.state,
      builder: (context, items) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: appColor,
            title: Text(
              'Add Product Category',
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
              child: store.state.categoryLoading
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
                        /////////////////// category id dropdown start ///////////////////
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
                                  'Select Category',
                                  style: TextStyle(
                                    color: Color(0xffB1B1B1),
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
                                value: _currentCategorySelected,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontFamily: 'poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                                items: catNames.map((var value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (var newValueSelected) {
                                  _onDropDownCategorySelected(newValueSelected);
                                  print(newValueSelected);
                                }),
                          ),
                        ),
                        /////////////////// category id dropdown end ///////////////////

                        //////////////// category name start ///////////////////
                        Container(
                          margin: EdgeInsets.only(bottom: 10, top: 15),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xFFDADADA),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextField(
                            controller: categoryNameController,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              labelText: "Product Category Name",
                              contentPadding: EdgeInsets.only(
                                  left: 18, top: 15, bottom: 14),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        //////////////// category name end ///////////////////

                        ///////////////////// Category image start ///////////////////
                        GestureDetector(
                          onTap: () {
                            _pickImage();
                          },
                          child: Container(
                            margin: EdgeInsets.all(10),
                            width: 250,
                            height: 200,
                            child: _pickedImage != null
                                ? Image.file(
                                    _pickedImage,
                                    fit: BoxFit.cover,
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
                        //////////////////// Category image end ///////////////////

                        ////////////////////// Add Category button start //////////////////////
                        GestureDetector(
                          onTap: () {
                            _isLoading ? null : _addCategory();
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
                                    'Add Product Category',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                        ////////////////////// Add Category button end //////////////////////
                      ],
                    ),
            ),
          ),
        );
      },
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
