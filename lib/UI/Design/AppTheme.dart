// ignore_for_file: overridden_fields, annotate_overrides
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

const kThemeModeKey = '__theme_mode__';
SharedPreferences? _prefs;

abstract class AppTheme {
  static Future initialize() async => _prefs = await SharedPreferences.getInstance();

  static ThemeMode get themeMode {
    final darkMode = _prefs?.getBool(kThemeModeKey);
    return darkMode == null
        ? ThemeMode.system
        : darkMode
        ? ThemeMode.dark
        : ThemeMode.light;
  }

  static void saveThemeMode(ThemeMode mode) =>
      mode == ThemeMode.system ? _prefs?.remove(kThemeModeKey) : _prefs?.setBool(kThemeModeKey, mode == ThemeMode.dark);

  static AppTheme of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? DarkModeTheme() : LightModeTheme();

  // Core Colors
  Color get primaryColor;

  Color get secondaryColor;

  Color get tertiaryColor;

  Color get alternate;

  Color get primaryBackground;

  Color get secondaryBackground;

  Color get primaryText;

  Color get secondaryText;

  // UI Colors
  Color get primaryBtnText;

  Color get lineColor;

  Color get white;

  Color get occupied;

  Color get unoccupied;

  Color get grayDark;

  Color get errorBorder;

  // Color Palette
  Color get bluePurple;

  Color get spaceCadetBlue;

  Color get verdigrisGreen;

  Color get redSalsa;

  Color get platinumGrey;

  Color get mountainMeadowGreen;

  Color get gunmetalGrey;

  Color get maximumBlueGreen;

  Color get paradisePink;

  Color get maizeYellow;

  Color get richBrilliantLavender;

  Color get chineseBlack;

  Color get gray;

  Color get amberYellow;

  Color get charlestonGreen;

  Color get blanchedAlmond;

  Color get wageningenGreen;

  // Retro Color Pairs
  final Color retroRedYellow = const Color(0xFFE14842);
  final Color retroRedYellowFont = const Color(0xFFF7BB2E);
  final Color retroPurplePink = const Color(0xFF614F89);
  final Color retroPurplePinkFont = const Color(0xFFFEA4B9);
  final Color retroGreenYellow = const Color(0xFF3B8457);
  final Color retroGreenYellowFont = const Color(0xFFF3B73E);
  final Color retroLgGreenOrange = const Color(0xFFC7D8C6);
  final Color retroLgGreenOrangeFont = const Color(0xFFDDEA90);
  final Color retroPinkBlue = const Color(0xFFC34C25);
  final Color retroPinkBlueFont = const Color(0xFFD1C9B3);
  final Color retroDullOrangeOfWhite = const Color(0xFFE9944A);
  final Color retroDullOrangeOfWhiteFont = const Color(0xFFF5F5DA);
  final Color retroOrangeBlack = const Color(0xFFE86E1A);
  final Color retroOrangeBlackFont = const Color(0xFF0B0E16);
  final Color retroMintBlue = const Color(0xFF87B1AC);
  final Color retroMintBlueFont = const Color(0xFF19184D);
  final Color retroGreenPink = const Color(0xFF084227);
  final Color retroGreenPinkFont = const Color(0xFFEC8091);
  final Color retroDuNavyCream = const Color(0xFF2C3950);
  final Color retroDuNavyCreamFont = const Color(0xFFF7D5B1);
  final Color retroLgGreyLgGrGr = const Color(0xFF667985);
  final Color retroLgGreyLgGrGrFont = const Color(0xFFCED9BF);
  final Color retroBlkLgBrown = const Color(0xFF32424B);
  final Color retroBlkLgBrownFont = const Color(0xFFC09576);
  final Color retroPolishDuYellow = const Color(0xFFB94429);
  final Color retroPolishDuYellowFont = const Color(0xFFFDDA7D);
  final Color retroLgBlackLgGrGr = const Color(0xFF2C3439);
  final Color retroLgBlackLgGrGrFont = const Color(0xFFCED9BF);
  final Color retroClassicGreyBlack = const Color(0xFFDBD6CB);
  final Color retroClassicGreyBlackFont = const Color(0xFF171717);

  // Text Styles
  TextStyle get title1 =>
      GoogleFonts.getFont('Proza Libre', color: primaryText, fontWeight: FontWeight.w400, fontSize: 24);

  TextStyle get title2 =>
      GoogleFonts.getFont('Proza Libre', color: secondaryText, fontWeight: FontWeight.w400, fontSize: 22);

  TextStyle get title3 =>
      GoogleFonts.getFont('Proza Libre', color: primaryText, fontWeight: FontWeight.w400, fontSize: 20);

  TextStyle get subtitle1 =>
      GoogleFonts.getFont('Proza Libre', color: primaryText, fontWeight: FontWeight.w400, fontSize: 18);

  TextStyle get subtitle2 =>
      GoogleFonts.getFont('Proza Libre', color: secondaryText, fontWeight: FontWeight.w400, fontSize: 16);

  TextStyle get bodyText1 =>
      GoogleFonts.getFont('Work Sans', color: primaryText, fontWeight: FontWeight.normal, fontSize: 14);

  TextStyle get bodyText2 =>
      GoogleFonts.getFont('Lexend Deca', color: secondaryText, fontWeight: FontWeight.normal, fontSize: 12);

  TextStyle get robotoMonoTitle1 =>
      GoogleFonts.getFont('Roboto Mono', color: secondaryText, fontWeight: FontWeight.normal, fontSize: 22);

  TextStyle get robotoMonoSmall =>
      GoogleFonts.getFont('Roboto Mono', color: secondaryText, fontWeight: FontWeight.normal, fontSize: 12);
}

