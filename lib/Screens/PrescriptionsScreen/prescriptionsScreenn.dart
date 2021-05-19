import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:duare/Api/api.dart';
import 'package:duare/ImageShowScreen/imageShowScreen.dart';
import 'package:duare/Redux/action.dart';
import 'package:duare/Redux/state.dart';
import 'package:duare/RouteTransition/routeAnimation.dart';
import 'package:duare/Screens/LoginScreen/loginScreen.dart';
import 'package:duare/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrescriptionsScreen extends StatefulWidget {
  @override
  _PrescriptionsScreenState createState() => _PrescriptionsScreenState();
}

class _PrescriptionsScreenState extends State<PrescriptionsScreen> {
  TextEditingController titleController = new TextEditingController();

  bool _showAddPrescription = false;
  bool _isUpload = false;
  bool _isEdit = false;
  var uploadImgbody;
  var editID;
  var editImage;

///////////////// Image Picker Essentials Start /////////////////////
  File _pickedImage;

  void _pickImage() async {
    final file = await ImagePicker.pickImage(source: ImageSource.camera);
    if (file != null) {
      setState(() => _pickedImage = file);
       _uploadImage(_pickedImage);     
    }
  }
  ///////////////// Image Picker Essentials End /////////////////////
  

  @override
  void initState() {
   _getAllPresscription();
    super.initState();
  }

  // ///////////////// get Presscriptions start /////////////////
  _getAllPresscription() async {
    store.dispatch(PrescriptionListLoadingAction(true));

    var res = await CallApi().getDataWithToken('ordermodule/getAllPrescription');
     var body = json.decode(res.body);
    // print(res.statusCode);
    // print('body - $body');
    // print('.....................');

    if (body['message'] == "You are not allowed to access this route... ") {
      _showMsg('Your login has expired!', 1);
      Navigator.pushReplacement(context, SlideLeftRoute(page: LoginScreen()));

    } ////////// checking if token is expired
    else if (res.statusCode == 200) {
      var body = json.decode(res.body); 
      print(body);
       store.dispatch(PrescriptionListAction(body['data']));
       

    } else if (res.statusCode == 401) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else {
      _showMsg('Something went wrong!', 1);
    }
     store.dispatch(PrescriptionListLoadingAction(false));
  }
  // ///////////////// get Presscriptions end /////////////////

  // //////////////////// upload image method start ////////////////////////////// 
  // _uploadImage(File filePath) async {
  //   print(filePath);
  //   print('from profile img upload method');

  //   String fileName = Path.basename(filePath.path);
  //   print(fileName);

  //   try {
  //     FormData formData = new FormData.fromMap({
  //       "file": await MultipartFile.fromFile(filePath.path, filename: fileName)
  //     });

  //     print('dat######## start-------->');
  //     print(formData);
  //     print('dat######## end-------->');

