import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nepvent_waiter/UI/Design/AppTheme.dart';
import 'package:nepvent_waiter/UI/Design/ButtonWidget.dart';
import 'package:nepvent_waiter/UI/HomeWidget.dart';
import 'package:nepvent_waiter/Utils/Constant.dart';

class SetIPWidget extends StatefulWidget {
  const SetIPWidget({super.key});

  @override
  State<SetIPWidget> createState() => _SetIPWidgetState();
}

class _SetIPWidgetState extends State<SetIPWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  TextEditingController ip1Controller = TextEditingController();
  TextEditingController ip2Controller = TextEditingController();
  TextEditingController ip3Controller = TextEditingController();
  TextEditingController ip4Controller = TextEditingController();
  final ip1FocusNode = FocusNode();
  final ip2FocusNode = FocusNode();
  final ip3FocusNode = FocusNode();
  final ip4FocusNode = FocusNode();
  bool isValid = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadIPAddress();
  }

  void _loadIPAddress() {
    final ipAddress = prefs.getString('ipAddress');
    if (ipAddress != null) {
      List<String> parts = ipAddress.split('.');
      if (parts.length == 4) {
        ip1Controller.text = parts[0];
        ip2Controller.text = parts[1];
        ip3Controller.text = parts[2];
        ip4Controller.text = parts[3];
        isValid = true;
      }
    }
  }

  Future _submit() async {
    debugPrint('submit');
    final String ipAddress = '${ip1Controller.text.trim()}.${ip2Controller.text.trim()}.${ip3Controller.text.trim()}.${ip4Controller.text.trim()}';
    debugPrint(' ❇️❇️❇️❇️❇️❇️ ipAddress ☑️☑️☑️☑️☑️ $ipAddress');
    prefs.setString('ipAddress', ipAddress);
    dio.options.baseUrl = 'http://${prefs.getString('ipAddress')!}:8080/';
  }

  @override
  void dispose() {
    // TODO: implement dispose
    ip1Controller.dispose();
    ip2Controller.dispose();
    ip3Controller.dispose();
    ip4Controller.dispose();
    ip1FocusNode.dispose();
    ip2FocusNode.dispose();
    ip3FocusNode.dispose();
    ip4FocusNode.dispose();
    super.dispose();
  }

  void validate(ipStr, TextEditingController controller, {required FocusNode currentNode, FocusNode? nextNode}) {
    String tempText = ipStr;
    bool switchFocus = false;
    if (ipStr.endsWith(".")) {
      debugPrint('ends with');
      tempText = tempText.replaceAll('.', '');
      if (ipStr.isNotEmpty && ipStr.length > 0) {
        switchFocus = true;
      }
      controller.text = tempText;
    }
    if (tempText.length == 3 && int.parse(tempText) <= 255) {
      switchFocus = true;
    }
    isValid =
        (ip1Controller.text.isNotEmpty &&
            ip2Controller.text.isNotEmpty &&
            ip3Controller.text.isNotEmpty &&
            ip4Controller.text.isNotEmpty)
        ? true
        : false;
    // setState(() =>( _ip1 = tempText));
    setState(() {});
    if (switchFocus && nextNode != null) {
      nextNode.requestFocus();
    }
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
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.always,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Welcome', style: AppTheme.of(context).title3),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(44, 8, 44, 0),
                  child: Text(
                    'Enter server IP to continue',
                    textAlign: TextAlign.center,
                    style: AppTheme.of(context).bodyText2,
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: ip1Controller,
                          autofocus: true,
                          focusNode: ip1FocusNode,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(3), // Max 3 digits
                            FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                          ],
                          decoration: InputDecoration(
                            hintText: '192',
                            hintStyle: AppTheme.of(context).bodyText2,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppTheme.of(context).secondaryColor, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppTheme.of(context).secondaryColor, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppTheme.of(context).errorBorder, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppTheme.of(context).errorBorder, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorStyle: TextStyle(fontSize: 0),
                          ),
                          style: AppTheme.of(context).bodyText1,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          onChanged: (text) =>
                              validate(text, ip1Controller, currentNode: ip1FocusNode, nextNode: ip2FocusNode),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '';
                            }
                            try {
                              if (int.parse(value) > 255) {
                                // return 'Can\'t be more than 255';
                                return '';
                              }
                            } on FormatException {
                              if (value.endsWith(".")) {
                                debugPrint('validator ends with .');
                              }
                            }
                            return null;
                          },
                        ),
                      ),
                      Text(
                        '.',
                        textAlign: TextAlign.center,
                        style: AppTheme.of(context).bodyText1.override(
                          fontFamily: AppTheme.of(context).bodyText1.fontFamily,
                          fontSize: 20,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(AppTheme.of(context).bodyText1.fontFamily),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: ip2Controller,
                          autofocus: true,
                          focusNode: ip2FocusNode,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(3), // Max 3 digits
                            FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                          ],
                          decoration: InputDecoration(
                            hintText: '162',
                            hintStyle: AppTheme.of(context).bodyText2,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppTheme.of(context).secondaryColor, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppTheme.of(context).secondaryColor, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppTheme.of(context).errorBorder, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppTheme.of(context).errorBorder, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorStyle: TextStyle(fontSize: 0),
                          ),
                          style: AppTheme.of(context).bodyText1,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          onChanged: (text) =>
                              validate(text, ip2Controller, currentNode: ip2FocusNode, nextNode: ip3FocusNode),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '';
                            }
                            try {
                              if (int.parse(value) > 255) {
                                // return 'Can\'t be more than 255';
                                return '';
                              }
                            } on FormatException {
                              if (value.endsWith(".")) {
                                debugPrint('validator ends with .');
                              }
                            }
                            return null;
                          },
                        ),
                      ),
                      Text(
                        '.',
                        textAlign: TextAlign.center,
                        style: AppTheme.of(context).bodyText1.override(
                          fontFamily: AppTheme.of(context).bodyText1.fontFamily,
                          fontSize: 20,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(AppTheme.of(context).bodyText1.fontFamily),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: ip3Controller,
                          autofocus: true,
                          focusNode: ip3FocusNode,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(3), // Max 3 digits
                            FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                          ],
                          decoration: InputDecoration(
                            hintText: '0',
                            hintStyle: AppTheme.of(context).bodyText2,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppTheme.of(context).secondaryColor, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppTheme.of(context).secondaryColor, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppTheme.of(context).errorBorder, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppTheme.of(context).errorBorder, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorStyle: TextStyle(fontSize: 0),
                          ),
                          style: AppTheme.of(context).bodyText1,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          onChanged: (text) =>
                              validate(text, ip3Controller, currentNode: ip3FocusNode, nextNode: ip4FocusNode),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '';
                            }
                            try {
                              if (int.parse(value) > 255) {
                                // return 'Can\'t be more than 255';
                                return '';
                              }
                            } on FormatException {
                              if (value.endsWith(".")) {
                                debugPrint('validator ends with .');
                              }
                            }
                            return null;
                          },
                        ),
                      ),
                      Text(
                        '.',
                        textAlign: TextAlign.center,
                        style: AppTheme.of(context).bodyText1.override(
                          fontFamily: AppTheme.of(context).bodyText1.fontFamily,
                          fontSize: 20,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(AppTheme.of(context).bodyText1.fontFamily),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: ip4Controller,
                          autofocus: true,
                          focusNode: ip4FocusNode,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(3), // Max 3 digits
                            FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                          ],
                          decoration: InputDecoration(
                            hintText: '1',
                            hintStyle: AppTheme.of(context).bodyText2,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppTheme.of(context).secondaryColor, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppTheme.of(context).secondaryColor, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppTheme.of(context).errorBorder, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppTheme.of(context).errorBorder, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorStyle: TextStyle(fontSize: 0),
                          ),
                          style: AppTheme.of(context).bodyText1,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          onChanged: (text) => validate(text, ip4Controller, currentNode: ip4FocusNode),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '';
                            }
                            try {
                              if (int.parse(value) > 255) {
                                // return 'Can\'t be more than 255';
                                return '';
                              }
                            } on FormatException {
                              if (value.endsWith(".")) {
                                debugPrint('validator ends with .');
                              }
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(44, 8, 44, 0),
                  child: Text(
                    isValid ? ' ' : 'Number should be between 0 and 255',
                    textAlign: TextAlign.center,
                    style: AppTheme.of(context).bodyText2.override(
                      fontFamily: AppTheme.of(context).bodyText2.fontFamily,
                      color: AppTheme.of(context).errorBorder,
                      useGoogleFonts: GoogleFonts.asMap().containsKey(AppTheme.of(context).bodyText2.fontFamily),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 44),
                  child: ButtonWidget(
                    onPressed: () {
                      if (isValid) {
                        _submit().then(
                          (value) =>
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeWidget())),
                        );
                      }
                    },
                    text: 'Confirm & Continue',
                    options: ButtonOptions(
                      width: 270,
                      height: 50,
                      color: isValid ? const Color(0xFF428FD2) : Colors.grey.shade300,
                      textStyle: AppTheme.of(context).subtitle2.override(
                        fontFamily: AppTheme.of(context).subtitle2.fontFamily,
                        color: AppTheme.of(context).primaryBackground,
                        useGoogleFonts: GoogleFonts.asMap().containsKey(AppTheme.of(context).subtitle2.fontFamily),
                      ),
                      elevation: 2,
                      borderSide: const BorderSide(color: Colors.transparent, width: 1),
                      borderRadius: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
