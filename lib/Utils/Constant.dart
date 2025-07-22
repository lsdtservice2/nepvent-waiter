import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';

//navigator Key
final navigatorKey = GlobalKey<NavigatorState>();

//shared Preference
late SharedPreferences prefs;

//Dio
var dio = Dio();

// Isar Initialize
late Isar isar;
