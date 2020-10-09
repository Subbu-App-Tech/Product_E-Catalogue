// import 'package:flutter/material.dart';
// import 'package:upi_india/upi_india.dart';
// import 'package:open_file/open_file.dart';
// import 'dart:io' show Platform;
// import 'package:url_launcher/url_launcher.dart';

// String localeName = Platform.localeName;

// // en_IN
// class Upitransactionpage extends StatefulWidget {
//   static const routeName = '/upi';
//   final filepath;
//   final bool ispaid;
//   Upitransactionpage({this.filepath, @required this.ispaid});

//   @override
//   _UpitransactionpageState createState() => _UpitransactionpageState();
// }

// class _UpitransactionpageState extends State<Upitransactionpage> {
//   Future<UpiResponse> _transaction;
//   UpiIndia _upiIndia = UpiIndia();
//   List<UpiApp> apps;
//   SnackBar snackBar;
//   @override
//   void initState() {
//     _upiIndia.getAllUpiApps().then((value) {
//       setState(() {
//         apps = value;
//       });
//     });
//     ispaid = widget.ispaid;
//     print(localeName);
//     super.initState();
//   }

//   void pop() async {
//     const url = "http://buymeacoff.ee/anandsubbu";
//     if (await canLaunch(url)) launch(url);
//   }

//   Future<UpiResponse> initiateTransaction(String app) async {
//     return _upiIndia.startTransaction(
//       app: app,
//       receiverUpiId: 'anandsubbu7@oksbi',
//       //'alagappanchetty@oksbi',
//       receiverName: 'Anand :: Product E-Catalogue',
//       transactionRefId: 'Productcatalogue',
//       transactionNote:
//           ispaid ? 'Catalogue without Watermark' : 'I just offer you a coffee',
//       amount: ispaid ? 57 : 27,
//     );
//   }

//   Widget displayUpiApps() {
//     if (apps == null)
//       return Center(child: CircularProgressIndicator());
//     else if (apps.length == 0)
//       return Center(child: Text("No apps found to handle transaction."));
//     else
//       return Center(
//         child: Wrap(
//           runSpacing: 3,
//           spacing: 3,
//           children: apps.map<Widget>((UpiApp app) {
//             return GestureDetector(
//               onTap: () async {
//                 _transaction = initiateTransaction(app.app);
//                 setState(() {});
//               },
//               child: Container(
//                 color: Colors.grey[100],
//                 height: 100,
//                 width: 100,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     Image.memory(app.icon, height: 60, width: 60),
//                     Text(app.name,
//                         style: TextStyle(), textAlign: TextAlign.center),
//                   ],
//                 ),
//               ),
//             );
//           }).toList(),
//         ),
//       );
//   }

//   Widget _firstwidget() {
//     return Column(
//       children: [
//         SizedBox(height: 20),
//         Text('✨ Download your Product catalogue ✨',
//             style: TextStyle(fontWeight: FontWeight.bold),
//             textAlign: TextAlign.center),
//         SizedBox(height: 20),
//         Center(
//             child: Text('Support Me by offering a cup of Coffee! 👍',
//                 textAlign: TextAlign.center)),
//         SizedBox(height: 7),
//         Center(child: Text('For just ₹ ${widget.ispaid ? 57 : 27}')),
//         SizedBox(height: 10),
//         (localeName != 'en_IN')
//             ? Container(
//                 height: 200,
//                 alignment: Alignment.center,
//                 child: RaisedButton(
//                     padding: EdgeInsets.all(15),
//                     child: Text('Buy me a coffee! ☕',
//                         style: TextStyle(color: Colors.white, fontSize: 21)),
//                     color: Colors.blue,
//                     onPressed: pop),
//               )
//             : displayUpiApps(),
//         SizedBox(height: 10),
//         if (localeName == 'en_IN')
//           Center(
//             child: Container(
//               color: Colors.grey[200],
//               padding: EdgeInsets.fromLTRB(50, 15, 50, 15),
//               child: Text('Buy me a coffee! ☕',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                   textAlign: TextAlign.center),
//             ),
//           ),
//       ],
//     );
//   }

