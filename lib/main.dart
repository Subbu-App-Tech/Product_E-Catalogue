import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'Provider/ProductDataP.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'Home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize();
  FirebaseApp app = await Firebase.initializeApp();
  app.setAutomaticDataCollectionEnabled(true);
  app.setAutomaticResourceManagementEnabled(true);
  MobileAds.instance.initialize();
  Directory dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  if (!(Hive.isAdapterRegistered(0))) {
    Hive.registerAdapter(ProductAdapter());
    Hive.registerAdapter(VarietyProductMAdapter());
    Hive.registerAdapter(AppSettingAdapter());
  }
  await Hive.openBox<Product>('Product');
  await Hive.openBox<VarietyProductM>('Variety');
  await Hive.openBox<AppSetting>('AppSetting');
  runApp(HomePage());
}

Box<AppSetting> settingBox = Hive.box<AppSetting>('AppSetting');
AppSetting appSetting = settingBox.get('key') ?? AppSetting();

Future testing() async {}
