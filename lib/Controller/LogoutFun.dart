import 'package:flutter/material.dart';
import 'package:nepvent_waiter/Controller/SocketService.dart';
import 'package:nepvent_waiter/Models/UserProfile.dart';
import 'package:nepvent_waiter/UI/HomeWidget.dart';
import 'package:nepvent_waiter/Utils/Constant.dart';
import 'package:provider/provider.dart';

void logout() async {
  await isar.writeTxn(() async {
    await Future.wait([isar.userProfiles.clear()]);
  });
  await prefs.setString('token', '');
  navigatorKey.currentContext!.read<SocketService>().disconnect();
  Navigator.pushReplacement(
    navigatorKey.currentContext!,
    MaterialPageRoute(builder: (context) => const HomeWidget()),
  );
}
