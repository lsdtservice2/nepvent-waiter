import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nepvent_waiter/UI/AuthScreen/LoginWidget.dart';
import 'package:nepvent_waiter/UI/DisabledWidget.dart';
import 'package:nepvent_waiter/Utils/Constant.dart';
import 'package:nepvent_waiter/Utils/Urls.dart';

/// Interceptor to attach Bearer token and handle auth-related responses
class AuthInterceptor extends Interceptor {
  AuthInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    debugPrint('Request URL: ${options.uri}');

    final excludedPaths = <String>[urls['login']!];

    if (!excludedPaths.contains(options.path)) {
      final token = prefs.getString('token');

      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      } else {
        debugPrint('No token found in SharedPreferences.');
      }
    }

    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('Response Received: ${response.statusCode} => ${response.requestOptions.path}');
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final context = navigatorKey.currentContext;

    if (err.response != null && context != null) {
      final statusCode = err.response?.statusCode;
      final data = err.response?.data;
      debugPrint('Dio Error: $statusCode :::::: $data');
      if (statusCode == 406) {
        final message = data is String
            ? 'Session Expired. Please Sign-in Again'
            : data?['message'] ?? 'Session Expired';

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginWidget()));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFFe74f5b),
            content: Text(data?['message'] ?? 'Session Expired'),
          ),
        );
      }
      if (statusCode == 402) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DisableWidget()),
        );
      } else {
        handler.next(err);
      }
    } else {
      debugPrint('Dio Error without response: ${err.message}');
      handler.next(err);
    }
  }
}
