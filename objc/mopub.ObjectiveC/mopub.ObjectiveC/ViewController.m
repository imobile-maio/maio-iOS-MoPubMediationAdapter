//
//  ViewController.m
//  mopub.ObjectiveC
//
//  Created by 土肥 一郎 on 2018/02/06.
//  Copyright © 2018年 maio. All rights reserved.
//

#import "ViewController.h"
#import "MoPub.h"
#import "MPRewardedVideo.h"

#define AD_UNIT_ID_INTER @"81a6a7820dda490d98f013b4dc32f0a2"
#define AD_UNIT_ID_REWARD @"a821b308f35542b781f58d2043dc8c44"

@interface ViewController ()
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
        [[MoPub sharedInstance] initializeRewardedVideoWithGlobalMediationSettings:nil delegate:nil];
        [MPRewardedVideo loadRewardedVideoAdWithAdUnitID:AD_UNIT_ID_REWARD withMediationSettings:nil];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loadInter {
    _interstitial = [MPInterstitialAdController interstitialAdControllerForAdUnitId:AD_UNIT_ID_INTER];
    [_interstitial loadAd];
}

-(void) showInter {
    [_interstitial showFromViewController:self];
}



- (IBAction)loadAdButton:(UIButton *)sender {
    [self loadInter];
}

- (IBAction)showAdButton:(UIButton *)sender {
    
    if([MPRewardedVideo hasAdAvailableForAdUnitID:AD_UNIT_ID_REWARD]) {
        [MPRewardedVideo presentRewardedVideoAdForAdUnitID:AD_UNIT_ID_REWARD fromViewController:self withReward:nil];
    }
}

- (IBAction)showInterButton:(UIButton *)sender {
    [self showInter];
}

- (IBAction)loadRewardAdButton:(UIButton *)sender {
    [MPRewardedVideo loadRewardedVideoAdWithAdUnitID:AD_UNIT_ID_REWARD withMediationSettings:nil];
}
@end
