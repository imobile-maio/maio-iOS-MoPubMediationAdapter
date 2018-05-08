//
//  ViewController.h
//  mopub.ObjectiveC
//
//  Created by 土肥 一郎 on 2018/02/06.
//  Copyright © 2018年 maio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoPub.h"

@interface ViewController : UIViewController<MPInterstitialAdControllerDelegate, MPRewardedVideoDelegate>
@property (nonatomic, retain) MPInterstitialAdController * _Nullable interstitial;

@end

