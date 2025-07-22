import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nepvent_waiter/Models/UserProfile.dart';
import 'package:nepvent_waiter/UI/AuthScreen/SetIPWidget.dart';
import 'package:nepvent_waiter/UI/Design/AppTheme.dart';
import 'package:nepvent_waiter/UI/Design/ButtonWidget.dart';
import 'package:nepvent_waiter/UI/HomeWidget.dart';
import 'package:nepvent_waiter/Utils/Constant.dart';
import 'package:nepvent_waiter/Utils/Urls.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  TextEditingController clientNameController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool passwordVisibility = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future _login() async {
    if (formKey.currentState!.validate()) {
      try {
        Response response = await dio.post(
          urls['login']!,
          data: {
            'slug': clientNameController.text.trim(),
            'user_name': emailAddressController.text.trim(),
            'password': passwordController.text.trim(),
          },
        );

        if (response.statusCode == 200) {
          final body = response.data;
          final user = body['message']?['user'];
          final userRoles = user?['User_Roles'];
          // debugPrint('User Roles: $userRoles');
          // debugPrint('Is User Role list not empty: ${userRoles is List && userRoles.isNotEmpty}');

          if (userRoles is List && userRoles.isNotEmpty) {
            // Save basic user info
            prefs.setString('token', body['message']['token'] ?? '');
            prefs.setString('tenant', clientNameController.text.trim());
            prefs.setString('name', '${user['first_name'] ?? ''} ${user['last_name'] ?? ''}');
            prefs.setString('userName', user['user_name'] ?? '');
            prefs.setString('email', user['email'] ?? '');
            prefs.setString('userId', user['id']?.toString() ?? '');

            // Check for COUPON role
            final bool isCouponRole = userRoles.any((role) {
              final roleName = role?['Role']?['name'];
              return roleName != null && roleName.toString().toUpperCase() == 'COUPON';
            });
            prefs.setBool('Ticketing', isCouponRole);

            // Call profile fetch
            await _restaurantProfile();

            // Save UserProfile to Isar
            final roleNames = userRoles
                .map((role) => role?['Role']?['name'] ?? '')
                .whereType<String>() // filters out nulls
                .toList();
            debugPrint('User Roles::::::::  $roleNames');

            final userProfile = UserProfile()
              ..fName = user['first_name'] ?? ''
              ..lName = user['last_name'] ?? ''
              ..restoName = body['message']?['tenantDetails']?['name'] ?? ''
              ..username = user['user_name'] ?? ''
              ..email = user['email'] ?? ''
              ..roles = roleNames;

            await isar.writeTxn(() async {
              await isar.userProfiles.put(userProfile);
            });

            // Navigate to home
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeWidget()),
            );
          } else {
            // Show role assignment error
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: const Color(0xFFe74f5b),
                content: Text('You are not assigned to any role. Please contact the admin.'),
              ),
            );
          }
        }
      } on DioException catch (err) {
        debugPrint('error on login: ${err.response?.statusCode}:::: ${err.response?.data}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFFe74f5b),
            content: Text(
              err.response?.data['message'] ?? 'Please check your internet connection.',
            ),
          ),
        );
      } catch (error) {
        debugPrint('error: $error');
      }
    }
  }

  Future<void> _restaurantProfile() async {
    try {
      final response = await dio.get(urls['profile']!);
      final profile = response.data['message'];
      await prefs.setString('restaurantName', profile['name'] ?? '');
      await prefs.setString('slug', profile['slug'] ?? '');
      await prefs.setInt('vatPercent', profile['vat_percent'] ?? 0);
      await prefs.setBool('customerOrderQR', profile['customerOrderQR'] ?? false);
      await prefs.setBool('irdApproved', profile['ird_approved'] ?? false);
      await prefs.setBool('vatReg', profile['vat_reg'] ?? false);
    } catch (e) {
      debugPrint('Failed to load restaurant profile: $e');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    clientNameController.dispose();
    emailAddressController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.of(context).primaryBackground,
        automaticallyImplyLeading: false,
        title: Image.asset(
          'assets/images/nepventLogo.png',
          width: 250,
          height: MediaQuery.of(context).size.height * 0.05,
          fit: BoxFit.contain,
        ),
        actions: [],
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 1,
          decoration: BoxDecoration(color: AppTheme.of(context).primaryBackground),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    child: Align(
                      alignment: const AlignmentDirectional(0, 0),
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 450, maxHeight: 500),
                        decoration: BoxDecoration(
                          color: AppTheme.of(context).primaryBackground,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Align(
                          alignment: const AlignmentDirectional(0, 0),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0, 3, 0, 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Hi there!',
                                          textAlign: TextAlign.center,
                                          style: AppTheme.of(context).title1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                          controller: clientNameController,
                                          autofocus: true,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            labelText: 'Restaurant / Client Name',
                                            labelStyle: AppTheme.of(context).bodyText1.override(
                                              fontFamily: AppTheme.of(context).bodyText1.fontFamily,
                                              color: const Color(0xFF95A1AC),
                                              useGoogleFonts: GoogleFonts.asMap().containsKey(
                                                AppTheme.of(context).bodyText1.fontFamily,
                                              ),
                                            ),
                                            hintText: 'Enter your client ID',
                                            hintStyle: AppTheme.of(context).bodyText1.override(
                                              fontFamily: AppTheme.of(context).bodyText1.fontFamily,
                                              color: const Color(0xFF95A1AC),
                                              useGoogleFonts: GoogleFonts.asMap().containsKey(
                                                AppTheme.of(context).bodyText1.fontFamily,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFFDBE2E7),
                                                width: 2,
                                              ),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFFDBE2E7),
                                                width: 2,
                                              ),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0x00000000),
                                                width: 2,
                                              ),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            focusedErrorBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0x00000000),
                                                width: 2,
                                              ),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            filled: true,
                                            fillColor: AppTheme.of(context).white,
                                            contentPadding: const EdgeInsetsDirectional.fromSTEB(
                                              16,
                                              24,
                                              0,
                                              24,
                                            ),
                                          ),
                                          style: AppTheme.of(context).bodyText1.override(
                                            fontFamily: AppTheme.of(context).bodyText1.fontFamily,
                                            color: const Color(0xFF2B343A),
                                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                              AppTheme.of(context).bodyText1.fontFamily,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                          controller: emailAddressController,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            labelText: 'Username',
                                            labelStyle: AppTheme.of(context).bodyText1.override(
                                              fontFamily: AppTheme.of(context).bodyText1.fontFamily,
                                              color: const Color(0xFF95A1AC),
                                              useGoogleFonts: GoogleFonts.asMap().containsKey(
                                                AppTheme.of(context).bodyText1.fontFamily,
                                              ),
                                            ),
                                            hintText: 'Enter your username ',
                                            hintStyle: AppTheme.of(context).bodyText1.override(
                                              fontFamily: AppTheme.of(context).bodyText1.fontFamily,
                                              color: const Color(0xFF95A1AC),
                                              useGoogleFonts: GoogleFonts.asMap().containsKey(
                                                AppTheme.of(context).bodyText1.fontFamily,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFFDBE2E7),
                                                width: 2,
                                              ),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFFDBE2E7),
                                                width: 2,
                                              ),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: AppTheme.of(context).errorBorder,
                                                width: 1,
                                              ),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            focusedErrorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: AppTheme.of(context).errorBorder,
                                                width: 1,
                                              ),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            filled: true,
                                            fillColor: AppTheme.of(context).white,
                                            contentPadding: const EdgeInsetsDirectional.fromSTEB(
                                              16,
                                              24,
                                              0,
                                              24,
                                            ),
                                          ),
                                          style: AppTheme.of(context).bodyText1.override(
                                            fontFamily: AppTheme.of(context).bodyText1.fontFamily,
                                            color: const Color(0xFF2B343A),
                                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                              AppTheme.of(context).bodyText1.fontFamily,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          autovalidateMode: AutovalidateMode.onUserInteraction,

                                          controller: passwordController,
                                          obscureText: !passwordVisibility,
                                          decoration: InputDecoration(
                                            labelText: 'Password',
                                            labelStyle: AppTheme.of(context).bodyText1.override(
                                              fontFamily: AppTheme.of(context).bodyText1.fontFamily,
                                              color: const Color(0xFF95A1AC),
                                              useGoogleFonts: GoogleFonts.asMap().containsKey(
                                                AppTheme.of(context).bodyText1.fontFamily,
                                              ),
                                            ),
                                            hintText: 'Enter your password here...',
                                            hintStyle: AppTheme.of(context).bodyText1.override(
                                              fontFamily: AppTheme.of(context).bodyText1.fontFamily,
                                              color: const Color(0xFF95A1AC),
                                              useGoogleFonts: GoogleFonts.asMap().containsKey(
                                                AppTheme.of(context).bodyText1.fontFamily,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFFDBE2E7),
                                                width: 2,
                                              ),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFFDBE2E7),
                                                width: 2,
                                              ),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0x00000000),
                                                width: 2,
                                              ),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            focusedErrorBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0x00000000),
                                                width: 2,
                                              ),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            filled: true,
                                            fillColor: AppTheme.of(context).white,
                                            contentPadding: const EdgeInsetsDirectional.fromSTEB(
                                              16,
                                              24,
                                              0,
                                              24,
                                            ),
                                            suffixIcon: InkWell(
                                              onTap: () => setState(
                                                () => passwordVisibility = !passwordVisibility,
                                              ),
                                              focusNode: FocusNode(skipTraversal: true),
                                              child: Icon(
                                                passwordVisibility
                                                    ? Icons.visibility_outlined
                                                    : Icons.visibility_off_outlined,
                                                color: const Color(0xFF95A1AC),
                                                size: 22,
                                              ),
                                            ),
                                          ),
                                          style: AppTheme.of(context).bodyText1.override(
                                            fontFamily: AppTheme.of(context).bodyText1.fontFamily,
                                            color: const Color(0xFF2B343A),
                                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                              AppTheme.of(context).bodyText1.fontFamily,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(20, 12, 20, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ButtonWidget(
                                        onPressed: () async {
                                          await _login();
                                        },
                                        text: 'Login',
                                        showLoadingIndicator: true,
                                        options: ButtonOptions(
                                          width: 100,
                                          height: 40,
                                          color: const Color(0xFF428FD2),
                                          textStyle: AppTheme.of(context).subtitle2.override(
                                            fontFamily: AppTheme.of(context).subtitle2.fontFamily,
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                              AppTheme.of(context).subtitle2.fontFamily,
                                            ),
                                          ),
                                          elevation: 2,
                                          borderSide: const BorderSide(
                                            color: Colors.transparent,
                                            width: 1,
                                          ),
                                          borderRadius: 8,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      ButtonWidget(
                                        onPressed: () {
                                          // sharedPrefs.then((prefs) {
                                          //   prefs.setString(
                                          //       'ipAddress', '');
                                          //   prefs.setString('token', '');
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => SetIPWidget()),
                                          );
                                          // });
                                        },
                                        text: 'Reset IP',
                                        options: ButtonOptions(
                                          width: 120,
                                          height: 40,
                                          color: AppTheme.of(context).white,
                                          textStyle: AppTheme.of(context).subtitle2.override(
                                            fontFamily: AppTheme.of(context).subtitle2.fontFamily,
                                            color: const Color(0xFF090F13),
                                            fontSize: 12,
                                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                              AppTheme.of(context).subtitle2.fontFamily,
                                            ),
                                          ),
                                          elevation: 0,
                                          borderSide: const BorderSide(
                                            color: Colors.transparent,
                                            width: 1,
                                          ),
                                          borderRadius: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text('Nepvent Waiter v3.0.0', style: AppTheme.of(context).bodyText1),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
