import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:productcatalogue/adMob/my_ad_mod.dart';
import 'package:productcatalogue/export.dart';
import 'package:upi_india/upi_india.dart';
import 'package:open_file/open_file.dart';
import 'dart:io' show Platform;
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String localeName = Platform.localeName;

class PdfDownloadPg extends StatelessWidget {
  static const routeName = '/PdfDownloadPg';
  final String filepath;
  final bool ispaid;
  const PdfDownloadPg({required this.filepath, required this.ispaid});

  @override
  Widget build(BuildContext context) {
    Future loadAd() async {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
        await MyMobAd().showRewardedInterstitialAd(() {
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (ctx) =>
                      Upitransactionpg(filepath: filepath, ispaid: ispaid)));
        });
      });
    }

    return FutureBuilder(
        future: loadAd(),
        builder: (c, s) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        });
  }
}

class Upitransactionpg extends StatefulWidget {
  final String filepath;
  final bool ispaid;
  Upitransactionpg({required this.filepath, required this.ispaid});

  @override
  _UpitransactionpgState createState() => _UpitransactionpgState();
}

class _UpitransactionpgState extends State<Upitransactionpg> {
  UpiResponse? _transaction;
  UpiIndia _upiIndia = UpiIndia();
  late List<UpiApp> apps;
  SnackBar? snackBar;
  @override
  void initState() {
    ispaid = widget.ispaid;
    MyMobAd().showInterstitialAd();
    super.initState();
  }

  void pop() async {
    const url = "http://buymeacoff.ee/anandsubbu";
    if (await launchUrl(Uri.parse(url))) launchUrl(Uri.parse(url));
  }

  Future<UpiResponse> initiateTransaction(UpiApp app) async {
    return _upiIndia.startTransaction(
      app: app,
      receiverUpiId: 'anandsubbu7@oksbi',
      receiverName: 'Anand :: $AppName',
      transactionRefId: 'Productcatalogue',
      transactionNote:
          ispaid ? 'Catalogue without Watermark' : 'I just offer you a coffee',
      amount: ispaid ? 87 : 57,
    );
  }

