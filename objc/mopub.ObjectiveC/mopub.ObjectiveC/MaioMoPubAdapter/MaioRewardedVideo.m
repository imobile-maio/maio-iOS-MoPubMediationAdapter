//
//  MaioRewardedVideo.m
//  mopub.ObjectiveC
//
//  Created by 土肥 一郎 on 2018/02/07.
//  Copyright © 2018年 maio. All rights reserved.
//

#import "MaioRewardedVideo.h"
#import "MPLogging.h"
#import "MaioCredentials.h"
#import "MaioManager.h"
#import "MaioError.h"
#import "MPRewardedVideoReward.h"

@implementation MaioRewardedVideo {
    MaioCredentials *_credentials;
    BOOL _isAdRequested;
}

-(void)initializeSdkWithParameters:(NSDictionary *)parameters
{
    _credentials = [MaioCredentials credentialsFromDictionary:parameters];
    [self initializeMaioSdk];
}

-(void)requestRewardedVideoWithCustomEventInfo:(NSDictionary *)info
{
    MaioManager *manager = [MaioManager sharedInstance];
    MaioCredentials *credentials = [MaioCredentials credentialsFromDictionary:info];
    if(!credentials) {
        [self.delegate rewardedVideoDidFailToLoadAdForCustomEvent:self error:[MaioError credentials]];
        return;
    }
    _credentials = credentials;
    
    if([manager isInitialized:credentials.mediaId] == NO) {
        _isAdRequested = YES;
        [self initializeMaioSdk];
        return;
    }
    
    if([manager hasDelegate:self forMediaId:_credentials.mediaId] == NO) {
        [manager addDelegate:self forMediaId:_credentials.mediaId];
    }
    
    if([manager canShowAtMediaId:credentials.mediaId zoneId:credentials.zoneId]) {
        [self.delegate rewardedVideoDidLoadAdForCustomEvent:self];
    } else {
        _isAdRequested = YES;
    }
}

-(void)initializeMaioSdk {
    if(!_credentials) {
        MPLogError(@"MaioRewardedVideo: invalid parameters");
        return;
    }
    
    MaioManager *manager = [MaioManager sharedInstance];
    [manager startWithMediaId:_credentials.mediaId delegate:self];
}

-(BOOL)hasAdAvailable {
    return [[MaioManager sharedInstance] canShowAtMediaId:_credentials.mediaId zoneId:_credentials.zoneId];
}

-(void)presentRewardedVideoFromViewController:(UIViewController *)viewController {
    [[MaioManager sharedInstance] showAtMediaId:_credentials.mediaId zoneId:_credentials.zoneId];
}

#pragma mark - MaioDelegate

-(void)maioDidChangeCanShow:(NSString *)zoneId newValue:(BOOL)newValue {
    if(_credentials.zoneId && ![zoneId isEqualToString:_credentials.zoneId]) {
        return;
    }
    
    if(_isAdRequested == NO) {
        return;
    }
    _isAdRequested = NO;
    
    if(newValue)
    {
        [self.delegate rewardedVideoDidLoadAdForCustomEvent:self];
    }
}

-(void)maioDidClickAd:(NSString *)zoneId {
    if(_credentials.zoneId && ![zoneId isEqualToString:_credentials.zoneId]) {
        return;
    }
    
    [self.delegate rewardedVideoDidReceiveTapEventForCustomEvent:self];
    [self.delegate rewardedVideoWillLeaveApplicationForCustomEvent:self];
}

-(void)maioWillStartAd:(NSString *)zoneId {
    if(_credentials.zoneId && ![zoneId isEqualToString:_credentials.zoneId]) {
        return;
    }
    
    [self.delegate rewardedVideoWillAppearForCustomEvent:self];
    [self.delegate rewardedVideoDidAppearForCustomEvent:self];
}

-(void)maioDidCloseAd:(NSString *)zoneId {
    if(_credentials.zoneId && ![zoneId isEqualToString:_credentials.zoneId]) {
        return;
    }
    
    [self.delegate rewardedVideoWillDisappearForCustomEvent:self];
    [self.delegate rewardedVideoDidDisappearForCustomEvent:self];
}

-(void)maioDidFinishAd:(NSString *)zoneId playtime:(NSInteger)playtime skipped:(BOOL)skipped rewardParam:(NSString *)rewardParam {
    if(_credentials.zoneId && ![zoneId isEqualToString:_credentials.zoneId]) {
        return;
    }
    
    
    MPRewardedVideoReward *reward = [[MPRewardedVideoReward alloc] initWithCurrencyAmount: [NSNumber numberWithInt:[rewardParam intValue]]];
    [self.delegate rewardedVideoShouldRewardUserForCustomEvent:self reward:reward];
}

-(void)maioDidFail:(NSString *)zoneId reason:(MaioFailReason)reason {
    if(_credentials.zoneId && ![zoneId isEqualToString:_credentials.zoneId]) {
        return;
    }
    
    [self.delegate rewardedVideoDidFailToPlayForCustomEvent:self error:[MaioError loadFailedWithReason:reason]];
}

@end
