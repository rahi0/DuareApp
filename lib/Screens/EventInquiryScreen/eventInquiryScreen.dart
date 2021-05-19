import 'dart:convert';
import 'dart:io';
import 'package:duare/Api/api.dart';
import 'package:duare/Redux/state.dart';
import 'package:duare/RouteTransition/routeAnimation.dart';
import 'package:duare/Screens/LoginScreen/loginScreen.dart';
import 'package:duare/main.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'package:path/path.dart' as Path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:mime_type/mime_type.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'dart:async';


class EventInquiryScreen extends StatefulWidget {
  @override
  _EventInquiryScreenState createState() => _EventInquiryScreenState();
}

class _EventInquiryScreenState extends State<EventInquiryScreen> {
  TextEditingController nameController = TextEditingController();
  bool _isLoading = false;
  bool _isUpload = false;
  String path = "", doc = '';
  // File file;

  // List fileList = [];
  // int imgPercent = 1;

///////////////// Image Picker Essentials Start /////////////////////
var uploadImgbody;
  File _pickedImage;

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
    _processingDialog("Processing...");

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
        Navigator.pop(context);
        _showMsg("Something went wrong!", 1);
        setState(() {
          _isUpload = false;
        });
      } else if (response.statusCode == 200) {
        Navigator.pop(context);
        _showMsg("Picture upload successful!", 2);
        print(response.data);
        // var body = json.decode(response.data);
        // print(body);
        // print(body['image']);

        setState(() {
          _isUpload = false;
         // uploadImgbody = body['image'];
         uploadImgbody = response.data['image']; 
        });
      } else {
        Navigator.pop(context);
        _showMsg("Something went wrong!", 1);
        setState(() {
          _isUpload = false;
        });
      }
    }).catchError((error) => print(error));
  }
  //////////////////// upload image method start //////////////////////////////

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        ////// this is the connector which mainly changes state/ui
        converter: (store) => store.state,
        builder: (context, items) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
              centerTitle: true,
              title: Text(
                'Event Inquiry',
                style: TextStyle(
                  fontFamily: 'poppins',
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                margin:
                    EdgeInsets.only(right: 16, left: 16, top: 20, bottom: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'For Event Inquiry',
                        style: TextStyle(
                          fontFamily: 'poppins',
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    ////////////// text field start //////////////
                    Container(
                      margin: EdgeInsets.only(top: 20, bottom: 20),
                      decoration: BoxDecoration(
                        // color: Color(0xFFF0EFEF),
                        border: Border.all(
                          color: Color(0xFFDADADA),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        maxLines: null,
                        minLines: 3,
                        controller: nameController,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          hintText: "Product name...",
                          hintStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            color: Color(0xffB1B1B1),
                            fontFamily: 'poppins',
                          ),
                          contentPadding:
                              EdgeInsets.only(left: 18, top: 12, bottom: 11),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    ////////////// text field start //////////////

                    ///////////////// upload button start /////////////////
                  // _isUpload?
                  //    Container(
                  //                       padding: const EdgeInsets.all(12.0),
                  //                       margin: EdgeInsets.only(top: 20),
                  //                       decoration: BoxDecoration(
                  //                           shape: BoxShape.circle,
                  //                           border: Border.all(
                  //                               color: appColor, width: 2)),
                  //                       child: Padding(
                  //                         padding: const EdgeInsets.all(12.0),
                  //                         child: Text(
                  //                             imgPercent.toString() + "%"),
                  //                       )):
                  // // Container(
                  // //               height: 27,
                  // //               child: SpinKitThreeBounce(
                  // //                 color: appColor,
                  // //                 size: 30,
                  // //               ),
                  // //             ):
                                GestureDetector(
                      onTap: () {    
                        _pickImage();
                        // _pickFile();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(
                            top: 15, bottom: 15, left: 15, right: 15),
                        // margin: EdgeInsets.only(top: 10, bottom: 20),
                        decoration: BoxDecoration(
                          // color: Color(0xFF0487FF),
                          // gradient: SweepGradient(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF00B658),
                              // Color(0xFF00B658),
                              // Color(0xFF00B658),
                              // Color(0xFF00B658),
                              // Color(0xFF00B658),
                              Colors.white,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomCenter,
                            stops: [1, 1],
                            // startAngle: 0.9,
                            // endAngle: 1.2,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Upload Order List',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            Icon(
                              FlutterIcons.upload_fea,
                              color: Color(0xFF00B658),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ///////////////// upload button end /////////////////
                    /////////////// prescription file view start ///////////////
                      if (_pickedImage != null)
                        
                        Container(
                          height: MediaQuery.of(context).size.width/1.5,
                          width: MediaQuery.of(context).size.width/1.9,
                          color: Colors.red,
                          margin: EdgeInsets.only(top: 20, bottom: 30),
                          child:
                              //  _pickedImage == null
                              //     ?
                              //     Image.asset(
                              //         "assets/images/image 6 (8).png",
                              //       )
                              //     :
                              Image.file(_pickedImage, fit: BoxFit.cover,),
                        ),
                      /////////////// prescription file view end ///////////////
                    ///////////  file name start//////
                    // fileList.length == 0
                    //     ? Container()
                    //     : Container(
                    //         child: Column(
                             
                    //               children: List.generate(
                    //               fileList.length, 
                    //                 (index) {
                    //                 return Container(
                    //                   margin: EdgeInsets.only(top: 15),
                                   
                    //                   child: Row(
                    //                     children: [
                    //                      Icon(FlutterIcons.file1_ant),
                    //                       Expanded(
                    //                            child: Container(
                    //                              margin: EdgeInsets.only(left: 5),
                    //                             child: Text(
                    //                               fileList[0]['name'],
                    //                               style: TextStyle(
                    //                                 fontFamily: 'poppins',
                    //                                 color: Colors.black,
                    //                                 fontSize: 16,
                    //                                 fontWeight: FontWeight.w500,
                    //                               ),
                    //                             ),
                    //                           ),
                    //                       ),

                    //                       IconButton(
                    //                         icon: Icon(Icons.close), 
                    //                         onPressed: (){
                    //                           if (!mounted) return;
                    //                           setState(() {
                    //                             fileList.removeAt(index);
                    //                           });
                    //                         })
                    //                     ],
                    //                   ),
                    //                 );
                    //               }),
                    //             ),
                    //         //  ],            
                    //         //),
                    //       ),

                    //////////// Send button start ///////////
                    GestureDetector(
                      onTap: () {
                        _isLoading || _isUpload ? null : _sendInquiry();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(top: 15, bottom: 15),
                        margin: EdgeInsets.only(top: 40, bottom: 25),
                        
                        decoration: BoxDecoration(
                          color: _isUpload ?
                          Colors.grey[300]:Color(0xFF0487FF),

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
                                'Send',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    //////////// Send button end /////////////
                  ],
                ),
              ),
            ),
          );                       
        });
  }

//   Future<void> _pickFile() async {
//     var filePicked = await FilePicker.getFile(
//         type: FileType.custom,
//         allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg', 'PNG', 'doc']);
//     // var file = await ImagePicker.pickImage(
//     //     source: ImageSource.gallery, imageQuality: 80);
//     print(filePicked);
//     path = filePicked.path;
      
//     if (filePicked != null) {
//       file = filePicked;
//       print(file);
//       print("file");

//       _uploadImage(file);
//      // _uploadFile();
//       // setState(() {
//       //   fileList.add({'name': "1", 'file': file});    

//       //   print(fileList.length);
//       // });
//     } else {
//       print("not selected");
//     }

//     // setState(() {
//     //   isDocItemPressed = false;
//     // });
//   }



//       void _uploadImage(filePath) async {
//      if (this.mounted){
//     setState(() {
//       _isUpload = true;
//     });
//      }
//     print("path");
//     print(filePath.path);

//     try {
//       String fileName = Path.basename(filePath.path);
//       print("File base name: $fileName");
//       print("File path name: $filePath");
//        String mimeType = mime(fileName);
//   String mimee = mimeType.split('/')[0];
//   String type = mimeType.split('/')[1];
  
//       FormData formData = FormData.fromMap({
//         "file": await MultipartFile.fromFile(
//           filePath.path, filename: fileName,
//           contentType: MediaType(mimee,type)
//          // contentType: MediaType('image')//MediaType('image','jpg') 
//           ),
//       });
//       print("formData");
//       print(formData);                
//       imgPercent = 1;
//       var response = await Dio().post(
//               CallApi().uploadApiUrl()+'productmodule/upload/images',
//               data: formData,
//               options: Options(
//                 headers: await _setHeaders(),
//               ), 
//               onSendProgress: (int sent, int total) {
          
//               if (!mounted) return;
              
//                setState(() {

//                   imgPercent = ((sent / total) * 100).toInt();
                
//                   print("percent");
//                   print(imgPercent);
                   
//                 });
//       });
      
//       print("response");
//       print(response);
      
//      // print(response.data['url']);
//     //   var body = json.decode(response);
//     //  print(body);
//  //     print(response.data[0]['url']);
//       // if (_isCancelImg == true) {
//       //  setState(() {
//       //     _isCancelImg = false;
//       //  });
//       // }   
      
//       setState(() {
//              imgPercent = 100;
//             _isUpload = false;
//      });   

      
//     //  fileList.add(
//     //   image
//       //  );
           
//       // if ((imgList.length - imgNum) == len) {
//       //   setState(() {
//       //     imgPercent = 100;
//       //     _isImage = false;
//       //     imgNum = imgNum + len;
//       //   });
//       // }

//      // print(imgList);
//     } catch (e) {
//        print("Exception Caught: $e");
//     }
//   }

//     _setHeaders() async => {
//         "Authorization": 'Bearer ' + await _getToken(),
//       };

//        _getToken() async {
//     SharedPreferences localStorage = await SharedPreferences.getInstance();
//     print(localStorage.getString('token'));
//     return localStorage.getString('token');
//   }


///////////////////////////  upload start //////////////////


  // Future<void> _uploadFile() async {
  //   // setState(() {
  //   //   isFileUploading = true;
  //   // });

  //   // print(path);
  //   // print(file);

  //   _getToken() async {
  //     SharedPreferences localStorage = await SharedPreferences.getInstance();
  //     print(localStorage.getString('token'));
  //     return localStorage.getString('token');
  //   }

  //   // open a bytestream
  //   var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
  //   // get file length
  //   var length = await file.length();
  //   // string to uri
  //   var uri = Uri.parse(CallApi().uploadApiUrl() + "productmodule/upload/images");
  //   // create multipart request
  //   var request = new http.MultipartRequest("POST", uri);
  //   // multipart that takes file
  //   var multipartFile =
  //       new http.MultipartFile('image', stream, length, filename: "tt.txt");
  //   // add file to multipart
  //   request.headers['authorization'] = 'Bearer ' + await _getToken();
  //   request.files.add(multipartFile);
  //   // send
  //   var response = await request.send();
  //   print(response.statusCode);

  //   // listen for response
  //   response.stream.transform(utf8.decoder).listen((value) {
  //     //print(value);
  //     final body = json.decode(value);
  //     print(body);
  //     //  print(body['success']);
  //     //    if(body['status'] == 'Token is Expired'){
  //     //   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
  //     // }
  //    if (response.statusCode == 200) {
  //       print("Oise Upload");

  //     //  setState(() {
  //       //   uploadedDocData = body;
  //       //         isDocumentPressed = true;
  //       //   isDocAvailable = true;
  //       //   isFileUploading = false;
  //      //  });
  //       // refresh(2);
  //    //   Navigator.pop(context);
  //       //print(uploadedDocData);
  //     } else {
  //        print("Oise na Upload");
  //       // setState(() {
  //       //   isDocumentPressed = true;
  //       //   isDocAvailable = true;
  //       //   isFileUploading = false;
  //       // });
  //      // Navigator.pop(context);
  //     }
  //   });
  // }

///////////////////////////  upload end //////////////////

/////////////////  send button /////////////////
  Future<void> _sendInquiry() async {
    if (nameController.text.isEmpty) {
      return _showMsg('Name can\'t be empty!', 1);
    } else {
      if (!mounted) return;
      setState(() {
        _isLoading = true;
      });

      var data = {
        'user_id':store.state.userInfoState['id'],
        'details':nameController.text,
        'image': uploadImgbody
      };

      print(data);

//       setState(() {
//         _isLoading = false;
//       });
// return;
      var res = await CallApi()
          .postDataWithToken(data, 'usermodule/storeInquiry');
      var body = json.decode(res.body);
      print('body - $body');
      print('res.statusCode  - ${res.statusCode}');

      if (res.statusCode == 200) {
        _showMsg('Your inquiry request has been placed successfully!', 2);
        Navigator.of(context).pop();
      } else if (res.statusCode == 422) {
        _showMsg('Login Expired!', 2);
        Navigator.push(context, SlideLeftRoute(page: LoginScreen()));
      } else {
        _showMsg("Something went wrong!! Please Try Again", 1);
      }

      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
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
  
  ////////////// pROCESSING Dialog STart //////////
  Future<Null> _processingDialog(title) async {
    return showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      border: Border.all(color: Colors.white)),
                  padding: EdgeInsets.only(bottom: 20, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'quicksand',
                            color: Color(0xff003A5B),
                            fontWeight: FontWeight.w500,
                            fontSize: 18),
                      ),

                      Container(
                        margin: EdgeInsets.only(left: 10),
                        height: 15,
                        width: 15,
                        child: CircularProgressIndicator(strokeWidth: 2,))
                    ],
                  ),
                ),
                
              ],
            ),
          );
        });
  }
////////////// Proccessing Dialog End //////////
}
