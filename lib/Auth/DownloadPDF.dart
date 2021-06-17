// import 'package:flutter/material.dart';
// import 'package:open_file/open_file.dart';
// // import 'package:google_mobile_ads/google_mobile_ads.dart';

// import 'package:google_mobile_ads/google_mobile_ads.dart';

// class ViewAdToDownload extends StatefulWidget {
//   static const routeName = '/upi';
//   final String filepath;
//   ViewAdToDownload({this.filepath, @required this.ispaid});

//   @override
//   _ViewAdToDownloadState createState() => _ViewAdToDownloadState();
// }

// class _ViewAdToDownloadState extends State<ViewAdToDownload> {
//   SnackBar snackBar;
//   @override
//   void initState() {
//     super.initState();
//   }


//   Future loadandshow() async {

//   }

//   Widget _firstwidget() {
//     int balance = ispaid ? 30 - _coins : 10 - _coins;
//     return Column(
//       children: [
//         SizedBox(height: 20),
//         Text('✨ Download your Product catalogue ✨',
//             style: TextStyle(fontWeight: FontWeight.bold),
//             textAlign: TextAlign.center),
//         SizedBox(height: 15),
// Text('If you Like My Work On This App.''\nPlease Buy me a Cof'),

//         SizedBox(height: 20),
//           RaisedButton(
//             padding: EdgeInsets.all(10),
//             color: Colors.blue,
//             onPressed: () => OpenFile.open(widget.filepath),
//             child: Text(
//               ' Download Your PDF ',
//               textAlign: TextAlign.center,
//               style: TextStyle(color: Colors.white)
//             ),
//           ),
//       ],
//     );
//   }

//   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

//   bool ispaid;
//   @override
//   Widget build(BuildContext context) {
//     isloded = isloded ?? false;
//     return Scaffold(
//       key: _scaffoldKey,
//       appBar: AppBar(title: Text('Download Catalogue')),
//       body: FutureBuilder(
//           future: loadandshow(),
//           builder: (ctx, sta) {
//             if (sta.connectionState == ConnectionState.done) {
//               return ListView(
//                 shrinkWrap: true,
//                 children: [_firstwidget()],
//               );
//             } else {
//               return Center(child: CircularProgressIndicator());
//             }
//           }),
//     );
//   }
// }
