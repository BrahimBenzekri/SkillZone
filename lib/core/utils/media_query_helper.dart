import 'package:flutter/material.dart';

class MediaQueryHelper {
  static MediaQueryData getData(BuildContext context) {
    return MediaQuery.of(context);
  }

  static EdgeInsets getSafePadding(BuildContext context) {
    return getData(context).padding; // Safe area padding
  }

  static Size getScreenSize(BuildContext context) {
    return getData(context).size; // Screen width & height
  }

  static double getScreenWidth(BuildContext context) {
    return getScreenSize(context).width;
  }

  static double getScreenHeight(BuildContext context) {
    return getScreenSize(context).height;
  }

  static double getDevicePixelRatio(BuildContext context) {
    return getData(context).devicePixelRatio; // Screen DPI
  }
}
