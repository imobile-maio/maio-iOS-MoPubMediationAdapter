//
//  ViewController.h
//  mopub.ObjectiveC
//
//  Copyright © 2018年 maio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoPub.h"

@interface ViewController : UIViewController <MPInterstitialAdControllerDelegate, MPRewardedVideoDelegate>
@property(nonatomic, retain) MPInterstitialAdController *_Nullable interstitial;

@end