  //     Response response = await Dio().post(
  //       'https://mobile.hombolttech.net/profile_upload',
  //       data: formData,
  //     );
  //     print('---------dio response----------------');
  //     print(response);
  //     print('------------------------');
  //     print(response.data['data']); // uploaded image's url
  //     setState(() {
  //       updateProfilePic = response.data['data'];
  //     });
  //   } catch (e) {
  //     print("Exception Caught: $e");
  //   }
  //   print("File base name: $fileName");
  // }
  // //////////////////// upload image method start //////////////////////////////
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
          return  Scaffold(
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
            'Prescriptions',
            style: TextStyle(
              fontFamily: 'poppins',
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: store.state.prescriptionListLoadingState?
        Center(
                child: SpinKitCircle(
                  color: Color(0xFF0487FF),
                  // size: 30,
                 ),
              ) :
        SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            margin: EdgeInsets.only(top: 20, left: 16, right: 16),
            child: Column(
              children: [   
                Column(
                  children: List.generate(
                    store.state.prescriptionListState.length,
                    (index) {
                      return GestureDetector(
                        onTap: (){
                          Navigator.push( context,ScaleRoute(page: ZoomPage(store.state.prescriptionListState[index]),));
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 20),
                          padding: EdgeInsets.only(
                              top: 16, bottom: 16, left: 14, right: 25),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              width: 0.5,
                              color: Color(0xFFDADADA),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  // 'Amma',
                                  store.state.prescriptionListState[index]['name']==null? "Untitled":
                                  '${store.state.prescriptionListState[index]['name']}',
                                  style: TextStyle(
                                    fontFamily: 'poppins',
                                    color: Color(0xFF263238),
                                    fontSize: 14,
                                    // fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  if (!mounted) return;
                                    setState(() {
                                        _isEdit = true;
                                        _showAddPrescription = !_showAddPrescription;
                                        titleController.text = store.state.prescriptionListState[index]['name']==null?"":store.state.prescriptionListState[index]['name'];
                                        editID = store.state.prescriptionListState[index]['id']==null?"":store.state.prescriptionListState[index]['id'];
                                        editImage = store.state.prescriptionListState[index]['image']==null?"":store.state.prescriptionListState[index]['image'];
                                    });
                                },
                                child: Icon(
                                  FlutterIcons.edit_fea,
                                  color: Color(0xFF979797),
                                  size: 20,
                                ),
                              ),
                              SizedBox(width: 20),
                              GestureDetector(
                                onTap: () {
                                  _showDeleteDialog(store.state.prescriptionListState[index], context);
                                },
                                child: Icon(
                                  FlutterIcons.trash_fea,
                                  color: Color(0xFF979797),
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                ///////////////// add new  button start /////////////////
                GestureDetector(
                  onTap: () {
                    if (!mounted) return;
                    setState(() {
                      _showAddPrescription = !_showAddPrescription;
                      uploadImgbody = null;
                      titleController.text="";
                      _isEdit = false;
                      editID = null;
                      editImage = null;
                      _pickedImage = null;
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(top: 15, bottom: 15),
                    margin: EdgeInsets.only(top: 10, bottom: 20),
                    decoration: BoxDecoration(
                      color: _showAddPrescription
                          ? Color(0xFFF0F0F0)
                          : Color(0xFF0487FF),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      _showAddPrescription ?"Cancel":'Add New ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: _showAddPrescription
                            ? Color(0xFF263238)
                            : Colors.white,
                        fontFamily: 'poppins',
                      ),
                    ),
                  ),
                ),
                ///////////////// add new  button end /////////////////

                if (_showAddPrescription)
                  Column(
                    children: [
                      ///////////////// upload prescription button start /////////////////
                     _isEdit? Container(): GestureDetector(
                        onTap: () {
                          _pickImage();
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(
                              top: 15, bottom: 15, left: 15, right: 15),
                          margin: EdgeInsets.only(top: 10, bottom: 20),
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
                                'Upload Prescription',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'poppins',
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
                      ///////////////// upload prescription button end /////////////////

                      /////////////// prescription file view start ///////////////
                      if (_pickedImage != null)
                        
                        Container(
                          height: 110,
                          width: 190,
                          margin: EdgeInsets.only(top: 20, bottom: 30),
                          child:
                              //  _pickedImage == null
                              //     ?
                              //     Image.asset(
                              //         "assets/images/image 6 (8).png",
                              //       )
                              //     :
                              Image.file(_pickedImage),
                        ),
                      /////////////// prescription file view end ///////////////

                      /////////////// title field start /////////////
                      Container(
                        margin: EdgeInsets.only(bottom: 15, top: 15),
                        decoration: BoxDecoration(
                          // color: Color(0xFFF0EFEF),
                          border: Border.all(
                            color: Color(0xFFDADADA),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextField(
                          controller: titleController,
                          keyboardType: TextInputType.text,
                          // obscureText: true,
                          style: TextStyle(
                            color: Color(0xff263238),
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            hintText: "Title",
                            hintStyle: TextStyle(
                              // fontSize: 13,
                              color: Color(0xffB1B1B1),
                              fontFamily: 'poppins',
                            ),
                            contentPadding:
                                EdgeInsets.only(left: 18, top: 15, bottom: 14),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      /////////////// title field end /////////////

                      ///////////////// save new  button start /////////////////
                      GestureDetector(
                        onTap: () {
                         _isEdit? _editPrescription() : _addprescription();
                          // setState(() {
                          //   _showAddPrescription = !_showAddPrescription;
                          // });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(top: 15, bottom: 15),
                          margin: EdgeInsets.only(top: 10, bottom: 20),
                          decoration: BoxDecoration(
                            color: Color(0xFF0487FF),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            'Save',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontFamily: 'poppins',
                            ),
                          ),
                        ),
                      ),
                      ///////////////// save new  button end /////////////////
                    ],
                  ),
              ],
            ),
          ),
        ),
      );
        }
    );
  }


  ////////// add prescription start //////////
  Future<void> _addprescription() async {


    if(titleController.text==""){
      _showMsg("Title is empty", 1);
    } 
    else if(uploadImgbody==null){
      _showMsg("Upload a prescription", 1);
    } 
    else{


      _processingDialog("Saving prescription");

    var data = {
      'user_id': store.state.userInfoState['id'],
      'name': titleController.text,
      'franchise_id': store.state.userInfoState['franchise_id'],
      'image': uploadImgbody,
    };

    //print(store.state.productDetailsState);
    print(data);

    var res = await CallApi().postDataWithToken(data, 'ordermodule/createPrescription');
    var body = json.decode(res.body);
    print('body - $body');

    if (res.statusCode == 200) {
      _showMsg('Prescription saved', 2);

     store.state.prescriptionListState.add(body['data']);
     store.dispatch(PrescriptionListAction(store.state.prescriptionListState));
     setState(() {
       uploadImgbody = null;
       _pickedImage = null;
       _showAddPrescription = false;
       titleController.text="";
     });
    } 
    else if (res.statusCode == 401) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
    else if (res.statusCode == 422) {
      _showMsg(body['message'], 1);
    }
     else {
      _showMsg("Something went wrong! Please try again", 1);
    }

    Navigator.pop(context);

    }
    
  }
  ////////// add prescription end //////////
  
  ////////// edit prescription start //////////
  Future<void> _editPrescription() async {

   if (titleController.text.isEmpty) {
      return _showMsg('Title can\'t be empty!', 1);
    }
   
    else{

      _processingDialog("Processing...");
    //   setState(() {
    //   _isLoading = true;
    // });

    var data = {
      'user_id': store.state.userInfoState['id'],
      'id': editID,
      'name': titleController.text,
      'image': editImage,
    };

     print(data);
    var res = await CallApi().postDataWithToken(data, 'ordermodule/updatePrescription');
    var body = json.decode(res.body);
    print('body - $body');

    if (res.statusCode == 200) {  
      Navigator.pop(context);
      for(var d in store.state.prescriptionListState){
        if(d['id']==data['id']){
         d['name']=data['name'];
        }
      }
      store.dispatch(PrescriptionListAction(store.state.prescriptionListState));
      if (!mounted) return;
      setState(() {
            titleController.text="";
            _isEdit = false;
            editID = null;
            editImage = null;
            _showAddPrescription = false;
       });
       _showMsg('Prescription edited successfully!', 2);
       
    } else {
      Navigator.pop(context);
      _showMsg("Something went wrong! Please try again", 1);
    }
                                         
    // if (!mounted) return;
    // setState(() {
    //   _isLoading = false;
    //   _showAddAddress = !_showAddAddress;
   
    // });

    }

    
  }
  ////////// edit prescription end //////////

  ////////// Delete prescription start //////////
  Future<void> _deleteAddress(dPrecription) async {
                  
      _processingDialog("Processing...");

    var data = {
     'id': dPrecription['id']
    };
     print(data);
    var res = await CallApi().postDataWithToken(data, 'ordermodule/delPrescription');
    var body = json.decode(res.body);
      print('body - $body');

    if (res.statusCode == 200) {
     for(var d in store.state.prescriptionListState){
       if(d['id']==dPrecription['id']){
      store.state.prescriptionListState.remove(d);
      store.dispatch(PrescriptionListAction(store.state.prescriptionListState));
      break;
        }
     }
     Navigator.of(context).pop();
     _showMsg('Prescription deleted successfully!', 2);

     
    } else {
      Navigator.of(context).pop();
      _showMsg("Something went wrong! Please try again", 1);
    }

    // if (!mounted) return;
    // setState(() {
    //   _isLoading = false;

    // });

    }
     ////////// Delete prescription End //////////

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
  
  //////////////// delete dialogue ///////////////
  Future<Null> _showDeleteDialog(d,context) async {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            //   title: new Text('Are you sure?'),
            content: new Text('Are you sure you want delete this address?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: new Text(
                  'No',
                   style: TextStyle(color: Colors.red[900]),
                ),
              ),
              new FlatButton(
                onPressed: (){
                  Navigator.of(context).pop();
                  _deleteAddress(d);
                },
                child: new Text(
                  'Yes',
                  // style: TextStyle(color: appColor),
                ),
              ),
            ],
          ),
        );
  }

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
