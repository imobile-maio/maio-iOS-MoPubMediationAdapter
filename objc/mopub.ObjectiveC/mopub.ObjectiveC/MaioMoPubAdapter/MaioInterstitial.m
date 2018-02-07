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

@implementation MaioInterstitial {
    MaioCredentials *_credentials;
}

- (void)requestInterstitialWithCustomEventInfo:(NSDictionary *)info {
    _credentials = [MaioCredentials credentialsFromDictionary:info];
    if(!_credentials) {
        [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:nil];
        return;
    }
    
    if([MaioManager sharedInstance].isInitialized) {
        if([Maio canShowAtZoneId:_credentials.zoneId]) {
            [self.delegate interstitialCustomEvent:self didLoadAd:self];
        } else {
            [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:nil];
        }
        return;
    }
    
    [Maio startWithMediaId:_credentials.mediaId delegate:self];
}

- (void)showInterstitialFromRootViewController:(UIViewController *)rootViewController {
    if(![Maio canShowAtZoneId:_credentials.zoneId]) return;
    
    [Maio showAtZoneId:_credentials.zoneId];
}

#pragma mark - MaioDelegate

-(void)maioDidChangeCanShow:(NSString *)zoneId newValue:(BOOL)newValue {
    if(newValue) {
        [self.delegate interstitialCustomEvent:self didLoadAd:self];
    } else {
        [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:nil];
    }
}

-(void)maioDidClickAd:(NSString *)zoneId
{
    if(![zoneId isEqualToString:_credentials.zoneId]) return;
    
    [self.delegate interstitialCustomEventDidReceiveTapEvent:self];
    [self.delegate interstitialCustomEventWillLeaveApplication:self];
}

-(void)maioDidCloseAd:(NSString *)zoneId
{
    if(![zoneId isEqualToString:_credentials.zoneId]) return;
    
    [self.delegate interstitialCustomEventWillDisappear:self];
    [self.delegate interstitialCustomEventDidDisappear:self];
}

- (void)maioWillStartAd:(NSString *)zoneId
{
    if(![zoneId isEqualToString:_credentials.zoneId]) return;
    
    [self.delegate interstitialCustomEventWillAppear:self];
    [self.delegate interstitialCustomEventDidDisappear:self];
}

-(void)maioDidFail:(NSString *)zoneId reason:(MaioFailReason)reason
{
    
    if(![zoneId isEqualToString:_credentials.zoneId]) return;
    
    [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:nil];
}

@end
