import 'package:flutter/material.dart';
import 'package:nepvent_waiter/Ticket/Models/CouponType.dart';
import 'package:nepvent_waiter/UI/Design/AppTheme.dart';

class TicketTypeCard extends StatelessWidget {
  final CouponType ticket;
  final bool isSelected;
  final bool isMobile;
  final VoidCallback onTap;
  final bool irdIncluded;

  const TicketTypeCard({
    super.key,
    required this.ticket,
    required this.isSelected,
    required this.isMobile,
    required this.onTap,
    required this.irdIncluded,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final highlightColor = theme.bluePurple; // Using theme's blue color
    final priceTextColor = theme.chineseBlack; // Using theme's dark color

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: isMobile ? 110 : 140,
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
            Text(
              ticket.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isMobile ? 14 : 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? highlightColor : theme.primaryText,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(height: 8),
              Text(
                'Rs. ${ticket.price.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: isMobile ? 14 : 16,
                  fontWeight: FontWeight.w600,
                  color: priceTextColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
