import 'package:flutter/material.dart';
import 'package:nepvent_waiter/Controller/AuthInterceptor.dart';
import 'package:nepvent_waiter/Controller/SocketService.dart';
import 'package:nepvent_waiter/Ticket/DashboardWidget.dart';
import 'package:nepvent_waiter/UI/AuthScreen/LoginWidget.dart';
import 'package:nepvent_waiter/UI/AuthScreen/SetIPWidget.dart';
import 'package:nepvent_waiter/UI/Design/LoadingWidget.dart';
import 'package:nepvent_waiter/UI/Screens/TransitionWidget.dart';
import 'package:nepvent_waiter/Utils/Constant.dart';
import 'package:provider/provider.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String? ipAddress;
  String? token;
  bool? ticketing;
  late SocketService socketService;

  @override
  void initState() {
    super.initState();
    socketService = context.read<SocketService>();
    _initializeApp();
  }

  Future _initializeApp() async {
    final values = await _getSharedValue();
    if (values != null) {
      setState(() {
        ipAddress = values['ipAddress'];
        token = values['token'];
        ticketing = values['ticketing'];
      });

      // Connect socket if token exists
      if (token != null && token!.isNotEmpty) {
        String socketUrl = "http://$ipAddress:8080/${values['tenant']}";
        try {
          debugPrint('Attempting socket connection...');
          await socketService.connectSocket(socketUrl, token!);
          debugPrint('Socket connected successfully');
        } catch (e) {
          debugPrint('Socket connection error: $e');
          // You might want to show an error message to the user here
        }
      }
    }
  }

  Future<Map<String, dynamic>?> _getSharedValue() async {
    try {
      final ipAddress = prefs.getString('ipAddress') ?? '';
      final token = prefs.getString('token') ?? '';
      final tenant = prefs.getString('tenant') ?? '';
      final ticketing = prefs.getBool('Ticketing') ?? false;

      if (token.isNotEmpty) {
        dio.interceptors.clear();
        dio.interceptors.add(AuthInterceptor());
      }

      dio.options.baseUrl = 'http://${prefs.getString('ipAddress')}:8080/';

      return {'ipAddress': ipAddress, 'token': token, 'tenant': tenant, 'ticketing': ticketing};
    } catch (e) {
      debugPrint('Error getting shared values: $e');
      return null;
    }
  }

  @override
  void dispose() {
    // Disconnect socket when widget is disposed
    // socketService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: FutureBuilder(
        future: _getSharedValue(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final data = snapshot.data ?? {};
            final String ipAddress = data['ipAddress'] ?? '';
            final String token = data['token'] ?? '';
            final bool ticketing = data['ticketing'] ?? false;

            debugPrint('Token: $token');

            if (ipAddress.isEmpty) {
              return const SetIPWidget();
            } else if (token.isEmpty) {
              return const LoginWidget();
            } else {
              return ticketing ? const DashboardWidget() : const TransitionWidget();
            }
          }
        },
      ),
    );
  }
}
