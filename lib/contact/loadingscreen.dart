import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
                        child: Text('Product E-Catalogue',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 27,
                                fontWeight: FontWeight.bold,
                                color: Colors.white))),
                    SizedBox(height: 32),
                    Card(
                        color: Colors.white,
                        child: Image(
                          image: AssetImage("assets/productc.png"),
                          height: 150,
                        ),
                        elevation: 18),
                    SizedBox(height: 40),
                    SizedBox(height: 30),
                    Text(
                      'Subbu\'s App Tech',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Spacer(),
                    Text('Made with ❤ in India',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    SizedBox(height: 5),
                    Image(
                      image: AssetImage("assets/indiaflag.png"),
                      height: 30,
                    ),
                    SizedBox(height: 13)
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          ],
        ),
      ),
    );
  }
}
