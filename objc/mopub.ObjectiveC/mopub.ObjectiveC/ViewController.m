//
//  ViewController.m
//  mopub.ObjectiveC
//
//  Copyright © 2018年 maio. All rights reserved.
//

#import "ViewController.h"
#import "MaioAdapterConfiguration.h"

#if __has_include(<MoPubSDK/MoPub.h>)
    #import <MoPubSDK/MoPub.h>
#elif __has_include(<MoPub/MoPub.h>)
    #import <MoPub/MoPub.h>
#else
    #import "MoPub.h"
#endif

#define AD_UNIT_ID_INTER @"SET_YOUR_AD_UNIT_ID"
#define AD_UNIT_ID_REWARD @"SET_YOUR_AD_UNIT_ID"

@interface ViewController () <MPInterstitialAdControllerDelegate, MPRewardedVideoDelegate>

@property(nonatomic, retain) MPInterstitialAdController *_Nullable interstitial;

- (IBAction)loadAdButton:(UIButton *)sender;

- (IBAction)showAdButton:(UIButton *)sender;

- (IBAction)showInterButton:(UIButton *)sender;

- (IBAction)loadRewardAdButton:(UIButton *)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        MPMoPubConfiguration *sdkConfig = [[MPMoPubConfiguration alloc] initWithAdUnitIdForAppInitialization:AD_UNIT_ID_REWARD];
        sdkConfig.globalMediationSettings = @[];
        sdkConfig.loggingLevel = MPBLogLevelDebug;

        sdkConfig.additionalNetworks = @[[MaioAdapterConfiguration class]];
        NSDictionary* maioConfig = @{@"configuration-key": @"configuration-value"};
        sdkConfig.mediatedNetworkConfigurations = [@{@"MaioAdapterConfiguration": maioConfig} mutableCopy];

        [[MoPub sharedInstance] initializeSdkWithConfiguration:sdkConfig completion:^{
            NSLog(@"SDK initialization complete");
        }];
        [MPRewardedVideo loadRewardedVideoAdWithAdUnitID:AD_UNIT_ID_REWARD withMediationSettings:nil];
        [MPRewardedVideo setDelegate:self forAdUnitId:AD_UNIT_ID_REWARD];
    });
}

- (void)rewardedVideoAdDidFailToLoadForAdUnitID:(NSString *)adUnitID error:(NSError *)error {
    NSLog(@"%@", error);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadInter {
    _interstitial = [MPInterstitialAdController interstitialAdControllerForAdUnitId:AD_UNIT_ID_INTER];
    _interstitial.delegate = self;
    [_interstitial loadAd];
}

- (void)showInter {
    [_interstitial showFromViewController:self];
}


- (IBAction)loadAdButton:(UIButton *)sender {
    [self loadInter];
}

- (IBAction)showInterButton:(UIButton *)sender {
    [self showInter];
}

- (IBAction)showAdButton:(UIButton *)sender {

    if ([MPRewardedVideo hasAdAvailableForAdUnitID:AD_UNIT_ID_REWARD]) {
        [MPRewardedVideo presentRewardedVideoAdForAdUnitID:AD_UNIT_ID_REWARD fromViewController:self withReward:nil];
    }
}

- (IBAction)loadRewardAdButton:(UIButton *)sender {
    [MPRewardedVideo loadRewardedVideoAdWithAdUnitID:AD_UNIT_ID_REWARD withMediationSettings:nil];
    [MPRewardedVideo setDelegate:self forAdUnitId:AD_UNIT_ID_REWARD];
}

#pragma mark - Interstitial Ad Delegates

- (void)interstitialDidLoadAd:(MPInterstitialAdController *)interstitial {
    NSLog(@"1: interstitialDidLoadAd");

}

- (void)interstitialDidFailToLoadAd:(MPInterstitialAdController *)interstitial {
    NSLog(@"2: interstitialDidFailToLoadAd");

}

- (void)interstitialWillAppear:(MPInterstitialAdController *)interstitial {
    NSLog(@"3: interstitialWillAppear");

}

- (void)interstitialDidAppear:(MPInterstitialAdController *)interstitial {
    NSLog(@"4: interstitialDidAppear");

}

- (void)interstitialWillDisappear:(MPInterstitialAdController *)interstitial {
    NSLog(@"5: interstitialWillDisappear");

}

- (void)interstitialDidDisappear:(MPInterstitialAdController *)interstitial {
    NSLog(@"6: interstitialDidDisappear");

}

- (void)interstitialDidExpire:(MPInterstitialAdController *)interstitial {
    NSLog(@"7: interstitialDidExpire");

}

- (void)interstitialDidReceiveTapEvent:(MPInterstitialAdController *)interstitial {
    NSLog(@"8: interstitialDidReceiveTapEvent");

}

#pragma mark - RewardedVideo Delegates


- (void)rewardedVideoAdDidLoadForAdUnitID:(NSString *)adUnitID {
    NSLog(@"1: rewardedVideoAdDidLoadForAdUnitID");
}

- (void)rewardedVideoAdDidExpireForAdUnitID:(NSString *)adUnitID {
    NSLog(@"2: rewardedVideoAdDidExpireForAdUnitID");

}

- (void)rewardedVideoAdDidFailToPlayForAdUnitID:(NSString *)adUnitID error:(NSError *)error {
    NSLog(@"3: rewardedVideoAdDidFailToPlayForAdUnitID");

}

- (void)rewardedVideoAdWillAppearForAdUnitID:(NSString *)adUnitID {
    NSLog(@"4: rewardedVideoAdWillAppearForAdUnitID");

}

- (void)rewardedVideoAdDidAppearForAdUnitID:(NSString *)adUnitID {
    NSLog(@"5: rewardedVideoAdDidAppearForAdUnitID");

}

- (void)rewardedVideoAdWillDisappearForAdUnitID:(NSString *)adUnitID {
    NSLog(@"6: rewardedVideoAdWillDisappearForAdUnitID");

}

- (void)rewardedVideoAdDidDisappearForAdUnitID:(NSString *)adUnitID {
    NSLog(@"7: rewardedVideoAdDidDisappearForAdUnitID");

}

- (void)rewardedVideoAdDidReceiveTapEventForAdUnitID:(NSString *)adUnitID {
    NSLog(@"8: rewardedVideoAdDidReceiveTapEventForAdUnitID");

}

- (void)rewardedVideoAdWillLeaveApplicationForAdUnitID:(NSString *)adUnitID {
    NSLog(@"9: rewardedVideoAdWillLeaveApplicationForAdUnitID");

}

- (void)rewardedVideoAdShouldRewardForAdUnitID:(NSString *)adUnitID reward:(MPRewardedVideoReward *)reward {
    NSLog(@"10: rewardedVideoAdShouldRewardForAdUnitID: %@", reward);
}

@end
