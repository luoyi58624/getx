part of '../../mini_getx.dart';

// ignore: avoid_classes_with_only_static_members
class GetPlatform {
  /// macos、macos web
  static final bool isMacOS = GeneralPlatform.isMacOS;

  /// windows、windows web
  static final bool isWindows = GeneralPlatform.isWindows;

  /// linux、linux web
  static final bool isLinux = GeneralPlatform.isLinux;

  /// android、android web
  static final bool isAndroid = GeneralPlatform.isAndroid;

  /// ios、ios web
  static final bool isIOS = GeneralPlatform.isIOS;

  /// fuchsia、fuchsia web
  static bool isFuchsia = GeneralPlatform.isFuchsia;

  /// mobile、mobile web
  static final bool isMobile = isIOS || isAndroid;

  /// desktop、macos web
  static final bool isDesktop = isMacOS || isWindows || isLinux;

  /// ios、ios web、macos、macos web
  static final bool isApple = GeneralPlatform.isApple;

  /// only mobile web
  static final bool isMobileWeb = GeneralPlatform.isMobileWeb;

  /// only desktop web
  static final bool isDesktopWeb = GeneralPlatform.isDesktopWeb;

  /// only mobile client
  static bool isMobileClient = GeneralPlatform.isMobileClient;

  /// only desktop client
  static bool isDesktopClient = GeneralPlatform.isDesktopClient;
}
