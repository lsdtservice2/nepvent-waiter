import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nepvent_waiter/Utils/Constant.dart';

class NotificationService {
  // static final NotificationService _instance = NotificationService._internal();
  //
  // factory NotificationService() => _instance;

  // Public async init method to be called once explicitly
  Future<void> init() async {
    await _initialize();
  }

  // Notification channels
  static const AndroidNotificationDetails _waiterCallChannel = AndroidNotificationDetails(
    'nepvent_waiter_calls',
    'Waiter Calls',
    channelDescription: 'Notifications for waiter calls',
    importance: Importance.max,
    priority: Priority.high,
    color: Color(0xFF303068),
    sound: RawResourceAndroidNotificationSound('slow_spring_board'),
    enableVibration: true,
    playSound: true,
    visibility: NotificationVisibility.public,
  );

  static const AndroidNotificationDetails _couponChannel = AndroidNotificationDetails(
    'nepvent_coupons',
    'Coupon Notifications',
    channelDescription: 'Notifications for coupon operations',
    importance: Importance.high,
    priority: Priority.defaultPriority,
  );

  static const DarwinNotificationDetails _darwinDetails = DarwinNotificationDetails(
    sound: 'slow_spring_board.aiff',
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  int _notificationId = 0;
  bool _notificationsEnabled = false;

  // Stream controllers
  final StreamController<ReceivedNotification> _didReceiveLocalNotificationStream =
      StreamController<ReceivedNotification>.broadcast();
  final StreamController<String?> _selectNotificationStream = StreamController<String?>.broadcast();

  // Background notification handler
  @pragma('vm:entry-point')
  static Future<void> backgroundNotificationHandler(NotificationResponse response) async {
    debugPrint('Background notification tapped: ${response.payload}');
    // Handle background notification tap
  }

  Future<void> _initialize() async {
    await _checkAndroidPermission();
    await _requestPermissions();
    _configureNotificationStreams();
    await _initializeNotifications();
  }

  Future<void> _checkAndroidPermission() async {
    if (Platform.isAndroid) {
      _notificationsEnabled =
          await _notifications
              .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
              ?.areNotificationsEnabled() ??
          false;
    }
  }

  Future<void> _requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await _requestIosPermissions();
    } else if (Platform.isAndroid) {
      await _requestAndroidPermissions();
    }
  }

  Future<void> _requestIosPermissions() async {
    await _notifications
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
    await _notifications
        .resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  Future<void> _requestAndroidPermissions() async {
    final granted = await _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    _notificationsEnabled = granted ?? false;
  }

  void _configureNotificationStreams() {
    _didReceiveLocalNotificationStream.stream.listen(_showNotificationDialog);
    _selectNotificationStream.stream.listen(_handleNotificationTap);
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings(
      '@mipmap/launcher_icon',
    );

    final DarwinInitializationSettings darwinSettings = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      // onDidReceiveLocalNotification: (id, title, body, payload) async {
      //   _didReceiveLocalNotificationStream.add(
      //     ReceivedNotification(id: id, title: title, body: body, payload: payload),
      //   );
      // },
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );

    await _notifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        _selectNotificationStream.add(details.payload);
      },
      onDidReceiveBackgroundNotificationResponse: backgroundNotificationHandler,
    );
  }

  void _showNotificationDialog(ReceivedNotification notification) async {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    await showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: notification.title != null ? Text(notification.title!) : null,
        content: notification.body != null ? Text(notification.body!) : null,
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _handleNotificationTap(String? payload) {
    if (payload != null) {
      try {
        final data = jsonDecode(payload) as Map<String, dynamic>;
        debugPrint('Notification payload: $data');
      } catch (e) {
        debugPrint('Error parsing notification payload: $e');
      }
    }
  }

  // Public notification methods
  Future<void> showWaiterCallNotification(Map<String, dynamic> data) async {
    final message = data['message'] ?? 'Waiter call';
    final tableNumber = data['tableNumber'] ?? 'Unknown table';

    await _notifications.show(
      _notificationId++,
      // 'Table $tableNumber needs assistance',
      'Nepvent',
      message,
      const NotificationDetails(android: _waiterCallChannel, iOS: _darwinDetails),
      payload: jsonEncode(data),
    );
  }

  // Future<void> showCouponSuccessNotification() async {
  //   await _notifications.show(
  //     _notificationId++,
  //     'Coupon Applied',
  //     'Your coupon has been successfully applied',
  //     NotificationDetails(android: _couponChannel),
  //   );
  // }

  // Future<void> showCouponErrorNotification() async {
  //   await _notifications.show(
  //     _notificationId++,
  //     'Coupon Error',
  //     'There was an error applying your coupon',
  //     NotificationDetails(android: _couponChannel),
  //   );
  // }

  void dispose() {
    _didReceiveLocalNotificationStream.close();
    _selectNotificationStream.close();
  }
}

class ReceivedNotification {
  final int id;
  final String? title;
  final String? body;
  final String? payload;

  const ReceivedNotification({required this.id, this.title, this.body, this.payload});
}
