import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'Provider/ProductDataP.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'Models/ProductModel.dart';
import 'Models/VarietyProductModel.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'Models/CategoryModel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize();
  FirebaseApp app = await Firebase.initializeApp();
  app.setAutomaticDataCollectionEnabled(true);
  app.setAutomaticResourceManagementEnabled(true);
  MobileAds.instance.initialize();
  // FirebaseAuth.instance.setSettings();
  Box<ProductModel> pbox;
  Box<VarietyProductM> vbox;
  Box<CategoryModel> cbox;
  Directory dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  if (!(Hive.isAdapterRegistered(0))) {
    Hive.registerAdapter(ProductModelAdapter());
    Hive.registerAdapter(VarietyProductMAdapter());
    Hive.registerAdapter(CategoryModelAdapter());
  }
  pbox = await Hive.openBox<ProductModel>('ProductModel');
  vbox = await Hive.openBox<VarietyProductM>('VarietyProductM');
  cbox = await Hive.openBox<CategoryModel>('CategoryModel');
  // await testing();
  runApp(HomePage(cbox: cbox, pbox: pbox, vbox: vbox));
}

Future testing() async {
  try {
    print(await Permission.storage.status);
    bool isAcc = await Permission.storage.request().isGranted;
    if (!isAcc) await Permission.storage.request();
    isAcc = await Permission.storage.request().isGranted;
    String dir = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);
    Directory savedDir = Directory(dir + '/Product E-catalogue');
    bool hasExisted = await savedDir.exists();
    print('>>>');
    if (!hasExisted) await savedDir.create(recursive: true);
    print('---$savedDir');
  } on Exception catch (e) {
    print('Error:: $e');
  }
}
