import 'package:flutter/material.dart';
import '../Screens/Import.dart';
import 'package:provider/provider.dart';
import '../Provider/CategoryDataP.dart';
import '../Provider/ProductDataP.dart';
import '../Provider/VarietyDataP.dart';
import '../Auth/sign_in.dart';
import '../main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Screens/Export.dart';
import '../Screens/Settingscreen.dart';
import '../contact/Aboutus.dart';
import '../contact/Contactus.dart';
import '../Models/SecureStorage.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key key}) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  SecureStorage storage = SecureStorage();
  String loginstatus;
  FirebaseUser user;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String imageurl;

  @override
  void initState() {
    initUser();
    super.initState();
  }

  initUser() async {
    user = await _auth.currentUser();
    setState(() {
      imageurl = user?.photoUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget _deleteconfirmation(BuildContext context) {
      return AlertDialog(
        title: Text(
          'Do You Want to Delete All Data',
        ),
        content: Text('Note: You can\'t redo it'),
        actions: [
          RaisedButton(
            child: Text(
              'Delete Data',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.red,
            onPressed: () {
              setState(() {
                Provider.of<VarietyData>(context, listen: false).deleteall();
                Provider.of<CategoryData>(context, listen: false).deleteall();
                Provider.of<ProductData>(context, listen: false).deleteall();
              });
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (ctx) => ProductCatalogue()));
            },
          ),
          RaisedButton(
            child: Text('Back'),
            color: Colors.blueAccent,
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      );
    }

    return Drawer(
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: (user == null)
                ? Text('🙏 Welcome 🙏')
                : Text("${user?.displayName}"),
            accountEmail: (user == null)
                ? Text('You Can Login Here')
                : Text("${user?.email}"),
            currentAccountPicture: CircleAvatar(
              backgroundImage: (imageurl == null)
                  ? AssetImage("assets/NoImage.png")
                  : NetworkImage("${user?.photoUrl}"),
              backgroundColor: Colors.white,
            ),
            onDetailsPressed: () {
              storage.setloginval('exited');
              setState(() {});
              (user == null)
                  ? Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (ctx) => ProductCatalogue()))
                  : Navigator.pushNamed(context, SettingScreen.routeName);
            },
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                ListTile(
                    dense: true,
                    title: Text('Home'),
                    leading: Icon(Icons.home, color: Colors.blue),
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => ProductCatalogue()));
                      setState(() {});
                    }),
                Divider(),
                ListTile(
                    dense: true,
                    leading: Icon(Icons.import_export, color: Colors.blue),
                    title: Text('Import Data'),
                    onTap: () {
                      Navigator.pushNamed(context, ImportExport.routeName);
                    }),
                Divider(),
                ListTile(
                    dense: true,
                    leading: Icon(Icons.file_download, color: Colors.blue),
                    title: Text('Export Data'),
                    onTap: () {
                      Navigator.pushNamed(context, ExportData.routeName);
                    }),
                Divider(),
                ListTile(
                    dense: true,
                    leading:
                        Icon(Icons.settings_applications, color: Colors.blue),
                    title: Text('Setting'),
                    onTap: () {
                      Navigator.pushNamed(context, SettingScreen.routeName);
                    }),
                Divider(),
                ListTile(
                    dense: true,
                    leading: Icon(Icons.contact_mail, color: Colors.blue),
                    title: Text('Contact us'),
                    onTap: () {
                      Navigator.pushNamed(context, ContactUs.routeName);
                    }),
                Divider(),
                ListTile(
                    dense: true,
                    leading: Icon(Icons.info, color: Colors.blue),
                    title: Text('About App'),
                    onTap: () {
                      Navigator.pushNamed(context, AboutUs.routeName);
                    }),
                Divider(),
                ListTile(
                    dense: true,
                    leading: Icon(Icons.delete_forever, color: Colors.red),
                    title: Text('Delete all Data'),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            _deleteconfirmation(context),
                      );
                    }),
                Divider(),
                ListTile(
                    dense: true,
                    leading: Icon(Icons.exit_to_app, color: Colors.red),
                    title: (user == null) ? Text('Exit') : Text('Sign out'),
                    onTap: () {
                       setState(() {
                      signOutGoogle();
                      storage.setloginval('exited');
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => ProductCatalogue()));
                    });
                    }),
              ],
            ),
          ),
        ],
      ),
      elevation: 12,
    );
  }
}
