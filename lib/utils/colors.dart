import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomColor {
  CustomColor._();

  static const Color lightGrey = Color(0xffcac5cb);
  static const Color mediumDarkGrey = Color(0xff757575);
  static const Color darkGrey = Color(0xff54656f);
  static const Color bgGrey = Color(0xffdfe5e7);
  static const Color buttonLightGreen = Color(0xffd9f5df);
  static const Color lineColorGrey = Color(0xff979797);
  static const Color fontDarkGrey = Color(0xff54656f);
  static const Color grey = Color(0xffA2B0B8);
  static const Color lightGreyBackground = Color(0xfff0f2f5);
  static const Color red = Colors.red;
  static const Color toastErrorColor = Color(0xfff5c4c4);
  static const Color toastWarningColor = Color(0xfffff5b3);
  static const Color toastSuccessColor = Color(0xffd0ebcd);
  static const Color toastInfoColor = Color(0xffbacbf5);
  static const Color toastSuccessText = Color(0xff50a747);
  static const Color toastWarningText = Color(0xffeae200);
  static const Color toastInfoText = Color(0xff2b60de);
  static const Color toastErrorText = Color(0xffcc0000);
  static const Color progressBg = Color.fromRGBO(255, 255, 255, 0.26);
  static const Color progressComp = Color.fromRGBO(145, 150, 255, 1);
  //Status Bar UI Style
  static const SystemUiOverlayStyle lightStatusBar = SystemUiOverlayStyle(
      statusBarColor: CustomColor.bgGrey,
      statusBarIconBrightness: Brightness.dark);

  static const SystemUiOverlayStyle darkGreyBar = SystemUiOverlayStyle(
      statusBarColor: CustomColor.darkGrey,
      statusBarIconBrightness: Brightness.dark);
}
