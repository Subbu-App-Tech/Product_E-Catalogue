import 'package:flutter/material.dart';
import 'package:productcatalogue/export.dart';
import '../Auth/sign_in.dart';

class LoginPage extends StatefulWidget {
  final Function() onDone;
  const LoginPage({super.key, required this.onDone});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Widget _signInButton() {
    return InkWell(
      onTap: () {
        FutureBuilder(
          future: signInWithGoogle().whenComplete(() {
            widget.onDone();
          }),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Text('Done');
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        );
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(40))),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(image: AssetImage("assets/google_logo.png"), height: 30),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'Sign in with Google',
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String? loginstatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.lightBlue[800],
            child: Image(
                image: AssetImage("assets/bluescreen.jpg"), fit: BoxFit.fill),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Spacer(),
                  Container(
                      child: Text(AppName,
                          style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white))),
                  SizedBox(height: 30),
                  Card(
                      color: Colors.white,
                      child: Image(
                        image: AssetImage("assets/productc.png"),
                        height: 150,
                      ),
                      elevation: 18),
                  SizedBox(height: 40),
                  _signInButton(),
                  SizedBox(height: 30),
                  Text(
                    'Subbu\'s App Tech',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.white60,
                            blurRadius: 7,
                            offset: Offset(-1, 5.0),
                          ),
                        ]),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      storage.setloginval('Skip_login');
                      widget.onDone();
                    },
                    child: Text(
                      'Skip Login For Now -->',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
