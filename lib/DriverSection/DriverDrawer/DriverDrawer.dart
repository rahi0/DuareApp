import 'package:duare/DriverSection/DriverHomePage/DriverHomePage.dart';
import 'package:duare/DriverSection/DriverOrderDashboard/DriverOrderDashboard.dart';
import 'package:duare/Redux/state.dart';
import 'package:duare/RouteTransition/routeAnimation.dart';
import 'package:duare/main.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class DriverDrawer extends StatefulWidget {
  @override
  _DriverDrawerState createState() => _DriverDrawerState();
}

class _DriverDrawerState extends State<DriverDrawer> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        ////// this is the connector which mainly changes state/ui
        converter: (store) => store.state,
        builder: (context, items) { 
    return Drawer(
      child: SafeArea(
        child: Container(
          child: Column(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Colors.blue[700],
                    Colors.blue[400],
                  ],
                )),
                child: Container(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child:
                          //  _isLoadingUser
                          //     ? Container(
                          //         height: 80,
                          //         width: 80,
                          //         margin: EdgeInsets.only(bottom: 10),
                          //         child: CircularProgressIndicator(),

                          //       )
                          //     :
                          Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: ClipOval(
                            child: Container(
                          height: 80,
                          width: 80,
                          color: Colors.white,
                          child: Icon(
                            Icons.person,
                            size: 40,
                          ),
                        )),
                      ),
                    ),
                    Container(
                      child: FittedBox(
                        child: new Text(
                          store.state.userInfoState['name']==null?"":
                          "${store.state.userInfoState['name']}",
                          style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontFamily: "Poppins",
                              fontSize: 22,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                )),
              ),

              Container(),
              //////////// dashboard Button Start ////////////////
              InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(context, FadeRoute(page: DriverHomepage()));
                  },
                  child: buttonContainer(
                    "Dashboard",
                  )),
              //////////// dashboard Button End ////////////////

              //////////// today's orders Button Start ////////////////
              InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context, FadeRoute(page: DriverOrderDashboard()));
                  },
                  child: buttonContainer(
                    "Today's Orders",
                  )),
              //////////// today's orders Button End ////////////////

              //////////// Help Button Start ////////////////
              InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    launch("tel:+8801750118555");
                  },
                  child: buttonContainer(
                    "Help",
                  )),
              //////////// Help Button End ////////////////

              //////////// Logout Button Start ////////////////
              InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: buttonContainer(
                    "Logout",
                  )),
              //////////// Logout Button End ////////////////
            ],
          ),
        ),
      ),
    );
  });
  }

  ////////////// buttonContainer ////////////////
  buttonContainer(var title) {
    return Container(
      // color: Colors.red,
      padding: EdgeInsets.only(left: 30, top: 15),
      margin: EdgeInsets.only(bottom: 5, top: 0),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Color(0xFF263238),
              fontFamily: 'poppins',
            ),
          ),
        ],
      ),
    );
  }
  ////////////// buttonContainer ////////////////
}
