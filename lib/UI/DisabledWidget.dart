import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:nepvent_waiter/UI/Design/AppTheme.dart';
import 'package:nepvent_waiter/UI/Design/ButtonWidget.dart';
import 'package:nepvent_waiter/UI/HomeWidget.dart';
import 'package:nepvent_waiter/Utils/Constant.dart';

class DisableWidget extends StatefulWidget {
  const DisableWidget({super.key});

  @override
  State<DisableWidget> createState() => _DisableWidgetState();
}

class _DisableWidgetState extends State<DisableWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String ipAddress = 'Not found';

  @override
  void initState() {
    super.initState();
    _loadIpAddress();
  }

  Future<void> _loadIpAddress() async {
    setState(() {
      ipAddress = prefs.getString('ipAddress') ?? 'Unavailable';
    });
  }

  void _logoutAndRetry() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeWidget()));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: theme.primaryBackground,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Text('IP Address: $ipAddress', style: theme.subtitle2),
                ),
                const SizedBox(height: 16),
                Lottie.asset(
                  'assets/lottie_animations/accessDenied.json',
                  width: 300,
                  fit: BoxFit.cover,
                  frameRate: FrameRate(60),
                  repeat: true,
                ),
                const SizedBox(height: 24),
                Text(
                  'Account Disabled',
                  style: theme.title2.override(
                    fontFamily: 'Outfit',
                    color: theme.primaryText,
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                    useGoogleFonts: GoogleFonts.asMap().containsKey(theme.title2.fontFamily),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Your account has been temporarily disabled.',
                  textAlign: TextAlign.center,
                  style: theme.subtitle2.override(
                    fontFamily: 'Outfit',
                    color: theme.primaryText,
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                    useGoogleFonts: GoogleFonts.asMap().containsKey(theme.subtitle2.fontFamily),
                  ),
                ),
                const SizedBox(height: 8),
                Text('Please contact your supervisor.', textAlign: TextAlign.center, style: theme.bodyText2),
                const SizedBox(height: 40),
                ButtonWidget(
                  onPressed: _logoutAndRetry,
                  text: 'Log out & Try Again',
                  options: ButtonOptions(
                    color: Colors.deepOrangeAccent,
                    textStyle: theme.title2.override(
                      fontFamily: theme.title2.fontFamily,
                      color: theme.white,
                      useGoogleFonts: GoogleFonts.asMap().containsKey(theme.title2.fontFamily),
                    ),
                    borderSide: const BorderSide(color: Colors.transparent),
                  ),
                ),
                const SizedBox(height: 40),
                Text('Nepvent pro v3.0.0', style: theme.bodyText1),
                Text('Nepvent Support: 9851255225', style: theme.bodyText2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
