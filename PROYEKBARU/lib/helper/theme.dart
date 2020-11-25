import 'package:flutter/material.dart';

List<BoxShadow> shadow = <BoxShadow>[
  BoxShadow(
      blurRadius: 10,
      offset: Offset(5, 5),
      color: AppTheme.apptheme.accentColor,
      spreadRadius: 1)
];
String get description {
  return '';
}

TextStyle get onPrimaryTitleText {
  return TextStyle(color: Colors.white, fontWeight: FontWeight.w600);
}

TextStyle get onPrimarySubTitleText {
  return TextStyle(
    color: Colors.white,
  );
}

BoxDecoration softDecoration = BoxDecoration(boxShadow: <BoxShadow>[
  BoxShadow(
      blurRadius: 8,
      offset: Offset(5, 5),
      color: Color(0xffe2e5ed),
      spreadRadius: 5),
  BoxShadow(
      blurRadius: 8,
      offset: Offset(-5, -5),
      color: Color(0xffffffff),
      spreadRadius: 5)
], color: Color(0xfff1f3f6));
TextStyle get titleStyle {
  return TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
}

TextStyle get subtitleStyle {
  return TextStyle(
      color: AppColor.darkGrey, fontSize: 14, fontWeight: FontWeight.bold);
}

TextStyle get userNameStyle {
  return TextStyle(
      color: AppColor.darkGrey, fontSize: 14, fontWeight: FontWeight.bold);
}

TextStyle get textStyle14 {
  return TextStyle(
      color: AppColor.darkGrey, fontSize: 14, fontWeight: FontWeight.bold);
}

class AplikasiColor {
  static final Color bondiBlue = Colors.amberAccent[700];
  static final Color cerulean = Colors.amber[200];
  static final Color spindle = Colors.amberAccent[200];
  static final Color white = Color.fromRGBO(255, 255, 255, 1.0);
  static final Color black = Color.fromRGBO(0, 0, 0, 1.0);
  static final Color woodsmoke = Color.fromRGBO(20, 23, 2, 1.0);
  static final Color woodsmoke_50 = Color.fromRGBO(20, 23, 2, 0.5);
  static final Color mystic = Color.fromRGBO(230, 236, 240, 1.0);
  static final Color dodgetBlue = Colors.amber[600];
  static final Color dodgetBlue_50 = Colors.amber[600];
  static final Color paleSky = Colors.yellow[200];
  static final Color ceriseRed = Color.fromRGBO(224, 36, 94, 1.0);
  static final Color paleSky50 = Colors.yellow[200];
}

class AppColor {
  static final Color primary = Colors.amber[600];
  static final Color secondary = Colors.amber[400];
  static final Color darkGrey = Color(0xff1657786);
  static final Color lightGrey = Color(0xffAAB8C2);
  static final Color extraLightGrey = Color(0xffE1E8ED);
  static final Color extraExtraLightGrey = Color(0xfF5F8FA);
  static final Color white = Color(0xFFffffff);
  static final Color transparentamber = Colors.amber[300];
}

class AppTheme {
  static final ThemeData apptheme = ThemeData(
      primarySwatch: Colors.blue,
      backgroundColor: AplikasiColor.white,
      accentColor: AplikasiColor.dodgetBlue,
      brightness: Brightness.light,
      primaryColor: AppColor.primary,
      secondaryHeaderColor: AppColor.secondary,
      cardColor: Colors.white,
      unselectedWidgetColor: Colors.grey,
      bottomAppBarColor: Colors.white,
      bottomSheetTheme: BottomSheetThemeData(backgroundColor: AppColor.white),
      appBarTheme: AppBarTheme(
          brightness: Brightness.light,
          color: AplikasiColor.white,
          iconTheme: IconThemeData(
            color: AplikasiColor.dodgetBlue,
          ),
          elevation: 0,
          textTheme: TextTheme(
            title: TextStyle(
                color: Colors.black, fontSize: 26, fontStyle: FontStyle.normal),
          )),
      tabBarTheme: TabBarTheme(
        labelStyle: titleStyle.copyWith(color: AplikasiColor.dodgetBlue),
        unselectedLabelColor: AppColor.darkGrey,
        unselectedLabelStyle: titleStyle.copyWith(color: AppColor.darkGrey),
        labelColor: AplikasiColor.dodgetBlue,
        labelPadding: EdgeInsets.symmetric(vertical: 12),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AplikasiColor.dodgetBlue,
      ),
      colorScheme: ColorScheme(
          background: Colors.white,
          onPrimary: Colors.white,
          onBackground: Colors.black,
          onError: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.black,
          error: Colors.red,
          primary: Colors.amber,
          primaryVariant: Colors.amber,
          secondary: AppColor.secondary,
          secondaryVariant: AppColor.darkGrey,
          surface: Colors.white,
          brightness: Brightness.light));
}
