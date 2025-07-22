import 'package:isar/isar.dart';


part 'Menus.g.dart';

@Collection()
class Menus {
  Id localId = Isar.autoIncrement;
  late int id;
  late String name;
  late double price;
  late bool vatInc;
  late List<Discount> discount;
  late List<Optioned> optioned;
  late int categoryMenuId;
  int? itemAvailable;
  late bool isWeighted;
}

@embedded
class Discount {
  late String name;
  late DateTime toDate;
  late DateTime toTime;
   bool? percent;
   int? discount;
   double? flatRate;
  late DateTime fromDate;
  late DateTime fromTime;
}
@embedded
class Optioned {
  late int max;
  late int min;
  late String name;
  late List<Opts> opts;
  late String type;
  late int current;

  Map<String, dynamic> toJson() {
    return {
      'max': max,
      'min': min,
      'name': name,
      'opts': opts.map((opt) => opt.toJson()).toList(),
      'type': type,
      'current': current,
    };
  }
}

@embedded
class Opts {
  late String optName;
  late int optPrice;
  late bool quantityEligible;
  late bool selected;
  late int count;

  Map<String, dynamic> toJson() {
    return {
      'optName': optName,
      'optPrice': optPrice,
      'quantityEligible': quantityEligible,
      'selected': selected,
      'count': count,
    };
  }
}

