import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:nepvent_waiter/Controller/AuthInterceptor.dart';
import 'package:nepvent_waiter/Controller/NepventProvider.dart';
import 'package:nepvent_waiter/Controller/NotificationService.dart';
import 'package:nepvent_waiter/Controller/SocketService.dart'; // Add this import if you have SocketService
import 'package:nepvent_waiter/Models/CategoryMenus.dart';
import 'package:nepvent_waiter/Models/Menus.dart';
import 'package:nepvent_waiter/Models/PrimaryCategoryMenu.dart';
import 'package:nepvent_waiter/Models/TableData.dart';
import 'package:nepvent_waiter/Models/Table_Location.dart';
import 'package:nepvent_waiter/Models/UserProfile.dart';
import 'package:nepvent_waiter/UI/HomeWidget.dart';
import 'package:nepvent_waiter/Utils/Constant.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart'; // Add this import
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();

  // Initialize services
  final notificationService = NotificationService();
  await notificationService.init();
  final socketService = SocketService(notificationService); // If you have SocketService

  dio.interceptors.add(AuthInterceptor());

  final dir = await getApplicationSupportDirectory();
  isar = await Isar.open(
    [
      PrimaryCategoryMenuSchema,
      MenusSchema,
      CategoryMenusSchema,
      TableLocationSchema,
      TableDataSchema,
      UserProfileSchema,
    ],
    directory: dir.path,
    name: "Nepvent Local Database",
  );

  runApp(
    MultiProvider(
      providers: [
        // Provide the NotificationService
        Provider<NotificationService>.value(value: notificationService),

        // Provide the SocketService if you have one
        Provider<SocketService>.value(value: socketService),

        // Add any other providers
        ChangeNotifierProvider(create: (_) => NepventProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
      home: HomeWidget(),
      navigatorKey: navigatorKey,
    );
  }
}
