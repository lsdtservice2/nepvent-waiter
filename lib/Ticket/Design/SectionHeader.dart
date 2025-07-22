import 'package:flutter/material.dart';
import 'package:nepvent_waiter/UI/Design/AppTheme.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final bool isRequired;

  const SectionHeader({super.key, required this.title, required this.isRequired});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: theme.primaryText, // Using primaryText from theme
          ),
        ),
        if (isRequired)
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              '*',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: theme.redSalsa, // Using redSalsa from theme
              ),
            ),
          ),
      ],
    );
  }
}
