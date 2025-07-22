import 'package:flutter/material.dart';
import 'package:nepvent_waiter/Controller/NepventProvider.dart';
import 'package:nepvent_waiter/UI/HomeWidget.dart';
import 'package:provider/provider.dart';

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    bool needRefresh = context.watch<NepventProvider>().isNeedRefresh;

    if (!needRefresh) {
      return const SizedBox.shrink(); // Avoid returning null
    }

    return FloatingActionButton(
      onPressed: () async {
        // Reset refresh flag
        context.read<NepventProvider>().isNeedRefresh = false;

        // Navigate with fade transition
        await Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, _, _) => const HomeWidget(),
            transitionsBuilder: (_, animation, _, child) =>
                FadeTransition(opacity: animation, child: child),
            transitionDuration: const Duration(milliseconds: 200),
          ),
        );
      },
      tooltip: 'Sync Data Later',
      backgroundColor: Colors.blue[800],
      elevation: 4,
      splashColor: Colors.blue[900],
      child: const Icon(Icons.sync, color: Colors.white, semanticLabel: 'Postpone sync'),
    );
  }
}
