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

@implementation MaioRewardedVideo {
    MaioCredentials *_credentials;
}

-(void)initializeSdkWithParameters:(NSDictionary *)parameters
{
    if([MaioManager sharedInstance].isInitialized) {
        [Maio setDelegate:self];
        return;
    }
    
    [self initializeMaioSdkWithInfo:parameters];
}

-(void)requestRewardedVideoWithCustomEventInfo:(NSDictionary *)info
{
    if(![MaioManager sharedInstance].isInitialized) {
        [self initializeMaioSdkWithInfo:info];
        return;
    }
    
    if([Maio canShowAtZoneId:_credentials.zoneId]) {
        [self.delegate rewardedVideoDidLoadAdForCustomEvent:self];
    } else {
        [self.delegate rewardedVideoDidFailToLoadAdForCustomEvent:self error:nil];
    }
}

-(void)initializeMaioSdkWithInfo:(NSDictionary *)info {
    
    _credentials = [MaioCredentials credentialsFromDictionary:info];
    if(!_credentials) {
        MPLogError(@"MaioRewardedVideo: invalid parameters\n%@", info.description);
        return;
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [Maio startWithMediaId:_credentials.mediaId delegate:self];
    });
}

-(BOOL)hasAdAvailable {
    return [Maio canShowAtZoneId:_credentials.zoneId];
}

-(void)presentRewardedVideoFromViewController:(UIViewController *)viewController {
    [Maio showAtZoneId:_credentials.zoneId];
}

#pragma mark - MaioDelegate

-(void)maioDidInitialize {
    [[MaioManager sharedInstance] setIsInitialized:YES];
}

-(void)maioDidChangeCanShow:(NSString *)zoneId newValue:(BOOL)newValue
{
    NSLog(@"change can show tp %d", newValue);
    
    if(zoneId && ![zoneId isEqualToString:_credentials.zoneId]) return;
    
    if(newValue)
    {
        [self.delegate rewardedVideoDidLoadAdForCustomEvent:self];
    }
}

-(void)maioDidClickAd:(NSString *)zoneId {
    if(zoneId && ![zoneId isEqualToString:_credentials.zoneId]) return;
    
    [self.delegate rewardedVideoDidReceiveTapEventForCustomEvent:self];
    [self.delegate rewardedVideoWillLeaveApplicationForCustomEvent:self];
}

-(void)maioWillStartAd:(NSString *)zoneId {
    if(zoneId && ![zoneId isEqualToString:_credentials.zoneId]) return;
    
    [self.delegate rewardedVideoWillAppearForCustomEvent:self];
    [self.delegate rewardedVideoDidAppearForCustomEvent:self];
}

-(void)maioDidCloseAd:(NSString *)zoneId {
    if(zoneId && ![zoneId isEqualToString:_credentials.zoneId]) return;
    
    [self.delegate rewardedVideoWillDisappearForCustomEvent:self];
    [self.delegate rewardedVideoDidDisappearForCustomEvent:self];
}

-(void)maioDidFinishAd:(NSString *)zoneId playtime:(NSInteger)playtime skipped:(BOOL)skipped rewardParam:(NSString *)rewardParam {
    if(zoneId && ![zoneId isEqualToString:_credentials.zoneId]) return;
    
    [self.delegate rewardedVideoShouldRewardUserForCustomEvent:self reward:nil];
}

@end
