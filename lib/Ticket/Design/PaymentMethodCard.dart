import 'package:flutter/material.dart';
import 'package:nepvent_waiter/Models/PaymentMethodModel.dart';
import 'package:nepvent_waiter/UI/Design/AppTheme.dart';

class PaymentMethodCard extends StatelessWidget {
  final PaymentMethodModel method;
  final String iconPath;
  final bool isSelected;
  final bool isMobile;
  final VoidCallback onSelect;

  const PaymentMethodCard({
    super.key,
    required this.method,
    required this.iconPath,
    required this.isSelected,
    required this.isMobile,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final highlightColor = theme.bluePurple; // Using theme's blue color
    final textColor = theme.primaryText;
    final unselectedTextColor = theme.secondaryText;

    return InkWell(
      onTap: onSelect,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: isMobile ? 95 : 120,
        height: isMobile ? 95 : 100,
        decoration: BoxDecoration(
          color: isSelected ? highlightColor.withOpacity(0.1) : theme.secondaryBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? highlightColor : theme.lineColor,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.grayDark.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconPath,
              width: isMobile ? 40 : 50,
              height: isMobile ? 40 : 50,
              fit: BoxFit.contain,
              // color: isSelected ? highlightColor : unselectedTextColor,
            ),
            if (isSelected) ...[
              const SizedBox(height: 8),
              Text(
                method.name,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: textColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