class LightModeTheme extends AppTheme {
  @override
  final Color primaryColor = const Color(0xFF4B39EF);
  @override
  final Color secondaryColor = const Color(0xFF39D2C0);
  @override
  final Color tertiaryColor = const Color(0xFF101213);
  @override
  final Color alternate = const Color(0xFFFF5963);
  @override
  final Color primaryBackground = const Color(0xFFF1F4F8);
  @override
  final Color secondaryBackground = const Color(0xFFFFFFFF);
  @override
  final Color primaryText = const Color(0xFF064851);
  @override
  final Color secondaryText = const Color(0xFF57636C);

  @override
  final Color primaryBtnText = const Color(0xFFFFFFFF);
  @override
  final Color lineColor = const Color(0xFFE0E3E7);
  @override
  final Color white = const Color(0xFFF1F4F8);
  @override
  final Color chineseBlack = const Color(0xFF064851);
  @override
  final Color blanchedAlmond = const Color(0xFFFEF0CE);

  // Greens
  @override
  final Color mountainMeadowGreen = const Color(0xFF33b786);
  @override
  final Color unoccupied = const Color(0xFF51aeb0);
  @override
  final Color verdigrisGreen = const Color(0xFF51aeb0);
  @override
  final Color maximumBlueGreen = const Color(0xFF37b9c6);
  @override
  final Color wageningenGreen = const Color(0xFF49a52c);
  @override
  final Color charlestonGreen = const Color(0xFF272727);

  // Blues
  @override
  final Color spaceCadetBlue = const Color(0xFF142457);
  @override
  final Color bluePurple = const Color(0xFF4B39EF);

  // Purples
  @override
  final Color richBrilliantLavender = const Color(0xFFFB9DFF);

  // Reds
  @override
  final Color occupied = const Color(0xFFf92d45);
  @override
  final Color errorBorder = const Color(0xFFFF5963);
  @override
  final Color redSalsa = const Color(0xFFf92d45);
  @override
  final Color paradisePink = const Color(0xFFe74f5b);

  // Greys
  @override
  final Color platinumGrey = const Color(0xFFe7e7e7);
  @override
  final Color grayDark = const Color(0xFF95A1AC);
  @override
  final Color gunmetalGrey = const Color(0xFF2b3443);
  @override
  final Color gray = const Color(0xFF064851);

  // Yellows
  @override
  final Color maizeYellow = const Color(0xFFFFCC47);
  @override
  final Color amberYellow = const Color(0xFFFBBD09);
}

class DarkModeTheme extends AppTheme {
  @override
  final Color primaryColor = const Color(0xFF4B39EF);
  @override
  final Color secondaryColor = const Color(0xFF39D2C0);
  @override
  final Color tertiaryColor = const Color(0xFFEE8B60);
  @override
  final Color alternate = const Color(0xFFFF5963);
  @override
  final Color primaryBackground = const Color(0xFF1A1F24);
  @override
  final Color secondaryBackground = const Color(0xFF101213);
  @override
  final Color primaryText = const Color(0xFFFFFFFF);
  @override
  final Color secondaryText = const Color(0xFF95A1AC);
  @override
  final Color bluePurple = const Color(0xFF4B39EF);

  @override
  final Color primaryBtnText = const Color(0xFFFFFFFF);
  @override
  final Color lineColor = const Color(0xFF22282F);
  @override
  final Color white = const Color(0xFFF1F4F8);
  @override
  final Color unoccupied = const Color(0xD91AB347);
  @override
  final Color occupied = const Color(0xFFFF5963);
  @override
  final Color grayDark = const Color(0xFF95A1AC);
  @override
  final Color errorBorder = const Color(0xFFFF5963);

  // Other colors that should be defined for dark mode
  @override
  Color get spaceCadetBlue => const Color(0xFF142457);

  @override
  Color get verdigrisGreen => const Color(0xFF51aeb0);

  @override
  Color get redSalsa => const Color(0xFFf92d45);

  @override
  Color get platinumGrey => const Color(0xFFe7e7e7);

  @override
  Color get mountainMeadowGreen => const Color(0xFF33b786);

  @override
  Color get gunmetalGrey => const Color(0xFF2b3443);

  @override
  Color get maximumBlueGreen => const Color(0xFF37b9c6);

  @override
  Color get paradisePink => const Color(0xFFe74f5b);

  @override
  Color get maizeYellow => const Color(0xFFFFCC47);

  @override
  Color get richBrilliantLavender => const Color(0xFFFB9DFF);

  @override
  Color get chineseBlack => const Color(0xFF064851);

  @override
  Color get gray => const Color(0xFF064851);

  @override
  Color get amberYellow => const Color(0xFFFBBD09);

  @override
  Color get charlestonGreen => const Color(0xFF272727);

  @override
  Color get blanchedAlmond => const Color(0xFFFEF0CE);

  @override
  Color get wageningenGreen => const Color(0xFF49a52c);
}

extension TextStyleHelper on TextStyle {
  TextStyle override({
    String? fontFamily,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    bool useGoogleFonts = true,
    TextDecoration? decoration,
    double? lineHeight,
    TextOverflow? overflow,
  }) => useGoogleFonts
      ? GoogleFonts.getFont(
          fontFamily!,
          color: color ?? this.color,
          fontSize: fontSize ?? this.fontSize,
          fontWeight: fontWeight ?? this.fontWeight,
          fontStyle: fontStyle ?? this.fontStyle,
          decoration: decoration,
          height: lineHeight,
        )
      : copyWith(
          fontFamily: fontFamily,
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
          fontStyle: fontStyle,
          decoration: decoration,
          height: lineHeight,
          overflow: overflow,
        );
}
