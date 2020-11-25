//
//  MaioRewardedVideoImmidiateResponseApdapter.m
//  mopub.ObjectiveC
//
//  Created by im-ttmskk on 2020/11/25.
//  Copyright © 2020 maio. All rights reserved.
//

#import "MaioRewardedVideoImmidiateResponseApdapter.h"
#import <Maio/Maio.h>

#import "MPLogging.h"
#import "MaioManager.h"
#import "MaioError.h"
#import "MaioCredentials.h"

@interface MaioRewardedVideoImmidiateResponseApdapter () <MaioDelegate>

@property (nonatomic) MaioCredentials *credentials;

@end

@implementation MaioRewardedVideoImmidiateResponseApdapter

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
    if ([MaioManager canRequestWithCustomEventInfo:info error:&loadError]) {
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

    if ([manager hasDelegate:self forMediaId:mediaId]) {
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

@end
