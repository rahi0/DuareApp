import 'package:flutter/material.dart';

class ReturnPolicyScreen extends StatefulWidget {
  @override
  _ReturnPolicyScreenState createState() => _ReturnPolicyScreenState();
}

class _ReturnPolicyScreenState extends State<ReturnPolicyScreen> {
  @override
  Widget build(BuildContext context) {
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
          'Return & Refund',
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
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 17, right: 17, top: 20),
              child: Text(
                '''Return Policy 
1     A user may return any product during the time of delivery : 

a) Product does not meet user’s expectation. 
b) Found damaged during delivery 
c) Have doubt about the product quality and quantity 
d) Received in an unhealthy/ unexpected condition 
e) Is not satisfied with the packaging 
f) Finds product unusable 

2. following products may not be eligible for return or replacement: 

a) Damages due to misuse of product 
b) Incidental damage due to malfunctioning of product c) Any consumable item which has been used/installed.
d) Products with tampered .
e) Any damage/defect which are not covered under the manufacturer's warranty.
f) Any product that is returned without all original packaging and accessories, including the box, manufacturer's packaging if any, and all other items originally included with the product/s delivered. 

Refund Policy
1.  Duare tries its best to serve the users. But if under any circumstances, we fail to fulfill our commitment or to provide the service, we will notify you within 24 hours via phone/ text/ email. If the service, that Duare fails to complete, requires any refund, it be done maximum within 10 Days after our acknowledgement.

2. Refund requests will be processed under mentioned situation:
- Unable to serve with any product.
- Customer returns any product from a paid order.
- Customer cancels a paid order before it has been dispatched.
For all the above three scenarios, the refund amount will be sent to Duare Balance of the customer. And the balance can only be used to purchase at Duare. Upon customer's request, Duare will transfer the refund amount to the user's original payment source within 10 days. Refund is only allowed for customers who have paid via bKash or card or other electronic method. For the orders that are paid via Cash, refund is only to be given through Duare Credits. 
''',
                style: TextStyle(
                  fontFamily: 'poppins',
                  color: Colors.black,
                  fontSize: 14,
                  // fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
