import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:firebase_admob/firebase_admob.dart';

class ViewAdToDownload extends StatefulWidget {
  static const routeName = '/upi';
  final filepath;
  final bool ispaid;
  ViewAdToDownload({this.filepath, @required this.ispaid});

  @override
  _ViewAdToDownloadState createState() => _ViewAdToDownloadState();
}

class _ViewAdToDownloadState extends State<ViewAdToDownload> {
  SnackBar snackBar;
  int retries;
  @override
  void initState() {
    isloded = false;
    retries = 0;
    FirebaseAdMob.instance.initialize(appId:
    //  FirebaseAdMob.testAppId
        'ca-app-pub-9568938816087708~5406343573'
        );
    ispaid = widget.ispaid ?? false;
    RewardedVideoAd.instance.listener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      events = event;
      if (event == RewardedVideoAdEvent.rewarded) {
        setState(() {
          _coins += rewardAmount;
        });
        print('$_coins | $rewardAmount');
        _scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text('You Earned 10 Points.')));
      } else if (event == RewardedVideoAdEvent.failedToLoad) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Sorry, Failed To Load Ad...'
              ' Please Check your Internet Connection or Retry it'),
        ));
      }
    };
    super.initState();
  }

  RewardedVideoAdEvent events;
  int _coins = 0;
  bool isloded;
  Future loadandshow() async {
    isloded = await RewardedVideoAd.instance
        .load(
            // adUnitId: RewardedVideoAd.testAdUnitId,
            adUnitId: 'ca-app-pub-9568938816087708/8867980391',
            targetingInfo: targetingInfo)
        .catchError((e) {
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(content: Text('Sorry, Error To Load Ad : $e')));
    });
    await Future.delayed(Duration(seconds: 2), () {});
    print('Completed | $isloded');
  }

  MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
      childDirected: true,
      // testDevices: ['70986832EA2D276F6277A5461962A4EC'],
      nonPersonalizedAds: true);
  Widget _firstwidget() {
    int balance = ispaid ? 30 - _coins : 10 - _coins;
    return Column(
      children: [
        SizedBox(height: 20),
        Text('✨ Download your Product catalogue ✨',
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),
        SizedBox(height: 30),
        Center(
            child: Text(' Please View Ads to get points ',
                textAlign: TextAlign.center)),
        SizedBox(height: 15),
        Center(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Your Current Point', style: TextStyle(fontSize: 18)),
                Text('$_coins',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
              ],
            ),
          ),
        ),
        SizedBox(height: 15),
        RaisedButton.icon(
            color: Colors.blue,
            onPressed: () async {
              try {
                retries += 1;
                if (events == RewardedVideoAdEvent.loaded) {
                  RewardedVideoAd.instance.show();
                } else {
                  setState((){});
                }
              } catch (e) {
                _scaffoldKey.currentState.showSnackBar(
                    SnackBar(content: Text('Sorry, Error To Load Ads : $e')));
              }
            },
            icon: Icon(Icons.monetization_on, color: Colors.white),
            label: Text(' View Ad ',
                style: TextStyle(fontSize: 12, color: Colors.white))),
        SizedBox(height: 20),
        Container(
          color: Colors.grey[100],
          padding: EdgeInsets.all(10),
          child: Text(
              (_coins >= (ispaid ? 30 : 10))
                  ? 'Thanks For Viewing Ad. This Help Me to Generate Fund to Improve App'
                  : '$balance Points Is Required to Download your PDF ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              textAlign: TextAlign.center),
        ),
        SizedBox(height: 20),
        if ((_coins >= (ispaid ? 30 : 10)) || retries > 3)
          RaisedButton(
            padding: EdgeInsets.all(10),
            color: Colors.blue,
            onPressed: () => OpenFile.open(widget.filepath),
            child: Text(
              ' Download Your PDF ',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),SizedBox(height: 30),
          Text('If Ad Not Loading, Please press Button for 5 times.')
      ],
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//   OpenFile.open(widget.filepath);
  bool ispaid;
  @override
  Widget build(BuildContext context) {
    isloded = isloded ?? false;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('Download Catalogue')),
      body: FutureBuilder(
          future: loadandshow(),
          builder: (ctx, sta) {
            if (sta.connectionState == ConnectionState.done) {
              return ListView(
                shrinkWrap: true,
                children: <Widget>[_firstwidget()],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
