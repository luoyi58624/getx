import 'dart:io';

// ignore: avoid_classes_with_only_static_members
class GeneralPlatform {
  static final bool isMacOS = Platform.isMacOS;

  static final bool isWindows = Platform.isWindows;

  static final bool isLinux = Platform.isLinux;

  static final bool isAndroid = Platform.isAndroid;

  static final bool isIOS = Platform.isIOS;

  static final bool isFuchsia = Platform.isFuchsia;

  static final bool isDesktop = Platform.isMacOS || Platform.isWindows || Platform.isLinux;
}
