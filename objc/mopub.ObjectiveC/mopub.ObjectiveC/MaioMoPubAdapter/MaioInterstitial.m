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
#import "MPLogging.h"
#import "MoPub.h"

@implementation MaioInterstitial {
    MaioCredentials *_credentials;
    BOOL _isAdRequested;
}

- (void)requestInterstitialWithCustomEventInfo:(NSDictionary *)info {
    NSError *loadError = nil;
    if (![self canRequestWithCustomEventInfo:info error:&loadError]) {
        [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:loadError];
        MPLogAdEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:loadError], nil);
        return;
    }

    _credentials = [MaioCredentials credentialsFromDictionary:info];

    MPLogAdEvent([MPLogEvent adLoadAttemptForAdapter:NSStringFromClass(self.class) dspCreativeId:nil dspName:nil], _credentials.zoneId);

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
        MPLogAdEvent([MPLogEvent adLoadSuccessForAdapter:NSStringFromClass(self.class)], _credentials.zoneId);
    } else {
        _isAdRequested = YES;
    }

}

- (void)showInterstitialFromRootViewController:(UIViewController *)rootViewController {
    MPLogAdEvent([MPLogEvent adShowAttemptForAdapter:NSStringFromClass(self.class)], _credentials.zoneId);

    MaioManager *manager = [MaioManager sharedInstance];
    if (![manager canShowAtMediaId:_credentials.mediaId zoneId:_credentials.zoneId]) return;
    [manager showAtMediaId:_credentials.mediaId zoneId:_credentials.zoneId];
}

- (BOOL)canRequestWithCustomEventInfo:(NSDictionary*)info error:(NSError**)errorPointer {

    // If GDPR is required do not initialize SDK
    if ([MoPub sharedInstance].isGDPRApplicable == MPBoolYes) {
        if (errorPointer) {
            *errorPointer = [MaioError gdpr];
        }
        return NO;
    }

    MaioCredentials *credentials = [MaioCredentials credentialsFromDictionary:info];
    if (!credentials) {
        if (errorPointer) {
            *errorPointer = [MaioError credentials];
        }
        return NO;
    }

    return YES;
}

#pragma mark - MaioDelegate

- (void)maioDidChangeCanShow:(NSString *)zoneId newValue:(BOOL)newValue {
    if (!_isAdRequested) {
        return;
    }

    if (_credentials.zoneId && ![zoneId isEqualToString:_credentials.zoneId]) {
        return;
    }
    _isAdRequested = NO;

    if (newValue) {
        [self.delegate interstitialCustomEvent:self didLoadAd:self];
        MPLogAdEvent([MPLogEvent adLoadSuccessForAdapter:NSStringFromClass(self.class)], _credentials.zoneId);
    } else {
        NSError *loadError = [MaioError loadFailed];
        [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:loadError];
        MPLogAdEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:loadError], _credentials.zoneId);
    }
}

- (void)maioDidClickAd:(NSString *)zoneId {
    if (_credentials.zoneId && ![zoneId isEqualToString:_credentials.zoneId]) {
        return;
    }

    [self.delegate interstitialCustomEventDidReceiveTapEvent:self];
    [self.delegate interstitialCustomEventWillLeaveApplication:self];
    MPLogAdEvent([MPLogEvent adTappedForAdapter:NSStringFromClass(self.class)], _credentials.zoneId);
    MPLogAdEvent([MPLogEvent adWillLeaveApplicationForAdapter:NSStringFromClass(self.class)], _credentials.zoneId);
}

- (void)maioDidCloseAd:(NSString *)zoneId {
    if (_credentials.zoneId && ![zoneId isEqualToString:_credentials.zoneId]) {
        return;
    }

    [self.delegate interstitialCustomEventWillDisappear:self];
    [self.delegate interstitialCustomEventDidDisappear:self];
    MPLogAdEvent([MPLogEvent adWillDisappearForAdapter:NSStringFromClass(self.class)], _credentials.zoneId);
    MPLogAdEvent([MPLogEvent adDidDisappearForAdapter:NSStringFromClass(self.class)], _credentials.zoneId);
}

- (void)maioWillStartAd:(NSString *)zoneId {
    if (_credentials.zoneId && ![zoneId isEqualToString:_credentials.zoneId]) {
        return;
    }

    [self.delegate interstitialCustomEventWillAppear:self];
    [self.delegate interstitialCustomEventDidAppear:self];
    MPLogAdEvent([MPLogEvent adWillAppearForAdapter:NSStringFromClass(self.class)], _credentials.zoneId);
    MPLogAdEvent([MPLogEvent adDidAppearForAdapter:NSStringFromClass(self.class)], _credentials.zoneId);
    MPLogAdEvent([MPLogEvent adShowSuccessForAdapter:NSStringFromClass(self.class)], _credentials.zoneId);
}

- (void)maioDidFail:(NSString *)zoneId reason:(MaioFailReason)reason {
    if (_credentials.zoneId && ![zoneId isEqualToString:_credentials.zoneId]) {
        return;
    }

    if (reason == MaioFailReasonVideoPlayback) {
        NSError *playbackError = [MaioError loadFailedWithReason:reason];
        [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:playbackError];
        MPLogAdEvent([MPLogEvent adShowFailedForAdapter:NSStringFromClass(self.class) error:playbackError], _credentials.zoneId);
        return;
    }

    NSError *loadError = [MaioError loadFailedWithReason:reason];
    [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:loadError];
    MPLogAdEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:loadError], _credentials.zoneId);
}

@end
