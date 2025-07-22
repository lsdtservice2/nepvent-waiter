import 'package:flutter/material.dart';
import 'package:nepvent_waiter/UI/Design/AppTheme.dart';
import 'package:nepvent_waiter/UI/Design/ButtonWidget.dart';
import 'package:nepvent_waiter/UI/Design/LoadingWidget.dart';
import 'package:nepvent_waiter/UI/HomeWidget.dart';
import 'package:nepvent_waiter/Utils/Constant.dart';

class EndDrawerWidget extends StatefulWidget {
  const EndDrawerWidget({super.key});

  @override
  State<EndDrawerWidget> createState() => _EndDrawerWidgetState();
}

class _EndDrawerWidgetState extends State<EndDrawerWidget> {
  String name = '';
  String userName = '';
  String email = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }
  Future<void> _loadPrefs() async {
    try {
      setState(() {
        name = prefs.getString('name') ?? '';
        userName = prefs.getString('userName') ?? '';
        email = prefs.getString('email') ?? '';
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle error if needed
    }
  }

  void _logout() async {
    await prefs.setString('token', '');
    // socketService.disconnect();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeWidget()),
      );
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void showLogoutConfirmationDialog(BuildContext context, VoidCallback onLogout) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon with soft background
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.logout, color: Colors.red, size: 36),
              ),
              const SizedBox(height: 20),

              // Title
              const Text(
                'Logout?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              // Message
              const Text(
                'Are you sure you want to logout from your account?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),

              const SizedBox(height: 30),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Cancel Button
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade400),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Logout Button
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: onLogout,
                      child: const Text('Yes, Logout'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const LoadingWidget();
    }

    return SafeArea(
      child: Column(
        children: [
          // Top AppBar-style Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    color: AppTheme.of(context).primaryText,
                    size: 26,
                  ),
                  onPressed: () {
                    if (Scaffold.of(context).isDrawerOpen ||
                        Scaffold.of(context).isEndDrawerOpen) {
                      Navigator.pop(context);
                    }
                  },
                ),
                const SizedBox(width: 8),
                Text(
                  'Settings',
                  style: AppTheme.of(context).title1.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
          ),

          Divider(
            height: 1,
            thickness: 1,
            color: AppTheme.of(context).secondaryText.withOpacity(0.4),
          ),

          // Profile and options
          // Expanded(
          //   child: ListView(
          //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          //     children: [
          //       // Profile Avatar and Name
          //       Column(
          //         children: [
          //           CircleAvatar(
          //             radius: 45,
          //             backgroundColor:
          //             AppTheme.of(context).primaryBackground.withOpacity(0.1),
          //             child: const Icon(Icons.person,
          //                 size: 50, color: Colors.black54),
          //           ),
          //           const SizedBox(height: 12),
          //           Text(
          //             name,
          //             style: AppTheme.of(context).subtitle1.copyWith(
          //               color: const Color(0xFF101213),
          //               fontWeight: FontWeight.w600,
          //               fontSize: 18,
          //             ),
          //           ),
          //           const SizedBox(height: 4),
          //           Text(
          //             userName,
          //             style: AppTheme.of(context).bodyText2.copyWith(
          //               color: const Color(0xFF57636C),
          //               fontSize: 14,
          //             ),
          //           ),
          //         ],
          //       ),
          //
          //       const SizedBox(height: 30),
          //
          //       // Add more settings options here if needed
          //
          //     ],
          //   ),
          // ),


          Container(
            margin: const EdgeInsets.only(top: 20),
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Image with Shadow
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 48,
                    backgroundColor: Colors.grey.shade200,
                    child: const Icon(Icons.person, size: 48, color: Colors.grey),
                  ),
                ),

                const SizedBox(height: 16),

                // Name
                Text(
                  name,
                  style: AppTheme.of(context).title2.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: const Color(0xFF101213),
                  ),
                ),

                const SizedBox(height: 6),

                // Username
                Text(
                  userName,
                  style: AppTheme.of(context).bodyText1.copyWith(
                    fontSize: 14,
                    color: const Color(0xFF6C757D),
                  ),
                ),
              ],
            ),
          ),


          // Logout Button
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: SizedBox(
              width: 160,
              height: 45,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout, size: 18),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.of(context).errorBorder,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: AppTheme.of(context).subtitle2.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed: () {
                  showLogoutConfirmationDialog(context, _logout);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

}
