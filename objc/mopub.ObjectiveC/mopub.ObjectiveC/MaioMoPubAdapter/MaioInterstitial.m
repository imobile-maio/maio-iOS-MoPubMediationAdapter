//
//  MaioInterstitial.m
//  mopub.ObjectiveC
//
//  Created by 土肥 一郎 on 2018/02/07.
//  Copyright © 2018年 maio. All rights reserved.
//

#import "MaioInterstitial.h"
#import "MaioCredentials.h"
#import "MaioManager.h"
#import "MaioError.h"

@implementation MaioInterstitial {
    MaioCredentials *_credentials;
    BOOL _isLoadRequested;
}

- (void)requestInterstitialWithCustomEventInfo:(NSDictionary *)info {
    _credentials = [MaioCredentials credentialsFromDictionary:info];
    if(!_credentials) {
        [self.delegate interstitialCustomEvent:self
                      didFailToLoadAdWithError:[MaioError credentials]];
        return;
    }
    
    MaioManager *manager = [MaioManager sharedInstance];
    
    if([manager isInitialized:_credentials.mediaId] == NO) {
        [manager startWithMediaId:_credentials.mediaId delegate:self];
        return;
    }
    
    if([manager canShowAtMediaId:_credentials.mediaId zoneId:_credentials.zoneId]) {
        [self.delegate interstitialCustomEvent:self didLoadAd:self];
    } else {
        _isLoadRequested = YES;
    }
    
}

- (void)showInterstitialFromRootViewController:(UIViewController *)rootViewController {
    MaioManager *manager = [MaioManager sharedInstance];
    if(![manager canShowAtMediaId:_credentials.mediaId zoneId:_credentials.zoneId]) return;
    
    [manager showAtMediaId:_credentials.mediaId zoneId:_credentials.zoneId];
}

#pragma mark - MaioDelegate

-(void)maioDidChangeCanShow:(NSString *)zoneId newValue:(BOOL)newValue {
    if(_isLoadRequested == NO) {
        return;
    }
    _isLoadRequested = NO;
    
    if(_credentials.zoneId && ![zoneId isEqualToString:_credentials.zoneId]) {
        return;
    }
    
    if(newValue) {
        [self.delegate interstitialCustomEvent:self didLoadAd:self];
    } else {
        [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:[MaioError loadFailed]];
    }
}

-(void)maioDidClickAd:(NSString *)zoneId
{
    if(_credentials.zoneId && ![zoneId isEqualToString:_credentials.zoneId]) {
        return;
    }
    
    [self.delegate interstitialCustomEventDidReceiveTapEvent:self];
    [self.delegate interstitialCustomEventWillLeaveApplication:self];
}

-(void)maioDidCloseAd:(NSString *)zoneId
{
    if(_credentials.zoneId && ![zoneId isEqualToString:_credentials.zoneId]) {
        return;
    }
    
    [self.delegate interstitialCustomEventWillDisappear:self];
    [self.delegate interstitialCustomEventDidDisappear:self];
}

- (void)maioWillStartAd:(NSString *)zoneId
{
    if(_credentials.zoneId && ![zoneId isEqualToString:_credentials.zoneId]) {
        return;
    }
    
    [self.delegate interstitialCustomEventWillAppear:self];
    [self.delegate interstitialCustomEventDidDisappear:self];
}

-(void)maioDidFail:(NSString *)zoneId reason:(MaioFailReason)reason
{
    if(_credentials.zoneId && ![zoneId isEqualToString:_credentials.zoneId]) {
        return;
    }
    
    [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:[MaioError loadFailedWithReason:reason]];
}

@end
