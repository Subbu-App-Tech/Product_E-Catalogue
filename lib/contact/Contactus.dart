import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';
// import 'dart:io';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:image_picker/image_picker.dart';

const String val = '''
If You want Product E-Catalogue For your own Business.
we were providing Mobile Apps & Website Services.
Please send your requirements to anandsubbu7@gmail.com.
''';

class ContactUs extends StatefulWidget {
  static const routeName = '/ContactUs';
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  List<String> attachments = [];
  bool? isHTML = false;

  final _subjectController = TextEditingController();

  final _bodyController = TextEditingController(
    text: 'Mail body...',
  );

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> send() async {
    final Email email = Email(
      body: _bodyController.text,
      subject: isbus!
          ? ''' App Develop Query '''
          : ''' Related to Product Catalogue :-
      ${_subjectController.text}''',
      recipients: ['anandsubbu7@gmail.com', 'anandsubbuapps@gmail.com'],
      attachmentPaths: attachments,
      isHTML: isHTML!,
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'Thanks for mail, we will get back to you...!';
    } catch (error) {
      platformResponse = 'Error';
      platformResponse = error.toString();
    }

    if (!mounted) return;
    // ignore: deprecated_member_use
    _scaffoldKey.currentState!.showSnackBar(SnackBar(
      content: Text(platformResponse),
    ));
  }

  bool? isbus;
  @override
  Widget build(BuildContext context) {
    isbus = ModalRoute.of(context)!.settings.arguments as bool?;
    isbus = isbus ?? false;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(isbus! ? 'App Requirement' : 'Mail to Us'),
        actions: <Widget>[
          IconButton(
            onPressed: send,
            icon: Icon(Icons.send),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              if (isbus!)
                Container(
                  child: Column(
                    children: [
                      Text(
                        'Catalogue App For Your Business',
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(val),
                    ],
                  ),
                  padding: EdgeInsets.all(12),
                ),
              // Padding(padding: EdgeInsets.all(8.0)),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  controller: _subjectController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Subject'),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  controller: _bodyController,
                  maxLines: 10,
                  decoration: InputDecoration(
                      labelText: 'Body', border: OutlineInputBorder()),
                ),
              ),
              CheckboxListTile(
                title: Text('HTML'),
                onChanged: (bool? value) {
                  setState(() {
                    isHTML = value;
                  });
                },
                value: isHTML,
              ),
              Wrap(children: [
                ...attachments
                    .map((item) => Container(
                          height: 50,
                          width: 50,
                          child: Image.file(File(item)),
                        ))
                    .toList()
              ]),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.camera),
        label: Text('Add Image'),
        onPressed: () {
          chooseimage(context);
        },
      ),
    );
  }

  void chooseimage(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return Container(
            padding: EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 150,
                  width: 150,
                  child: TextButton(
                    child: Column(
                      children: [
                        Image.asset('assets/camera.png', fit: BoxFit.fill),
                        Text('Camera')
                      ],
                    ),
                    onPressed: () async {
                      final pick = await ImagePicker()
                          .pickImage(source: ImageSource.camera);
                      if (pick != null)
                        setState(() => attachments.add(pick.path));
                      Navigator.pop(context);
                    },
                  ),
                ),
                Container(
                  height: 150,
                  width: 150,
                  child: TextButton(
                    child: Column(
                      children: [
                        Image.asset('assets/gallery.png', fit: BoxFit.fill),
                        Text('Gallery')
                      ],
                    ),
                    onPressed: () async {
                      final pick = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      if (pick != null)
                        setState(() => attachments.add(pick.path));
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            ),
          );
        });
  }
}

// ),
// routes: {
//   ExportData.routeName: (ctx) => ExportData(),
//   SettingScreen.routeName: (ctx) => SettingScreen(),
//   ImportExport.routeName: (ctx) => ImportExport(),
//   // ContactUs.routeName: (ctx) => ContactUs(),
//   AboutUs.routeName: (ctx) => AboutUs(),
// },