//   bool ispaid;
//   @override
//   Widget build(BuildContext context) {
//     if (localeName != 'en_IN') ispaid = false;
//     return Scaffold(
//       appBar: AppBar(title: Text('Download Catalogue')),
//       body: ListView(
//         shrinkWrap: true,
//         children: <Widget>[
//           _firstwidget(),
//           SizedBox(height: 2),
//           FutureBuilder(
//             future: _transaction,
//             builder:
//                 (BuildContext context, AsyncSnapshot<UpiResponse> snapshot) {
//               if (snapshot.connectionState == ConnectionState.done) {
//                 if (snapshot.hasError) {
//                   return Center(child: Text('An Unknown error has occured'));
//                 }
//                 UpiResponse _upiResponse;
//                 _upiResponse = snapshot.data;
//                 if (_upiResponse.error != null) {
//                   String text = '';
//                   switch (snapshot.data.error) {
//                     case UpiError.APP_NOT_INSTALLED:
//                       text = "Requested app not installed on device";
//                       break;
//                     case UpiError.INVALID_PARAMETERS:
//                       text = "Requested app cannot handle the transaction";
//                       break;
//                     case UpiError.NULL_RESPONSE:
//                       text = "requested app didn't returned any response";
//                       break;
//                     case UpiError.USER_CANCELLED:
//                       text = "You cancelled the transaction";
//                       break;
//                   }
//                   return Center(child: Text(text));
//                 }
//                 bool transstatus = false;
//                 String result = '';
//                 String status = _upiResponse.status;
//                 switch (status) {
//                   case UpiPaymentStatus.SUCCESS:
//                     transstatus = true;
//                     result = 'Thanks For Your Coffee 😇 ';
//                     print('Transaction Successfull ');
//                     break;
//                   case UpiPaymentStatus.SUBMITTED:
//                     transstatus = true;
//                     result = ' Your Coffee is Ordered';
//                     print('Transaction Submitted 😊');
//                     break;
//                   case UpiPaymentStatus.FAILURE:
//                     result = 'Oppss, My Coffee is Cancelled 😔 ';
//                     print('Transaction Failed ');
//                     break;
//                   default:
//                     result = 'Oppss, My Coffee is Cancelled 😔 ';
//                     print('Received an Unknown transaction status');
//                 }
//                 return (transstatus == true)
//                     ? Column(
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
//                             child: RaisedButton(
//                               color: Colors.green,
//                               elevation: 12,
//                               child: Padding(
//                                 padding: const EdgeInsets.all(5),
//                                 child: Text(
//                                   '>>  Download PDF 🔥  <<',
//                                   style: TextStyle(
//                                       color: Colors.white, fontSize: 18),
//                                 ),
//                               ),
//                               onPressed: () {
//                                 OpenFile.open(widget.filepath);
//                               },
//                             ),
//                           ),
//                           Center(
//                               child: Container(
//                             color: Colors.greenAccent,
//                             alignment: Alignment.center,
//                             padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
//                             width: double.infinity,
//                             child: Text(
//                               result,
//                               style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white),
//                               textAlign: TextAlign.center,
//                             ),
//                           ))
//                         ],
//                       )
//                     : Center(
//                         child: Container(
//                         color: Colors.redAccent,
//                         alignment: Alignment.center,
//                         padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
//                         width: double.infinity,
//                         child: Text(
//                           result,
//                           style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white),
//                           textAlign: TextAlign.center,
//                         ),
//                       ));
//               } else
//                 return Text(' ');
//             },
//           ),
//           SizedBox(height: 30),
//           if (!(widget.ispaid))
//             // if (localeName != 'en_IN')
//             FlatButton(
//               color: Colors.grey[100],
//               onPressed: () {
//                 OpenFile.open(widget.filepath);
//               },
//               child: Text(
//                 'Skip -> I Don\'t like to Offer you a coffee',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 12),
//               ),
//             ),
//           SizedBox(height: 15),
//         ],
//       ),
//     );
//   }
// }
