import 'dart:convert';
import 'dart:io';

import 'package:duare/Models/ShopOwnerModels/SoProductSubCategoriesModel.dart';
import 'package:duare/Redux/action.dart';
import 'package:duare/RouteTransition/routeAnimation.dart';
import 'package:duare/Screens/LoginScreen/loginScreen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart' as Path;
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:duare/Api/api.dart';
import 'package:flutter/material.dart';
import 'package:duare/main.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopOwnerAddSubCategory extends StatefulWidget {
  var productCategoryId;

  ShopOwnerAddSubCategory(this.productCategoryId);

  @override
  _ShopOwnerAddSubCategoryState createState() =>
      _ShopOwnerAddSubCategoryState();
}

class _ShopOwnerAddSubCategoryState extends State<ShopOwnerAddSubCategory> {
  TextEditingController subCategoryNameController = TextEditingController();

  bool _isLoading = false;

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
        print(response.data);
        print('response.data');
        print(response.data['image']);
        // var body = json.decode(response.data);
        // print('body -- $body');
        // print(body['image']);

        setState(() {
          _isUpload = false;
          // uploadImgbody = body['image'];
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

  //////////////////////// add sub category start /////////////////////////////
  _addSubCategory() async {
    if (subCategoryNameController.text.isEmpty) {
      return _showMsg('Sub category name can\'t be empty!', 1);
    }

    setState(() {
      _isLoading = true;
    });

    var data = {
      'name': subCategoryNameController.text,
      'image': uploadImgbody == null
          ? "http://duareadmin.duare.net/img/photo.jpg"
          : uploadImgbody,
      'product_category_id': widget.productCategoryId,
    };

    print('----------------------data---------------------');
    print(data);
    print('----------------------data---------------------');

    var res = await CallApi()
        .postDataWithToken(data, 'shopownermodule/addProductSubCategory');
    print('res - $res');
    var body = json.decode(res.body);
    print('body - $body');
    print('res.statusCode  - ${res.statusCode}');

    if (res.statusCode == 200) {
      _showMsg('Sub catgeory added successfully!', 2);
      Navigator.pop(context);
      var data = {
        'data': [body['data']],
      };
      // print('data----------------------------');
      // print(data);
      // print('data-----------------------------');

      var productSubCategory =
          soProductSubCategoriesModelFromJson(json.encode(data)).data;
      // print('productSubCategory');
      // print(productSubCategory);
      store.state.soProductSubCategoriesState.add(productSubCategory[0]);
      store.dispatch(SoProductSubCategoriesAction(
          store.state.soProductSubCategoriesState));
    } else if (res.statusCode == 401) {
      _showMsg("Login expired!", 1);
      Navigator.push(context, SlideLeftRoute(page: LoginScreen()));
    } else {
      // _showMsg(body['message'], 1);
      _showMsg('Something went wrong!', 1);
    }

    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
  }
  //////////////////////// add sub category end /////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor,
        title: Text(
          'Add Sub Category',
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
              //////////////// sub category name start ///////////////////
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
                  controller: subCategoryNameController,
                  keyboardType: TextInputType.text,
                  // obscureText: true,
                  style: TextStyle(
                    color: Color(0xffB1B1B1),
                    fontFamily: 'poppins',
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    labelText: "Sub Category Name",
                    contentPadding:
                        EdgeInsets.only(left: 18, top: 15, bottom: 14),
                    border: InputBorder.none,
                  ),
                ),
              ),
              //////////////// sub category name end ///////////////////

              ///////////////////// Sub Category image start ///////////////////
              GestureDetector(
                onTap: () {
                  _pickImage();
                },
                child: Container(
                  margin: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width/1.6,
                  height: MediaQuery.of(context).size.width/1.6,
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
              //////////////////// Sub Category image end ///////////////////

              ////////////////////// Add Sub Category button start //////////////////////
              GestureDetector(
                onTap: () {
                  _isLoading ? null : _addSubCategory();
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
                          'Add Sub Category',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              ////////////////////// Add Sub Category button end //////////////////////
            ],
          ),
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