  Widget displayUpiApps() {
    if (apps.length == 0)
      return Center(
          child: TextButton(
        child: Text("My UPI ID : anandsubbu7@oksbi"),
        onPressed: () {
          Clipboard.setData(new ClipboardData(text: 'anandsubbu7@oksbi'));
          BotToast.showText(text: 'UPI ID Copied to ClipBoard');
        },
      ));
    else
      return Center(
        child: Wrap(
          runSpacing: 3,
          spacing: 3,
          children: apps.map<Widget>((UpiApp app) {
            return GestureDetector(
              onTap: () async => onTap(app),
              child: Container(
                color: Colors.grey[100],
                height: 100,
                width: 100,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.memory(app.icon, height: 60, width: 60),
                    Text(app.name,
                        style: TextStyle(), textAlign: TextAlign.center),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      );
  }

  Widget _firstwidget() {
    print('isIndia ======= $isIndia');
    return Column(
      children: [
        SizedBox(height: 20),
        Text('✨ Download your Product catalogue ✨',
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),
        SizedBox(height: 20),
        Center(
            child: Text('Support Me by offering Cup of Coffee! 👍',
                textAlign: TextAlign.center)),
        SizedBox(height: 7),
        Center(child: Text('For just ₹ ${widget.ispaid ? 87 : 57}')),
        SizedBox(height: 10),
        (!isIndia)
            ? Container(
                height: 200,
                alignment: Alignment.center,
                // ignore: deprecated_member_use
                child: RaisedButton(
                    padding: EdgeInsets.all(15),
                    child: Text('Buy me a coffee! ☕',
                        style: TextStyle(color: Colors.white, fontSize: 21)),
                    color: Colors.blue,
                    onPressed: pop),
              )
            : displayUpiApps(),
        SizedBox(height: 10),
        if (isIndia)
          Center(
            child: Container(
              color: Colors.grey[200],
              padding: EdgeInsets.fromLTRB(50, 15, 50, 15),
              child: Text('Buy me a coffee! ☕',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  textAlign: TextAlign.center),
            ),
          ),
      ],
    );
  }

  String? result;
  String text = '';
  bool transstatus = false;
  void onTap(UpiApp app) async {
    try {
      _transaction = await initiateTransaction(app);
      String? status = _transaction?.status;
      switch (status) {
        case UpiPaymentStatus.SUCCESS:
          transstatus = true;
          result = 'Thanks For Your Coffee 😇 ';
          print('Transaction Successfull ');
          break;
        case UpiPaymentStatus.SUBMITTED:
          transstatus = true;
          result = ' Your Coffee is Ordered';
          print('Transaction Submitted 😊');
          break;
        case UpiPaymentStatus.FAILURE:
          result = 'Oppss, My Coffee is Cancelled 😔 ';
          print('Transaction Failed ');
          break;
        default:
          result = 'Oppss, My Coffee is Cancelled 😔 ';
          print('Received an Unknown transaction status');
      }
      BotToast.showText(text: result ?? '');
    } catch (e) {
      switch (e.runtimeType) {
        case UpiIndiaAppNotInstalledException:
          text = "Requested app not installed on device";
          break;
        case UpiIndiaUserCancelledException:
          text = 'You cancelled the transaction';
          break;
        case UpiIndiaNullResponseException:
          text = "Requested app didn't return any response";
          break;
        case UpiIndiaInvalidParametersException:
          text = "Requested app cannot handle the transaction";
          break;
        default:
          text = "An Unknown error has occurred";
          break;
      }
      BotToast.showText(text: text);
    }
    setState(() {});
  }

  Future getCountry() async {
    try {
      apps = await _upiIndia.getAllUpiApps();
      http.Response data = await http.get(Uri.parse('http://ip-api.com/json'));
      Map map = jsonDecode(data.body);
      country = map['country'] ?? '';
      print('---------------------$country | ${apps.length}');
    } catch (e) {
      print('Error :: $e');
      country = '';
    }
  }

  String country = '';
  late bool ispaid;
  late bool isIndia;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Download Catalogue')),
      body: FutureBuilder(
          future: getCountry(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done)
              return Center(child: CircularProgressIndicator());
            if (country != 'India') ispaid = false;
            isIndia = country == 'India';
            return ListView(
              shrinkWrap: true,
              children: <Widget>[
                _firstwidget(),
                SizedBox(height: 2),
                (transstatus == true)
                    ? Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                            // ignore: deprecated_member_use
                            child: RaisedButton(
                                color: Colors.green,
                                elevation: 12,
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text('>>  Download PDF 🔥  <<',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18)),
                                ),
                                onPressed: () =>
                                    OpenFile.open(widget.filepath)),
                          ),
                          Center(
                              child: Container(
                            color: Colors.greenAccent,
                            alignment: Alignment.center,
                            padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                            width: double.infinity,
                            child: Text(result ?? '',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                                textAlign: TextAlign.center),
                          ))
                        ],
                      )
                    : (result == null)
                        ? SizedBox()
                        : Center(
                            child: Container(
                            color: Colors.redAccent,
                            alignment: Alignment.center,
                            padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                            width: double.infinity,
                            child: Text(result!,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                                textAlign: TextAlign.center),
                          )),
                SizedBox(height: 30),
                Container(
                  color: Colors.grey[100],
                  child: TextButton(
                    onPressed: () async {
                      await MyMobAd().showRewardedInterstitialAd(() {
                        OpenFile.open(widget.filepath);
                      });
                    },
                    child: Text(
                      'Skip -> I Don\'t like to Offer you a coffee',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                SizedBox(height: 15),
              ],
            );
          }),
    );
  }
}
