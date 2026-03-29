import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
 
/// SRP: مسؤول فقط عن تحميل وعرض الـ Rewarded Ad.
/// استخدمه من أي مكان في التطبيق عبر getIt.
class RewardedAdService {
  static const String _adUnitId = 'ca-app-pub-2435311949965691/2679768374';
 
  RewardedAd? _rewardedAd;
  bool        _isLoading = false;
 
  bool get isReady => _rewardedAd != null;
 
  /// حمّل الـ ad — استدعيها عند بدء التطبيق أو بعد كل عرض
  void loadAd() {
    if (_isLoading) return;
    _isLoading = true;
 
    RewardedAd.load(
      adUnitId: _adUnitId,
      request:  const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isLoading  = false;
          if (kDebugMode) print('✅ RewardedAd loaded');
        },
        onAdFailedToLoad: (error) {
          _rewardedAd = null;
          _isLoading  = false;
          if (kDebugMode) print('❌ RewardedAd failed: $error');
        },
      ),
    );
  }
 
  /// اعرض الـ ad.
  /// [onRewarded]  — بيتنادى لما المستخدم يشوف الـ ad لآخرها.
  /// [onNotReady]  — بيتنادى لو الـ ad مش جاهزة (اختياري).
  void showAd({
    required VoidCallback onRewarded,
    VoidCallback?         onNotReady,
  }) {
    if (_rewardedAd == null) {
      if (kDebugMode) print('⚠️ Ad not ready');
      onNotReady?.call();
      loadAd(); // حاول تحمّل للمرة الجاية
      return;
    }
 
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
        loadAd(); // حمّل ad جديدة للمرة الجاية
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _rewardedAd = null;
        loadAd();
        // لو فشل العرض — امنح المستخدم المكافأة عشان ما تعاقبوش
        onRewarded();
      },
    );
 
    _rewardedAd!.show(
      onUserEarnedReward: (_, reward) {
        if (kDebugMode) print('🎁 User earned reward: ${reward.amount}');
        onRewarded();
      },
    );
  }
 
  void dispose() {
    _rewardedAd?.dispose();
    _rewardedAd = null;
  }
}