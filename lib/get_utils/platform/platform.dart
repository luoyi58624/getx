part of '../../mini_getx.dart';

// ignore: avoid_classes_with_only_static_members
class GetPlatform {
  static final bool isMacOS = GeneralPlatform.isMacOS;

  static final bool isWindows = GeneralPlatform.isWindows;

  static final bool isLinux = GeneralPlatform.isLinux;

  static final bool isAndroid = GeneralPlatform.isAndroid;

  static final bool isIOS = GeneralPlatform.isIOS;

  static final bool isFuchsia = GeneralPlatform.isFuchsia;

  static final bool isMobile = GetPlatform.isIOS || GetPlatform.isAndroid;

  static final bool isDesktop = GetPlatform.isMacOS || GetPlatform.isWindows || GetPlatform.isLinux;
}
