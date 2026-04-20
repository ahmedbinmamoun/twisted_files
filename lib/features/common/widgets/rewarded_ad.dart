

import 'package:google_mobile_ads/google_mobile_ads.dart';

RewardedAd? _rewardedAd;

String rewardedAdUnitId = 'ca-app-pub-1839430517523354/6551642690';

void loadRewardedAd(){
  RewardedAd.load(
    adUnitId: rewardedAdUnitId, 
    request: const AdRequest(),
    rewardedAdLoadCallback: RewardedAdLoadCallback(
      onAdLoaded: (ad){
        _rewardedAd = ad;
      },
       onAdFailedToLoad: (error){
        _rewardedAd = null;
        print('Faild to load ad: $error');
       }
       )
    );
}


void showRewardedAd(){
  if (_rewardedAd == null) {
    print('Ad not ready');
    return;
  }
  _rewardedAd!.show(
    onUserEarnedReward: (AdWithoutView ad, RewardItem reward){
      print('User earned reward: ${reward.amount}');
    }
    );

    _rewardedAd = null;
    loadRewardedAd();
}