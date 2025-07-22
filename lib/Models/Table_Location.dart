import 'package:isar/isar.dart';
part 'Table_Location.g.dart';
@Collection()
class TableLocation {
 Id localId = Isar.autoIncrement;
 late int id;
 late  String name;
}