import 'package:flutter/material.dart';
import 'package:nepvent_waiter/Models/UserProfile.dart';
import 'package:nepvent_waiter/UI/HomeWidget.dart';
import 'package:nepvent_waiter/Utils/Constant.dart';

void logout() async {
  await isar.writeTxn(() async {
    await Future.wait([isar.userProfiles.clear()]);
  });
  await prefs.setString('token', '');
  // socketService.disconnect();
  Navigator.pushReplacement(
    navigatorKey.currentContext!,
    MaterialPageRoute(builder: (context) => const HomeWidget()),
  );
}
