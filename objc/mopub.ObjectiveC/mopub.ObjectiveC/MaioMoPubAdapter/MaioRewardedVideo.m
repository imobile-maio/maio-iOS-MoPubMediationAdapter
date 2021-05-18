//
//  MaioRewardedVideo.m
//  mopub.ObjectiveC
//
//  Copyright © 2018年 maio. All rights reserved.
//

#import "MaioRewardedVideo.h"
#import "MaioCredentials.h"
#import "MaioManager.h"
#import "MaioError.h"

@interface MaioRewardedVideo ()

@property (nonatomic) MaioCredentials *credentials;
@property (nonatomic) BOOL isAdRequested;

@end

@implementation MaioRewardedVideo

/// Declared  by `MPFullscreenAdAdapter+Private.h`
/// Initialized by `MPFullscreenAdAdapter -init`
@dynamic delegate;

/// Declared  by `MPFullscreenAdAdapter+Private.h`
/// Initialized by  `MPFullscreenAdAdapter -setUpWithAdConfiguration:localExtras:`
@dynamic localExtras;

- (BOOL)isRewardExpected {
    return YES;
}

- (BOOL)hasAdAvailable {
    MaioManager *manager = [MaioManager sharedInstance];
    if ([manager isAdStockOut:_credentials.zoneId]) {
        return NO;
    }
    return [manager canShowAtMediaId:_credentials.mediaId zoneId:_credentials.zoneId];
}
- (void)setHasAdAvailable:(BOOL)hasAdAvailable {
    // NOOP
}

- (BOOL)enableAutomaticImpressionAndClickTracking {
    return YES;
}

- (void)initializeSdkWithParameters:(NSDictionary *)parameters {
    _credentials = [MaioCredentials credentialsFromDictionary:parameters];
    [self initializeMaioSdk];
}

- (void)requestAdWithAdapterInfo:(NSDictionary *)info adMarkup:(NSString *)adMarkup {
    NSError* loadError = nil;
    if (![self canRequestWithCustomEventInfo:info error:&loadError]) {
        [self.delegate fullscreenAdAdapter:self didFailToLoadAdWithError:loadError];
        MPLogAdEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:loadError], nil);
        return;
    }

    MaioManager *manager = [MaioManager sharedInstance];
    MaioCredentials *credentials = [MaioCredentials credentialsFromDictionary:info];
    _credentials = credentials;
    MPLogAdEvent([MPLogEvent adLoadAttemptForAdapter:NSStringFromClass(self.class) dspCreativeId:nil dspName:nil], _credentials.zoneId);

    if (![manager isInitialized:credentials.mediaId]) {
        _isAdRequested = YES;
        [self initializeMaioSdk];
        return;
    }

    if (![manager hasDelegate:self forMediaId:_credentials.mediaId]) {
        [manager addDelegate:self forMediaId:_credentials.mediaId];
    }

    if ([manager isAdStockOut:_credentials.zoneId]) {
        NSError *adStockOutError = [MaioError loadFailedWithReason:MaioFailReasonAdStockOut];
        [self.delegate fullscreenAdAdapter:self didFailToLoadAdWithError:adStockOutError];
        MPLogAdEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:adStockOutError], nil);
    }

    if ([manager canShowAtMediaId:credentials.mediaId zoneId:credentials.zoneId]) {
        [self.delegate fullscreenAdAdapterDidLoadAd:self];
        MPLogAdEvent([MPLogEvent adLoadSuccessForAdapter:NSStringFromClass(self.class)], _credentials.zoneId);
    } else {
        _isAdRequested = YES;
    }
}

- (void)initializeMaioSdk {
    if (!_credentials) {
        MPLogError(@"MaioRewardedVideo: invalid parameters");
        return;
    }

    MaioManager *manager = [MaioManager sharedInstance];
    [manager startWithMediaId:_credentials.mediaId delegate:self];
}

- (void)presentAdFromViewController:(UIViewController *)viewController {
    MPLogAdEvent([MPLogEvent adShowAttemptForAdapter:NSStringFromClass(self.class)], _credentials.zoneId);
    [[MaioManager sharedInstance] showAtMediaId:_credentials.mediaId zoneId:_credentials.zoneId viewController:viewController];
}

- (BOOL)canRequestWithCustomEventInfo:(NSDictionary*)info error:(NSError**)errorPointer {
    return [MaioManager canRequestWithCustomEventInfo:info error:errorPointer];
}

#pragma mark - MaioDelegate

- (void)maioDidChangeCanShow:(NSString *)zoneId newValue:(BOOL)newValue {
    if (_credentials.zoneId && ![zoneId isEqualToString:_credentials.zoneId]) {
        return;
    }

    if (!_isAdRequested) {
        return;
    }
    _isAdRequested = NO;

    if (newValue) {
        [self.delegate fullscreenAdAdapterDidLoadAd:self];
        MPLogAdEvent([MPLogEvent adLoadSuccessForAdapter:NSStringFromClass(self.class)], _credentials.zoneId);
    }
}

