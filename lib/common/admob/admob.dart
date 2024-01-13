import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

AdManagerInterstitialAd? _interstitialAd;

void loadAd() {
  AdManagerInterstitialAd.load(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-9332149282803752/5096086415' // Android ad unit ID
          : 'ca-app-pub-9332149282803752/9605116609', // iOS ad unit ID
      request: const AdManagerAdRequest(),
      adLoadCallback: AdManagerInterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('AdManagerInterstitialAd failed to load: $error');
        },
      ));
}

void showAd() {
  _interstitialAd?.show();
}