
import 'package:duare/Redux/action.dart';
import 'package:duare/Redux/state.dart';
import 'package:duare/Screens/BottomNavigationPages/HomePage/electronicsHome.dart';
import 'package:duare/Screens/BottomNavigationPages/HomePage/medicineHome.dart';
import 'package:duare/Screens/BottomNavigationPages/HomePage/restaurantsHome.dart';
import 'package:duare/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'groceryHome.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // List categoryList = [
  //   'Grocery',
  //   'Restaurants',
  //   'Electronics',
  //   'Medicine',
  // ];
  var _currentCategorySelected = store.state.categoryNamesListState[0];
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
          store.state.whichHomeState['name'] = _currentCategorySelected;
          store.state.whichHomeState['id'] = catId;

          store.dispatch(WhichHomeAction(store.state.whichHomeState));
          break;
        }
      }
    });
  }

  @override
  void initState() {
    // print(
    //     'store.state.whichHomeState['name'] ----- ${store.state.whichHomeState['name']}');
    if (store.state.whichHomeState['name'] == "" ||
        store.state.whichHomeState['name'] == null) {
      setState(() {
        _currentCategorySelected = 'Grocery';
      });
    } else {
      if (store.state.whichHomeState['name'] == "Grocery") {
        setState(() {
          _currentCategorySelected = 'Grocery';
        });                   
      }
      if (store.state.whichHomeState['name'] == "Restaurants") {
        setState(() {
          _currentCategorySelected = 'Restaurants';
        });
      }
      if (store.state.whichHomeState['name'] == "Electronics") {
        setState(() {                          
          _currentCategorySelected = 'Electronics';
        });
      }
      if (store.state.whichHomeState['name'] == "Medicine") {
        setState(() {
          _currentCategorySelected = 'Medicine';
        });                       
      }
    }
    // TODO: implement initState
    super.initState();
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
          title: Container(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
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
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF263238),
                    fontFamily: 'poppins',
                  ),
                  items: store.state.categoryNamesListState.map((var value) {
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
          actions: [
            Row(
              children: [
                Icon(
                  Icons.location_pin,
                  color: Colors.black,
                ),
                Container(
                  padding: EdgeInsets.only(right: 10, left: 5),
                  child: Text(
                    'Office',
                    style: TextStyle(
                      fontFamily: 'poppins',
                      color: Color(0xFF263238),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        body: _currentCategorySelected == 'Grocery'
            ? GroceryHome()
            : _currentCategorySelected == 'Restaurants'
                ? RestaurantsHome()
                : _currentCategorySelected == 'Electronics'
                    ? ElectronicsHome()
                    : _currentCategorySelected == 'Medicine'
                        ? MedicineHome()
                        // : Container(),
                        : GroceryHome(),
      );
        }
    );
  }
}
