import 'package:flutter/material.dart';
import 'package:nepvent_waiter/UI/Design/AppTheme.dart';

class CounterButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? iconColor;

  const CounterButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return IconButton(
      icon: Icon(icon),
      iconSize: 24,
      color: iconColor ?? theme.secondaryText,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: backgroundColor ?? theme.secondaryBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: theme.lineColor),
        ),
        padding: const EdgeInsets.all(12),
      ),
    );
  }
}
