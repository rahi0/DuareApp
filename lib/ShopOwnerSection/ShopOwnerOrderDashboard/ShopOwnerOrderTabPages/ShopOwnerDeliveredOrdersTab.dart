import 'dart:convert';

import 'package:duare/Api/api.dart';
import 'package:duare/Redux/action.dart';
import 'package:duare/Redux/state.dart';
import 'package:duare/Screens/LoginScreen/loginScreen.dart';
import 'package:duare/ShopOwnerSection/ShopOwnerOrderDetailsPage/ShopOwnerOrderDetailsPage.dart';
import 'package:duare/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class ShopOwnerDeliveredOrdersTab extends StatefulWidget {
  @override
  _ShopOwnerDeliveredOrdersTabState createState() =>
      _ShopOwnerDeliveredOrdersTabState();
}

class _ShopOwnerDeliveredOrdersTabState
    extends State<ShopOwnerDeliveredOrdersTab> {
  ////////////////// get AllDeliveredOrders list start ////////////////////
  _getAllDeliveredOrders() async {
    var res = await CallApi().getDataWithTokenandQuery(
        'shopownermodule/getAllOrders', '&status=Delivered');
    var body = json.decode(res.body);
    print(res.statusCode);
    print('body - $body');
    print('.....................');

    if (res.statusCode == 200) {
      store.dispatch(SoDeliveredOrdersAction(body['data']));
    } else if (res.statusCode == 401) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else {
      _showMsg('Something went wrong!', 1);
    }

    store.dispatch(SoDeliveredOrdersLoadingAction(false));
  }
  ////////////////// get AllDeliveredOrders list end ////////////////////

  ///
  Future<void> _onRefresh() async {
    _getAllDeliveredOrders();
  }

  @override
  void initState() {
    _getAllDeliveredOrders();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        ////// this is the connector which mainly changes state/ui
        converter: (store) => store.state,
        builder: (context, items) {
          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Container(
                margin:
                    EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                child: store.state.soDeliveredOrdersLoadingState
                    ?
                    ////////////////////// progress inidcator start //////////////////////
                    Center(
                        child: Container(
                          child: SpinKitCircle(
                            color: Color(0xFF0487FF),
                          ),
                        ),
                      )
                    ////////////////////// progress inidcator end //////////////////////
                    : store.state.soDeliveredOrdersState.length == 0
                        ?
                        ////////////////////// no orders text container start //////////////////////
                        Center(
                            child: Container(
                              child: Text(
                                'No Delivered Orders',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  fontFamily: 'poppins',
                                ),
                              ),
                            ),
                          )
                        ////////////////////// no orders text container end //////////////////////
                        :
                        //////////////////// orders list start //////////////////////
                        Column(
                            children: List.generate(
                              store.state.soDeliveredOrdersState.length,
                              (index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ShopOwnerOrderDetailsPage(store
                                                        .state
                                                        .soDeliveredOrdersState[
                                                    index]['id'])));
                                  },
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        buildItemContainer('Order ID',
                                            '${store.state.soDeliveredOrdersState[index]['id']}'),
                                        buildItemContainer('Time',
                                            '${DateFormat.yMd().add_jm().format(DateTime.parse(store.state.soDeliveredOrdersState[index]['statusUpdated']))}'),
                                        buildItemContainer('Price',
                                            '???${store.state.soDeliveredOrdersState[index]['total']}'),
                                        buildItemContainer(
                                            'Payment Type',
                                            store.state.soDeliveredOrdersState[
                                                        index]['paymentType'] ==
                                                    null
                                                ? ''
                                                : '${store.state.soDeliveredOrdersState[index]['paymentType']}'),
                                        Container(
                                          margin: EdgeInsets.only(bottom: 10),
                                          child: Divider(),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                ////////////////////// orders list end //////////////////////
              ),
            ),
          );
        });
  }

  ///////////////////////////////////////////////////////
  Container buildItemContainer(var title, var value) {
    return Container(
      padding: EdgeInsets.only(bottom: 5),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Text(
              '$title: ',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontFamily: 'poppins',
              ),
            ),
          ),
          Container(
            child: Text(
              value,
              style: TextStyle(
                fontWeight:
                    title == 'Price' ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
  ///////////////////////////////////////////////////////

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
