import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage with ChangeNotifier {
  final storage = FlutterSecureStorage();

  //Save Credentials
  Future savecurrency(String currency) async {
    await storage.delete(key: "currency");
    await storage.write(key: "currency", value: currency);
  }

  Future savecompanyname(String name) async {
    await storage.delete(key: "companyname");
    await storage.write(key: "companyname", value: name);
  }

  Future savecontactnumber(String name) async {
    await storage.delete(key: "contactnumber");
    await storage.write(key: "contactnumber", value: name);
  }

  Future<String> getcurrency() async {
    String? value = await storage.read(key: "currency");
    if (value == null) {
      return '';
    } else if (value == 'null') {
      return '';
    } else {
      return value;
    }
  }

  Future setloginval(String currency) async {
    await storage.delete(key: "login");
    await storage.write(key: "login", value: currency);
  }

  Future<String> getloginstatus() async {
    String? value = await storage.read(key: "login");
    if (value == null) {
      return '';
    } else if (value == 'null') {
      return '';
    } else {
      return value;
    }
  }

  Future<String> getcompanyname() async {
    String? value = await storage.read(key: "companyname");
    if (value == null) {
      return '';
    } else if (value == 'null') {
      return '';
    } else {
      return value;
    }
  }

  Future<String> getcontactno() async {
    String? value = await storage.read(key: "contactnumber");
    if (value == null) {
      return '';
    } else if (value == 'null') {
      return '';
    } else {
      return value;
    }
  }

  //Clear Saved Credentials
  Future clear() {
    return storage.deleteAll();
  }
}
