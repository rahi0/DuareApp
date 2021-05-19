import 'dart:convert';
import 'package:duare/Redux/state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:duare/Api/api.dart';
import 'package:duare/RouteTransition/routeAnimation.dart';
import 'package:duare/Screens/LoginScreen/loginScreen.dart';
import 'package:duare/Screens/RegisterScreen/registerScreen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:duare/main.dart';
import 'package:duare/Redux/action.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class GetStartedScreen extends StatefulWidget {
  @override
  _GetStartedScreenState createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  // List countryList = ['Select Country'];
  var _currentCountrySelected = 'Select Country';
  var _currentCitySelected = 'Select City';

  void _onDropDownCountrySelected(String newValueSelected) {

     

 
  
    setState(() {
      _currentCountrySelected = newValueSelected;
      print('_currentCountrySelected ----------------------- ');
      print(_currentCountrySelected);
    });
      if (store.state.countryList.length > 0) {
        for (var d in store.state.countryList) {

          print("length");
          print(d['cities'].length);

          print(d['name']);
          print(newValueSelected);

          if(d['name']==newValueSelected){

            print(d['id']);
            print(d['cities']);
              if (d['cities'].length > 0) {
            for (var city in d['cities']) {
              store.state.cityList.add(city['city_name']);
            }

             store.dispatch(CityListAction(store.state.cityList));
          }
          else{
             _currentCitySelected = 'Select City';
     List cityList = ['Select City'];
    store.dispatch(CityListAction(cityList)); 
          }
            break;
          }
       
          
        }

           print("store.state.cityList");
    print(store.state.cityList);

        
      }
  }

  void _onDropDownCitySelected(String newValueSelected) {
    setState(() {
      _currentCitySelected = newValueSelected;
      print('_currentCitySelected ----------------------- ');
      print(_currentCitySelected);
    });
  }

  // List<DropdownMenuItem<String>> _dropDownCountryItems;

  List contList = [];

  // List<DropdownMenuItem<String>> getDropDownCountryItems() {
  //   List<DropdownMenuItem<String>> items = new List();
  //   for (String countryList in contList) {
  //     items.add(new DropdownMenuItem(
  //       value: countryList,
  //       child: new Text(
  //         countryList,
  //         textAlign: TextAlign.start,
  //         overflow: TextOverflow.ellipsis,
  //         style: TextStyle(
  //           fontSize: 16,
  //           color: Colors.black,
  //           fontFamily: 'poppins',
  //         ),
  //       ),
  //     ));
  //   }
  //   return items;
  // }

  Future<void> _showCountryCity() async {
    var res = await CallApi().getData('usermodule/getAllCountry');

    if (res.statusCode == 200) {
      var body = json.decode(res.body);

      //   store.state.countryList.clear();
      print(body['data']);
      // print('data');
      // print(store.state.countryList.length);

      //List countryList = ['Select Country'];
      List countryList = [];
      countryList.add({
        "id": 0,
        "name": "Select Country",
        "code": "0",
        "created_at": "2020-04-16T16:21:28.000000Z",
        "updated_at": "2020-04-16T16:21:28.000000Z",
        "cities": []

      });
      store.dispatch(CountryListAction(countryList));


      List cityList = ['Select City'];
      store.dispatch(CityListAction(cityList));



      if (body['data'].length > 0) {
        for (var d in body['data']) {
          store.state.countryList.add(d);

          // if      (d['cities'].length > 0) {
          //   for (var city in d['cities']) {
          //     store.state.cityList.add(city['city_name']);
          //   }
          // }
        }
      }
                             
      store.dispatch(CountryListAction(store.state.countryList));
      store.dispatch(CityListAction(store.state.cityList));
      print(store.state.countryList);

      print("swd");
    } else if (res.statusCode == 401) {
      _showMsg("Your session has expired", 1); 
      Navigator.push(context, SlideLeftRoute(page: LoginScreen()));
    } else {
      _showMsg("Something went wrong", 1);
    }

    store.dispatch(CountryLoadingAction(false));
  }

  @override
  void initState() {
    _showCountryCity();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        ////// this is the connector which mainly changes state/ui
        converter: (store) => store.state,
        builder: (context, items) {
          return Scaffold(
            bottomNavigationBar: /////////////////////// Next Button Start //////////////////////
                GestureDetector(
              onTap: () {

               
                if (_currentCountrySelected == "" || _currentCountrySelected=="Select Country") {
                   return _showMsg("Select country!", 1);
                }
                else if (_currentCitySelected == "" || _currentCitySelected == "Select City") {
                   return _showMsg("Select city!", 1);
                }

                else {
                    Navigator.push(
                    context,
                    SlideLeftRoute(
                        page: RegisterScreen(
                            _currentCountrySelected, _currentCitySelected)));
                }

                
              },
              child: Container(
                margin:
                    EdgeInsets.only(top: 30, bottom: 20, left: 25, right: 25),
                padding: EdgeInsets.only(top: 12, bottom: 12),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: appColor,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Text(
                  'Next',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            ////////////////////// Next Button End //////////////////////

            body: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ///////////////// Where are you from? Start ///////////////
                  Container(
                    child: Text(
                      'Where are you from?',
                      style: TextStyle(
                        fontFamily: 'poppins',
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF263238),
                      ),
                    ),
                  ),
                  ///////////////// Where are you from? End ///////////////

                  SizedBox(height: 30),
                  store.state.countryLoading
                      ? Container(
                          height: 27,
                          child: SpinKitThreeBounce(
                            color: appColor,
                            size: 30,
                          ),
                        )
                      : Container(),
                  ///////////////// Country Dropdown Field Start ///////////////
                  Container(
                    margin: EdgeInsets.only(left: 16, right: 16, top: 10),
                    padding:
                        EdgeInsets.only(left: 20, right: 22, top: 3, bottom: 3),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Color(0xFFE9E9E9),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        //  height: 52,
                        child: DropdownButton<String>(
                            // isDense: true,
                            isExpanded: true,
                            icon: Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.black,
                            ),
                            value: _currentCountrySelected,
                            hint: Text("Select Country"),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF263238),
                              fontFamily: 'poppins',         
                            ),
                            items: //_dropDownCountryItems,
                                store.state.countryList.map((var value) {
                              return DropdownMenuItem<String>(
                                value: value['name'],
                                child: Text(
                                  value['name'],
                                ),
                              );
                            }).toList(),
                            onChanged: (var newValueSelected) {
                              _onDropDownCountrySelected(newValueSelected);
                              print(newValueSelected);
                            }),
                      ),
                    ),
                  ),
                  ///////////////// Country Dropdown Field End ///////////////

                  ///////////////// City Dropdown Field Start ///////////////
                  Container(
                    margin: EdgeInsets.only(left: 16, right: 16, top: 30),
                    padding: EdgeInsets.only(
                        left: 20, right: 22, top: 12, bottom: 13),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Color(0xFFE9E9E9),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                          isDense: true,
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.black,
                          ),
                          value: _currentCitySelected,
                          hint: Text("Select City"),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF263238),
                            fontFamily: 'poppins',
                          ),
                          items: store.state.cityList.map((var value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                              ),
                            );
                          }).toList(),
                          onChanged: (var newValueSelected) {
                            _onDropDownCitySelected(newValueSelected);
                            print(newValueSelected);
                          }),
                    ),
                  ),
                  ///////////////// City Dropdown Field End ///////////////
                ],
              ),
            ),  
          );
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

}