- (void)maioDidClickAd:(NSString *)zoneId {
    if (_credentials.zoneId && ![zoneId isEqualToString:_credentials.zoneId]) {
        return;
    }

    [self.delegate fullscreenAdAdapterDidReceiveTap:self];
    [self.delegate fullscreenAdAdapterWillLeaveApplication:self];
    MPLogAdEvent([MPLogEvent adTappedForAdapter:NSStringFromClass(self.class)], _credentials.zoneId);
    MPLogAdEvent([MPLogEvent adWillLeaveApplicationForAdapter:NSStringFromClass(self.class)], _credentials.zoneId);
}

- (void)maioWillStartAd:(NSString *)zoneId {
    if (_credentials.zoneId && ![zoneId isEqualToString:_credentials.zoneId]) {
        return;
    }

    [self.delegate fullscreenAdAdapterAdWillAppear:self];
    [self.delegate fullscreenAdAdapterAdDidAppear:self];
    MPLogAdEvent([MPLogEvent adWillAppearForAdapter:NSStringFromClass(self.class)], _credentials.zoneId);
    MPLogAdEvent([MPLogEvent adDidAppearForAdapter:NSStringFromClass(self.class)], _credentials.zoneId);
    MPLogAdEvent([MPLogEvent adShowSuccessForAdapter:NSStringFromClass(self.class)], _credentials.zoneId);
}

- (void)maioDidCloseAd:(NSString *)zoneId {
    if (_credentials.zoneId && ![zoneId isEqualToString:_credentials.zoneId]) {
        return;
    }

    [self.delegate fullscreenAdAdapterAdWillDisappear:self];
    [self.delegate fullscreenAdAdapterAdDidDisappear:self];
    MPLogAdEvent([MPLogEvent adWillDisappearForAdapter:NSStringFromClass(self.class)], _credentials.zoneId);
    MPLogAdEvent([MPLogEvent adDidDisappearForAdapter:NSStringFromClass(self.class)], _credentials.zoneId);

    /// Added by MoPubSDK 5.15.0
    /// https://developers.mopub.com/networks/integrate/build-adapters-ios/#quick-start-for-fullscreen-ads
    {
        // [self.delegate fullscreenAdAdapterAdWillDismiss:self];
        SEL selector = NSSelectorFromString(@"fullscreenAdAdapterAdWillDismiss:");
        if ([self.delegate respondsToSelector:selector]) {
            [self.delegate performSelector:selector withObject:self];
            // Not exists [MPLogEvent adWillDismissModalForAdapter:]
            NSString *name = NSStringFromClass(self.class);
            NSString *message = [NSString stringWithFormat:@"Adapter ad from %@ will dismiss modal", name];
            MPLogAdEvent([[MPLogEvent alloc] initWithMessage:message], _credentials.zoneId);
        }
    }
    {
        SEL selector = NSSelectorFromString(@"fullscreenAdAdapterAdDidDismiss:");
        if ([self.delegate respondsToSelector:selector]) {
            [self.delegate performSelector:selector withObject:self];
            MPLogAdEvent([MPLogEvent adDidDismissModalForAdapter:NSStringFromClass(self.class)], _credentials.zoneId);
        }
    }
}

- (void)maioDidFinishAd:(NSString *)zoneId playtime:(NSInteger)playtime skipped:(BOOL)skipped rewardParam:(NSString *)rewardParam {
    if (_credentials.zoneId && ![zoneId isEqualToString:_credentials.zoneId]) {
        return;
    }


    MPRewardedVideoReward *reward = [[MPRewardedVideoReward alloc] initWithCurrencyAmount:@([rewardParam intValue])];
    [self.delegate fullscreenAdAdapter:self willRewardUser:reward];
}

- (void)maioDidFail:(NSString *)zoneId reason:(MaioFailReason)reason {
    if (_credentials.zoneId && ![zoneId isEqualToString:_credentials.zoneId]) {
        return;
    }

    if (reason == MaioFailReasonVideoPlayback) {
        NSError *playbackError = [MaioError loadFailedWithReason:reason];
        [self.delegate fullscreenAdAdapter:self didFailToShowAdWithError:playbackError];
        MPLogAdEvent([MPLogEvent adShowFailedForAdapter:NSStringFromClass(self.class) error:playbackError], _credentials.zoneId);
        return;
    }
    NSError *loadError = [MaioError loadFailedWithReason:reason];
    [self.delegate fullscreenAdAdapter:self didFailToLoadAdWithError:loadError];
    MPLogAdEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:loadError], _credentials.zoneId);
}

@end
