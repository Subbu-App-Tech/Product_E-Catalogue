import 'package:flutter/material.dart';
import '../Widgets/Drawer.dart';
import '../Models/SecureStorage.dart';

class SettingScreen extends StatefulWidget {
  static const routeName = '/settingscreen';
  SettingScreen({Key key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final GlobalKey<ScaffoldState> _scafkey = new GlobalKey<ScaffoldState>();
  SnackBar snackBar;
  final _frm = GlobalKey<FormState>();
  String currency;
  String companyname;
  String mobileno;
  SecureStorage storage = SecureStorage();
  TextEditingController _textcontroller = TextEditingController();
  TextEditingController _companycontroller = TextEditingController();
  TextEditingController _mobilenocontroller = TextEditingController();
  @override
  void didChangeDependencies() async {
    currency = await storage.getcurrency();
    companyname = await storage.getcompanyname();
    mobileno = await storage.getcontactno();
    _textcontroller.text = currency;
    _companycontroller.text = companyname;
    _mobilenocontroller.text = mobileno;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scafkey,
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text('Setting'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          width: double.infinity,
          child: Card(
            elevation: 10,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: Text(
                    'Profile Details',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  padding: EdgeInsets.fromLTRB(15, 30, 15, 15),
                ),
                Container(
                  padding: EdgeInsets.all(25),
                  child: Form(
                      key: _frm,
                      child: Column(children: <Widget>[
                        TextFormField(
                          controller: _companycontroller,
                          decoration: InputDecoration(
                            labelText: 'Company Name',
                          ),
                          onSaved: (value) {
                            _companycontroller.text = value;
                            setState(() {});
                          },
                        ),
                        TextFormField(
                          controller: _mobilenocontroller,
                          decoration: InputDecoration(
                            labelText: 'Contact Number',
                          ),
                          onSaved: (value) {
                            _mobilenocontroller.text = value;
                            setState(() {});
                          },
                        ),
                        TextFormField(
                          controller: _textcontroller,
                          decoration: InputDecoration(
                            labelText: 'Currency',
                          ),
                          onSaved: (value) {
                            _textcontroller.text = value;
                            setState(() {});
                          },
                        ),
                      ])),
                ),
                RaisedButton(
                  color: Colors.green,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Text(
                      'Save',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  onPressed: () {
                    _frm.currentState.save();
                    storage.savecurrency(_textcontroller.text);
                    storage.savecompanyname(_companycontroller.text);
                    storage.savecontactnumber(_mobilenocontroller.text);
                    setState(() {});
                    _scafkey.currentState.showSnackBar(
                        SnackBar(content: Text('Saved Succesfully..!')));
                  },
                ),
                SizedBox(height: 25)
              ],
            ),
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.save),
      //   onPressed: () {
      //     _frm.currentState.save();
      //     storage.savecurrency(_textcontroller.text);
      //     storage.savecompanyname(_companycontroller.text);
      //     storage.savecontactnumber(_mobilenocontroller.text);
      //     setState(() {});
      //     _scafkey.currentState
      //         .showSnackBar(SnackBar(content: Text('Saved Succesfully..!')));
      //   },
      // ),
    );
  }
}
