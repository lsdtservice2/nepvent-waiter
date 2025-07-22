import 'package:isar/isar.dart';

part 'UserProfile.g.dart';

@Collection()
class UserProfile {
  Id localId = Isar.autoIncrement;
  late String restoName;
  late String fName;
  late String lName;
  late String username;
  late String email;
  late List<String> roles;
}
