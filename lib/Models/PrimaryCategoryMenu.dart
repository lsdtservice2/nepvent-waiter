import 'package:isar/isar.dart';

part 'PrimaryCategoryMenu.g.dart';

@Collection()
class PrimaryCategoryMenu {
  Id localId = Isar.autoIncrement;
  late int id;
  late String name;
}
