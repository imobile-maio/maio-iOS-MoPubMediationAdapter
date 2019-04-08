//
//  MaioInterstitial.m
//  mopub.ObjectiveC
//
//  Copyright © 2018年 maio. All rights reserved.
//

#import "MaioInterstitial.h"
#import "MaioCredentials.h"
#import "MaioManager.h"
#import "MaioError.h"

@implementation MaioInterstitial {
    MaioCredentials *_credentials;
    BOOL _isAdRequested;
}

- (void)requestInterstitialWithCustomEventInfo:(NSDictionary *)info {
    _credentials = [MaioCredentials credentialsFromDictionary:info];
    if (!_credentials) {
        [self.delegate interstitialCustomEvent:self
                      didFailToLoadAdWithError:[MaioError credentials]];
        return;
    }

    MaioManager *manager = [MaioManager sharedInstance];

    if (![manager isInitialized:_credentials.mediaId]) {
        [manager startWithMediaId:_credentials.mediaId delegate:self];
        _isAdRequested = YES;
        return;
    }

    if (![manager hasDelegate:self forMediaId:_credentials.mediaId]) {
        [manager addDelegate:self forMediaId:_credentials.mediaId];
    }

    if ([manager canShowAtMediaId:_credentials.mediaId zoneId:_credentials.zoneId]) {
        [self.delegate interstitialCustomEvent:self didLoadAd:self];
    } else {
        _isAdRequested = YES;
    }

}

- (void)showInterstitialFromRootViewController:(UIViewController *)rootViewController {
    MaioManager *manager = [MaioManager sharedInstance];
    if (![manager canShowAtMediaId:_credentials.mediaId zoneId:_credentials.zoneId]) return;

    [manager showAtMediaId:_credentials.mediaId zoneId:_credentials.zoneId];
}

#pragma mark - MaioDelegate

- (void)maioDidChangeCanShow:(NSString *)zoneId newValue:(BOOL)newValue {
    if (!_isAdRequested) {
        return;
    }
    _isAdRequested = NO;

    if (_credentials.zoneId && ![zoneId isEqualToString:_credentials.zoneId]) {
        return;
    }

    if (newValue) {
        [self.delegate interstitialCustomEvent:self didLoadAd:self];
    } else {
        [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:[MaioError loadFailed]];
    }
}

- (void)maioDidClickAd:(NSString *)zoneId {
    if (_credentials.zoneId && ![zoneId isEqualToString:_credentials.zoneId]) {
        return;
    }

    [self.delegate interstitialCustomEventDidReceiveTapEvent:self];
    [self.delegate interstitialCustomEventWillLeaveApplication:self];
}

- (void)maioDidCloseAd:(NSString *)zoneId {
    if (_credentials.zoneId && ![zoneId isEqualToString:_credentials.zoneId]) {
        return;
    }

    [self.delegate interstitialCustomEventWillDisappear:self];
    [self.delegate interstitialCustomEventDidDisappear:self];
}

- (void)maioWillStartAd:(NSString *)zoneId {
    if (_credentials.zoneId && ![zoneId isEqualToString:_credentials.zoneId]) {
        return;
    }

    [self.delegate interstitialCustomEventWillAppear:self];
    [self.delegate interstitialCustomEventDidAppear:self];
}

- (void)maioDidFail:(NSString *)zoneId reason:(MaioFailReason)reason {
    if (_credentials.zoneId && ![zoneId isEqualToString:_credentials.zoneId]) {
        return;
    }

    [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:[MaioError loadFailedWithReason:reason]];
}

@end