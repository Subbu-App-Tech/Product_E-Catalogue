import 'package:hive/hive.dart';

part 'VarietyProduct.g.dart';

// flutter packages pub run build_runner build
@HiveType(typeId: 1)
class VarietyProductM extends HiveObject {
  @HiveField(0)
  final String productid;
  @HiveField(1)
  final String id;
  @HiveField(2)
  String name;
  @HiveField(3)
  late double price;
  @HiveField(4)
  late double wsp;

  VarietyProductM({
    required this.productid,
    required this.id,
    required this.name,
    this.price = 0,
    this.wsp = 0,
  });

  void updatename(name) {
    this.name = name;
  }

  void updateprice(double price) {
    this.price = price;
  }

  void updatewsp(double wsp) {
    this.wsp = wsp;
  }

  String getIndex(int index) {
    switch (index) {
      case 0:
        return '$name';
      case 1:
        return '${price.toString()}';
    }
    return '';
  }
}
