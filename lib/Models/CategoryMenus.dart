import 'package:isar/isar.dart';

part 'CategoryMenus.g.dart';

@Collection()
class CategoryMenus {
  Id localId = Isar.autoIncrement;
  late int id;
  late int primaryCategoryId;
  late String name;
  late bool disableDiscount;
}
