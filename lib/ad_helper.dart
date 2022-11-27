import 'dart:io';

class AdHelper {

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3553866592029918/9114114012';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3553866592029918/9114114012';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
  static String get bannerAdUnitIdA {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3553866592029918/8133873132';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3553866592029918/8133873132';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return '<YOUR_ANDROID_INTERSTITIAL_AD_UNIT_ID>';
    } else if (Platform.isIOS) {
      return '<YOUR_IOS_INTERSTITIAL_AD_UNIT_ID>';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return '<YOUR_ANDROID_REWARDED_AD_UNIT_ID>';
    } else if (Platform.isIOS) {
      return '<YOUR_IOS_REWARDED_AD_UNIT_ID>';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}