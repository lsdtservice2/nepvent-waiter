// import 'package:flutter/material.dart';
// import 'package:nepvent_waiter/Models/UserProfile.dart';
// import 'package:nepvent_waiter/UI/Design/AppTheme.dart';
// import 'package:nepvent_waiter/UI/HomeWidget.dart';
// import 'package:nepvent_waiter/UI/Screens/ProfileIntroWidget.dart';
// import 'package:nepvent_waiter/Utils/Constant.dart';
//
// class PopupMenuWidget extends StatelessWidget {
//   const PopupMenuWidget({super.key});
//
//   void _logout() async {
//     await isar.writeTxn(() async {
//       await Future.wait([isar.userProfiles.clear()]);
//     });
//     await prefs.setString('token', '');
//     // socketService.disconnect();
//     Navigator.pushReplacement(
//       navigatorKey.currentContext!,
//       MaterialPageRoute(builder: (context) => const HomeWidget()),
//     );
//   }
//
//   void showLogoutConfirmationDialog(BuildContext context, VoidCallback onLogout) {
//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         elevation: 10,
//         backgroundColor: Colors.white,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Icon with soft background
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(color: Colors.red.withAlpha(25), shape: BoxShape.circle),
//                 child: const Icon(Icons.logout, color: Colors.red, size: 36),
//               ),
//               const SizedBox(height: 20),
//
//               // Title
//               const Text('Logout?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//
//               const SizedBox(height: 10),
//
//               // Message
//               const Text(
//                 'Are you sure you want to logout from your account?',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 16, color: Colors.black87),
//               ),
//
//               const SizedBox(height: 30),
//
//               // Buttons
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   // Cancel Button
//                   Expanded(
//                     child: OutlinedButton(
//                       style: OutlinedButton.styleFrom(
//                         side: BorderSide(color: Colors.grey.shade400),
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                       ),
//                       onPressed: () => Navigator.pop(context),
//                       child: const Text('Cancel'),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   // Logout Button
//                   Expanded(
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red,
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                       ),
//                       onPressed: onLogout,
//                       child: const Text('Yes, Logout'),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     String name = prefs.getString('name') ?? '';
//     return Padding(
//       padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
//       child: PopupMenuButton(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         position: PopupMenuPosition.under,
//         offset: const Offset(50, 0),
//         onSelected: (value) async {
//           if (value == 'Profile') {
//             Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileIntroWidget()));
//           } else if (value == 'logout') {
//             showLogoutConfirmationDialog(context, _logout);
//           }
//         },
//         itemBuilder: (BuildContext context) => [
//           PopupMenuItem(
//             value: 'Profile',
//             child: Row(
//               children: [
//                 Icon(Icons.person, color: AppTheme.of(context).primaryText, size: 26),
//                 SizedBox(width: 12),
//                 Text(
//                   'Profile',
//                   style: TextStyle(fontFamily: 'Open Sans', fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//           ),
//           PopupMenuItem(
//             enabled: false,
//             height: 1,
//             child: Divider(thickness: 1, color: AppTheme.of(context).primaryText.withAlpha(51)),
//           ),
//
//           PopupMenuItem(
//             value: 'logout',
//             child: Row(
//               children: [
//                 Icon(Icons.delete_outline_rounded, color: AppTheme.of(context).retroRedYellow, size: 26),
//                 SizedBox(width: 12),
//                 Text(
//                   'Logout',
//                   style: TextStyle(
//                     fontFamily: 'Open Sans',
//                     color: AppTheme.of(context).retroRedYellow,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//         icon: CircleAvatar(
//           backgroundColor: AppTheme.of(context).secondaryText,
//           radius: 25,
//           child: Text(
//             name.trim().split(" ").map((e) => e[0]).join(),
//             style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nepvent_waiter/Controller/LogoutFun.dart';
import 'package:nepvent_waiter/UI/Design/AppTheme.dart';
import 'package:nepvent_waiter/UI/Design/LogoutDialog.dart';
import 'package:nepvent_waiter/UI/Screens/PaymentInvoiceWidget.dart';
import 'package:nepvent_waiter/UI/Screens/ProfileIntroWidget.dart';
import 'package:nepvent_waiter/Utils/Constant.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class PopupMenuWidget extends StatelessWidget {
  const PopupMenuWidget({super.key});

  void showSearchInvoiceDialog(BuildContext context) {
    final theme = AppTheme.of(context);
    TextEditingController idController = TextEditingController();
    final FocusNode invoiceIdFocusNode = FocusNode();

    showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Search Invoice',
                style: theme.title3.copyWith(fontWeight: FontWeight.bold, color: theme.primaryText),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Invoice ID Search Section
              Text(
                'Enter Invoice ID',
                style: theme.subtitle1?.copyWith(color: theme.secondaryText),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      focusNode: invoiceIdFocusNode,
                      decoration: InputDecoration(
                        hintText: 'e.g. 123456',
                        prefixIcon: Icon(Icons.search, color: theme.secondaryText),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: theme.secondaryText!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: theme.primaryColor!),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                      controller: idController,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          _searchInvoice(context, value);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                    onPressed: () {
                      if (idController.text.isNotEmpty) {
                        _searchInvoice(context, idController.text.trim());
                      } else {
                        invoiceIdFocusNode.requestFocus();
                      }
                    },
                    child: const Text('Search'),
                  ),
                ],
              ),

              // Divider with OR text
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Row(
                  children: [
                    Expanded(child: Divider(color: theme.secondaryText, thickness: 1)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'OR',
                        style: theme.bodyText1?.copyWith(color: theme.secondaryText),
                      ),
                    ),
                    Expanded(child: Divider(color: theme.secondaryText, thickness: 1)),
                  ],
                ),
              ),

              // Barcode Scan Section
              Column(
                children: [
                  Text(
                    'Scan Barcode',
                    style: theme.subtitle1?.copyWith(color: theme.secondaryText),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    icon: Icon(Icons.barcode_reader, color: theme.primaryText, size: 24),
                    label: Text('Scan Now', style: theme.subtitle1),
                    onPressed: () async {
                      try {
                        String? res = await SimpleBarcodeScanner.scanBarcode(
                          context,
                          barcodeAppBar: BarcodeAppBar(
                            appBarTitle: 'Scan Invoice Barcode',
                            centerTitle: true,
                            enableBackButton: true,
                            backButtonIcon: Icon(Icons.arrow_back, color: theme.primaryText),
                            // backgroundColor: theme.primaryColor,
                            // titleTextStyle: TextStyle(
                            //   color: theme.primaryText,
                            //   fontWeight: FontWeight.bold,
                            // ),
                          ),
                          isShowFlashIcon: true,
                          // flashIconColor: theme.primaryText,
                          delayMillis: 500,
                          cameraFace: CameraFace.back,
                          scanFormat: ScanFormat.ONLY_BARCODE,
                        );

                        if (res != null && res.isNotEmpty) {
                          List invoiceDet = res.split('~*~');
                          if (invoiceDet.isNotEmpty) {
                            _searchInvoice(context, invoiceDet[0]);
                          }
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error scanning barcode: $e'),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),

              const SizedBox(height: 16),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Close', style: TextStyle(color: theme.secondaryText)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _searchInvoice(BuildContext context, String invoiceId) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PaymentInvoiceWidget(invoiceId: invoiceId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    String name = prefs.getString('name') ?? '';
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
      child: PopupMenuButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        position: PopupMenuPosition.under,
        offset: const Offset(50, 0),
        onSelected: (value) async {
          if (value == 'Profile') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileIntroWidget()),
            );
          } else if (value == 'Search Invoice') {
            showSearchInvoiceDialog(context);
          } else if (value == 'logout') {
            showDialog(
              context: context,
              builder: (context) => Dialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 10,
                backgroundColor: Colors.white,
                child: LogoutDialog(onLogout: logout),
              ),
            );
          }
        },
        itemBuilder: (BuildContext context) => [
          PopupMenuItem(
            value: 'Profile',
            child: Row(
              children: [
                Icon(Icons.person, color: AppTheme.of(context).primaryText, size: 26),
                SizedBox(width: 12),
                Text(
                  'Profile',
                  style: TextStyle(
                    fontFamily: 'Open Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'Search Invoice',
            child: Row(
              children: [
                Icon(Icons.search, color: AppTheme.of(context).primaryText, size: 26),
                SizedBox(width: 12),
                Text(
                  'Search Invoice',
                  style: TextStyle(
                    fontFamily: 'Open Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuItem(
            enabled: false,
            height: 1,
            child: Divider(thickness: 1, color: AppTheme.of(context).primaryText.withAlpha(51)),
          ),
          PopupMenuItem(
            value: 'logout',
            child: Row(
              children: [
                Icon(
                  Icons.delete_outline_rounded,
                  color: AppTheme.of(context).retroRedYellow,
                  size: 26,
                ),
                SizedBox(width: 12),
                Text(
                  'Logout',
                  style: TextStyle(
                    fontFamily: 'Open Sans',
                    color: AppTheme.of(context).retroRedYellow,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
        icon: CircleAvatar(
          backgroundColor: AppTheme.of(context).secondaryText,
          radius: 25,
          child: Text(
            name.trim().split(" ").map((e) => e[0]).join(),
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
