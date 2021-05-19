import 'dart:async';
import 'package:duare/Api/api.dart';
import 'package:duare/Redux/action.dart';
import 'package:duare/RouteTransition/routeAnimation.dart';
import 'package:duare/Screens/LoginScreen/loginScreen.dart';
import 'package:duare/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:convert';
import 'package:duare/Redux/state.dart';
import 'package:flutter_redux/flutter_redux.dart';
class AddressesScreen extends StatefulWidget {
  @override
  _AddressesScreenState createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  TextEditingController addressController = new TextEditingController();
  TextEditingController titleController = new TextEditingController();
  TextEditingController apartmentController = new TextEditingController();

  bool _showAddAddress = false;
  bool _isLoading = false;
  bool _isEdit = false;
  var addressId;

  String fullAddress = "";
  var lat;
  var lon;
  var pickLatitude;
  var pickLongitude;
  var addressLatitude;
  var addressLongitude;

  /////////////// For Google Map ////////////////////
  ///
  Set<Marker> _markers = Set();
  Completer<GoogleMapController> _controller = Completer();

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  //static final
   CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 13.4746,
  );



   


    Future<void> _showDeliveryAddress() async {
      store.dispatch(DeliveryAddressLoadingAction(true));
    var res = await CallApi()
        .getDataWithToken('usermodule/getDeleveryAddress');

    if (res.statusCode == 200) {
      var body = json.decode(res.body);
      print(body);
      store.dispatch(DeliveryAddressAction(body));
    }
    else if (res.statusCode == 401) {
      
      _showMsg("Login expired!", 1);
       Navigator.push( context, SlideLeftRoute(page: LoginScreen()));
    }
    else{

         _showMsg("Something went wrong", 1);

    }
   store.dispatch(DeliveryAddressLoadingAction(false));
  }

  @override
  void initState() {
    print(store.state.userInfoState);
   _showDeliveryAddress();
   _getDeviceLocation();
   
    super.initState();
  }

    Future<void> _pull() async {
   _showDeliveryAddress();
  }

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
            'Address',
            style: TextStyle(
              fontFamily: 'poppins',
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: RefreshIndicator(
                    onRefresh: _pull,
                    child: SingleChildScrollView(
            physics:AlwaysScrollableScrollPhysics(),
            child: Container(
              margin: EdgeInsets.only(top: 20, left: 16, right: 16),
              child: Column(
                children: [
                 store.state.deliveryAddressLoading?
             Container(
               margin: EdgeInsets.only(top:MediaQuery.of(context).size.height/3),
               child: SpinKitCircle( 
                              color: Color(0xFF0487FF),
                              // size: 30,
                            ),
             ): Column(
                            children: [
                              Column(
                    children: List.generate(
                      store.state.deliveryAddress.length,
                      (index) {
                        return Container(
                              margin: EdgeInsets.only(bottom: 20),
                              padding: EdgeInsets.only(
                                  top: 16, bottom: 16, left: 14, right: 15),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  width: 0.5,
                                  color: Color(0xFFDADADA),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(bottom: 8),
                                    child: Text(
                                      store.state.deliveryAddress[index]['title']==""||
                                      store.state.deliveryAddress[index]['title'] ==null?
                                      "Address $index":
                                      store.state.deliveryAddress[index]['title'],
                                      style: TextStyle(
                                        fontFamily: 'poppins',
                                        color: Color(0xFF00B658),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                 
                                  GestureDetector(
                                    onTap: () {},
                                    child: Row(
                                      children: [
                                  Expanded(
                                          child: Text(
                                          store.state.deliveryAddress[index]['address']==null?"":store.state.deliveryAddress[index]['address'],
                                            style: TextStyle(
                                              fontFamily: 'poppins',
                                              color: Color(0xFF263238),
                                              fontSize: 14,
                                              // fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        InkWell(
                                          onTap: (){  

      if (!mounted) return;
      setState(() {
        _isEdit = true;
       _kGooglePlex = CameraPosition(  
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 13.4746,
  );
          _showAddAddress = !_showAddAddress;
          titleController.text = store.state.deliveryAddress[index]['title']==null?"":store.state.deliveryAddress[index]['title'];
          addressController.text = store.state.deliveryAddress[index]['address']==null?"":store.state.deliveryAddress[index]['address'];
          apartmentController.text = store.state.deliveryAddress[index]['apartment_number']==null?"":store.state.deliveryAddress[index]['apartment_number'];
          addressId=store.state.deliveryAddress[index]['id'];
          
      });
                                              
                                          },

                                            child: Container(
                                               padding:  EdgeInsets.all(5.0), 
                                              child: Icon(
                                              FlutterIcons.edit_fea,
                                              color: Color(0xFF979797),
                                              size: 20,
                                          ),
                                            ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                     
                                   Expanded(
                                        child: Text(
                                          store.state.deliveryAddress[index]['apartment_number']==null?"":
                                           store.state.deliveryAddress[index]['apartment_number'],
                                          style: TextStyle(
                                            fontFamily: 'poppins',
                                            color: Colors.black,
                                            fontSize: 14,
                                            // fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      InkWell(
                                       splashColor: Colors.grey[200],
                                  onTap: () {
                                      _showDeleteDialog(store.state.deliveryAddress[index], context);
                                  
                                        
                                  },
                                   child: Container(
                                     padding:  EdgeInsets.all(5.0),
                                     child: Icon(
                                          FlutterIcons.trash_fea,
                                          color: Color(0xFF979797),
                                          size: 20,
                                        ),
                                   ),
                                    ),
                                    ],
                                  ),
                                ],
                              ),
                        );
                      },
                    ),

                    
                  ),
                    ///////////////// add new address button start /////////////////
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showAddAddress = !_showAddAddress;
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(top: 15, bottom: 15),
                      margin: EdgeInsets.only(top: 10, bottom: 20),
                      decoration: BoxDecoration(
                        color:
                            _showAddAddress ? Color(0xFFDADADA) : Color(0xFF0487FF),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        'Add New Address',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontFamily: 'poppins',
                        ),
                      ),
                    ),
                  ),
                  ///////////////// add new address button end /////////////////
                            ],
                          ),
                

                  !_showAddAddress
                      ? Container()
                      : Column(
                          children: [
                            /////////////// GoogleMap start /////////////////
                            Container(
                              height: 180,
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.only(top: 20, bottom: 20),
                              // padding: EdgeInsets.symmetric(
                              //   //vertical: 5,
                              //   horizontal: 20,
                              // ),
                              child: GoogleMap(
                                mapType: MapType.normal,
                                markers: _markers,
                                initialCameraPosition: _kGooglePlex,
                                onMapCreated: _onMapCreated,
                                onCameraMove: ((_position) => _updatePosition(_position)),
                              ),
                            ),
                            /////////////// GoogleMap end /////////////////

                            /////////////// address field start /////////////
                            Container(
                              margin: EdgeInsets.only(bottom: 5, top: 15),
                              decoration: BoxDecoration(
                                // color: Color(0xFFF0EFEF),
                                border: Border.all(
                                  color: Color(0xFFDADADA),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: TextField(
                                controller: addressController,
                                readOnly: true,
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                  color: Color(0xffB1B1B1),
                                  fontFamily: 'poppins',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  // hintText: "Type here....",
                                  // hintStyle: TextStyle(
                                  //   // fontSize: 13,
                                  //   color: Color(0xffB1B1B1),
                                  //   fontFamily: 'poppins',
                                  // ),
                                  contentPadding: EdgeInsets.only(
                                      left: 18, top: 15, bottom: 14, right: 18),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            /////////////// address field end /////////////

                            /////////////// title field start /////////////
                            Container(
                              margin: EdgeInsets.only(bottom: 5, top: 15),
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
                                  contentPadding: EdgeInsets.only(
                                      left: 18, top: 15, bottom: 14),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            /////////////// title field end /////////////

                            /////////////// apartment field start /////////////
                            Container(
                              margin: EdgeInsets.only(bottom: 5, top: 15),
                              decoration: BoxDecoration(
                                // color: Color(0xFFF0EFEF),
                                border: Border.all(
                                  color: Color(0xFFDADADA),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: TextField(
                                controller: apartmentController,
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                  color: Color(0xff263238),
                                  fontFamily: 'poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  hintText: "Apartment Number",
                                  hintStyle: TextStyle(
                                    // fontSize: 13,
                                    color: Color(0xffB1B1B1),
                                    fontFamily: 'poppins',
                                  ),
                                  contentPadding: EdgeInsets.only(
                                      left: 18, top: 15, bottom: 14),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            /////////////// apartment field end /////////////
                            
                             ///////////////// Cancel new address button start /////////////////
                            SizedBox(height: 40,),
                            
                           _isEdit?
                            GestureDetector(
                              onTap: () {
                                  setState(() {
                                    _showAddAddress = !_showAddAddress;
                                  });
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.only(top: 15, bottom: 15),
                                margin: EdgeInsets.only( bottom: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color:appColor)
                                ),
                                child:Text(
                                  'Cancel',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: appColor,
                                    fontFamily: 'poppins',
                                  ),
                                ),
                              ),
                            ):Container(),
                            ///////////////// Cancel new address button end /////////////////
                            ///////////////// save new address button start /////////////////
                            
                            
                            GestureDetector(
                              onTap: () {
            
                 
                                  
                                 _isLoading ? null : 

                                 _isEdit? _editAddress():_addAddress();

                                // setState(() {
                                //   _showAddAddress = !_showAddAddress;
                                // });
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.only(top: 15, bottom: 15),
                                margin: EdgeInsets.only(bottom: 20),
                                decoration: BoxDecoration(
                                  color: Color(0xFF0487FF),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child:  _isLoading
                            ? Container(  
                                height: 27,
                                child: SpinKitThreeBounce(
                                  color: Colors.white,
                                  size: 30,
                                ),
                              )
                            :Text(
                                  'Save',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    fontFamily: 'poppins',
                                  ),
                                ),
                              ),
                            ),
                            ///////////////// save new address button end /////////////////
                          ],
                        ),
                ],
              ),
            ),
          ),
        ),
      );
        }
   );
      
        }


    Future<void> _addAddress() async {
    if (addressController.text.isEmpty) {
      return _showMsg('Address can\'t be empty!', 1);
    }
    else if (titleController.text.isEmpty) {
      return _showMsg('Title can\'t be empty!', 1);
    }
    else if(apartmentController.text.isEmpty){
        return _showMsg('Apartment number can\'t be empty!', 1);
    }
    // if (titleController.text.isEmpty) {
    //   return _showMsg('Password can\'t be empty!', 1);
    // }

    else{


      setState(() {
      _isLoading = true;
    });

    var data = {
      'title': titleController.text,
      'address': addressController.text,
      'apartment_number':apartmentController.text,
      'lat': addressLatitude,
      'long': addressLongitude
    };

   
     print(data);

    var res = await CallApi().postDataWithToken(data, 'usermodule/createDeleveryAddress');
    var body = json.decode(res.body);
    print('body - $body');

    if (res.statusCode == 201) {
      _showMsg('Address created successfully!', 2);

      store.state.deliveryAddress.add(
      {
      'id':body['id'],
      'title': data['title'],
      'address': data['address'],
      'apartment_number':data['apartment_number'],
      'lat': data['lat'],
      'long': data['long'],
      }

      );
      store.dispatch(DeliveryAddressAction(store.state.deliveryAddress));

      titleController.text = "";
      addressController.text="";
      apartmentController.text = "";
      addressLatitude =0.0;
      addressLongitude=0.0;

    } else {
      _showMsg("Something went wrong! Please try again", 1);
    }

    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _showAddAddress = !_showAddAddress;

    });

    }

    
  }

    Future<void> _editAddress() async {

    if (addressController.text.isEmpty) {
      return _showMsg('Address can\'t be empty!', 1);
    }
    else if (titleController.text.isEmpty) {
      return _showMsg('Title can\'t be empty!', 1);
    }

    else if(apartmentController.text.isEmpty){
        return _showMsg('Apartment number can\'t be empty!', 1);
    }
   
    else{


      setState(() {
      _isLoading = true;
    });

    var data = {
      'title': titleController.text,
      'address': addressController.text,
      'apartment_number':apartmentController.text,
      'lat': addressLatitude,
      'long': addressLongitude,
      'user_id':store.state.userInfoState['id'],
      'id':addressId
    };

   
     print(data);

    var res = await CallApi().postDataWithToken(data, 'usermodule/updateDeleveryAddress');
    var body = json.decode(res.body);
    print('body - $body');

    if (res.statusCode == 200) {  
      _showMsg('Address edited successfully!', 2);
      
     

      for(var d in store.state.deliveryAddress){
        if(d['id']==data['id']){
         d['title']=data['title'];
         d['address']=data['address'];
         d['apartment_number']=data['apartment_number'];
         d['lat']=data['lat'];
         d['long']=data['long'];
        }
      }
      store.dispatch(DeliveryAddressAction(store.state.deliveryAddress));
       
    } else {
      _showMsg("Something went wrong! Please try again", 1);
    }
                                         
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _showAddAddress = !_showAddAddress;
   
    });

    }

    
  }



      Future<void> _deleteAddress(d) async {
                  

      setState(() {
      _isLoading = true;
    });

    var data = {
     'user_id':store.state.userInfoState['id'],
     'id':d['id']
    };

   
     print(data);

    var res = await CallApi().postDataWithToken(data, 'usermodule/deleteDeleveryAddress');
    var body = json.decode(res.body);
      print('body - $body');

    if (res.statusCode == 200) {
      _showMsg('Address deleted successfully!', 2);

     //// for(var d in store.state.deliveryAddress){
       // if(d['id']==data['id']){
      store.state.deliveryAddress.remove(d);
      store.dispatch(DeliveryAddressAction(store.state.deliveryAddress));
      // break;
      //   }
    //  }

    Navigator.of(context).pop();

     
    } else {
      _showMsg("Something went wrong! Please try again", 1);
    }

    if (!mounted) return;
    setState(() {
      _isLoading = false;

    });

    

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
                  _showProcessingDialog(context);
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


  /////////////  processing ///////////////
      Future<Null> _showProcessingDialog(context) async {
    return showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6.0))),
       
              content: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 28,
                          width: 28,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            backgroundColor: Colors.grey.withOpacity(0.3),
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.grey[400]),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left:12),
                          child: Text(
                    "Processing...",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontFamily: 'Oswald',
                          fontWeight: FontWeight.w400),
                  ),
                        )


                      ],
                    )
               
      
            );
          });
        });
  }

   /////////// updated marker ////////////
    
      void _updatePosition(CameraPosition _position) async {
         Marker markerDevice = _markers.firstWhere(
        (p) => p.markerId == MarkerId('deviceMarker'),
        orElse: () => null);
    setState(() {
      _markers.remove(markerDevice);
    });



    Marker marker = _markers.firstWhere(
        (p) => p.markerId == MarkerId('marker_2'),
        orElse: () => null);
    setState(() {
      _markers.remove(marker);
    });

    _markers.add(
      Marker(
        markerId: MarkerId('marker_2'),
        //   icon: texiIcon,
        position: LatLng(_position.target.latitude, _position.target.longitude),

        // infoWindow: myAddress != ''
        //     ? InfoWindow(title: "$myAddress")
        //     : InfoWindow(
        //         title: '${_position.target.latitude}',
        //         snippet: '${_position.target.longitude}'),
        // infoWindow: InfoWindow(title: '${_position.target.latitude}',
        //         snippet: '${_position.target.longitude}'),
        draggable: true,
        //icon: _searchMarkerIcon,
      ),
    );

   // setState(() {
      pickLatitude = _position.target.latitude;
      pickLongitude = _position.target.longitude;
  //  });

    print("picklat: " +
        pickLatitude.toString() +
        "     picklong: " +
        pickLongitude.toString());
      
        
       showAddress(pickLatitude, pickLongitude);
  }
  ////// ***** _getDeviceLocation Method start ***** //////
  void _getDeviceLocation() async {
    // await Future.delayed(Duration(seconds: 3));
    LocationData currentLocation;
    var location = Location();
    try {
      currentLocation = await location.getLocation();
    } on Exception {
      currentLocation = null;
    }

    var currentLatitude = currentLocation.latitude;
    lat = currentLatitude;
    var currentLongitude = currentLocation.longitude;
    lon = currentLongitude;

    GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(currentLatitude, currentLongitude),
        zoom: 12,
      ),
    ));

    setState(() {
      _markers.add(
        Marker(
          // icon: markerIcon,
         // infoWindow:InfoWindow(title: ''),
          markerId: MarkerId('deviceMarker'),
          position: LatLng(currentLatitude, currentLongitude),
        ),
      );
      print('Latitude -- ' + currentLatitude.toString());
      print('Longitude -- ' + currentLongitude.toString());
    });

    if(currentLatitude!=null && currentLongitude!=null){
          showAddress(currentLatitude, currentLongitude);
    }
     
  }
  ////// ***** _getDeviceLocation Method end ***** //////

  showAddress(latitude, longitude) async {


    final coordinates = new Coordinates(latitude, longitude);
        var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
        var first = addresses.first;
        addressLatitude = latitude;
        addressLongitude = longitude;
        setState(() {
           addressController.text = first.addressLine;
        });

        print("${first.featureName} : ${first.addressLine}");
    // setState(() {
    //   _loading = true;
    // });
    // //await Future.delayed(Duration(seconds: 3));
    // var arearesponse = await CallApi().getAddress(
    //     "?latlng=$latitude,$longitude&key=AIzaSyAiXNjJ3WpC-U-NKUPY66eQK471y1CiWTY");
    // var areacontent = arearesponse.body;
    // final area = json.decode(areacontent);
    // print("area");
    // print(area['results'][0]['formatted_address']);

    // if (!mounted) return;
    // setState(() {
    //   fullAddress = area['results'][0]['formatted_address'];
    //   addressController.text = fullAddress;
    //   _loading = false;
    // });
  }

}

