import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nepvent_waiter/UI/Design/AppTheme.dart';

class TicketingAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const TicketingAppBarWidget({super.key, required this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.of(context).primaryBackground,
      automaticallyImplyLeading: false,
      title: Text(
        title,
        style: AppTheme.of(context).title1.override(
          fontFamily: AppTheme.of(context).title1.fontFamily,
          color: AppTheme.of(context).primaryText,
          useGoogleFonts: GoogleFonts.asMap().containsKey(AppTheme.of(context).title1.fontFamily),
        ),
      ),
      elevation: 3,
      actions: actions,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
