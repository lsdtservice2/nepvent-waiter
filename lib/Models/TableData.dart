import 'package:isar/isar.dart';
part 'TableData.g.dart';

@Collection()
class TableData{
  Id localId = Isar.autoIncrement;
  late int id;
  late int locationId;
  late String table_name;
  late bool occupied;
  late List<JoinedTable> joinedTable;
  late List<SourceTable> sourceTable;
}
@embedded
class JoinedTable{
  late int id;
  late int table;
  late int joinTable;
  late PrimaryJoin primaryJoin;
}
@embedded
class PrimaryJoin{
  late int id;
  late String table_name;
}

@embedded
class SourceTable{
  late int id;
  late int table;
  late int joinTable;
  late SecondaryTable secondaryTable;
}
@embedded
class SecondaryTable{
  late int id;
  late String table_name;

}

