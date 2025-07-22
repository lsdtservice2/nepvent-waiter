import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isar/isar.dart';
import 'package:nepvent_waiter/Models/UserProfile.dart';
import 'package:nepvent_waiter/UI/Design/AppTheme.dart';
import 'package:nepvent_waiter/UI/Design/CustomFloatingActionButton.dart';
import 'package:nepvent_waiter/UI/Screens/TableSelectionWidget.dart';
import 'package:nepvent_waiter/Utils/Constant.dart';

class ProfileIntroWidget extends StatelessWidget {
  const ProfileIntroWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primaryBackground,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: theme.chineseBlack, size: 30),
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TableSelectionWidget()),
            );
          },
        ),
        title: Text(
          "Profile",
          style: theme.title1.override(
            fontFamily: theme.title1.fontFamily,
            color: theme.chineseBlack,
            useGoogleFonts: GoogleFonts.asMap().containsKey(theme.title1.fontFamily),
          ),
        ),
        elevation: 3,
        centerTitle: false,
      ),
      body: SafeArea(
        child: FutureBuilder<List<UserProfile>>(
          future: isar.userProfiles.where().findAll(),
          builder: (BuildContext context, AsyncSnapshot<List<UserProfile>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No data found'));
            } else {
              final userProfile = snapshot.data!.first;
              return Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDFDFD),
                        boxShadow: const [
                          BoxShadow(blurRadius: 10, color: Color(0xFFD8D8D8), offset: Offset(0, 2)),
                        ],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(0),
                                  bottomRight: Radius.circular(0),
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                              ),
                              alignment: AlignmentDirectional(-1, 0),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(14, 0, 0, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 35,
                                      height: 35,
                                      decoration: BoxDecoration(
                                        color: const Color(0x56FDFDFD),
                                        borderRadius: BorderRadius.circular(100),
                                      ),
                                      child: Icon(
                                        Icons.person_sharp,
                                        color: AppTheme.of(context).secondaryBackground,
                                        size: 24,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                                      child: Text(
                                        'Personal Information',
                                        style: AppTheme.of(context).bodyText1.override(
                                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                                            AppTheme.of(context).bodyText1.fontFamily,
                                          ),
                                          color: AppTheme.of(context).secondaryBackground,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          fontStyle: AppTheme.of(context).bodyText1.fontStyle,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(14, 18, 14, 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                    child: Text(
                                      'Restaurant Name',
                                      style: AppTheme.of(context).bodyText1.override(
                                        useGoogleFonts: GoogleFonts.asMap().containsKey(
                                          AppTheme.of(context).bodyText1.fontFamily,
                                        ),
                                        color: AppTheme.of(context).secondaryText,
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                        fontStyle: AppTheme.of(context).bodyText1.fontStyle,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        userProfile.restoName,
                                        style: AppTheme.of(context).bodyText1.override(
                                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                                            AppTheme.of(context).bodyText1.fontFamily,
                                          ),
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                          fontStyle: AppTheme.of(context).bodyText1.fontStyle,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(14, 18, 14, 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                    child: Text(
                                      'First Name',
                                      style: AppTheme.of(context).bodyText1.override(
                                        useGoogleFonts: GoogleFonts.asMap().containsKey(
                                          AppTheme.of(context).bodyText1.fontFamily,
                                        ),
                                        color: AppTheme.of(context).secondaryText,
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                        fontStyle: AppTheme.of(context).bodyText1.fontStyle,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        userProfile.fName,
                                        style: AppTheme.of(context).bodyText1.override(
                                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                                            AppTheme.of(context).bodyText1.fontFamily,
                                          ),
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                          fontStyle: AppTheme.of(context).bodyText1.fontStyle,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(14, 18, 14, 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                    child: Text(
                                      'Last Name',
                                      style: AppTheme.of(context).bodyText1.override(
                                        useGoogleFonts: GoogleFonts.asMap().containsKey(
                                          AppTheme.of(context).bodyText1.fontFamily,
                                        ),
                                        color: AppTheme.of(context).secondaryText,
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                        fontStyle: AppTheme.of(context).bodyText1.fontStyle,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        userProfile.lName,
                                        style: AppTheme.of(context).bodyText1.override(
                                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                                            AppTheme.of(context).bodyText1.fontFamily,
                                          ),
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                          fontStyle: AppTheme.of(context).bodyText1.fontStyle,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(14, 18, 14, 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                    child: Text(
                                      'Username',
                                      style: AppTheme.of(context).bodyText1.override(
                                        useGoogleFonts: GoogleFonts.asMap().containsKey(
                                          AppTheme.of(context).bodyText1.fontFamily,
                                        ),
                                        color: AppTheme.of(context).secondaryText,
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                        fontStyle: AppTheme.of(context).bodyText1.fontStyle,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        userProfile.username,
                                        style: AppTheme.of(context).bodyText1.override(
                                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                                            AppTheme.of(context).bodyText1.fontFamily,
                                          ),
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                          fontStyle: AppTheme.of(context).bodyText1.fontStyle,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(14, 18, 14, 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                    child: Text(
                                      'Email Address',
                                      style: AppTheme.of(context).bodyText1.override(
                                        useGoogleFonts: GoogleFonts.asMap().containsKey(
                                          AppTheme.of(context).bodyText1.fontFamily,
                                        ),
                                        color: AppTheme.of(context).secondaryText,
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                        fontStyle: AppTheme.of(context).bodyText1.fontStyle,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        userProfile.email,
                                        style: AppTheme.of(context).bodyText1.override(
                                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                                            AppTheme.of(context).bodyText1.fontFamily,
                                          ),
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                          fontStyle: AppTheme.of(context).bodyText1.fontStyle,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 20, 16, 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDFDFD),
                        boxShadow: const [
                          BoxShadow(blurRadius: 10, color: Color(0xFFD8D8D8), offset: Offset(0, 2)),
                        ],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(0),
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            alignment: AlignmentDirectional(-1, 0),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(14, 0, 0, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      color: const Color(0x56FDFDFD),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Icon(
                                      Icons.shield_sharp,
                                      color: AppTheme.of(context).secondaryBackground,
                                      size: 24,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                                    child: Text(
                                      'Roles',
                                      style: AppTheme.of(context).bodyText1.override(
                                        useGoogleFonts: GoogleFonts.asMap().containsKey(
                                          AppTheme.of(context).bodyText1.fontFamily,
                                        ),
                                        color: AppTheme.of(context).secondaryBackground,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        fontStyle: AppTheme.of(context).bodyText1.fontStyle,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(14, 8, 8, 18),
                            child: Wrap(
                              spacing: 4,
                              runSpacing: 8,
                              children: userProfile.roles.map((role) {
                                return Chip(
                                  label: Text(
                                    role.toUpperCase(),
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: Color(0xFF518982),
                                    ),
                                  ),
                                  backgroundColor: const Color(0xFFF4FFFD),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(35),
                                    side: const BorderSide(color: Color(0xFF518982)),
                                  ),
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  elevation: 3,
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
      floatingActionButton: const CustomFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
