//
//  MaioRewardedVideoImmediateResponseApdapter.m
//  mopub.ObjectiveC
//
//  Created by im-ttmskk on 2020/11/25.
//  Copyright © 2020 maio. All rights reserved.
//

#import "MaioRewardedVideoImmediateResponseAdapter.h"
#import <Maio/Maio.h>

#import "MaioManager.h"
#import "MaioError.h"
#import "MaioCredentials.h"

@interface MaioRewardedVideoImmediateResponseAdapter () <MaioDelegate>

@property (nonatomic) MaioCredentials *credentials;

@end

@implementation MaioRewardedVideoImmediateResponseAdapter

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
    return [[MaioManager sharedInstance] canShowAtMediaId:self.credentials.mediaId zoneId:self.credentials.zoneId];
}
- (void)setHasAdAvailable:(BOOL)hasAdAvailable {
    // NOOP
}

- (BOOL)enableAutomaticImpressionAndClickTracking {
    return YES;
}

- (void)presentAdFromViewController:(UIViewController *)viewController {
    NSString *mediaId = self.credentials.mediaId;
    NSString *zoneId = self.credentials.zoneId;
    MPLogAdEvent([MPLogEvent adShowAttemptForAdapter:NSStringFromClass(self.class)], zoneId);
    [[MaioManager sharedInstance] showAtMediaId:mediaId zoneId:zoneId viewController:viewController];
}

- (void)requestAdWithAdapterInfo:(NSDictionary *)info adMarkup:(NSString *)adMarkup {
    NSError* loadError = nil;
    if (![MaioManager canRequestWithCustomEventInfo:info error:&loadError]) {
        [self.delegate fullscreenAdAdapter:self didFailToLoadAdWithError:loadError];
        MPLogAdEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:loadError], nil);
        return;
    }

    self.credentials = [MaioCredentials credentialsFromDictionary:info];
    NSString *mediaId = self.credentials.mediaId;
    NSString *zoneId = self.credentials.zoneId;
    MPLogAdEvent([MPLogEvent adLoadAttemptForAdapter:NSStringFromClass(self.class) dspCreativeId:nil dspName:nil], zoneId);

    MaioManager *manager = [MaioManager sharedInstance];
    NSError *notReadyError = [MaioError notReadyYet];
    if (![manager isInitialized:mediaId]) {
        [[MaioManager sharedInstance] startWithMediaId:mediaId delegate:self];
        [self.delegate fullscreenAdAdapter:self didFailToLoadAdWithError:notReadyError];
        MPLogAdEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:notReadyError], nil);
        return;
    }

    if (![manager hasDelegate:self forMediaId:mediaId]) {
        [manager addDelegate:self forMediaId:mediaId];
    }

    if ([self hasAdAvailable]) {
        [self.delegate fullscreenAdAdapterDidLoadAd:self];
        MPLogAdEvent([MPLogEvent adLoadSuccessForAdapter:NSStringFromClass(self.class)], zoneId);
    } else {
        [self.delegate fullscreenAdAdapter:self didFailToLoadAdWithError:notReadyError];
        MPLogAdEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:notReadyError], nil);
    }
}

#pragma mark - MaioDelegate

- (void)maioDidChangeCanShow:(NSString *)zoneId newValue:(BOOL)newValue {
    // NOOP
}

- (void)maioDidClickAd:(NSString *)zoneId {
    if (self.credentials.zoneId && ![zoneId isEqualToString:self.credentials.zoneId]) {
        return;
    }

    [self.delegate fullscreenAdAdapterDidReceiveTap:self];
    [self.delegate fullscreenAdAdapterWillLeaveApplication:self];
    MPLogAdEvent([MPLogEvent adTappedForAdapter:NSStringFromClass(self.class)], self.credentials.zoneId);
    MPLogAdEvent([MPLogEvent adWillLeaveApplicationForAdapter:NSStringFromClass(self.class)], self.credentials.zoneId);
}

- (void)maioWillStartAd:(NSString *)zoneId {
    if (self.credentials.zoneId && ![zoneId isEqualToString:self.credentials.zoneId]) {
        return;
    }

    [self.delegate fullscreenAdAdapterAdWillAppear:self];
    [self.delegate fullscreenAdAdapterAdDidAppear:self];
    MPLogAdEvent([MPLogEvent adWillAppearForAdapter:NSStringFromClass(self.class)], self.credentials.zoneId);
    MPLogAdEvent([MPLogEvent adDidAppearForAdapter:NSStringFromClass(self.class)], self.credentials.zoneId);
    MPLogAdEvent([MPLogEvent adShowSuccessForAdapter:NSStringFromClass(self.class)], self.credentials.zoneId);
}

- (void)maioDidCloseAd:(NSString *)zoneId {
    if (self.credentials.zoneId && ![zoneId isEqualToString:self.credentials.zoneId]) {
        return;
    }

    [self.delegate fullscreenAdAdapterAdWillDisappear:self];
    [self.delegate fullscreenAdAdapterAdDidDisappear:self];
    MPLogAdEvent([MPLogEvent adWillDisappearForAdapter:NSStringFromClass(self.class)], self.credentials.zoneId);
    MPLogAdEvent([MPLogEvent adDidDisappearForAdapter:NSStringFromClass(self.class)], self.credentials.zoneId);

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
            MPLogAdEvent([MPLogEvent adDidDismissModalForAdapter:NSStringFromClass(self.class)], self.credentials.zoneId);
        }
    }
}

- (void)maioDidFinishAd:(NSString *)zoneId playtime:(NSInteger)playtime skipped:(BOOL)skipped rewardParam:(NSString *)rewardParam {
    if (self.credentials.zoneId && ![zoneId isEqualToString:self.credentials.zoneId]) {
        return;
    }

    MPRewardedVideoReward *reward = [[MPRewardedVideoReward alloc] initWithCurrencyType:rewardParam amount:@(1)];
    [self.delegate fullscreenAdAdapter:self willRewardUser:reward];
}

- (void)maioDidFail:(NSString *)zoneId reason:(MaioFailReason)reason {
    if (self.credentials.zoneId && ![zoneId isEqualToString:self.credentials.zoneId]) {
        return;
    }

    if (reason == MaioFailReasonVideoPlayback) {
        NSError *playbackError = [MaioError loadFailedWithReason:reason];
        [self.delegate fullscreenAdAdapter:self didFailToShowAdWithError:playbackError];
        MPLogAdEvent([MPLogEvent adShowFailedForAdapter:NSStringFromClass(self.class) error:playbackError], self.credentials.zoneId);
        return;
    }
    NSError *loadError = [MaioError loadFailedWithReason:reason];
    [self.delegate fullscreenAdAdapter:self didFailToLoadAdWithError:loadError];
    MPLogAdEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:loadError], self.credentials.zoneId);
}

@end
