import 'package:flutter/material.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;
  static late double safeAreaHorizontal;
  static late double safeAreaVertical;
  static late double safeBlockHorizontal;
  static late double safeBlockVertical;
  static late double devicePixelRatio;
  static late TextScaler textScaler;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - safeAreaVertical) / 100;

    devicePixelRatio = _mediaQueryData.devicePixelRatio;
    textScaler = _mediaQueryData.textScaler;
  }

  static double height(double height) {
    return blockSizeVertical * height;
  }

  static double width(double width) {
    return blockSizeHorizontal * width;
  }

  static double adaptiveHeight(double value) {
    return height(value).clamp(value * 0.8, value * 1.2);
  }

  static double adaptiveWidth(double value) {
    return width(value).clamp(value * 0.8, value * 1.2);
  }

  static double fontSize(double size) {
    final double scaleFactor = textScaler.scale(1.0);
    return (blockSizeHorizontal * size * scaleFactor).clamp(
      size * 0.8,
      size * 1.2,
    );
  }
}
