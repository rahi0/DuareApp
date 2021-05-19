import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

class ZoomPage extends StatefulWidget {
  final prescription;
  ZoomPage(this.prescription);
  @override
  _ZoomPageState createState() => _ZoomPageState();
}

class _ZoomPageState extends State<ZoomPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        centerTitle: true,
        title: Text("${widget.prescription['name']}",
        style: TextStyle(
              fontFamily: 'poppins',
              color: Colors.black,
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),),
      ),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: InteractiveViewer(
            child: CachedNetworkImage(
               imageUrl: widget.prescription['image'],
               fit: BoxFit.contain,
               placeholder: (context, url) => Center(
                  child: SpinKitFadingCircle(
                    color: Colors.grey,
                  ),
                ),
               errorWidget: (context, url, error) =>Center(child: new Icon(Icons.error)),
               )
          ),
        ),
      ),
    );
  }
}