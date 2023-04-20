import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';

part 'Settings.g.dart';

@HiveType(typeId: 10)
class AppSetting with ChangeNotifier {
  @HiveField(0)
  String? apiKey;
  @HiveField(1)
  bool? viewMode;
  @HiveField(2)
  String? password;

  AppSetting({this.apiKey, this.viewMode, this.password});

  set setViewMode(viewMode) => this.viewMode = viewMode;
  bool get isViewMode => this.viewMode ?? false;
}
