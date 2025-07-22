import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nepvent_waiter/UI/Design/AppTheme.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.of(context).primaryBackground,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 24),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/lottie_animations/loading.json',
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                  frameRate: FrameRate(60),
                  repeat: true,
                  animate: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
