import 'package:flutter/material.dart';
import 'package:nepvent_waiter/Models/PaymentMethodModel.dart';
import 'package:nepvent_waiter/UI/Design/AppTheme.dart';

class OtherPaymentMethodsDropdown extends StatelessWidget {
  final List<PaymentMethodModel> methods;
  final int? selectedId;
  final bool isMobile;
  final Function(PaymentMethodModel) onSelect;

  const OtherPaymentMethodsDropdown({
    super.key,
    required this.methods,
    this.selectedId,
    required this.isMobile,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final selectedMethod = selectedId != null && methods.any((m) => m.id == selectedId)
        ? methods.firstWhere((m) => m.id == selectedId)
        : null;

    // Use theme colors for the payment method highlight
    final highlightColor = theme.bluePurple; // Using bluePurple from theme
    final highlightColorLight = highlightColor.withOpacity(0.1);
    final textColor = theme.primaryText;
    final unselectedTextColor = theme.secondaryText;
    final borderColor = theme.lineColor;

    return Container(
      width: isMobile ? 90 : 120,
      height: isMobile ? 90 : 100,
      decoration: BoxDecoration(
        color: selectedMethod != null ? highlightColorLight : theme.secondaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selectedMethod != null ? highlightColor : borderColor,
          width: selectedMethod != null ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.grayDark.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: PopupMenuButton<PaymentMethodModel>(
        onSelected: onSelect,
        itemBuilder: (context) => methods.map((method) {
          return PopupMenuItem<PaymentMethodModel>(
            value: method,
            child: Row(
              children: [
                if (method.id == selectedId) Icon(Icons.check, color: highlightColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    method.name,
                    style: TextStyle(
                      color: method.id == selectedId ? highlightColor : textColor,
                      fontWeight: method.id == selectedId ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        offset: const Offset(0, -10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              selectedMethod != null ? Icons.payment : Icons.more_vert_outlined,
              size: 40,
              color: selectedMethod != null ? highlightColor : unselectedTextColor,
            ),
            const SizedBox(height: 8),
            Text(
              selectedMethod?.name ?? 'More',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: selectedMethod != null ? highlightColor : unselectedTextColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
